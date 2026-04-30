<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Produk;
use App\Models\ProdukImage;
use App\Models\Category;
use App\Models\Message;
use Illuminate\Support\Str;

class ProdukController extends Controller
{
    /**
     * Display a produk of the resource.
     */
    public function index(Request $request)
    {
        $categories = Category::withCount(['produks' => function($q) {
            $q->where('status', 'active');
        }])->get();
        
        $query = Produk::with('featuredImage', 'category')->where('status', 'active');

        // Search Filter
        if ($request->filled('search')) {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        // Category Filter
        if ($request->filled('category')) {
            $query->whereHas('category', function($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        // Condition Filter
        if ($request->filled('condition')) {
            $query->where('condition', $request->condition);
        }

        // Price Filter
        if ($request->filled('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }
        if ($request->filled('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }

        // Location Filter (Nearest)
        if ($request->filled('lat') && $request->filled('lng')) {
            $lat = $request->lat;
            $lng = $request->lng;
            $query->selectRaw("*, (6371 * acos(cos(radians(?)) * cos(radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin(radians(latitude)))) AS distance", [$lat, $lng, $lat])
                  ->orderBy('distance');
        }

        // Sorting
        if ($request->filled('sort')) {
            switch ($request->sort) {
                case 'cheap':
                    $query->orderBy('price', 'asc');
                    break;
                case 'expensive':
                    $query->orderBy('price', 'desc');
                    break;
                case 'oldest':
                    $query->orderBy('created_at', 'asc');
                    break;
                case 'newest':
                    $query->latest();
                    break;
            }
        } else if (!$request->filled('lat')) {
            $query->latest();
        }

        $produks = $query->paginate(12)->withQueryString();
        
        $unreadCount = 0;
        if (auth()->check()) {
            $unreadCount = Message::where('receiver_id', auth()->id())
                ->where('is_read', false)
                ->count();
        }
        
        return view('welcome', compact('categories', 'produks', 'unreadCount'));
    } 

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $categories = Category::all();
        return view('produk.create', compact('categories'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|max:255',
            'category_id' => 'required|exists:categories,id',
            'price' => 'required|numeric|min:0',
            'location' => 'required|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'condition' => 'required|in:baru,bekas,refurbished',
            'description' => 'required',
            'images.*' => 'image|mimes:jpeg,png,jpg,webp|max:2048'
        ]);

        $produk = Produk::create([
            'user_id' => auth()->id(),
            'category_id' => $request->category_id,
            'title' => $request->title,
            'slug' => Str::slug($request->title) . '-' . rand(1000, 9999),
            'description' => $request->description,
            'price' => $request->price,
            'condition' => $request->condition,
            'location' => $request->location,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
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
        } else {
            // Default placeholder if no image
            ProdukImage::create([
                'produk_id' => $produk->id,
                'image_path' => 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=800', // Just a placeholder
                'is_featured' => true,
            ]);
        }

        return redirect()->route('home')->with('success', 'Produk berhasil dipasang!');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $slug)
    {
        $produk = Produk::with(['user', 'category', 'images'])->where('slug', $slug)->firstOrFail();
        $produk->increment('views');
        return view('produk.show', compact('produk'));
    }

    public function edit(string $id)
    {
        $produk = Produk::findOrFail($id);
        
        if (auth()->id() !== $produk->user_id) {
            abort(403);
        }

        $categories = Category::all();
        return view('produk.edit', compact('produk', 'categories'));
    }

    public function update(Request $request, string $id)
    {
        $produk = Produk::findOrFail($id);
        
        if (auth()->id() !== $produk->user_id) {
            abort(403);
        }

        $request->validate([
            'title' => 'required|max:255',
            'category_id' => 'required|exists:categories,id',
            'price' => 'required|numeric|min:0',
            'location' => 'required|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'condition' => 'required|in:baru,bekas,refurbished',
            'description' => 'required',
        ]);

        $produk->update([
            'title' => $request->title,
            'category_id' => $request->category_id,
            'price' => $request->price,
            'location' => $request->location,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'condition' => $request->condition,
            'description' => $request->description,
        ]);

        return redirect()->route('dashboard')->with('success', 'Produk berhasil diperbarui!');
    }

    public function updateStatus(Request $request, $id)
    {
        $produk = Produk::findOrFail($id);
        
        if (auth()->id() !== $produk->user_id) {
            abort(403);
        }

        $request->validate(['status' => 'required|in:active,sold,draft']);
        $produk->update(['status' => $request->status]);

        return redirect()->back()->with('success', 'Status produk berhasil diubah!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $produk = Produk::findOrFail($id);
        
        if (auth()->id() !== $produk->user_id) {
            abort(403);
        }

        $produk->delete();
        return redirect()->back()->with('success', 'Produk berhasil dihapus!');
    }
}
