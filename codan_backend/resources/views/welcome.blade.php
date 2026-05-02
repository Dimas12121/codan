<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="scroll-smooth">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>codan | Jual Beli Aman dan Nyaman</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        <style>
            body { font-family: 'Plus Jakarta Sans', sans-serif; }
            .glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(255, 255, 255, 0.2); }
            .blue-glass { background: rgba(30, 58, 138, 0.85); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(59, 130, 246, 0.3); }
            .dark .glass { background: rgba(15, 23, 42, 0.8); border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
            .sell-btn { background: linear-gradient(to right, #3b82f6, #6366f1); box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4); }
            .card-hover:hover { transform: translateY(-5px); box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1); }
            ::-webkit-scrollbar { width: 5px; height: 5px; }
            ::-webkit-scrollbar-track { background: transparent; }
            ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
            .no-scrollbar::-webkit-scrollbar { display: none; }
            
            @keyframes shimmer {
                0% { background-position: -200% 0; }
                100% { background-position: 200% 0; }
            }
            .shimmer-text {
                background: linear-gradient(90deg, #fff 0%, #3b82f6 50%, #fff 100%);
                background-size: 200% auto;
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                animation: shimmer 3s linear infinite;
            }
        </style>
    </head>
    <body class="bg-gray-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 antialiased transition-colors duration-300">
        
        <!-- Navbar -->
        <nav class="sticky top-0 z-50 blue-glass transition-all duration-300" id="main-nav">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col lg:flex-row lg:items-center justify-between py-4 lg:h-20 gap-4">
                    <!-- Logo & Search Integration -->
                    <div class="flex items-center justify-between lg:justify-start gap-4 lg:gap-8 w-full lg:w-auto">
                        <a href="/" class="flex-shrink-0 flex items-center gap-2 group relative">
                            <div class="w-10 h-10 lg:w-11 lg:h-11 sell-btn rounded-2xl flex items-center justify-center group-hover:scale-110 group-hover:rotate-12 transition-all duration-500 shadow-xl shadow-blue-500/40 relative overflow-hidden">
                                <div class="absolute inset-0 bg-gradient-to-tr from-transparent via-white/30 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                                <i data-lucide="shopping-bag" class="text-white w-4 h-4 lg:w-5 lg:h-5"></i>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-lg lg:text-xl font-black tracking-tighter text-white uppercase italic shimmer-text leading-none">codan</span>
                                <span class="text-[7px] lg:text-[8px] font-black tracking-[0.4em] text-blue-400 mt-0.5 ml-0.5">MARKETPLACE</span>
                            </div>
                        </a>

                        <!-- Mobile Search Trigger (only on very small screens) -->
                        <div class="lg:hidden flex items-center gap-3">
                            <a href="{{ route('inbox.index') }}" class="relative p-2 text-white">
                                <i data-lucide="message-circle" class="w-6 h-6"></i>
                                @if($unreadCount > 0)
                                <span class="absolute top-0 right-0 w-4 h-4 bg-red-500 rounded-full border border-blue-900"></span>
                                @endif
                            </a>
                            <button onclick="toggleDrawer()" class="p-2 text-white bg-white/10 rounded-xl">
                                <i data-lucide="align-right" class="w-5 h-5"></i>
                            </button>
                        </div>

                        <!-- Search Bar (Desktop) -->
                        <form action="{{ route('home') }}" method="GET" class="hidden lg:flex items-center flex-1 min-w-[500px] bg-white/10 backdrop-blur-md p-1 rounded-2xl border border-white/20 focus-within:border-blue-500 transition-all">
                            <div class="relative w-1/3 border-r border-white/10">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                    <i data-lucide="map-pin" class="h-4 w-4 text-gray-400"></i>
                                </div>
                                <input type="text" class="block w-full pl-10 pr-3 py-2.5 bg-transparent border-none focus:ring-0 text-sm font-bold text-white placeholder-gray-400" placeholder="Indonesia">
                            </div>
                            <div class="relative flex-1">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                    <i data-lucide="search" class="h-4 w-4 text-gray-400"></i>
                                </div>
                                <input type="text" name="search" value="{{ request('search') }}" class="block w-full pl-10 pr-3 py-2.5 bg-transparent border-none focus:ring-0 text-sm font-bold text-white placeholder-gray-400" placeholder="Cari mobil, gadget, hobi...">
                            </div>
                            <button type="submit" class="p-2.5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
                                <i data-lucide="search" class="w-4 h-4"></i>
                            </button>
                        </form>
                    </div>

                    <!-- Mobile Search Bar (Only Mobile) -->
                    <form action="{{ route('home') }}" method="GET" class="lg:hidden w-full flex items-center gap-2">
                        <div class="flex-1 bg-white/10 p-1 rounded-2xl flex items-center border border-white/10">
                            <div class="pl-4">
                                <i data-lucide="search" class="w-4 h-4 text-gray-400"></i>
                            </div>
                            <input type="text" name="search" placeholder="Cari di codan..." class="flex-1 bg-transparent border-none focus:ring-0 text-xs text-white font-bold py-2.5">
                        </div>
                        <button type="button" class="p-3 bg-white/10 rounded-2xl text-white">
                            <i data-lucide="sliders-horizontal" class="w-4 h-4"></i>
                        </button>
                    </form>

                    <!-- Auth Actions (Desktop) -->
                    <div class="hidden lg:flex items-center gap-6">
                        @auth
                            <a href="{{ route('inbox.index') }}" class="relative p-2.5 rounded-full hover:bg-white/10 transition-all group">
                                <i data-lucide="message-circle" class="w-6 h-6 text-white group-hover:text-blue-400"></i>
                                @if($unreadCount > 0)
                                <span class="absolute top-0 right-0 w-5 h-5 bg-red-500 text-white text-[10px] font-black rounded-full flex items-center justify-center border-2 border-blue-900">
                                    {{ $unreadCount > 9 ? '9+' : $unreadCount }}
                                </span>
                                @endif
                            </a>
                        @else
                            <a href="{{ route('login') }}" class="text-sm font-black uppercase tracking-widest text-white hover:text-blue-400 transition-colors">Login / Daftar</a>
                        @endauth
                        
                        <a href="{{ route('produks.create') }}" class="sell-btn inline-flex items-center justify-center gap-3 px-8 py-3.5 rounded-2xl text-white text-xs font-black uppercase tracking-widest transition-all hover:scale-105 active:scale-95 shadow-lg shadow-blue-500/30">
                            <i data-lucide="plus-circle" class="w-5 h-5"></i>
                            PASANG IKLAN
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Dynamic Category Section & Filters -->
        <section class="bg-white dark:bg-slate-900 border-b border-gray-100 dark:border-slate-800 py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6" x-data="{ 
                    showFilters: false,
                    getLocation() {
                        if (navigator.geolocation) {
                            navigator.geolocation.getCurrentPosition((position) => {
                                const lat = position.coords.latitude;
                                const lng = position.coords.longitude;
                                const url = new URL(window.location.href);
                                url.searchParams.set('lat', lat);
                                url.searchParams.set('lng', lng);
                                window.location.href = url.href;
                            }, (error) => {
                                alert('Gagal mendapatkan lokasi. Pastikan izin lokasi aktif.');
                            });
                        } else {
                            alert('Browser Anda tidak mendukung geolokasi.');
                        }
                    }
                }">
                    <div class="flex items-center justify-between w-full lg:w-auto gap-4">
                        <!-- Draggable Categories -->
                        <div class="relative group/scroll flex-1 overflow-hidden max-w-4xl">
                            <div id="category-scroll" class="flex items-center gap-3 overflow-x-auto pb-2 no-scrollbar scroll-smooth select-none">
                                <a href="{{ route('home') }}" class="flex items-center gap-3 px-5 py-3 rounded-2xl border {{ !request('category') ? 'border-blue-500 bg-blue-50 text-blue-600' : 'bg-white dark:bg-slate-900 border-gray-100 dark:border-slate-800' }} hover:border-blue-500 transition-all flex-shrink-0 group">
                                    <div class="w-7 h-7 rounded-lg {{ !request('category') ? 'bg-blue-600 text-white' : 'bg-gray-100 dark:bg-slate-800 text-gray-500' }} flex items-center justify-center transition-all">
                                        <i data-lucide="layout-grid" class="w-4 h-4"></i>
                                    </div>
                                    <span class="text-[10px] font-black uppercase">Semua</span>
                                </a>
                                @foreach($categories as $category)
                                <a href="{{ route('home', array_merge(request()->query(), ['category' => $category->slug])) }}" 
                                   class="flex items-center gap-3 px-5 py-3 rounded-2xl border relative transition-all flex-shrink-0 group
                                   {{ request('category') == $category->slug ? 'border-blue-500 bg-blue-50 text-blue-600' : 'bg-white dark:bg-slate-900 border-gray-100 dark:border-slate-800' }} hover:border-blue-500">
                                    <div class="w-7 h-7 rounded-lg {{ request('category') == $category->slug ? 'bg-blue-600 text-white' : 'bg-gray-100 dark:bg-slate-800 text-gray-400' }} flex items-center justify-center transition-all">
                                        <i data-lucide="{{ $category->icon ?: 'tag' }}" class="w-4 h-4"></i>
                                    </div>
                                    <span class="text-[10px] font-black uppercase">{{ $category->name }}</span>
                                </a>
                                @endforeach
                            </div>
                        </div>

                        <!-- Filter Toggle Button -->
                        <button @click="showFilters = !showFilters" class="lg:hidden flex items-center gap-2 px-5 py-3 rounded-2xl bg-slate-900 text-white font-bold text-xs shadow-lg active:scale-95 transition-all">
                            <i data-lucide="sliders-horizontal" class="w-4 h-4"></i>
                            Filter
                        </button>
                    </div>

                    <div class="hidden lg:flex items-center gap-4">
                        <button @click="showFilters = !showFilters" :class="showFilters ? 'bg-blue-600 text-white border-blue-600' : 'bg-white dark:bg-slate-900 border-gray-100 dark:border-slate-800 text-slate-600'" class="flex items-center gap-2 px-6 py-3 rounded-2xl border font-black text-[10px] uppercase tracking-[0.2em] transition-all hover:border-blue-500">
                            <i data-lucide="sliders-horizontal" class="w-4 h-4"></i>
                            Advanced Filter
                        </button>
                    </div>

                    <!-- Advanced Filters Panel -->
                    <div x-show="showFilters" x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 -translate-y-4" x-transition:enter-end="opacity-100 translate-y-0" class="absolute left-0 right-0 top-full mt-2 z-40 px-4 sm:px-6 lg:px-8">
                        <div class="max-w-7xl mx-auto bg-white dark:bg-slate-900 rounded-[2rem] shadow-2xl border border-slate-100 dark:border-slate-800 p-6 sm:p-8">
                            <form action="{{ route('home') }}" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-6">
                                <!-- Keep existing search & category -->
                                <input type="hidden" name="search" value="{{ request('search') }}">
                                <input type="hidden" name="category" value="{{ request('category') }}">
                                <input type="hidden" name="condition" value="{{ request('condition') }}">
                                <input type="hidden" name="lat" value="{{ request('lat') }}">
                                <input type="hidden" name="lng" value="{{ request('lng') }}">

                                <!-- Price Range -->
                                <div class="space-y-3">
                                    <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 block ml-1">Rentang Harga (Rp)</label>
                                    <div class="flex items-center gap-2">
                                        <input type="number" name="min_price" value="{{ request('min_price') }}" placeholder="Min" class="w-full bg-slate-50 dark:bg-slate-800 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-blue-500">
                                        <div class="w-2 h-0.5 bg-slate-300"></div>
                                        <input type="number" name="max_price" value="{{ request('max_price') }}" placeholder="Max" class="w-full bg-slate-50 dark:bg-slate-800 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-blue-500">
                                    </div>
                                </div>

                                <!-- Sorting -->
                                <div class="space-y-3">
                                    <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 block ml-1">Urutkan Berdasarkan</label>
                                    <select name="sort" class="w-full bg-slate-50 dark:bg-slate-800 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-blue-500">
                                        <option value="newest" {{ request('sort') == 'newest' ? 'selected' : '' }}>Terbaru</option>
                                        <option value="cheap" {{ request('sort') == 'cheap' ? 'selected' : '' }}>Termurah</option>
                                        <option value="expensive" {{ request('sort') == 'expensive' ? 'selected' : '' }}>Termahal</option>
                                        <option value="oldest" {{ request('sort') == 'oldest' ? 'selected' : '' }}>Terlama</option>
                                    </select>
                                </div>

                                <!-- Proximity -->
                                <div class="space-y-3">
                                    <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 block ml-1">Lokasi</label>
                                    <button type="button" @click="getLocation()" class="w-full flex items-center justify-center gap-2 px-4 py-3 rounded-xl border-2 {{ request('lat') ? 'border-blue-600 bg-blue-50 text-blue-600' : 'border-slate-100 dark:border-slate-800 text-slate-600' }} text-xs font-bold transition-all hover:bg-slate-50 dark:hover:bg-slate-800">
                                        <i data-lucide="map-pin" class="w-4 h-4"></i>
                                        {{ request('lat') ? 'Lokasi Aktif' : 'Terdekat dari Saya' }}
                                    </button>
                                </div>

                                <!-- Actions -->
                                <div class="flex items-end gap-2">
                                    <button type="submit" class="flex-1 py-3 bg-blue-600 text-white rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-blue-500/20 hover:bg-blue-700 transition-all active:scale-95">Terapkan</button>
                                    <a href="{{ route('home') }}" class="p-3 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 rounded-xl hover:bg-slate-200 transition-all">
                                        <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Trendy Marquee -->
        <div class="bg-blue-600 py-3 overflow-hidden whitespace-nowrap relative">
            <div class="flex animate-marquee">
                @for($i = 0; $i < 4; $i++)
                <div class="flex items-center gap-12 mx-12">
                    <span class="text-white text-[11px] font-black uppercase tracking-[0.3em] flex items-center gap-3 italic">
                         <i data-lucide="zap" class="w-4 h-4 fill-white"></i> 
                         IKLAN TERBARU HARI INI
                    </span>
                    <span class="text-white/40 text-[11px] font-black uppercase tracking-[0.3em] italic">SALE UP TO 90%</span>
                    <span class="text-white/40 text-[11px] font-black uppercase tracking-[0.3em] italic">TRUSTED SELLER</span>
                </div>
                @endfor
            </div>
        </div>

        <style>
            @keyframes marquee {
                0% { transform: translateX(0); }
                100% { transform: translateX(-50%); }
            }
            .animate-marquee {
                display: flex;
                width: max-content;
                animation: marquee 30s linear infinite;
            }
        </style>

        <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="relative h-[500px] lg:h-[450px] rounded-[2.5rem] overflow-hidden shadow-2xl group">
                <img src="https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&q=80&w=1600" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" alt="Hero Banner">
                <div class="absolute inset-0 bg-gradient-to-t lg:bg-gradient-to-r from-slate-900 via-slate-900/40 to-transparent flex flex-col justify-center items-center lg:items-start text-center lg:text-left px-6 lg:px-24">
                    <span class="inline-block px-4 py-1 rounded-full bg-blue-600/20 text-blue-400 text-[10px] font-black uppercase tracking-widest mb-4 lg:mb-6 backdrop-blur-md w-fit border border-blue-500/20">Promo Ramadhan</span>
                    <h2 class="text-3xl lg:text-7xl font-extrabold text-white leading-[1.1] mb-4 lg:mb-6">
                        Jual Cepat <br class="hidden lg:block"> <span class="text-blue-500 italic">Tanpa Ribet.</span>
                    </h2>
                    <p class="text-gray-300 text-sm lg:text-lg mb-8 lg:mb-10 max-w-md font-medium leading-relaxed opacity-90">Bergabunglah dengan jutaan orang lainnya yang telah berhasil menjual barang mereka di codan.</p>
                    <div class="flex flex-col sm:flex-row gap-4">
                        <a href="{{ route('produks.create') }}" class="inline-flex items-center justify-center gap-2 px-8 py-4 rounded-2xl bg-white text-slate-900 font-black text-xs uppercase tracking-widest hover:shadow-2xl transition-all hover:-translate-y-1 shadow-xl">
                            Pasang Iklan Sekarang
                            <i data-lucide="arrow-right" class="w-4 h-4"></i>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- produks Grid -->
        <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div class="flex items-center justify-between mb-12">
                <div>
                    <h3 class="text-3xl font-extrabold flex items-center gap-3 tracking-tight">
                        <span class="w-3 h-10 bg-blue-600 rounded-full"></span>
                        Rekomendasi Terbaru
                    </h3>
                    <p class="text-gray-500 mt-1 font-medium">Temukan barang berkualitas dengan harga terbaik.</p>
                </div>
                <a href="#" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-gray-100 dark:bg-slate-900 text-slate-900 dark:text-white font-bold hover:bg-blue-600 hover:text-white transition-all group">
                    Lihat Semua
                    <i data-lucide="chevron-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform"></i>
                </a>
            </div>

            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-8">
                @forelse($produks as $produk)
                <div class="relative group flex flex-col h-full">
                    <a href="{{ route('produks.show', $produk->slug) }}" class="bg-white dark:bg-slate-900 rounded-3xl overflow-hidden border border-gray-100 dark:border-slate-800 card-hover transition-all group flex flex-col h-full shadow-sm">
                        <div class="relative aspect-[4/3] overflow-hidden m-3 rounded-2xl">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-all duration-700" alt="{{ $produk->title }}">
                            @if($produk->condition == 'baru')
                            <div class="absolute top-3 left-3 px-3 py-1.5 rounded-xl bg-emerald-500 text-white text-[9px] font-black uppercase tracking-widest shadow-lg shadow-emerald-500/20">Baru</div>
                            @elseif($produk->condition == 'refurbished')
                            <div class="absolute top-3 left-3 px-3 py-1.5 rounded-xl bg-blue-500 text-white text-[9px] font-black uppercase tracking-widest shadow-lg shadow-blue-500/20">Refurbished</div>
                            @else
                            <div class="absolute top-3 left-3 px-3 py-1.5 rounded-xl bg-slate-800 backdrop-blur-md text-white text-[9px] font-black uppercase tracking-widest shadow-lg shadow-slate-900/40">Bekas</div>
                            @endif
                        </div>
                        <div class="px-6 pb-6 pt-2 flex-1 flex flex-col">
                            <div class="text-2xl font-black text-blue-600 mb-2 tracking-tighter italic">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                            <h4 class="text-slate-800 dark:text-gray-100 font-bold text-lg line-clamp-2 leading-snug mb-auto group-hover:text-blue-600 transition-colors">{{ $produk->title }}</h4>
                            
                            <div class="mt-6 pt-6 border-t border-gray-50 dark:border-slate-800/50 flex items-center justify-between text-[11px] text-gray-400 uppercase tracking-[0.1em] font-extrabold">
                                <span class="flex items-center gap-1.5">
                                    <i data-lucide="map-pin" class="w-3.5 h-3.5"></i>
                                    {{ $produk->location }}
                                </span>
                                <span>{{ $produk->created_at->diffForHumans() }}</span>
                            </div>
                        </div>
                    </a>

                    <!-- Wishlist Toggle Button -->
                    <div class="absolute top-6 right-6 z-20">
                        <form action="{{ route('wishlist.toggle', $produk) }}" method="POST">
                            @csrf
                            <button type="submit" class="p-2.5 rounded-full bg-white/60 dark:bg-slate-800/60 backdrop-blur-md transition-all shadow-lg active:scale-90 {{ Auth::check() && Auth::user()->wishlists()->where('produk_id', $produk->id)->exists() ? 'text-pink-600' : 'text-slate-900 dark:text-white hover:text-pink-600' }}">
                                <i data-lucide="heart" class="w-4 h-4 {{ Auth::check() && Auth::user()->wishlists()->where('produk_id', $produk->id)->exists() ? 'fill-current' : '' }}"></i>
                            </button>
                        </form>
                    </div>
                </div>
                @empty
                <div class="col-span-full py-20 text-center">
                    <div class="w-20 h-20 bg-gray-50 dark:bg-slate-900 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i data-lucide="search-x" class="w-10 h-10 text-gray-300"></i>
                    </div>
                    <h4 class="text-xl font-black text-slate-800 dark:text-gray-100 uppercase tracking-tighter italic">Iklan tidak ditemukan</h4>
                    <p class="text-gray-400 font-medium mt-1">Coba gunakan kata kunci lain atau pilih kategori berbeda.</p>
                </div>
                @endforelse
            </div>

            <div class="mt-16">
                {{ $produks->appends(request()->query())->links() }}
            </div>
        </main>

        <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 mb-20">
            <div class="bg-gray-900 rounded-[2.5rem] lg:rounded-[3rem] p-10 lg:p-20 relative overflow-hidden shadow-[0_35px_60px_-15px_rgba(59,130,246,0.3)]">
                <div class="absolute top-0 right-0 -mr-20 -mt-20 w-96 h-96 bg-blue-400/20 rounded-full blur-3xl animate-pulse"></div>
                <div class="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 bg-indigo-400/20 rounded-full blur-3xl"></div>
                
                <div class="relative z-10 flex flex-col lg:flex-row items-center justify-between gap-8 lg:gap-12">
                    <div class="max-w-2xl text-center lg:text-left">
                        <h2 class="text-3xl lg:text-6xl font-black text-white mb-4 lg:mb-6 leading-tight">Mulai Jualan <br class="lg:hidden"> Hari Ini!</h2>
                        <p class="text-blue-100 text-base lg:text-xl font-medium leading-relaxed opacity-90 italic">Berikan barang lama Anda rumah baru dan dapatkan uang tambahan dengan mudah.</p>
                    </div>
                    <a href="{{ route('register') }}" class="w-full lg:w-auto px-10 lg:px-12 py-5 lg:py-6 rounded-[1.5rem] lg:rounded-[2rem] bg-white text-blue-600 text-xl lg:text-2xl font-black text-center hover:scale-105 active:scale-95 transition-all shadow-2xl">
                        Daftar Gratis
                    </a>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="bg-slate-950 text-slate-400 py-24 border-t border-slate-900">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-16 mb-24">
                    <div class="col-span-1 lg:col-span-1">
                        <a href="/" class="flex items-center gap-3 mb-10 group">
                            <div class="w-12 h-12 sell-btn rounded-2xl flex items-center justify-center group-hover:rotate-6 transition-transform">
                                <i data-lucide="shopping-bag" class="text-white w-7 h-7"></i>
                            </div>
                            <span class="text-3xl font-black tracking-tighter text-white uppercase italic">CO-DE<span class="text-blue-600">AN</span></span>
                        </a>
                        <p class="text-sm leading-relaxed max-w-xs font-medium opacity-60 mb-8">Eksplorasi ribuan produk berkualitas dari penjual terpercaya di seluruh Indonesia. Keamanan dan kenyamanan Anda adalah prioritas kami.</p>
                        <div class="flex gap-4">
                            <a href="#" class="w-10 h-10 rounded-xl bg-slate-900 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all"><i data-lucide="instagram" class="w-5 h-5"></i></a>
                            <a href="#" class="w-10 h-10 rounded-xl bg-slate-900 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all"><i data-lucide="facebook" class="w-5 h-5"></i></a>
                            <a href="#" class="w-10 h-10 rounded-xl bg-slate-900 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all"><i data-lucide="twitter" class="w-5 h-5"></i></a>
                        </div>
                    </div>
                    
                    <div>
                        <h5 class="text-white font-black mb-10 uppercase text-[10px] tracking-[0.3em]">Quick Links</h5>
                        <ul class="space-y-4 text-sm font-bold">
                            @foreach($categories->take(4) as $cat)
                            <li><a href="{{ route('home', ['category' => $cat->slug]) }}" class="hover:text-blue-500 transition-colors flex items-center gap-2 capitalize italic"><div class="w-1 h-1 rounded-full bg-blue-500"></div> {{ $cat->name }}</a></li>
                            @endforeach
                        </ul>
                    </div>

                    <div>
                        <h5 class="text-white font-black mb-10 uppercase text-[10px] tracking-[0.3em]">Bantuan</h5>
                        <ul class="space-y-4 text-sm font-bold">
                            <li><a href="#" class="hover:text-blue-500 transition-colors">Pusat Bantuan</a></li>
                            <li><a href="#" class="hover:text-blue-500 transition-colors">Syarat & Ketentuan</a></li>
                            <li><a href="#" class="hover:text-blue-500 transition-colors">Kebijakan Privasi</a></li>
                        </ul>
                    </div>

                    <div class="bg-slate-900/50 p-8 rounded-[2rem] border border-slate-800">
                        <h5 class="text-white font-black mb-6 uppercase text-[10px] tracking-[0.3em]">Berlangganan</h5>
                        <p class="text-[11px] font-bold mb-6 leading-relaxed opacity-60">Dapatkan info promo dan produk terbaru langsung di email Anda.</p>
                        <form class="flex flex-col gap-3">
                            <input type="email" placeholder="Email Anda" class="w-full px-5 py-3.5 rounded-xl bg-slate-800 border-none text-xs font-bold focus:ring-2 focus:ring-blue-500 outline-none">
                            <button class="w-full py-3.5 rounded-xl sell-btn text-white text-[10px] font-black uppercase tracking-widest shadow-xl shadow-blue-600/20 active:scale-95 transition-all">Subscribe</button>
                        </form>
                    </div>
                </div>

                <div class="pt-12 border-t border-slate-900 flex flex-col md:flex-row items-center justify-between gap-6 text-[10px] font-black uppercase tracking-widest">
                    <p>© 2026 codan MARKETPLACE. ALL RIGHTS RESERVED.</p>
                    <div class="flex gap-8">
                        <a href="#" class="hover:text-white transition-colors">Sitemap</a>
                        <a href="#" class="hover:text-white transition-colors">Contact</a>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Mobile Bottom Navigation -->
        <div class="lg:hidden fixed bottom-0 left-0 right-0 z-[100] px-4 pb-4">
            <div class="bg-white/80 dark:bg-slate-900/80 backdrop-blur-xl border border-white/20 dark:border-slate-800/50 shadow-2xl rounded-[3rem] p-2 flex items-center justify-between">
                <a href="{{ route('home') }}" class="flex flex-col items-center justify-center w-14 h-14 rounded-full transition-all {{ request()->routeIs('home') ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' : 'text-slate-400' }}">
                    <i data-lucide="home" class="w-5 h-5"></i>
                    <span class="text-[8px] font-black uppercase tracking-widest mt-1">Beranda</span>
                </a>
                
                <a href="{{ route('dashboard') }}" class="flex flex-col items-center justify-center w-14 h-14 text-slate-400 rounded-full transition-all">
                    <i data-lucide="search" class="w-5 h-5"></i>
                    <span class="text-[8px] font-black uppercase tracking-widest mt-1">Iklan</span>
                </a>

                <!-- Centered Sell Button -->
                <div class="relative -top-6">
                    <a href="{{ route('produks.create') }}" class="w-16 h-16 bg-gradient-to-tr from-blue-600 to-indigo-700 rounded-full flex items-center justify-center text-white shadow-2xl shadow-blue-500/40 border-4 border-slate-50 dark:border-slate-950 active:scale-90 transition-all">
                        <i data-lucide="plus" class="w-8 h-8"></i>
                    </a>
                </div>

                <a href="{{ route('inbox.index') }}" class="flex flex-col items-center justify-center w-14 h-14 text-slate-400 rounded-full transition-all hover:text-blue-500">
                    <div class="relative">
                        <i data-lucide="message-circle" class="w-5 h-5"></i>
                        @if(isset($unreadCount) && $unreadCount > 0)
                        <span class="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full border border-white"></span>
                        @endif
                    </div>
                    <span class="text-[8px] font-black uppercase tracking-widest mt-1">Chat</span>
                </a>

                <a href="{{ route('dashboard') }}" class="flex flex-col items-center justify-center w-14 h-14 text-slate-400 rounded-full transition-all">
                    <i data-lucide="user" class="w-5 h-5"></i>
                    <span class="text-[8px] font-black uppercase tracking-widest mt-1">Akun</span>
                </a>
            </div>
        </div>

        <!-- Mobile Side Menu (Full Feature Drawer) -->
        <div id="mobile-drawer" class="fixed inset-0 z-[200] invisible">
            <div id="drawer-overlay" class="absolute inset-0 bg-slate-950/60 backdrop-blur-sm opacity-0 transition-opacity duration-300"></div>
            <div id="drawer-content" class="absolute right-0 top-0 bottom-0 w-80 bg-white dark:bg-slate-900 shadow-2xl translate-x-full transition-transform duration-300 overflow-y-auto">
                <div class="p-8">
                    <div class="flex items-center justify-between mb-10">
                        <h5 class="text-lg font-black italic tracking-tighter uppercase">Menu Utama</h5>
                        <button onclick="toggleDrawer()" class="p-2 rounded-xl bg-gray-100 dark:bg-slate-800"><i data-lucide="x" class="w-5 h-5"></i></button>
                    </div>

                    @auth
                    <div class="flex items-center gap-4 p-4 rounded-3xl bg-blue-600 mb-8 shadow-xl shadow-blue-500/20">
                        <div class="w-12 h-12 rounded-full bg-white flex items-center justify-center text-blue-600 font-black text-xl">
                            {{ substr(Auth::user()->name, 0, 1) }}
                        </div>
                        <div class="text-white">
                            <div class="font-black italic leading-none">{{ Auth::user()->name }}</div>
                            <div class="text-[10px] font-bold opacity-80 uppercase tracking-widest mt-1">Verified User</div>
                        </div>
                    </div>
                    @endauth

                    <div class="space-y-2">
                        <a href="{{ route('profile.edit') }}" class="flex items-center gap-4 p-4 rounded-2xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-all font-bold">
                            <i data-lucide="settings" class="w-5 h-5 text-slate-400"></i> Pengaturan Akun
                        </a>
                        <a href="{{ route('wishlist.index') }}" class="flex items-center gap-4 p-4 rounded-2xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-all font-bold">
                            <i data-lucide="heart" class="w-5 h-5 text-red-400"></i> Wishlist Saya
                        </a>
                        <a href="#" class="flex items-center gap-4 p-4 rounded-2xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-all font-bold">
                            <i data-lucide="ticket" class="w-5 h-5 text-amber-500"></i> Voucher & Promo
                        </a>
                        <a href="#" class="flex items-center gap-4 p-4 rounded-2xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-all font-bold">
                            <i data-lucide="help-circle" class="w-5 h-5 text-blue-500"></i> Pusat Bantuan
                        </a>
                        
                        <div class="pt-6 mt-6 border-t border-gray-100 dark:border-slate-800">
                            <h6 class="text-[10px] font-black uppercase text-slate-400 tracking-[0.3em] ml-4 mb-4">Moderasi</h6>
                            @if(auth()->check() && auth()->user()->role === 'admin')
                            <a href="{{ route('admin.dashboard') }}" class="flex items-center gap-4 p-4 rounded-2xl bg-red-500/10 text-red-500 transition-all font-bold group">
                                <i data-lucide="shield-check" class="w-5 h-5"></i> Admin Control Center
                            </a>
                            @endif
                        </div>

                        <form method="POST" action="{{ route('logout') }}" class="mt-10">
                            @csrf
                            <button type="submit" class="w-full flex items-center gap-4 p-4 rounded-2xl bg-gray-100 dark:bg-slate-800 text-gray-400 font-bold">
                                <i data-lucide="log-out" class="w-5 h-5"></i> Keluar
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleDrawer() {
                const drawer = document.getElementById('mobile-drawer');
                const overlay = document.getElementById('drawer-overlay');
                const content = document.getElementById('drawer-content');
                
                if (drawer.classList.contains('invisible')) {
                    drawer.classList.remove('invisible');
                    setTimeout(() => {
                        overlay.classList.replace('opacity-0', 'opacity-100');
                        content.classList.replace('translate-x-full', 'translate-x-0');
                    }, 10);
                } else {
                    overlay.classList.replace('opacity-100', 'opacity-0');
                    content.classList.replace('translate-x-0', 'translate-x-full');
                    setTimeout(() => drawer.classList.add('invisible'), 300);
                }
            }

            // Navbar Scroll Effect
            window.addEventListener('scroll', function() {
                const nav = document.getElementById('main-nav');
                if (window.scrollY > 20) {
                    nav.classList.add('py-4', 'shadow-2xl', 'bg-opacity-90');
                } else {
                    nav.classList.remove('py-4', 'shadow-2xl', 'bg-opacity-90');
                }
            });

            // Draggable Categories
            document.addEventListener('DOMContentLoaded', function() {
                const slider = document.getElementById('category-scroll');
                if(!slider) return;
                
                let isDown = false;
                let startX;
                let scrollLeft;

                slider.addEventListener('mousedown', (e) => {
                    isDown = true;
                    slider.classList.add('cursor-grabbing');
                    startX = e.pageX - slider.offsetLeft;
                    scrollLeft = slider.scrollLeft;
                });

                slider.addEventListener('mouseleave', () => {
                    isDown = false;
                    slider.classList.remove('cursor-grabbing');
                });

                slider.addEventListener('mouseup', () => {
                    isDown = false;
                    slider.classList.remove('cursor-grabbing');
                });

                slider.addEventListener('mousemove', (e) => {
                    if(!isDown) return;
                    e.preventDefault();
                    const x = e.pageX - slider.offsetLeft;
                    const walk = (x - startX) * 2;
                    slider.scrollLeft = scrollLeft - walk;
                });
                
                lucide.createIcons();
            });
        </script>
    </body>
</html>
