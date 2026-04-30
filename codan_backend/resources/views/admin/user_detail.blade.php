@extends('layouts.admin')

@section('title', 'Detail User: ' . $user->name)

@section('content')
<div class="max-w-7xl mx-auto">
    <div class="mb-10">
        <a href="{{ route('admin.users') }}" class="inline-flex items-center gap-2 text-xs font-black uppercase tracking-widest text-slate-400 hover:text-blue-500 transition-all">
            <i data-lucide="arrow-left" class="w-4 h-4"></i>
            Kembali ke Daftar User
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        <!-- Sidebar Detail -->
        <div class="lg:col-span-1 space-y-8">
            <div class="admin-card p-10 text-center relative overflow-hidden group">
                <div class="absolute inset-0 bg-gradient-to-b from-blue-600/5 to-transparent"></div>
                <div class="relative z-10">
                    <div class="w-32 h-32 rounded-[2.5rem] bg-gradient-to-tr from-blue-600 to-indigo-700 text-white flex items-center justify-center font-black text-5xl shadow-2xl mx-auto mb-8 group-hover:scale-105 transition-transform duration-500">
                        {{ substr($user->name, 0, 1) }}
                    </div>
                    <h3 class="text-2xl font-black text-white italic tracking-tighter">{{ $user->name }}</h3>
                    <p class="text-sm font-bold text-slate-400 mt-2 mb-4">{{ $user->email }}</p>
                    
                    <div class="space-y-4 mb-8 text-left max-w-[240px] mx-auto border-t border-slate-800 pt-6">
                        <div class="flex items-center gap-3 group/item">
                            <div class="w-8 h-8 rounded-lg bg-blue-500/10 flex items-center justify-center text-blue-500 group-hover/item:bg-blue-600 group-hover/item:text-white transition-all">
                                <i data-lucide="phone" class="w-4 h-4"></i>
                            </div>
                            <div>
                                <div class="text-[8px] font-black uppercase tracking-widest text-slate-500">Nomor Telepon</div>
                                <div class="text-xs font-bold text-slate-300">{{ $user->phone ?: 'Belum Ada Data' }}</div>
                            </div>
                        </div>
                        
                        <div class="flex items-center gap-3 group/item">
                            <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-500 group-hover/item:bg-emerald-600 group-hover/item:text-white transition-all">
                                <i data-lucide="map-pin" class="w-4 h-4"></i>
                            </div>
                            <div class="flex-1 min-w-0">
                                <div class="text-[8px] font-black uppercase tracking-widest text-slate-500">Lokasi Terkini</div>
                                <div class="text-xs font-bold text-slate-300 truncate">{{ $user->location ?: 'Belum Diatur' }}</div>
                            </div>
                            @if($user->location)
                            <a href="https://www.google.com/maps/search/?api=1&query={{ urlencode($user->location) }}" target="_blank" class="p-2 rounded-lg bg-slate-800 text-slate-400 hover:text-white hover:bg-emerald-600 transition-all shadow-lg" title="Lihat di Maps">
                                <i data-lucide="navigation" class="w-3 h-3"></i>
                            </a>
                            @endif
                        </div>
                    </div>
                    
                    <div class="flex items-center justify-center gap-3">
                        <span class="px-4 py-1.5 rounded-xl bg-blue-600/10 text-blue-500 text-[10px] font-black uppercase tracking-widest border border-blue-600/20">
                            {{ $user->role }}
                        </span>
                        <span class="px-4 py-1.5 rounded-xl {{ $user->is_active ? 'bg-emerald-600/10 text-emerald-500' : 'bg-red-600/10 text-red-500' }} text-[10px] font-black uppercase tracking-widest border {{ $user->is_active ? 'border-emerald-600/20' : 'border-red-600/20' }}">
                            {{ $user->is_active ? 'AKTIF' : 'NONAKTIF' }}
                        </span>
                    </div>
                </div>
            </div>

            <div class="admin-card p-10 bg-red-600/5 border-red-500/20">
                <h4 class="text-xs font-black uppercase tracking-[0.3em] text-red-500 mb-6 flex items-center gap-2">
                    <i data-lucide="shield-alert" class="w-4 h-4"></i>
                    Fraud Investigation
                </h4>
                <div class="space-y-4">
                    <p class="text-[10px] font-bold text-slate-500 leading-relaxed italic">Gunakan metode OSINT untuk memverifikasi nomor telepon ini di database penipuan.</p>
                    
                    <div class="grid grid-cols-2 gap-3">
                        @if($user->phone)
                        <a href="https://www.truecaller.com/search/id/{{ $user->phone }}" target="_blank" class="flex flex-col items-center gap-2 p-4 rounded-2xl bg-slate-900 border border-slate-800 hover:border-blue-500 hover:bg-blue-600/10 transition-all group">
                            <i data-lucide="search" class="w-5 h-5 text-blue-500 group-hover:scale-110 transition-transform"></i>
                            <span class="text-[9px] font-black uppercase tracking-widest text-slate-400">Truecaller</span>
                        </a>
                        <a href="https://wa.me/{{ preg_replace('/[^0-9]/', '', $user->phone) }}" target="_blank" class="flex flex-col items-center gap-2 p-4 rounded-2xl bg-slate-900 border border-slate-800 hover:border-emerald-500 hover:bg-emerald-600/10 transition-all group">
                            <i data-lucide="message-square" class="w-5 h-5 text-emerald-500 group-hover:scale-110 transition-transform"></i>
                            <span class="text-[9px] font-black uppercase tracking-widest text-slate-400">WhatsApp</span>
                        </a>
                        <a href="https://www.google.com/search?q=%22{{ $user->phone }}%22+penipu+OR+fraud" target="_blank" class="col-span-2 flex items-center justify-center gap-3 p-4 rounded-2xl bg-slate-900 border border-slate-800 hover:border-red-500 hover:bg-red-600/10 transition-all group">
                            <i data-lucide="globe" class="w-4 h-4 text-red-500"></i>
                            <span class="text-[9px] font-black uppercase tracking-widest text-slate-400">Search Scam Database (Google)</span>
                        </a>
                        @else
                        <div class="col-span-2 py-4 text-center text-[10px] font-bold text-slate-600 italic">Nomor telepon tidak tersedia untuk investigasi.</div>
                        @endif
                    </div>
                </div>
            </div>

            <div class="admin-card p-10">
                <h4 class="text-xs font-black uppercase tracking-[0.3em] text-slate-500 mb-8 pb-4 border-b border-slate-800">Statistik Penjual</h4>
                <div class="space-y-8">
                    <div class="flex items-center justify-between">
                        <div class="text-xs font-bold text-slate-400 italic">Total Iklan</div>
                        <div class="text-xl font-black text-white">{{ $user->produks_count }}</div>
                    </div>
                    <div class="flex items-center justify-between">
                        <div class="text-xs font-bold text-slate-400 italic">Iklan Aktif</div>
                        <div class="text-xl font-black text-emerald-500">{{ $stats['active_produks'] }}</div>
                    </div>
                    <div class="flex items-center justify-between">
                        <div class="text-xs font-bold text-slate-400 italic">Iklan Terjual</div>
                        <div class="text-xl font-black text-blue-500">{{ $stats['sold_produks'] }}</div>
                    </div>
                    <div class="flex items-center justify-between">
                        <div class="text-xs font-bold text-slate-400 italic">Total Jangkauan</div>
                        <div class="text-xl font-black text-white flex items-center gap-2">
                            {{ number_format($stats['total_views'], 0, ',', '.') }}
                            <i data-lucide="eye" class="w-4 h-4 text-slate-500"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content (produks) -->
        <div class="lg:col-span-2 space-y-10">
            <div class="admin-card p-10">
                <div class="flex items-center justify-between mb-10">
                    <h3 class="text-xl font-black uppercase tracking-tighter flex items-center gap-3">
                        <span class="w-1.5 h-6 bg-blue-600 rounded-full"></span>
                        History Iklan User
                    </h3>
                </div>

                <div class="space-y-6">
                    @forelse($user->produks as $produk)
                    <div class="flex items-center gap-6 p-5 rounded-3xl hover:bg-white/5 transition-all group border border-transparent hover:border-slate-800">
                        <div class="w-24 h-24 rounded-2xl overflow-hidden shrink-0 shadow-lg">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                        </div>
                        <div class="flex-1 min-w-0">
                            <div class="flex items-center gap-2 mb-1">
                                <span class="text-[9px] font-black {{ $produk->status == 'active' ? 'text-emerald-500' : 'text-slate-500' }} uppercase tracking-widest italic border-r border-slate-700 pr-3 mr-1">Status: {{ $produk->status }}</span>
                                <span class="text-[10px] font-bold text-blue-500 uppercase tracking-widest">{{ $produk->category->name }}</span>
                            </div>
                            <h4 class="font-black text-xl text-white truncate mb-1">{{ $produk->title }}</h4>
                            <div class="text-sm font-bold text-gray-500 italic">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                            <div class="flex items-center gap-4 mt-3">
                                <span class="text-[10px] font-bold text-slate-500 flex items-center gap-1">
                                    <i data-lucide="calendar" class="w-3 h-3"></i>
                                    {{ $produk->created_at->format('d M Y') }}
                                </span>
                                <span class="text-[10px] font-bold text-slate-500 flex items-center gap-1">
                                    <i data-lucide="eye" class="w-3 h-3"></i>
                                    {{ $produk->views }} Views
                                </span>
                            </div>
                        </div>
                        <a href="{{ route('produks.show', $produk->slug) }}" target="_blank" class="p-4 rounded-2xl bg-white/5 text-slate-500 hover:bg-blue-600 hover:text-white transition-all">
                            <i data-lucide="external-link" class="w-5 h-5"></i>
                        </a>
                    </div>
                    @empty
                    <div class="py-20 text-center text-slate-500 font-bold italic">User ini belum pernah memasang iklan.</div>
                    @endforelse
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
