@extends('layouts.admin')

@section('title', 'Dashboard')

@section('content')
<div class="max-w-7xl mx-auto">
    @if(session('success'))
    <div class="mb-8 p-6 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="check-circle" class="w-6 h-6 text-green-600 dark:text-green-400"></i>
        <div class="text-green-800 dark:text-green-300 font-bold">{{ session('success') }}</div>
    </div>
    @endif
    
    <!-- Hero Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
        <div class="admin-card p-8 group overflow-hidden relative">
            <div class="absolute -right-4 -top-4 w-24 h-24 bg-blue-500/5 rounded-full blur-2xl group-hover:bg-blue-500/10 transition-all"></div>
            <div class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Total Pengguna</div>
            <div class="flex items-end gap-3">
                <div class="text-5xl font-black tracking-tighter">{{ $stats['users'] }}</div>
                <div class="text-xs font-bold text-green-600 mb-1.5 flex items-center gap-1">
                    <i data-lucide="arrow-up-right" class="w-3 h-3"></i>
                    {{ $stats['active_users'] }} Aktif
                </div>
            </div>
            <div class="mt-6 flex gap-1 h-1 bg-gray-100 dark:bg-slate-800 rounded-full overflow-hidden">
                <div class="h-full bg-blue-600" style="width: 70%"></div>
            </div>
        </div>

        <div class="admin-card p-8 group overflow-hidden relative">
            <div class="absolute -right-4 -top-4 w-24 h-24 bg-emerald-500/5 rounded-full blur-2xl group-hover:bg-emerald-500/10 transition-all"></div>
            <div class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Iklan Terpasang</div>
            <div class="flex items-end gap-3">
                <div class="text-5xl font-black tracking-tighter">{{ $stats['produks'] }}</div>
                <div class="text-xs font-bold text-emerald-600 mb-1.5">{{ $stats['active_produks'] }} Live</div>
            </div>
            <div class="mt-6 flex gap-1 h-1 bg-gray-100 dark:bg-slate-800 rounded-full overflow-hidden">
                <div class="h-full bg-emerald-500" style="width: 85%"></div>
            </div>
        </div>

        <div class="admin-card p-8 group overflow-hidden relative">
            <div class="absolute -right-4 -top-4 w-24 h-24 bg-red-500/5 rounded-full blur-2xl group-hover:bg-red-500/10 transition-all"></div>
            <div class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Laporan Masukan</div>
            <div class="flex items-end gap-3">
                <div class="text-5xl font-black tracking-tighter text-red-600">{{ $stats['pending_reports'] }}</div>
                <div class="text-xs font-bold text-red-400 mb-1.5">Action Required</div>
            </div>
            <div class="mt-6 flex gap-1 h-1 bg-gray-100 dark:bg-slate-800 rounded-full overflow-hidden">
                <div class="h-full bg-red-500" style="width: 40%"></div>
            </div>
        </div>

        <div class="admin-card p-8 group overflow-hidden relative">
            <div class="absolute -right-4 -top-4 w-24 h-24 bg-indigo-500/5 rounded-full blur-2xl group-hover:bg-indigo-500/10 transition-all"></div>
            <div class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Staff Aktif</div>
            <div class="flex items-end gap-3">
                <div class="text-5xl font-black tracking-tighter text-indigo-600">{{ $stats['admins'] }}</div>
                <div class="text-xs font-bold text-indigo-400 mb-1.5 italic">Moderators</div>
            </div>
            <div class="mt-6 h-1 bg-indigo-100 dark:bg-slate-800 rounded-full overflow-hidden">
                <div class="h-full bg-indigo-600" style="width: 100%"></div>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
        <!-- Monitoring Center -->
        <div class="lg:col-span-2 admin-card p-10">
            <div class="flex items-center justify-between mb-10">
                <h3 class="text-xl font-black uppercase tracking-tighter flex items-center gap-3">
                    <span class="w-1.5 h-6 bg-blue-600 rounded-full"></span>
                    Iklan Populer
                </h3>
                <div class="flex gap-2">
                    <button class="px-4 py-2 bg-gray-50 dark:bg-slate-800 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-blue-600 hover:text-white transition-all shadow-sm">Views</button>
                    <button class="px-4 py-2 text-[10px] font-black uppercase tracking-widest text-gray-400">Date</button>
                </div>
            </div>
            
            <div class="space-y-6">
                @foreach($topproduks as $top)
                <div class="flex items-center gap-6 p-4 rounded-3xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-all group">
                    <div class="w-20 h-20 rounded-2xl overflow-hidden shrink-0 shadow-lg">
                        <img src="{{ $top->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                    </div>
                    <div class="flex-1 min-w-0">
                        <div class="flex items-center gap-2 mb-1">
                            <span class="px-2 py-0.5 rounded-md bg-blue-50 dark:bg-blue-900/40 text-[8px] font-black text-blue-600 uppercase tracking-widest">{{ $top->category->name }}</span>
                            <span class="text-[9px] font-bold text-gray-400 uppercase tracking-widest italic">{{ $top->created_at->diffForHumans() }}</span>
                        </div>
                        <h4 class="font-black text-lg text-slate-800 dark:text-gray-100 truncate group-hover:text-blue-600 transition-colors">{{ $top->title }}</h4>
                        <div class="flex items-center gap-4 mt-2">
                            <div class="flex items-center gap-1.5 text-xs font-bold text-gray-400">
                                <i data-lucide="eye" class="w-3.5 h-3.5"></i>
                                {{ number_format($top->views, 0, ',', '.') }} Views
                            </div>
                            <div class="flex items-center gap-1.5 text-xs font-bold text-gray-400">
                                <i data-lucide="user" class="w-3.5 h-3.5"></i>
                                {{ $top->user->name }}
                            </div>
                        </div>
                    </div>
                    <a href="{{ route('produks.show', $top->slug) }}" target="_blank" class="p-4 rounded-2xl bg-gray-100 dark:bg-slate-800 text-gray-400 hover:bg-blue-600 hover:text-white transition-all">
                        <i data-lucide="external-link" class="w-5 h-5"></i>
                    </a>
                </div>
                @endforeach
            </div>
        </div>

        <!-- System Activity -->
        <div class="admin-card p-10 flex flex-col">
            <div class="flex items-center justify-between mb-10">
                <h3 class="text-xl font-black uppercase tracking-tighter flex items-center gap-3">
                    <span class="w-1.5 h-6 bg-emerald-500 rounded-full"></span>
                    User Baru
                </h3>
                <a href="{{ route('admin.users') }}" class="text-[10px] font-black text-blue-600 uppercase tracking-widest hover:underline">Semua</a>
            </div>

            <div class="space-y-8 flex-1">
                @foreach($recentUsers as $user)
                <div class="flex items-center gap-4 relative">
                    <div class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-slate-100 to-slate-200 dark:from-slate-800 dark:to-slate-700 flex items-center justify-center text-slate-600 dark:text-gray-400 font-black shadow-inner">
                        {{ substr($user->name, 0, 1) }}
                    </div>
                    <div class="flex-1">
                        <div class="text-sm font-black text-slate-800 dark:text-gray-100">{{ $user->name }}</div>
                        <div class="text-[9px] font-bold text-gray-400 uppercase tracking-[0.2em]">{{ $user->email }}</div>
                    </div>
                    @if($user->role == 'admin')
                        <i data-lucide="shield-check" class="w-4 h-4 text-blue-500"></i>
                    @endif
                </div>
                @endforeach
            </div>

            <div class="mt-10 p-6 bg-blue-600 rounded-[2rem] text-white">
                <div class="flex items-start justify-between mb-4">
                    <div class="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
                        <i data-lucide="zap" class="w-5 h-5 fill-white"></i>
                    </div>
                    <div class="text-right">
                        <div class="text-[8px] font-black uppercase tracking-[0.2em] opacity-60">Health Status</div>
                        <div class="text-sm font-black italic">OPTIMAL</div>
                    </div>
                </div>
                <p class="text-[10px] font-bold leading-relaxed opacity-90">Sistem bekerja dengan performa terbaik. Monitoring real-time aktif.</p>
            </div>
        </div>
    </div>
</div>
@endsection
