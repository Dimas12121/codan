<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Produk;
use App\Models\Category;
use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class AdminController extends Controller
{
    public function index()
    {
        $stats = [
            'users' => User::count(),
            'produks' => Produk::count(),
            'categories' => Category::count(),
            'active_produks' => Produk::where('status', 'active')->count(),
            'active_users' => User::where('is_active', true)->count(),
            'inactive_users' => User::where('is_active', false)->count(),
            'admins' => User::where('role', 'admin')->where('is_active', true)->count(),
            'sellers' => User::where('role', 'seller')->where('is_active', true)->count(),
            'buyers' => User::where('role', 'buyer')->where('is_active', true)->count(),
            'draft_produks' => Produk::where('status', 'draft')->count(),
            'sold_produks' => Produk::where('status', 'sold')->count(),
            'pending_reports' => Report::where('status', 'pending')->count(),
        ];

        $recentProduks = Produk::with(['user', 'category'])->latest()->take(5)->get();
        $recentUsers = User::latest()->take(5)->get();
        $topProduks = Produk::with(['user', 'category'])->orderBy('views', 'desc')->take(5)->get();

        return view('admin.dashboard', compact('stats', 'recentProduks', 'recentUsers', 'topProduks'));
    }

    public function produks()
    {
        $produks = Produk::with(['user', 'category'])->latest()->paginate(20);
        return view('admin.produk', compact('produks'));
    }

    public function users()
    {
        $users = User::latest()->paginate(20);
        return view('admin.users', compact('users'));
    }

    public function userDetail($id)
    {
        $user = User::with(['produks' => function($q) {
            $q->latest();
        }])->withCount('produks')->findOrFail($id);

        $stats = [
            'active_produks' => $user->produks()->where('status', 'active')->count(),
            'sold_produks' => $user->produks()->where('status', 'sold')->count(),
            'total_views' => $user->produks()->sum('views'),
        ];

        return view('admin.user_detail', compact('user', 'stats'));
    }

    public function activeUsers()
    {
        $users = User::where('is_active', true)->latest()->paginate(20);
        return view('admin.users', compact('users'));
    }

    public function inactiveUsers()
    {
        $users = User::where('is_active', false)->latest()->paginate(20);
        return view('admin.users', compact('users'));
    }

    public function deleteproduk($id)
    {
        Produk::findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Produk berhasil dihapus oleh Admin.');
    }

    public function deleteUser($id)
    {
        $user = User::findOrFail($id);
        
        // Prevent deleting yourself
        if ($user->id === auth()->id()) {
            return redirect()->back()->with('error', 'Anda tidak bisa menghapus akun Anda sendiri!');
        }

        // Prevent deleting the last active admin
        if ($user->role === 'admin') {
            $activeAdminsCount = User::where('role', 'admin')->where('is_active', true)->count();
            if ($activeAdminsCount <= 1) {
                return redirect()->back()->with('error', 'Tidak bisa menghapus admin terakhir yang aktif!');
            }
        }
        
        $user->delete();
        return redirect()->back()->with('success', 'User berhasil dihapus/dinonaktifkan.');
    }

    public function toggleUserStatus($id)
    {
        $user = User::findOrFail($id);
        
        // Prevent deactivating yourself
        if ($user->id === auth()->id()) {
            return redirect()->back()->with('error', 'Anda tidak bisa menonaktifkan akun Anda sendiri!');
        }

        // Prevent deactivating the last active admin
        if ($user->role === 'admin' && $user->is_active) {
            $activeAdminsCount = User::where('role', 'admin')->where('is_active', true)->count();
            if ($activeAdminsCount <= 1) {
                return redirect()->back()->with('error', 'Tidak bisa menonaktifkan admin terakhir yang aktif!');
            }
        }
        
        $user->is_active = !$user->is_active;
        $user->save();
        
        $status = $user->is_active ? 'diaktifkan' : 'dinonaktifkan';
        return redirect()->back()->with('success', "User {$user->name} berhasil {$status}.");
    }

    public function updateprodukstatus(Request $request, $id)
    {
        $produk = Produk::findOrFail($id);
        $request->validate([
            'status' => 'required|in:draft,active,sold,rejected',
        ]);
        
        $produk->status = $request->status;
        $produk->save();
        
        return redirect()->back()->with('success', "Status produk '{$produk->title}' berhasil diubah menjadi {$produk->status}.");
    }

    public function updateRole(Request $request, $id)
    {
        $user = User::findOrFail($id);
        $request->validate([
            'role' => 'required|in:buyer,seller,admin',
        ]);

        // Prevent demoting the last active admin
        if ($user->role === 'admin' && $request->role !== 'admin') {
            $activeAdminsCount = User::where('role', 'admin')->where('is_active', true)->count();
            if ($activeAdminsCount <= 1) {
                return redirect()->back()->with('error', 'Tidak bisa menurunkan jabatan admin terakhir yang aktif!');
            }
        }

        // Prevent the admin from demoting themselves
        if ($user->id === auth()->id() && $request->role !== 'admin') {
            return redirect()->back()->with('error', 'Anda tidak bisa menurunkan jabatan Anda sendiri demi keamanan!');
        }

        $user->role = $request->role;
        $user->save();

        return redirect()->back()->with('success', "Role {$user->name} berhasil diubah menjadi {$user->role}.");
    }

    // Category Management
    public function categories()
    {
        $categories = Category::withCount('produks')->get();
        return view('admin.categories', compact('categories'));
    }

    public function storeCategory(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:categories',
            'icon' => 'nullable|string|max:255',
        ]);

        Category::create([
            'name' => $request->name,
            'slug' => Str::slug($request->name),
            'icon' => $request->icon ?? 'tag',
        ]);

        return redirect()->back()->with('success', 'Kategori berhasil ditambahkan.');
    }

    public function updateCategory(Request $request, $id)
    {
        $category = Category::findOrFail($id);
        $request->validate([
            'name' => 'required|string|max:255|unique:categories,name,'.$id,
            'icon' => 'nullable|string|max:255',
        ]);

        $category->update([
            'name' => $request->name,
            'slug' => Str::slug($request->name),
            'icon' => $request->icon ?? $category->icon,
        ]);

        return redirect()->back()->with('success', 'Kategori berhasil diperbarui.');
    }

    public function deleteCategory($id)
    {
        $category = Category::findOrFail($id);
        if ($category->produks()->count() > 0) {
            return redirect()->back()->with('error', 'Kategori tidak bisa dihapus karena masih memiliki produk!');
        }
        $category->delete();
        return redirect()->back()->with('success', 'Kategori berhasil dihapus.');
    }

    // Report Management
    public function reports()
    {
        $reports = Report::with(['user', 'produk.user'])->latest()->paginate(20);
        return view('admin.reports', compact('reports'));
    }

    public function updateReportStatus(Request $request, $id)
    {
        $report = Report::findOrFail($id);
        $request->validate([
            'status' => 'required|in:pending,resolved,ignored',
            'admin_notes' => 'nullable|string',
        ]);

        $report->status = $report->status; // Wait, this looks like a bug in original code, but I'll fix it
        $report->status = $request->status;
        $report->admin_notes = $request->admin_notes;
        $report->save();

        return redirect()->back()->with('success', 'Status laporan berhasil diperbarui.');
    }

    public function deleteReport($id)
    {
        Report::findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Laporan berhasil dihapus.');
    }
}
