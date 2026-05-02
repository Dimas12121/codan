<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>{{ $produk->title }} | codan</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        <style>
            body { font-family: 'Plus Jakarta Sans', sans-serif; }
            .glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); }
            .sell-btn { background: linear-gradient(to right, #3b82f6, #6366f1); }
        </style>
    </head>
    <body class="bg-gray-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 antialiased">
        
        <!-- Navbar (Simplified) -->
        <nav class="sticky top-0 z-50 bg-white/95 dark:bg-slate-900/95 backdrop-blur-md border-b border-gray-100 dark:border-slate-800">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex items-center justify-between h-16 sm:h-20">
                    <div class="flex items-center gap-4">
                        <a href="{{ url()->previous() }}" class="lg:hidden p-2 text-slate-600 dark:text-gray-400">
                            <i data-lucide="arrow-left" class="w-6 h-6"></i>
                        </a>
                        <a href="/" class="flex items-center gap-2">
                            <div class="w-8 h-8 sm:w-10 sm:h-10 sell-btn rounded-xl flex items-center justify-center shadow-lg shadow-blue-500/20">
                                <i data-lucide="shopping-bag" class="text-white w-5 h-5 sm:w-6 sm:h-6"></i>
                            </div>
                            <span class="text-xl font-black tracking-tighter uppercase italic hidden sm:block">codan</span>
                        </a>
                    </div>
                    <div class="flex items-center gap-2 sm:gap-4">
                        <button class="p-2.5 hover:bg-gray-100 dark:hover:bg-slate-800 rounded-2xl transition-all">
                            <i data-lucide="share-2" class="w-5 h-5"></i>
                        </button>
                        <form action="{{ route('wishlist.toggle', $produk) }}" method="POST">
                            @csrf
                            <button type="submit" class="p-2.5 hover:bg-gray-100 dark:hover:bg-slate-800 rounded-2xl transition-all {{ Auth::check() && Auth::user()->wishlists()->where('produk_id', $produk->id)->exists() ? 'text-pink-600' : 'text-slate-400' }}">
                                <i data-lucide="heart" class="w-5 h-5 {{ Auth::check() && Auth::user()->wishlists()->where('produk_id', $produk->id)->exists() ? 'fill-current' : '' }}"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto px-0 sm:px-6 lg:px-8 py-0 sm:py-8">
            @if(session('success'))
            <div class="mx-4 sm:mx-0 mb-6 p-4 sm:p-6 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-2xl sm:rounded-[2rem] flex items-center gap-4">
                <i data-lucide="check-circle" class="w-5 h-5 sm:w-6 sm:h-6 text-green-600"></i>
                <div class="text-green-800 dark:text-green-300 font-bold text-sm sm:text-base">{{ session('success') }}</div>
            </div>
            @endif
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                
                <!-- Left: Product Images & Description -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Image Gallery -->
                    <div class="bg-white dark:bg-slate-900 sm:rounded-3xl overflow-hidden shadow-sm border-b sm:border border-gray-100 dark:border-slate-800">
                        <div class="relative aspect-[4/3] sm:aspect-video">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover" alt="{{ $produk->title }}">
                            
                            <!-- Gallery Thumbnails -->
                            @if($produk->images->count() > 1)
                            <div class="absolute bottom-4 left-0 right-0 px-4">
                                <div class="flex gap-2 overflow-x-auto no-scrollbar pb-2">
                                    @foreach($produk->images as $image)
                                    <button class="w-16 h-16 sm:w-20 sm:h-20 shrink-0 rounded-xl overflow-hidden border-2 {{ $loop->first ? 'border-blue-600 shadow-xl' : 'border-white/50' }} backdrop-blur-md">
                                        <img src="{{ $image->image_path }}" class="w-full h-full object-cover" alt="Gallery">
                                    </button>
                                    @endforeach
                                </div>
                            </div>
                            @endif
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="bg-white dark:bg-slate-900 sm:rounded-3xl p-6 sm:p-8 shadow-sm border-b sm:border border-gray-100 dark:border-slate-800">
                        <h2 class="text-xl sm:text-2xl font-black mb-6 flex items-center gap-3 underline decoration-blue-500 decoration-4 underline-offset-8">Deskripsi</h2>
                        <div class="prose dark:prose-invert max-w-none text-gray-600 dark:text-gray-300 leading-relaxed font-medium text-sm sm:text-base">
                            {!! nl2br(e($produk->description)) !!}
                        </div>
                        
                        <div class="mt-8 pt-8 border-t border-gray-50 dark:border-slate-800 flex flex-wrap gap-6 sm:gap-10">
                            <div>
                                <span class="text-[9px] sm:text-[10px] font-black uppercase tracking-widest text-gray-400 block mb-2">Kategori</span>
                                <span class="px-4 py-2 rounded-xl bg-blue-50 dark:bg-blue-900/20 text-blue-600 font-bold text-xs sm:text-sm">{{ $produk->category->name }}</span>
                            </div>
                            <div>
                                <span class="text-[9px] sm:text-[10px] font-black uppercase tracking-widest text-gray-400 block mb-2">Kondisi</span>
                                <span class="px-4 py-2 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 font-bold text-xs sm:text-sm capitalize">{{ $produk->condition }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Price & Seller -->
                <div class="space-y-6">
                    <!-- Price Card -->
                    <div class="bg-white dark:bg-slate-900 rounded-3xl p-8 shadow-xl border border-gray-100 dark:border-slate-800 relative overflow-hidden group">
                        <div class="absolute top-0 right-0 -mr-8 -mt-8 w-24 h-24 bg-blue-600/10 rounded-full blur-2xl group-hover:scale-150 transition-transform"></div>
                        
                        <div class="text-4xl font-black text-blue-600 italic tracking-tighter mb-4">
                            Rp {{ number_format($produk->price, 0, ',', '.') }}
                        </div>
                        <h1 class="text-xl font-bold leading-tight mb-6">{{ $produk->title }}</h1>
                        
                        <div class="flex items-center justify-between text-xs text-gray-400 font-black uppercase tracking-widest mb-6">
                            <span class="flex items-center gap-1.5 font-bold">
                                <i data-lucide="map-pin" class="w-3.5 h-3.5"></i>
                                {{ $produk->location }}
                            </span>
                            <span>{{ $produk->created_at->format('d M') }}</span>
                        </div>

                        <!-- Map -->
                        @if($produk->latitude && $produk->longitude)
                        <div class="rounded-2xl overflow-hidden border border-gray-100 dark:border-slate-800 h-48 mb-6">
                            <div id="map" class="w-full h-full"></div>
                        </div>
                        <script>
                            function initMap() {
                                const pos = { lat: {{ $produk->latitude }}, lng: {{ $produk->longitude }} };
                                const map = new google.maps.Map(document.getElementById("map"), {
                                    zoom: 15,
                                    center: pos,
                                    disableDefaultUI: true,
                                    styles: [
                                        { "featureType": "poi", "stylers": [{ "visibility": "off" }] }
                                    ]
                                });
                                new google.maps.Marker({
                                    position: pos,
                                    map: map,
                                    icon: {
                                        path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                                        scale: 5,
                                        fillColor: "#3b82f6",
                                        fillOpacity: 1,
                                        strokeWeight: 2,
                                        strokeColor: "#ffffff",
                                    }
                                });
                            }
                        </script>
                        <script src="https://maps.googleapis.com/maps/api/js?key={{ env('GOOGLE_MAPS_API_KEY') }}&callback=initMap" async defer></script>
                        @endif
                    </div>

                    <!-- Seller Card -->
                    <div class="bg-white dark:bg-slate-900 rounded-3xl p-8 shadow-sm border border-gray-100 dark:border-slate-800">
                        <h3 class="text-sm font-black uppercase tracking-widest text-gray-400 mb-6">Profil Penjual</h3>
                        <div class="flex items-center gap-4 mb-8">
                            <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-100 to-indigo-100 dark:from-slate-800 dark:to-slate-700 flex items-center justify-center animate-pulse">
                                <span class="text-2xl font-black text-blue-600">{{ substr($produk->user->name, 0, 1) }}</span>
                            </div>
                            <div>
                                <div class="font-black text-lg">{{ $produk->user->name }}</div>
                                <div class="text-xs font-bold text-gray-400">{{ $produk->user->email }}</div>
                            </div>
                        </div>
                        
                        <div class="space-y-4">
                            @auth
                                @if(auth()->id() !== $produk->user_id)
                                    <a href="{{ route('inbox.show', [$produk->id, $produk->user_id]) }}" class="w-full py-4 rounded-2xl sell-btn text-white font-black shadow-lg hover:scale-[1.02] transition-all flex items-center justify-center gap-3">
                                        <i data-lucide="message-circle" class="w-5 h-5"></i>
                                        CHAT PENJUAL
                                    </a>
                                @else
                                    <div class="w-full py-4 rounded-2xl bg-gray-100 text-gray-400 font-black text-center flex items-center justify-center gap-3">
                                        <i data-lucide="user" class="w-5 h-5"></i>
                                        IKLAN ANDA SENDIRI
                                    </div>
                                @endif
                            @else
                                <a href="{{ route('login') }}" class="w-full py-4 rounded-2xl sell-btn text-white font-black shadow-lg hover:scale-[1.02] transition-all flex items-center justify-center gap-3">
                                    <i data-lucide="log-in" class="w-5 h-5"></i>
                                    LOGIN UNTUK CHAT
                                </a>
                            @endauth
                            <div x-data="{ showNumber: false }">
                                <button x-show="!showNumber" @click="showNumber = true" class="w-full py-4 rounded-2xl border border-blue-600 text-blue-600 font-black hover:bg-blue-50 dark:hover:bg-blue-900/10 transition-all flex items-center justify-center gap-3">
                                    <i data-lucide="phone" class="w-5 h-5"></i>
                                    TAMPILKAN NOMOR
                                </button>
                                <a x-show="showNumber" href="https://wa.me/{{ preg_replace('/[^0-9]/', '', $produk->user->phone ?? '08123456789') }}" target="_blank" class="w-full py-4 rounded-2xl bg-emerald-500 text-white font-black hover:bg-emerald-600 transition-all flex items-center justify-center gap-3 shadow-lg shadow-emerald-500/20">
                                    <i data-lucide="whatsapp" class="w-5 h-5"></i>
                                    {{ $produk->user->phone ?? 'Nomor Tidak Tersedia' }}
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Safety Tips -->
                    <div class="bg-amber-50 dark:bg-amber-900/10 rounded-3xl p-6 border border-amber-100 dark:border-amber-900/20">
                        <div class="flex gap-4">
                            <i data-lucide="shield-check" class="w-6 h-6 text-amber-600 shrink-0"></i>
                            <div>
                                <p class="text-sm font-bold text-amber-900 dark:text-amber-200 mb-2 italic underline decoration-amber-500/30">Tips Keamanan</p>
                                <ul class="text-[11px] font-medium text-amber-800/80 dark:text-amber-400/80 space-y-2 list-disc pl-3">
                                    <li>Jangan pernah mentransfer uang di muka.</li>
                                    <li>Lakukan COD di tempat keramaian.</li>
                                    <li>Periksa barang sebelum membayar.</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Report Button -->
                    @auth
                        @if(auth()->id() !== $produk->user_id)
                        <div x-data="{ open: false }" class="pb-24 sm:pb-0">
                            <button @click="open = !open" class="w-full py-3 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-red-500 transition-all flex items-center justify-center gap-2">
                                <i data-lucide="flag" class="w-3.5 h-3.5"></i>
                                Laporkan Iklan Ini
                            </button>
                            
                            <div x-show="open" x-transition class="mt-4 p-6 bg-white dark:bg-slate-900 rounded-2xl border border-red-100 dark:border-red-900/20 shadow-lg">
                                <form action="{{ route('reports.store', $produk->id) }}" method="POST">
                                    @csrf
                                    <div class="mb-4">
                                        <label class="block text-[10px] font-black uppercase tracking-widest text-gray-400 mb-2">Alasan Pelaporan</label>
                                        <select name="reason" required class="w-full px-4 py-2 rounded-xl bg-gray-50 dark:bg-slate-800 border-none text-xs font-bold">
                                            <option value="Penipuan">Penipuan</option>
                                            <option value="Barang Terlarang">Barang Terlarang</option>
                                            <option value="Informasi Palsu">Informasi Palsu</option>
                                            <option value="Spam/Duplikat">Spam/Duplikat</option>
                                            <option value="Lainnya">Lainnya</option>
                                        </select>
                                    </div>
                                    <div class="mb-4">
                                        <label class="block text-[10px] font-black uppercase tracking-widest text-gray-400 mb-2">Detail (Opsional)</label>
                                        <textarea name="details" class="w-full px-4 py-2 rounded-xl bg-gray-50 dark:bg-slate-900 border-none text-xs font-bold" rows="3" placeholder="Jelaskan lebih lanjut..."></textarea>
                                    </div>
                                    <button type="submit" class="w-full py-3 bg-red-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-red-700 transition-all shadow-lg shadow-red-200 dark:shadow-none">
                                        Kirim Laporan
                                    </button>
                                </form>
                            </div>
                        </div>
                        @else
                        <div class="pb-24 sm:pb-0"></div>
                        @endif
                    @endauth
                </div>
            </div>
        </main>

        <!-- Fixed Mobile Action Bar -->
        <div class="lg:hidden fixed bottom-0 left-0 right-0 z-[100] px-4 pb-6">
            <div class="bg-white/90 dark:bg-slate-900/90 backdrop-blur-xl border border-white/20 dark:border-slate-800/50 shadow-2xl rounded-[2rem] p-3 flex items-center gap-3">
                @auth
                    @if(auth()->id() !== $produk->user_id)
                        <a href="{{ route('inbox.show', [$produk->id, $produk->user_id]) }}" class="flex-1 h-14 bg-blue-600 text-white rounded-2xl flex items-center justify-center gap-2 font-black text-xs uppercase tracking-widest shadow-lg shadow-blue-500/20 active:scale-95 transition-all">
                            <i data-lucide="message-circle" class="w-5 h-5"></i>
                            Chat
                        </a>
                        <a href="https://wa.me/{{ preg_replace('/[^0-9]/', '', $produk->user->phone ?? '08123456789') }}" target="_blank" class="flex-1 h-14 bg-emerald-500 text-white rounded-2xl flex items-center justify-center gap-2 font-black text-xs uppercase tracking-widest shadow-lg shadow-emerald-500/20 active:scale-95 transition-all">
                            <i data-lucide="phone" class="w-5 h-5"></i>
                            WhatsApp
                        </a>
                    @else
                        <a href="{{ route('produks.edit', $produk->id) }}" class="flex-1 h-14 bg-slate-800 text-white rounded-2xl flex items-center justify-center gap-2 font-black text-xs uppercase tracking-widest shadow-lg active:scale-95 transition-all">
                            <i data-lucide="edit-3" class="w-5 h-5"></i>
                            Edit Iklan
                        </a>
                    @endif
                @else
                    <a href="{{ route('login') }}" class="flex-1 h-14 bg-blue-600 text-white rounded-2xl flex items-center justify-center gap-2 font-black text-xs uppercase tracking-widest shadow-lg shadow-blue-500/20 active:scale-95 transition-all">
                        <i data-lucide="log-in" class="w-5 h-5"></i>
                        Login untuk Chat
                    </a>
                @endauth
            </div>
        </div>

        <footer class="bg-slate-900 text-slate-500 py-10 text-center text-[10px] font-black uppercase tracking-[0.2em] mt-20">
            © 2026 codan Project.
        </footer>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
