<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    /**
     * Display a produk of notifications.
     */
    public function index()
    {
        $notifications = Auth::user()->notifications()->paginate(20);
        return view('notifications.index', compact('notifications'));
    }

    /**
     * Mark a specific notification as read.
     */
    public function markAsRead($id)
    {
        $notification = Auth::user()->notifications()->findOrFail($id);
        $notification->markAsRead();

        if (request()->ajax()) {
            return response()->json(['success' => true]);
        }

        return back();
    }

    /**
     * Mark all notifications as read.
     */
    public function markAllAsRead()
    {
        Auth::user()->unreadNotifications->markAsRead();

        if (request()->ajax()) {
            return response()->json(['success' => true]);
        }

        return back();
    }

    /**
     * Get unread notifications for the dropdown.
     */
    public function getUnread()
    {
        $notifications = Auth::user()->unreadNotifications()->take(5)->get();
        $unreadCount = Auth::user()->unreadNotifications()->count();

        return response()->json([
            'notifications' => $notifications,
            'unreadCount' => $unreadCount
        ]);
    }
}
