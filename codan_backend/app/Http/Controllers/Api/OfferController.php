<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Offer;
use App\Models\Produk;
use App\Models\Message;
use App\Notifications\NewOfferNotification;
use App\Events\MessageSent;

class OfferController extends Controller
{
    /**
     * Get offers made by the user or received by the user.
     */
    public function index(Request $request)
    {
        $type = $request->query('type', 'sent'); // sent or received

        if ($type === 'received') {
            $offers = Offer::whereHas('produk', function ($query) use ($request) {
                $query->where('user_id', $request->user()->id);
            })->with(['user', 'produk'])->latest()->paginate(15);
        } else {
            $offers = Offer::where('user_id', $request->user()->id)
                ->with(['produk.user'])->latest()->paginate(15);
        }

        return response()->json([
            'success' => true,
            'data' => $offers
        ]);
    }

    /**
     * Store a new offer.
     */
    public function store(Request $request)
    {
        $request->validate([
            'produk_id' => 'required|exists:produks,id',
            'offer_price' => 'required|numeric|min:0',
            'message' => 'nullable|string|max:500',
        ]);

        $produk = Produk::findOrFail($request->produk_id);

        if ($produk->user_id === $request->user()->id) {
            return response()->json(['success' => false, 'message' => 'You cannot offer on your own produk'], 403);
        }

        $offer = Offer::create([
            'user_id' => $request->user()->id,
            'produk_id' => $request->produk_id,
            'offer_price' => $request->offer_price,
            'message' => $request->message,
            'status' => 'pending',
        ]);

        // Automatically send a chat message when offer is made
        $msgContent = "🏷️ Saya mengajukan penawaran baru sebesar Rp " . number_format($request->offer_price, 0, ',', '.') . ". " . ($request->message ?? '');
        
        $message = Message::create([
            'sender_id' => $request->user()->id,
            'receiver_id' => $produk->user_id,
            'produk_id' => $produk->id,
            'message' => $msgContent,
        ]);

        // Notify vendor
        $produk->user->notify(new NewOfferNotification($offer));

        // Real-time Chat Broadcast
        try {
            broadcast(new MessageSent($message))->toOthers();
        } catch (\Exception $e) {
            \Log::error('API Offer Broadcast failed: ' . $e->getMessage());
        }

        return response()->json([
            'success' => true,
            'message' => 'Offer sent successfully',
            'data' => $offer
        ], 201);
    }

    /**
     * Update offer status (Accept/Reject/Cancel).
     */
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:accepted,rejected,cancelled',
        ]);

        $offer = Offer::with('produk')->findOrFail($id);

        if ($request->status === 'cancelled') {
            if ($request->user()->id !== $offer->user_id) {
                return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
            }
        } else {
            // Seller accepting/rejecting
            if ($request->user()->id !== $offer->produk->user_id) {
                return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
            }
        }

        $offer->update(['status' => $request->status]);

        // Trigger notifications...

        return response()->json([
            'success' => true,
            'message' => 'Offer status updated to ' . $request->status,
            'data' => $offer
        ]);
    }
}
