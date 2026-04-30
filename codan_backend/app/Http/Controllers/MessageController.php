<?php

namespace App\Http\Controllers;

use App\Models\Message;
use App\Models\Produk;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class MessageController extends Controller
{
    public function index()
    {
        $conversations = $this->getConversations();
        return view('inbox.index', compact('conversations'));
    }

    public function show($produkId, $partnerId)
    {
        $userId = Auth::id();
        $produk = Produk::with('featuredImage', 'user')->findOrFail($produkId);
        $partner = User::findOrFail($partnerId);
        $conversations = $this->getConversations();

        $messages = Message::where(function($q) use ($userId, $partnerId, $produkId) {
                $q->where('sender_id', $userId)->where('receiver_id', $partnerId)->where('produk_id', $produkId);
            })
            ->orWhere(function($q) use ($userId, $partnerId, $produkId) {
                $q->where('sender_id', $partnerId)->where('receiver_id', $userId)->where('produk_id', $produkId);
            })
            ->orderBy('created_at', 'asc')
            ->get();

        // Mark as read
        Message::where('receiver_id', $userId)
            ->where('sender_id', $partnerId)
            ->where('produk_id', $produkId)
            ->update(['is_read' => true]);

        return view('inbox.show', [
            'produk' => $produk,
            'activePartner' => $partner,
            'messages' => $messages,
            'conversations' => $conversations
        ]);
    }

    private function getConversations()
    {
        $userId = Auth::id();
        
        // Step 1: Get latest messages for each conversation (produk + Partner)
        // Subquery to get the latest message ID for each (produk_id, sender_id, receiver_id) combo
        $latestMessageIds = Message::where('sender_id', $userId)
            ->orWhere('receiver_id', $userId)
            ->select(DB::raw('MAX(id) as id'))
            ->groupBy('produk_id', DB::raw('CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END', [$userId]))
            ->pluck('id');

        return Message::whereIn('id', $latestMessageIds)
            ->with(['produk.featuredImage', 'sender', 'receiver'])
            ->latest()
            ->get()
            ->map(function($message) use ($userId) {
                $partnerId = $message->sender_id == $userId ? $message->receiver_id : $message->sender_id;
                
                // Still doing a count here, but it's much better than before as it's only for the final list
                // we could optimize further with a join but this is usually sufficient for inbox
                $message->unread_count = Message::where('produk_id', $message->produk_id)
                    ->where('receiver_id', $userId)
                    ->where('sender_id', $partnerId)
                    ->where('is_read', false)
                    ->count();
                    
                return $message;
            })
            ->sortByDesc('created_at');
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
            return redirect()->back()->with('error', 'Pesan, gambar, atau lokasi harus diisi.');
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

        // Send notification to receiver
        $receiver = User::find($request->receiver_id);
        $receiver->notify(new \App\Notifications\NewMessageNotification($message));

        // Real-time Broadcast
        try {
            broadcast(new \App\Events\MessageSent($message))->toOthers();
        } catch (\Exception $e) {
            \Log::error('Broadcast message sent failed: ' . $e->getMessage());
        }

        if (request()->ajax() || request()->wantsJson()) {
            return response()->json($message);
        }

        return redirect()->back()->with('success', 'Pesan terkirim!');
    }

    public function destroy(string $id)
    {
        $message = Message::findOrFail($id);

        if ($message->sender_id !== Auth::id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        // Clone for event data before deletion
        $messageClone = clone $message;
        $message->delete();

        try {
            broadcast(new \App\Events\MessageDeleted($messageClone))->toOthers();
        } catch (\Exception $e) {
            // Log error but continue
            \Log::error('Broadcast deletion failed: ' . $e->getMessage());
        }

        if (request()->wantsJson() || request()->ajax()) {
            return response()->json(['success' => true]);
        }

        return redirect()->back()->with('success', 'Pesan dihapus!');
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
                \Log::error('Broadcast read failed: ' . $e->getMessage());
            }
        }

        return response()->json(['success' => true, 'updated' => $updated]);
    }
}
