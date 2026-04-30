<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    /**
     * Get all notifications for the authenticated user.
     */
    public function index(Request $request)
    {
        $query = Auth::user()->notifications();

        if ($request->query('status') === 'unread') {
            $query = Auth::user()->unreadNotifications();
        }

        $notifications = $query->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $notifications
        ]);
    }

    /**
     * Get the count of unread notifications.
     */
    public function unreadCount()
    {
        $count = Auth::user()->unreadNotifications()->count();

        return response()->json([
            'success' => true,
            'unread_count' => $count
        ]);
    }

    /**
     * Mark a specific notification as read.
     */
    public function markAsRead($id)
    {
        $notification = Auth::user()->notifications()->findOrFail($id);
        $notification->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Notification marked as read'
        ]);
    }

    /**
     * Mark all notifications as read.
     */
    public function markAllAsRead()
    {
        Auth::user()->unreadNotifications->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'All notifications marked as read'
        ]);
    }

    /**
     * Delete a notification.
     */
    public function destroy($id)
    {
        Auth::user()->notifications()->findOrFail($id)->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notification deleted'
        ]);
    }
}
