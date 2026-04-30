<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Notifications\Notification;

class NewOfferNotification extends Notification implements ShouldBroadcast
{
    use Queueable;

    protected $offer;

    /**
     * Create a new notification instance.
     */
    public function __construct($offer)
    {
        $this->offer = $offer;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['database', 'broadcast'];
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            'offer_id' => $this->offer->id,
            'produk_id' => $this->offer->produk_id,
            'produk_title' => $this->offer->produk->title,
            'buyer_name' => $this->offer->user->name,
            'offer_price' => $this->offer->offer_price,
            'message' => 'Penawaran baru untuk ' . $this->offer->produk->title,
            'description' => $this->offer->user->name . ' menawar seharga Rp ' . number_format($this->offer->offer_price, 0, ',', '.')
        ];
    }
}
