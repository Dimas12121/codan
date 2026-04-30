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

class MessageRead implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $listingId;
    public $readerId;
    public $partnerId;

    /**
     * Create a new event instance.
     */
    public function __construct($listingId, $readerId, $partnerId)
    {
        $this->listingId = $listingId;
        $this->readerId = $readerId;
        $this->partnerId = $partnerId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        $ids = [$this->readerId, $this->partnerId];
        sort($ids);
        
        return [
            new PrivateChannel('chat.' . $this->listingId . '.' . $ids[0] . '.' . $ids[1]),
        ];
    }
}
