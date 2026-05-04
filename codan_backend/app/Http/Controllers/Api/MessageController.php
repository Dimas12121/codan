<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\Produk;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Events\MessageSent;
use App\Events\MessageDeleted;

class MessageController extends Controller
{
    public function index()
    {
        $userId = Auth::id();
        
        $latestMessageIds = Message::where('sender_id', $userId)
            ->orWhere('receiver_id', $userId)
            ->select(DB::raw('MAX(id) as id'))
            ->groupBy('produk_id', DB::raw("CASE WHEN sender_id = {$userId} THEN receiver_id ELSE sender_id END"))
            ->pluck('id');

        $conversations = Message::whereIn('id', $latestMessageIds)
            ->with(['produk.featuredImage', 'sender', 'receiver'])
            ->latest()
            ->get()
            ->map(function($message) use ($userId) {
                $partner = $message->sender_id == $userId ? $message->receiver : $message->sender;
                
                return [
                    'id' => $message->id,
                    'produk' => [
                        'id' => $message->produk->id,
                        'title' => $message->produk->title,
                        'image' => $message->produk->featuredImage->image_path ? url($message->produk->featuredImage->image_path) : null,
                    ],
                    'partner' => [
                        'id' => $partner->id,
                        'name' => $partner->name,
                        'avatar' => null,
                        'wa_link' => $partner->wa_link,
                    ],
                    'last_message' => $message->message ?? 'Sent an image',
                    'unread_count' => Message::where('produk_id', $message->produk_id)
                        ->where('receiver_id', $userId)
                        ->where('sender_id', $partner->id)
                        ->where('is_read', false)
                        ->count(),
                    'created_at' => $message->created_at->toDateTimeString(),
                    'timestamp' => $message->created_at->diffForHumans(),
                ];
            });

        return response()->json($conversations);
    }

    public function show($produkId, $partnerId)
    {
        $userId = Auth::id();
        $produk = Produk::with('featuredImage')->findOrFail($produkId);
        $partner = User::findOrFail($partnerId);

        $messages = Message::where(function($q) use ($userId, $partnerId, $produkId) {
                $q->where('sender_id', $userId)->where('receiver_id', $partnerId)->where('produk_id', $produkId);
            })
            ->orWhere(function($q) use ($userId, $partnerId, $produkId) {
                $q->where('sender_id', $partnerId)->where('receiver_id', $userId)->where('produk_id', $produkId);
            })
            ->orderBy('created_at', 'asc')
            ->get()
            ->map(function($msg) {
                if ($msg->image_path) {
                    $msg->image_path = url($msg->image_path);
                }
                return $msg;
            });

        // Mark as read
        Message::where('receiver_id', $userId)
            ->where('sender_id', $partnerId)
            ->where('produk_id', $produkId)
            ->update(['is_read' => true]);

        return response()->json([
            'produk' => [
                'id' => $produk->id,
                'title' => $produk->title,
                'price' => $produk->price,
                'image' => url($produk->featuredImage->image_path),
            ],
            'partner' => [
                'id' => $partner->id,
                'name' => $partner->name,
                'wa_link' => $partner->wa_link,
            ],
            'messages' => $messages
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'produk_id' => 'required|exists:produks,id',
            'receiver_id' => 'required|exists:users,id',
            'message' => 'nullable|string|max:1000',
            'image' => 'nullable|image|max:2048',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        if (!$request->message && !$request->hasFile('image') && !$request->latitude) {
            return response()->json(['error' => 'Pesan, gambar, atau lokasi harus diisi.'], 422);
        }

        $imagePath = null;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('chat', 'public');
            $imagePath = '/storage/' . $path;
        }

        $message = Message::create([
            'sender_id' => Auth::id(),
            'receiver_id' => $request->receiver_id,
            'produk_id' => $request->produk_id,
            'message' => $request->message,
            'image_path' => $imagePath,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
        ]);

        // Real-time Broadcast
        try {
            broadcast(new MessageSent($message))->toOthers();
        } catch (\Exception $e) {
            \Log::error('API Broadcast message sent failed: ' . $e->getMessage());
        }

        if ($message->image_path) {
            $message->image_path = url($message->image_path);
        }

        return response()->json($message, 201);
    }

    public function destroy($id)
    {
        $message = Message::findOrFail($id);

        if ($message->sender_id !== Auth::id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $messageClone = clone $message;
        $message->delete();

        try {
            broadcast(new MessageDeleted($messageClone))->toOthers();
        } catch (\Exception $e) {
            \Log::error('API Broadcast deletion failed: ' . $e->getMessage());
        }

        return response()->json(['success' => true]);
    }

    public function markAsRead($produkId, $partnerId)
    {
        $userId = Auth::id();
        
        $updated = Message::where('produk_id', $produkId)
            ->where('receiver_id', $userId)
            ->where('sender_id', $partnerId)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        if ($updated > 0) {
            try {
                broadcast(new \App\Events\MessageRead($produkId, $userId, $partnerId))->toOthers();
                
                // Also mark related notifications as read
                auth()->user()->unreadNotifications()
                    ->where('type', 'App\Notifications\NewMessageNotification')
                    ->where('data->produk_id', $produkId)
                    ->where('data->sender_id', $partnerId)
                    ->update(['read_at' => now()]);
                    
            } catch (\Exception $e) {
                \Log::error('API Broadcast read failed: ' . $e->getMessage());
            }
        }

        return response()->json(['success' => true, 'updated' => $updated]);
    }

    public function clear($produkId, $partnerId)
    {
        $userId = Auth::id();
        
        $deleted = Message::where('produk_id', $produkId)
            ->where(function($q) use ($userId, $partnerId) {
                $q->where(function($q2) use ($userId, $partnerId) {
                    $q2->where('sender_id', $userId)->where('receiver_id', $partnerId);
                })->orWhere(function($q2) use ($userId, $partnerId) {
                    $q2->where('sender_id', $partnerId)->where('receiver_id', $userId);
                });
            })
            ->delete();

        return response()->json(['success' => true, 'deleted_count' => $deleted]);
    }
}
