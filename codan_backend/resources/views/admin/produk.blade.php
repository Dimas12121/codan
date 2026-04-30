@extends('layouts.admin')

@section('title', 'Manajemen Iklan')

@section('content')
<div class="max-w-7xl mx-auto">
    @if(session('success'))
    <div class="mb-8 p-6 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-[2rem] flex items-center gap-4">
        <i data-lucide="check-circle" class="w-6 h-6 text-emerald-600 dark:text-emerald-400"></i>
        <div class="text-emerald-800 dark:text-emerald-300 font-bold">{{ session('success') }}</div>
    </div>
    @endif

    <!-- produks Table Card -->
    <div class="admin-card">
        <div class="overflow-x-auto lg:overflow-visible no-scrollbar">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-gray-50/50 dark:bg-slate-800/50">
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Informasi Iklan</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Penjual & Kategori</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Status</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100/50 dark:divide-slate-800/50">
                    @foreach($produks as $produk)
                    <tr class="group hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-all">
                        <td class="px-8 py-6">
                            <div class="flex items-center gap-6">
                                <div class="w-20 h-20 rounded-2xl overflow-hidden shrink-0 shadow-lg group-hover:scale-105 transition-transform duration-500">
                                    <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover">
                                </div>
                                <div class="min-w-0">
                                    <div class="font-black text-slate-800 dark:text-white truncate max-w-[250px]">{{ $produk->title }}</div>
                                    <div class="text-sm font-bold text-blue-600 italic mt-0.5">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                                    <div class="text-[9px] font-black text-gray-400 uppercase tracking-widest mt-1 italic">{{ $produk->created_at->format('d M Y') }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex flex-col gap-2">
                                <div class="flex items-center gap-2">
                                    <div class="w-6 h-6 rounded-lg bg-slate-100 dark:bg-slate-800 flex items-center justify-center">
                                        <i data-lucide="user" class="w-3 h-3 text-slate-400"></i>
                                    </div>
                                    <span class="text-xs font-bold text-slate-600 dark:text-gray-300">{{ $produk->user->name }}</span>
                                    <span class="text-xs font-bold text-slate-600 dark:text-gray-300">{{ $produk->user->phone }}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <div class="w-6 h-6 rounded-lg bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
                                        <i data-lucide="tag" class="w-3 h-3 text-blue-500"></i>
                                    </div>
                                    <span class="text-[10px] font-black text-blue-500 uppercase tracking-widest">{{ $produk->category->name }}</span>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            @php
                                $statusClasses = [
                                    'active' => 'bg-emerald-50 text-emerald-600 border-emerald-100',
                                    'draft' => 'bg-slate-50 text-slate-400 border-slate-100',
                                    'sold' => 'bg-blue-50 text-blue-600 border-blue-100',
                                    'rejected' => 'bg-red-50 text-red-600 border-red-100'
                                ];
                            @endphp
                            <span class="px-3 py-1.5 rounded-xl text-[9px] font-black uppercase tracking-widest border {{ $statusClasses[$produk->status] ?? $statusClasses['draft'] }}">
                                {{ $produk->status }}
                            </span>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex items-center justify-center gap-3">
                                <!-- Change Status -->
                                <div class="relative group/pop">
                                    <button class="p-3 rounded-2xl bg-gray-50/10 text-slate-400 hover:bg-blue-600 hover:text-white transition-all shadow-sm" title="Moderasi Status">
                                        <i data-lucide="refresh-cw" class="w-5 h-5"></i>
                                    </button>
                                    <div class="absolute right-0 top-full mt-3 w-56 bg-[#1e293b] rounded-[2rem] shadow-2xl border border-blue-500/30 z-[100] opacity-0 invisible group-hover/pop:opacity-100 group-hover/pop:visible transition-all duration-300 scale-95 group-hover/pop:scale-100 origin-top-right">
                                        <div class="p-6">
                                            <div class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-4 text-center border-b border-slate-700/50 pb-2">Moderasi Iklan</div>
                                            <form action="{{ route('admin.produks.update-status', $produk->id) }}" method="POST" class="space-y-2">
                                                @csrf @method('PATCH')
                                                <div class="grid grid-cols-1 gap-1">
                                                    @foreach(['active', 'draft', 'sold', 'rejected'] as $status)
                                                    <button type="submit" name="status" value="{{ $status }}" class="px-4 py-2 text-left rounded-xl hover:bg-blue-600/20 text-[10px] font-black uppercase tracking-widest {{ $produk->status == $status ? 'text-blue-500' : 'text-slate-400' }} transition-all">
                                                        {{ $status }}
                                                    </button>
                                                    @endforeach
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <a href="{{ route('produks.show', $produk->slug) }}" target="_blank" class="p-3 rounded-2xl bg-gray-50 dark:bg-slate-800 text-slate-400 hover:bg-indigo-600 hover:text-white transition-all shadow-sm" title="Lihat Iklan">
                                    <i data-lucide="eye" class="w-5 h-5"></i>
                                </a>

                                <!-- Delete -->
                                <form action="{{ route('admin.produks.delete', $produk->id) }}" method="POST" onsubmit="return confirm('Hapus iklan ini?')">
                                    @csrf @method('DELETE')
                                    <button type="submit" class="p-3 rounded-2xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all shadow-sm" title="Hapus Iklan">
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
        <div class="p-8 border-t border-gray-100 dark:border-slate-800">
            {{ $produks->links() }}
        </div>
    </div>
</div>
@endsection
