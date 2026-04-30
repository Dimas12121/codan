<?php

namespace App\Http\Controllers;

use App\Models\Offer;
use App\Models\Message;
use App\Notifications\NewOfferNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OfferController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'produk_id' => 'required|exists:produks,id',
            'offer_price' => 'required|numeric|min:0',
            'message' => 'nullable|string|max:500',
        ]);

        $produk = \App\Models\Produk::findOrFail($request->produk_id);

        $offer = Offer::create([
            'user_id' => Auth::id(),
            'produk_id' => $request->produk_id,
            'offer_price' => $request->offer_price,
            'message' => $request->message,
            'status' => 'pending',
        ]);

        // Automatically send a chat message when offer is made
        $msgContent = "🏷️ Saya mengajukan penawaran baru sebesar Rp " . number_format($request->offer_price, 0, ',', '.') . ". " . ($request->message ?? '');
        
        $message = Message::create([
            'sender_id' => Auth::id(),
            'receiver_id' => $produk->user_id,
            'produk_id' => $produk->id,
            'message' => $msgContent,
        ]);

        // Send notification to seller
        $produk->user->notify(new NewOfferNotification($offer));

        // Real-time Chat Broadcast for the auto-generated message
        try {
            broadcast(new \App\Events\MessageSent($message))->toOthers();
        } catch (\Exception $e) {}

        return redirect()->back()->with('success', 'Penawaran berhasil dikirim!');
    }
}
