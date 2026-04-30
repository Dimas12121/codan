<?php

namespace App\Events;

use App\Models\Message;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class MessageSent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $message;

    /**
     * Create a new event instance.
     */
    public function __construct(Message $message)
    {
        $this->message = $message;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        // Sort IDs to ensure same channel for both sender and receiver
        $ids = [$this->message->sender_id, $this->message->receiver_id];
        sort($ids);
        
        return [
            new PrivateChannel('chat.' . $this->message->listing_id . '.' . $ids[0] . '.' . $ids[1]),
        ];
    }

    public function broadcastWith(): array
    {
        return [
            'id' => $this->message->id,
            'message' => $this->message->message,
            'image_path' => $this->message->image_path ? url($this->message->image_path) : null,
            'latitude' => $this->message->latitude,
            'longitude' => $this->message->longitude,
            'sender_id' => $this->message->sender_id,
            'receiver_id' => $this->message->receiver_id,
            'listing_id' => $this->message->listing_id,
            'created_at' => $this->message->created_at->toDateTimeString(),
        ];
    }
}
