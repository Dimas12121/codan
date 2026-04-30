<x-app-layout>
    <div class="bg-gray-50 dark:bg-slate-950 min-h-screen pb-24 sm:pb-12">
        <!-- Header Section -->
        <div class="max-w-xl mx-auto pt-6 px-4">
            <!-- Profile Card -->
            <div class="bg-white dark:bg-slate-900 rounded-[2rem] p-6 shadow-sm border border-slate-100 dark:border-slate-800">
                <div class="flex items-center gap-4">
                    <div class="relative">
                        <div class="w-16 h-16 sm:w-20 sm:h-20 rounded-full border-2 border-slate-50 dark:border-slate-800 bg-slate-100 dark:bg-slate-800 overflow-hidden shadow-sm">
                            @if($user->avatar)
                                <img src="{{ asset('storage/' . $user->avatar) }}" alt="{{ $user->name }}" class="w-full h-full object-cover">
                            @else
                                <div class="w-full h-full flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-slate-800 dark:to-slate-700">
                                    <i data-lucide="user" class="w-8 h-8 text-blue-500"></i>
                                </div>
                            @endif
                        </div>
                    </div>
                    <div>
                        <h2 class="text-xl font-bold text-slate-900 dark:text-white leading-tight">{{ $user->name }}</h2>
                        <p class="text-xs text-slate-400 dark:text-slate-500">{{ $user->email }}</p>
                        <div class="mt-2 inline-flex items-center px-2 py-0.5 rounded-md bg-blue-50 dark:bg-blue-900/20 text-[10px] font-bold text-blue-600 dark:text-blue-400 gap-1 italic">
                            <i data-lucide="award" class="w-3 h-3"></i>
                            {{ $user->role == 'seller' ? 'Premium Seller' : 'Verified Member' }}
                        </div>
                    </div>
                </div>

                <!-- Stats Row (Horizontal) -->
                <div class="flex items-center justify-between gap-2 mt-8 pt-6 border-t border-slate-50 dark:border-slate-800">
                    <div class="flex flex-col items-center justify-center flex-1">
                        <div class="flex items-baseline gap-1">
                            <span class="text-xl font-bold text-slate-900 dark:text-white">{{ $stats['products_count'] }}</span>
                            <span class="text-[10px] text-slate-400 font-bold uppercase tracking-tighter">Produk</span>
                        </div>
                    </div>
                    <div class="flex flex-col items-center justify-center flex-1 border-l border-slate-50 dark:border-slate-800">
                        <div class="flex items-baseline gap-1">
                            <span class="text-xl font-bold text-slate-900 dark:text-white">{{ $stats['transactions_count'] }}</span>
                            <span class="text-[10px] text-slate-400 font-bold uppercase tracking-tighter">Trans</span>
                        </div>
                    </div>
                    <div class="flex flex-col items-center justify-center flex-1 border-l border-slate-50 dark:border-slate-800">
                        <div class="flex items-baseline gap-1">
                            <span class="text-xl font-bold text-slate-900 dark:text-white">{{ $stats['response_rate'] }}</span>
                            <span class="text-[10px] text-slate-400 font-bold uppercase tracking-tighter">Respon</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Action Cards (Horizontal) -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-4">
                <a href="#" class="bg-white dark:bg-slate-900 p-3 rounded-2xl border border-slate-50 dark:border-slate-800 flex items-center gap-3 group active:scale-95 transition-all shadow-sm shadow-slate-100">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-slate-800 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-all shrink-0">
                        <i data-lucide="history" class="w-5 h-5"></i>
                    </div>
                    <span class="text-xs font-bold text-slate-600 dark:text-slate-400">Riwayat</span>
                </a>
                <a href="{{ route('wishlist.index') }}" class="bg-white dark:bg-slate-900 p-3 rounded-2xl border border-slate-50 dark:border-slate-800 flex items-center gap-3 group active:scale-95 transition-all shadow-sm shadow-slate-100">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-slate-800 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-all shrink-0">
                        <i data-lucide="heart" class="w-5 h-5"></i>
                    </div>
                    <span class="text-xs font-bold text-slate-600 dark:text-slate-400">Wishlist</span>
                </a>
                <a href="#" class="bg-white dark:bg-slate-900 p-3 rounded-2xl border border-slate-50 dark:border-slate-800 flex items-center gap-3 group active:scale-95 transition-all shadow-sm shadow-slate-100">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-slate-800 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-all shrink-0">
                        <i data-lucide="tag" class="w-5 h-5"></i>
                    </div>
                    <span class="text-xs font-bold text-slate-600 dark:text-slate-400">Promo</span>
                </a>
                <a href="#" class="bg-white dark:bg-slate-900 p-3 rounded-2xl border border-slate-50 dark:border-slate-800 flex items-center gap-3 group active:scale-95 transition-all shadow-sm shadow-slate-100">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-slate-800 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-all shrink-0">
                        <i data-lucide="help-circle" class="w-5 h-5"></i>
                    </div>
                    <span class="text-xs font-bold text-slate-600 dark:text-slate-400">Bantuan</span>
                </a>
            </div>

            <!-- List Sections -->
            <div class="mt-8 space-y-6">
                <!-- Transaksi Section -->
                <div>
                    <h3 class="text-lg font-black text-slate-900 dark:text-white px-2 mb-3">Transaksi</h3>
                    <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-100 dark:border-slate-800 overflow-hidden shadow-sm">
                        <a href="#" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors border-b border-slate-50 dark:border-slate-800">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="shopping-bag" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Riwayat Transaksi</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                        <a href="{{ route('wishlist.index') }}" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="heart" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Wishlist</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                    </div>
                </div>

                <!-- Jual & Sewa Section -->
                <div>
                    <h3 class="text-lg font-black text-slate-900 dark:text-white px-2 mb-3">Jual & Sewa</h3>
                    <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-100 dark:border-slate-800 overflow-hidden shadow-sm">
                        <a href="{{ route('dashboard') }}" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors border-b border-slate-50 dark:border-slate-800">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="store" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Produk Saya</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                        <a href="#" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors border-b border-slate-50 dark:border-slate-800">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="repeat" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Sewaan Saya</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                        <a href="#" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="star" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Ulasan & Rating</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                    </div>
                </div>

                <!-- Lainnya Section -->
                <div>
                    <h3 class="text-lg font-black text-slate-900 dark:text-white px-2 mb-3">Lainnya</h3>
                    <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-100 dark:border-slate-800 overflow-hidden shadow-sm">
                        <a href="{{ route('profile.edit') }}" class="flex items-center justify-between p-5 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-600">
                                    <i data-lucide="settings" class="w-5 h-5"></i>
                                </div>
                                <span class="text-sm font-bold text-slate-700 dark:text-slate-200">Pengaturan</span>
                            </div>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-300"></i>
                        </a>
                    </div>
                </div>
                
                <!-- Logout Button -->
                <div class="pt-4">
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit" class="w-full p-5 bg-red-50 dark:bg-red-900/10 rounded-[2rem] border border-red-100 dark:border-red-900/20 text-red-600 font-black uppercase tracking-widest text-xs flex items-center justify-center gap-2 active:scale-95 transition-all">
                            <i data-lucide="log-out" class="w-4 h-4"></i>
                            Keluar Akun
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
