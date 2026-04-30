@extends('layouts.admin')

@section('title', 'Manajemen Pengguna')

@section('content')
<div class="max-w-7xl mx-auto">
    <!-- Success Alert -->
    @if(session('success'))
    <div class="mb-8 p-6 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="check-circle" class="w-6 h-6 text-emerald-600 dark:text-emerald-400"></i>
        <div class="text-emerald-800 dark:text-emerald-300 font-bold">{{ session('success') }}</div>
    </div>
    @endif

    <!-- Error Alert -->
    @if(session('error'))
    <div class="mb-8 p-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="alert-circle" class="w-6 h-6 text-red-600 dark:text-red-400"></i>
        <div class="text-red-800 dark:text-red-300 font-bold">{{ session('error') }}</div>
    </div>
    @endif

    <!-- Filters & Stats Area -->
    <div class="flex flex-col md:flex-row items-center justify-between gap-6 mb-10">
        <div class="flex bg-white dark:bg-slate-900 p-1.5 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
            <a href="{{ route('admin.users') }}" class="px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all {{ request()->routeIs('admin.users') ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/30' : 'text-gray-400 hover:text-slate-600' }}">Semua</a>
            <a href="{{ route('admin.users.active') }}" class="px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all {{ request()->routeIs('admin.users.active') ? 'bg-emerald-600 text-white shadow-lg shadow-emerald-500/30' : 'text-gray-400 hover:text-slate-600' }}">Aktif</a>
            <a href="{{ route('admin.users.inactive') }}" class="px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all {{ request()->routeIs('admin.users.inactive') ? 'bg-amber-600 text-white shadow-lg shadow-amber-500/30' : 'text-gray-400 hover:text-slate-600' }}">Nonaktif</a>
        </div>

        <div class="flex bg-white dark:bg-slate-900 px-6 py-2.5 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
            <span class="text-[10px] font-black uppercase tracking-widest text-slate-400">Total: <span class="text-slate-900 dark:text-white ml-2">{{ $users->total() }} User</span></span>
        </div>
    </div>

    <!-- Users Table Card -->
    <div class="admin-card">
        <div class="overflow-x-auto lg:overflow-visible no-scrollbar">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-gray-50/50 dark:bg-slate-800/50">
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Identitas User</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Role & Status</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Bergabung</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-center">Panel Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100/50 dark:divide-slate-800/50">
                    @foreach($users as $user)
                    <tr class="group hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-all">
                        <td class="px-8 py-6">
                            <div class="flex items-center gap-5">
                                <div class="w-14 h-14 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-600 text-white flex items-center justify-center font-black text-xl shadow-lg shadow-blue-500/20 group-hover:scale-110 transition-transform">
                                    {{ substr($user->name, 0, 1) }}
                                </div>
                                <div>
                                    <a href="{{ route('admin.users.detail', $user->id) }}" class="font-black text-slate-800 dark:text-white mb-0.5 hover:text-blue-500 transition-colors">{{ $user->name }}</a>
                                    <div class="text-xs font-medium text-slate-400 flex items-center gap-1.5">
                                        <i data-lucide="mail" class="w-3 h-3"></i>
                                        {{ $user->email }}
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex flex-col gap-2">
                                <div class="flex items-center gap-2">
                                    @if($user->role == 'admin')
                                        <span class="px-2.5 py-1 rounded-lg bg-orange-50 dark:bg-orange-500/10 text-orange-600 text-[8px] font-black uppercase tracking-widest border border-orange-100 dark:border-orange-500/20">Admin</span>
                                    @elseif($user->role == 'seller')
                                        <span class="px-2.5 py-1 rounded-lg bg-blue-50 dark:bg-blue-500/10 text-blue-600 text-[8px] font-black uppercase tracking-widest border border-blue-100 dark:border-blue-500/20">Seller</span>
                                    @else
                                        <span class="px-2.5 py-1 rounded-lg bg-gray-50 dark:bg-gray-500/10 text-gray-500 text-[8px] font-black uppercase tracking-widest border border-gray-100 dark:border-gray-500/20">Buyer</span>
                                    @endif
                                    
                                    @if($user->is_active)
                                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                                    @else
                                        <span class="w-1.5 h-1.5 rounded-full bg-slate-300"></span>
                                    @endif
                                </div>
                                <div class="text-[9px] font-black {{ $user->is_active ? 'text-emerald-600' : 'text-slate-400' }} uppercase tracking-widest italic">
                                    {{ $user->is_active ? 'Status: Aktif' : 'Status: Nonaktif' }}
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-6 whitespace-nowrap">
                            <div class="text-xs font-bold text-slate-400 uppercase tracking-widest">{{ $user->created_at->format('d M Y') }}</div>
                            <div class="text-[9px] font-medium text-slate-300 italic">{{ $user->created_at->diffForHumans() }}</div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex items-center justify-center gap-3">
                                @if($user->id !== auth()->id())
                                    <!-- Role Change -->
                                    <div class="relative group/pop">
                                        <button class="p-3 rounded-2xl bg-gray-50/10 text-slate-400 hover:bg-blue-600 hover:text-white transition-all shadow-sm" title="Ubah Role">
                                            <i data-lucide="user-cog" class="w-5 h-5"></i>
                                        </button>
                                        <div class="absolute right-0 top-full mt-3 w-56 bg-[#1e293b] rounded-[2rem] shadow-2xl border border-blue-500/30 z-[100] opacity-0 invisible group-hover/pop:opacity-100 group-hover/pop:visible transition-all duration-300 scale-95 group-hover/pop:scale-100 origin-top-right">
                                            <div class="p-6">
                                                <div class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-4 text-center">Update User Role</div>
                                                <form action="{{ route('admin.users.role', $user->id) }}" method="POST" class="space-y-3">
                                                    @csrf @method('PATCH')
                                                    <select name="role" class="w-full px-4 py-3 rounded-2xl bg-[#0b0f1a] border-none text-xs font-bold text-white focus:ring-2 focus:ring-blue-500">
                                                        <option value="buyer" {{ $user->role == 'buyer' ? 'selected' : '' }}>Set as Buyer</option>
                                                        <option value="seller" {{ $user->role == 'seller' ? 'selected' : '' }}>Set as Seller</option>
                                                        <option value="admin" {{ $user->role == 'admin' ? 'selected' : '' }}>Set as Admin</option>
                                                    </select>
                                                    <button type="submit" class="w-full py-3 bg-blue-600 text-white rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-blue-500/20">Apply Changes</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Toggle Status -->
                                    <form action="{{ route('admin.users.toggle-status', $user->id) }}" method="POST" onsubmit="return confirm('Update status user ini?')">
                                        @csrf @method('PATCH')
                                        <button type="submit" class="p-3 rounded-2xl {{ $user->is_active ? 'bg-amber-50 text-amber-500 hover:bg-amber-500' : 'bg-emerald-50 text-emerald-500 hover:bg-emerald-500' }} hover:text-white transition-all shadow-sm" title="{{ $user->is_active ? 'Nonaktifkan' : 'Aktifkan' }}">
                                            <i data-lucide="{{ $user->is_active ? 'user-x' : 'user-check' }}" class="w-5 h-5"></i>
                                        </button>
                                    </form>
                                    
                                    <!-- Delete -->
                                    <form action="{{ route('admin.users.delete', $user->id) }}" method="POST" onsubmit="return confirm('Hapus permanen user ini?')">
                                        @csrf @method('DELETE')
                                        <button type="submit" class="p-3 rounded-2xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all shadow-sm" title="Hapus Permanen">
                                            <i data-lucide="trash-2" class="w-5 h-5"></i>
                                        </button>
                                    </form>
                                @else
                                    <span class="px-4 py-2 rounded-xl bg-gray-50 dark:bg-slate-800 text-[10px] font-black text-slate-400 uppercase tracking-widest italic border border-dashed border-slate-200 dark:border-slate-700">Akun Anda</span>
                                @endif
                            </div>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        
        <!-- Pagination Area -->
        <div class="px-8 py-8 border-t border-gray-100 dark:border-slate-800 bg-gray-50/30 dark:bg-slate-800/20">
            {{ $users->links() }}
        </div>
    </div>
</div>
@endsection
