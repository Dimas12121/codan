<?php

use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

Broadcast::channel('chat.{listingId}.{id1}.{id2}', function ($user, $listingId, $id1, $id2) {
    return (int) $user->id === (int) $id1 || (int) $user->id === (int) $id2;
});
