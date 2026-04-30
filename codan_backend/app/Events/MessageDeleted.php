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

class MessageDeleted implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $messageId;
    public $listingId;
    public $senderId;
    public $receiverId;

    /**
     * Create a new event instance.
     */
    public function __construct(Message $message)
    {
        $this->messageId = $message->id;
        $this->listingId = $message->listing_id;
        $this->senderId = $message->sender_id;
        $this->receiverId = $message->receiver_id;
    }

    /**
     * Get the channels the event should broadcast on.
     */
    public function broadcastOn(): array
    {
        $ids = [$this->senderId, $this->receiverId];
        sort($ids);
        
        return [
            new PrivateChannel('chat.' . $this->listingId . '.' . $ids[0] . '.' . $ids[1]),
        ];
    }
}
