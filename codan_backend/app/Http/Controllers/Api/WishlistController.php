<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Wishlist;

class WishlistController extends Controller
{
    /**
     * Get user's wishlist.
     */
    public function index(Request $request)
    {
        $wishlist = Wishlist::where('user_id', $request->user()->id)
            ->with(['produk.featuredImage', 'produk.category'])
            ->latest()
            ->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $wishlist
        ]);
    }

    /**
     * Toggle item in wishlist.
     */
    public function toggle(Request $request)
    {
        $request->validate([
            'produk_id' => 'required|exists:produks,id',
        ]);

        $wishlist = Wishlist::where('user_id', $request->user()->id)
            ->where('produk_id', $request->produk_id)
            ->first();

        if ($wishlist) {
            $wishlist->delete();
            return response()->json([
                'success' => true,
                'message' => 'Removed from wishlist',
                'status' => 'removed'
            ]);
        } else {
            Wishlist::create([
                'user_id' => $request->user()->id,
                'produk_id' => $request->produk_id,
            ]);
            return response()->json([
                'success' => true,
                'message' => 'Added to wishlist',
                'status' => 'added'
            ], 201);
        }
    }
}
