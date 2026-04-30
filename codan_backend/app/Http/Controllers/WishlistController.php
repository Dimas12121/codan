<?php

namespace App\Http\Controllers;

use App\Models\Wishlist;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WishlistController extends Controller
{
    /**
     * Display the user's wishlist.
     */
    public function index()
    {
        $wishlists = Auth::user()->wishlists()->with(['produk.featuredImage', 'produk.category'])->latest()->paginate(12);
        return view('wishlist.index', compact('wishlists'));
    }

    /**
     * Toggle a produk in the user's wishlist.
     */
    public function toggle(Request $request, produk $produk)
    {
        $user = Auth::user();
        $wishlist = Wishlist::where('user_id', $user->id)->where('produk_id', $produk->id)->first();

        if ($wishlist) {
            $wishlist->delete();
            $status = 'removed';
        } else {
            Wishlist::create([
                'user_id' => $user->id,
                'produk_id' => $produk->id,
            ]);
            $status = 'added';
        }

        if ($request->ajax()) {
            return response()->json([
                'status' => $status,
                'message' => $status == 'added' ? 'Produk ditambahkan ke wishlist' : 'Produk dihapus dari wishlist'
            ]);
        }

        return back()->with('success', $status == 'added' ? 'Produk ditambahkan ke wishlist' : 'Produk dihapus dari wishlist');
    }
}
