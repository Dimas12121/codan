<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Review;
use App\Models\User;

class ReviewController extends Controller
{
    /**
     * Get reviews for a specific user.
     */
    public function index($userId)
    {
        $reviews = Review::where('reviewee_id', $userId)
            ->with(['reviewer'])
            ->latest()
            ->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $reviews
        ]);
    }

    /**
     * Store a new review.
     */
    public function store(Request $request)
    {
        $request->validate([
            'reviewee_id' => 'required|exists:users,id',
            'produk_id' => 'required|exists:produks,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        if ($request->user()->id == $request->reviewee_id) {
            return response()->json(['success' => false, 'message' => 'You cannot review yourself'], 403);
        }

        // Potential check: Has there been an accepted offer or message exchange?
        // For now, allow reviews if produk exists.

        $review = Review::create([
            'reviewer_id' => $request->user()->id,
            'reviewee_id' => $request->reviewee_id,
            'produk_id' => $request->produk_id,
            'rating' => $request->rating,
            'comment' => $request->comment,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Review posted successfully',
            'data' => $review
        ], 201);
    }
}
