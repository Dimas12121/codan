<x-app-layout>
    <div class="bg-gray-50 dark:bg-slate-950 min-h-screen pb-32">
        <!-- Mobile Header -->
        <div class="px-6 pt-8 pb-6 bg-white dark:bg-slate-900 rounded-b-[3rem] shadow-sm border-b border-gray-100 dark:border-slate-800">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 dark:text-white italic tracking-tighter leading-tight">
                        {{ auth()->user()->role == 'seller' ? 'DASHBOARD PENJUAL' : 'DASHBOARD PEMBELI' }}
                    </h2>
                    <p class="text-slate-500 font-medium text-xs mt-1">Hello, {{ auth()->user()->name }}!</p>
                </div>
                <div class="px-3 py-1 rounded-full bg-blue-100 text-blue-600 text-[10px] font-black uppercase tracking-widest">{{ auth()->user()->role }}</div>
            </div>

            @if(auth()->user()->role == 'seller')
            <a href="{{ route('produks.create') }}" class="w-full flex items-center justify-center gap-3 py-4 rounded-2xl bg-blue-600 text-white text-sm font-black shadow-xl shadow-blue-500/20 active:scale-95 transition-all">
                <i data-lucide="plus" class="w-5 h-5"></i>
                IKLAN BARU
            </a>
            @else
            <a href="{{ route('home') }}" class="w-full flex items-center justify-center gap-3 py-4 rounded-2xl bg-indigo-600 text-white text-sm font-black shadow-xl shadow-indigo-500/20 active:scale-95 transition-all">
                <i data-lucide="shopping-bag" class="w-5 h-5"></i>
                MULAI BELANJA
            </a>
            @endif
        </div>

        <div class="px-6 mt-8">
            @if(auth()->user()->role == 'buyer')
                <!-- Search Section -->
                <div class="space-y-4 bg-white dark:bg-slate-900 p-6 rounded-[2.5rem] shadow-sm border border-gray-100 dark:border-slate-800">
                    <form action="{{ route('dashboard') }}" method="GET" class="space-y-4">
                        <div class="relative">
                            <i data-lucide="map-pin" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"></i>
                            <input type="text" class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 dark:bg-slate-800 border-none text-sm font-semibold focus:ring-2 focus:ring-blue-500" placeholder="Seluruh Indonesia">
                        </div>
                        <div class="relative">
                            <i data-lucide="search" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"></i>
                            <input type="text" name="search" value="{{ request('search') }}" class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 dark:bg-slate-800 border-none text-sm font-semibold focus:ring-2 focus:ring-blue-500" placeholder="Cari Mobil, HP, dll...">
                        </div>
                        <button type="submit" class="w-full py-4 bg-blue-600 text-white rounded-2xl font-black uppercase tracking-widest shadow-lg shadow-blue-500/20 active:scale-95 transition-all">
                            CARI SEKARANG
                        </button>
                    </form>
                </div>

                <!-- Categories -->
                <div class="mt-10 overflow-x-auto no-scrollbar flex gap-4 pb-4">
                    <a href="{{ route('dashboard') }}" class="flex flex-col items-center gap-2 shrink-0">
                        <div class="w-16 h-16 rounded-2xl {{ !request('category') ? 'bg-blue-600 text-white' : 'bg-white dark:bg-slate-900 border border-gray-100 dark:border-slate-800' }} flex items-center justify-center shadow-sm">
                            <i data-lucide="layout-grid" class="w-6 h-6"></i>
                        </div>
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-500">Semua</span>
                    </a>
                    @foreach($categories as $category)
                    <a href="{{ route('dashboard', array_merge(request()->query(), ['category' => $category->slug])) }}" class="flex flex-col items-center gap-2 shrink-0">
                        <div class="w-16 h-16 rounded-2xl {{ request('category') == $category->slug ? 'bg-blue-600 text-white' : 'bg-white dark:bg-slate-900 border border-gray-100 dark:border-slate-800' }} flex items-center justify-center shadow-sm">
                            <i data-lucide="{{ $category->icon ?: 'tag' }}" class="w-6 h-6"></i>
                        </div>
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-500">{{ $category->name }}</span>
                    </a>
                    @endforeach
                </div>

                <!-- Recommendations -->
                <div class="mt-10 mb-6">
                    <h3 class="text-xl font-black italic tracking-tighter flex items-center gap-2">
                        <span class="w-2 h-6 bg-blue-600 rounded-full"></span>
                        REKOMENDASI
                    </h3>
                </div>

                <div class="grid grid-cols-1 gap-6">
                    @foreach($recommendations as $produk)
                    <a href="{{ route('produks.show', $produk->slug) }}" class="bg-white dark:bg-slate-900 rounded-[2.5rem] overflow-hidden border border-gray-100 dark:border-slate-800 shadow-sm flex">
                        <div class="w-32 h-32 shrink-0 p-2">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover rounded-2xl">
                        </div>
                        <div class="p-4 flex flex-col justify-between flex-1 min-w-0">
                            <div>
                                <h4 class="text-sm font-bold text-slate-800 dark:text-gray-100 truncate">{{ $produk->title }}</h4>
                                <div class="text-lg font-black text-blue-600 italic tracking-tighter mt-1">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                            </div>
                            <div class="flex items-center justify-between text-[8px] font-black uppercase tracking-widest text-gray-400">
                                <span>{{ $produk->category->name }}</span>
                                <span>{{ $produk->created_at->diffForHumans() }}</span>
                            </div>
                        </div>
                    </a>
                    @endforeach
                </div>
            @else
                <!-- Seller View Stats -->
                <div class="grid grid-cols-2 gap-4">
                    <div class="bg-white dark:bg-slate-900 p-5 rounded-[2rem] border border-gray-100 dark:border-slate-800 shadow-sm">
                        <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center mb-3">
                            <i data-lucide="layout-grid" class="w-5 h-5 text-blue-600"></i>
                        </div>
                        <div class="text-[8px] font-black uppercase tracking-widest text-gray-400">Iklan</div>
                        <div class="text-xl font-black">{{ $produks->count() }}</div>
                    </div>
                    <div class="bg-white dark:bg-slate-900 p-5 rounded-[2rem] border border-gray-100 dark:border-slate-800 shadow-sm">
                        <div class="w-10 h-10 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 flex items-center justify-center mb-3">
                            <i data-lucide="eye" class="w-5 h-5 text-emerald-600"></i>
                        </div>
                        <div class="text-[8px] font-black uppercase tracking-widest text-gray-400">Dilihat</div>
                        <div class="text-xl font-black">{{ number_format($totalViews ?? 0, 0, ',', '.') }}</div>
                    </div>
                </div>

                <div class="mt-10 flex gap-4 border-b border-gray-100 dark:border-slate-800 pb-4">
                    <a href="{{ route('dashboard', ['status' => 'active']) }}" class="text-[10px] font-black uppercase tracking-widest {{ ($status ?? 'active') == 'active' ? 'text-blue-600' : 'text-gray-400' }}">Iklan Aktif</a>
                    <a href="{{ route('dashboard', ['status' => 'sold']) }}" class="text-[10px] font-black uppercase tracking-widest {{ ($status ?? '') == 'sold' ? 'text-blue-600' : 'text-gray-400' }}">Terjual</a>
                </div>

                <div class="mt-6 space-y-4">
                    @foreach($produks as $produk)
                    <div class="bg-white dark:bg-slate-900 rounded-[2.5rem] overflow-hidden border border-gray-100 dark:border-slate-800 shadow-sm p-4">
                        <div class="flex gap-4">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-20 h-20 rounded-2xl object-cover">
                            <div class="flex-1 min-w-0 flex flex-col justify-between">
                                <h4 class="text-sm font-bold truncate">{{ $produk->title }}</h4>
                                <div class="text-base font-black text-blue-600 italic tracking-tighter">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                                <div class="flex gap-2">
                                    <span class="px-2 py-0.5 rounded-lg bg-emerald-50 text-emerald-600 text-[8px] font-black uppercase tracking-widest">{{ $produk->status }}</span>
                                    <span class="px-2 py-0.5 rounded-lg bg-gray-50 text-slate-500 text-[8px] font-black uppercase tracking-widest">{{ $produk->condition }}</span>
                                </div>
                            </div>
                        </div>
                        <div class="grid grid-cols-3 gap-2 mt-4 pt-4 border-t border-gray-50 dark:border-slate-800/50">
                            <a href="{{ route('produks.show', $produk->slug) }}" class="flex items-center justify-center py-2 rounded-xl bg-gray-50 text-[8px] font-black uppercase tracking-widest">Detail</a>
                            <a href="{{ route('produks.edit', $produk->id) }}" class="flex items-center justify-center py-2 rounded-xl bg-gray-50 text-[8px] font-black uppercase tracking-widest text-blue-600">Edit</a>
                            <form action="{{ route('produks.destroy', $produk->id) }}" method="POST" class="w-full">
                                @csrf
                                @method('DELETE')
                                <button class="w-full flex items-center justify-center py-2 rounded-xl bg-red-50 text-[8px] font-black uppercase tracking-widest text-red-600">Hapus</button>
                            </form>
                        </div>
                    </div>
                    @endforeach
                </div>
            @endif
        </div>
    </div>
</x-app-layout>
