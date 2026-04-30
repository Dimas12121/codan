@extends('layouts.admin')

@section('title', 'Manajemen Kategori')

@section('content')
<div class="max-w-7xl mx-auto">
    <!-- Feedback Messages -->
    @if(session('success'))
    <div class="mb-8 p-6 bg-emerald-500/10 border border-emerald-500/20 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="check-circle" class="w-6 h-6 text-emerald-500"></i>
        <div class="text-emerald-500 font-bold">{{ session('success') }}</div>
    </div>
    @endif
    
    @if(session('error'))
    <div class="mb-8 p-6 bg-red-500/10 border border-red-500/20 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="alert-circle" class="w-6 h-6 text-red-500"></i>
        <div class="text-red-500 font-bold">{{ session('error') }}</div>
    </div>
    @endif

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        <!-- Add Category Form -->
        <div class="lg:col-span-1">
            <div class="admin-card p-10 sticky top-8 relative overflow-hidden group">
                <div class="absolute inset-0 bg-gradient-to-tr from-blue-600/5 to-transparent"></div>
                <h3 class="text-xl font-black text-white mb-8 uppercase tracking-tighter italic flex items-center gap-3 relative z-10">
                    <span class="w-1.5 h-6 bg-blue-600 rounded-full"></span>
                    Tambah Kategori
                </h3>
                <form action="{{ route('admin.categories.store') }}" method="POST" class="relative z-10">
                    @csrf
                    <div class="space-y-8">
                        <div>
                            <label class="block text-[10px] font-black uppercase tracking-[0.3em] text-slate-500 mb-3">Nama Kategori</label>
                            <input type="text" name="name" required class="w-full px-6 py-4 rounded-3xl bg-[#0b0f1a] border-none focus:ring-2 focus:ring-blue-500 font-bold text-white transition-all">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black uppercase tracking-[0.3em] text-slate-500 mb-3">Icon (Lucide ID)</label>
                            <input type="text" name="icon" placeholder="monitor, car, smartphone" class="w-full px-6 py-4 rounded-3xl bg-[#0b0f1a] border-none focus:ring-2 focus:ring-blue-500 font-bold text-white transition-all">
                        </div>
                        <button type="submit" class="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-3xl font-black uppercase tracking-widest transition-all shadow-xl shadow-blue-600/20 active:scale-95">
                            Simpan Kategori
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Categories List -->
        <div class="lg:col-span-2">
            <div class="admin-card overflow-hidden">
                <div class="overflow-x-auto lg:overflow-visible no-scrollbar">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-900/50">
                                <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Nama Kategori</th>
                                <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Total Iklan</th>
                                <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800">
                            @foreach($categories as $category)
                            <tr class="hover:bg-white/5 transition-all group">
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-5">
                                        <div class="w-14 h-14 rounded-2xl bg-[#0b0f1a] flex items-center justify-center text-blue-500 shadow-inner group-hover:scale-110 transition-transform">
                                            <i data-lucide="{{ $category->icon ?: 'tag' }}" class="w-6 h-6"></i>
                                        </div>
                                        <div>
                                            <div class="font-black text-white italic tracking-tighter text-lg">{{ $category->name }}</div>
                                            <div class="text-[9px] font-bold text-slate-500 uppercase tracking-widest italic mt-1">/{{ $category->slug }}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-3">
                                        <span class="text-2xl font-black text-white">{{ $category->produks_count }}</span>
                                        <span class="text-[9px] font-bold text-slate-500 uppercase tracking-widest">Postingan</span>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex items-center justify-center gap-3">
                                        <!-- Edit Popover -->
                                        <div class="relative group/pop">
                                            <button class="p-4 rounded-2xl bg-[#0b0f1a] text-slate-400 hover:bg-blue-600 hover:text-white transition-all" title="Edit Kategori">
                                                <i data-lucide="edit-3" class="w-5 h-5"></i>
                                            </button>
                                            <div class="absolute right-0 top-full mt-3 w-72 bg-[#1e293b] rounded-[2.5rem] shadow-2xl border border-blue-500/30 z-[100] opacity-0 invisible group-hover/pop:opacity-100 group-hover/pop:visible transition-all duration-300 scale-95 group-hover/pop:scale-100 origin-top-right">
                                                <div class="p-8">
                                                    <div class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-6 text-center border-b border-slate-700/50 pb-3">Update Kategori</div>
                                                    <form action="{{ route('admin.categories.update', $category->id) }}" method="POST" class="space-y-4">
                                                        @csrf @method('PATCH')
                                                        <div>
                                                            <label class="block text-[9px] font-black uppercase tracking-widest text-slate-500 mb-2">Nama</label>
                                                            <input type="text" name="name" value="{{ $category->name }}" class="w-full px-5 py-3 rounded-2xl bg-[#0b0f1a] border-none text-xs font-bold text-white focus:ring-1 focus:ring-blue-500">
                                                        </div>
                                                        <div>
                                                            <label class="block text-[9px] font-black uppercase tracking-widest text-slate-500 mb-2">Icon ID</label>
                                                            <input type="text" name="icon" value="{{ $category->icon }}" class="w-full px-5 py-3 rounded-2xl bg-[#0b0f1a] border-none text-xs font-bold text-white focus:ring-1 focus:ring-blue-500">
                                                        </div>
                                                        <button type="submit" class="w-full py-3 bg-blue-600 text-white rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-blue-500/20 active:scale-95 transition-all">Update Permanen</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Delete -->
                                        <form action="{{ route('admin.categories.delete', $category->id) }}" method="POST" onsubmit="return confirm('Hapus kategori ini?')">
                                            @csrf @method('DELETE')
                                            <button type="submit" class="p-4 rounded-2xl bg-red-500/10 text-red-500 hover:bg-red-500 hover:text-white transition-all" title="Hapus Kategori">
                                                <i data-lucide="trash-2" class="w-5 h-5"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
