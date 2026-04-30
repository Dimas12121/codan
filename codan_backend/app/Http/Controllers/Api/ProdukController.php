<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Produk;
use App\Models\ProdukImage;
use Illuminate\Support\Str;

class ProdukController extends Controller
{
    /**
     * Display a produk of the resource.
     */
    public function index(Request $request)
    {
        $query = Produk::with(['featuredImage', 'category', 'user']);

        if ($request->has('category')) {
            $query->whereHas('category', function($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        if ($request->has('search')) {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        $produks = $query->where('status', 'active')->latest()->paginate(10);

        return response()->json([
            'success' => true,
            'data' => $produks
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|max:255',
            'category_id' => 'required|exists:categories,id',
            'price' => 'required|numeric|min:0',
            'type' => 'required|in:sell,rent',
            'rental_period' => 'required_if:type,rent|nullable|in:daily,weekly,monthly',
            'location' => 'required|max:255',
            'description' => 'required',
            'images.*' => 'image|mimes:jpeg,png,jpg,webp|max:2048'
        ]);

        $produk = Produk::create([
            'user_id' => $request->user()->id,
            'category_id' => $request->category_id,
            'title' => $request->title,
            'slug' => Str::slug($request->title) . '-' . rand(1000, 9999),
            'description' => $request->description,
            'price' => $request->price,
            'type' => $request->type ?? 'sell',
            'rental_period' => $request->rental_period,
            'condition' => $request->condition ?? 'used',
            'location' => $request->location,
            'status' => 'active',
        ]);

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $index => $image) {
                $path = $image->store('produks', 'public');
                ProdukImage::create([
                    'produk_id' => $produk->id,
                    'image_path' => '/storage/' . $path,
                    'is_featured' => $index === 0,
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Produk created successfully',
            'data' => $produk->load('images')
        ], 201);
    }

    public function show($identifier)
    {
        $produk = Produk::with(['user', 'category', 'images'])
            ->where(function($query) use ($identifier) {
                $query->where('id', $identifier)
                      ->orWhere('slug', $identifier);
            })
            ->first();

        if (!$produk) {
            return response()->json([
                'success' => false,
                'message' => 'Produk not found'
            ], 404);
        }

        $produk->increment('views');

        return response()->json([
            'success' => true,
            'data' => $produk
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $produk = Produk::findOrFail($id);

        if ($request->user()->id !== $produk->user_id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $request->validate(['status' => 'required|in:active,sold,draft']);
        $produk->update(['status' => $request->status]);

        return response()->json(['success' => true, 'message' => 'Status updated', 'data' => $produk]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, string $id)
    {
        $produk = Produk::findOrFail($id);

        if ($request->user()->id !== $produk->user_id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $produk->delete();
        return response()->json(['success' => true, 'message' => 'Produk deleted']);
    }

    /**
     * Get produks owned by the authenticated user.
     */
    public function myproduks(Request $request)
    {
        $produks = Produk::where('user_id', $request->user()->id)
            ->with(['featuredImage', 'category'])
            ->latest()
            ->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $produks
        ]);
    }

    /**
     * Update the specified produk.
     */
    public function update(Request $request, $id)
    {
        $produk = Produk::findOrFail($id);

        if ($request->user()->id !== $produk->user_id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'title' => 'sometimes|required|max:255',
            'category_id' => 'sometimes|required|exists:categories,id',
            'price' => 'sometimes|required|numeric|min:0',
            'type' => 'sometimes|required|in:sell,rent',
            'rental_period' => 'required_if:type,rent|nullable|in:daily,weekly,monthly',
            'location' => 'sometimes|required|max:255',
            'description' => 'sometimes|required',
            'condition' => 'sometimes|in:new,used',
            'status' => 'sometimes|in:active,sold,draft',
            'images.*' => 'image|mimes:jpeg,png,jpg,webp|max:2048'
        ]);

        $produk->update($request->only([
            'title', 'category_id', 'price', 'type', 'rental_period', 'location', 'description', 'condition', 'status'
        ]));

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('produks', 'public');
                ProdukImage::create([
                    'produk_id' => $produk->id,
                    'image_path' => '/storage/' . $path,
                    'is_featured' => false,
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Produk updated successfully',
            'data' => $produk->load('images')
        ]);
    }
}
