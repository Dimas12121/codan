<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center gap-3">
            <div class="p-2 bg-pink-500/10 rounded-xl">
                <i data-lucide="heart" class="w-5 h-5 text-pink-600 dark:text-pink-400"></i>
            </div>
            <h2 class="font-bold text-2xl text-slate-800 dark:text-white leading-tight">
                {{ __('Wishlist Saya') }}
            </h2>
        </div>
    </x-slot>

    <div class="py-8 sm:py-12 bg-slate-50 dark:bg-slate-950 min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            
            @if($wishlists->isEmpty())
                <div class="bg-white dark:bg-slate-900 rounded-[2.5rem] p-16 text-center shadow-sm border border-slate-100 dark:border-slate-800">
                    <div class="w-24 h-24 bg-pink-50 dark:bg-pink-900/20 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i data-lucide="heart" class="w-12 h-12 text-pink-300"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-slate-900 dark:text-white mb-2">Wishlist Kosong</h3>
                    <p class="text-slate-400 max-w-xs mx-auto text-sm leading-relaxed mb-8">
                        Belum ada barang yang Anda simpan. Cari barang impian Anda dan simpan di sini!
                    </p>
                    <a href="{{ route('home') }}" class="inline-flex items-center gap-2 px-8 py-3 bg-blue-600 text-white font-bold rounded-2xl hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 active:scale-95">
                        Jelajahi Produk
                    </a>
                </div>
            @else
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
                    @foreach($wishlists as $wishlist)
                        @php $produk = $wishlist->produk; @endphp
                        <div class="group bg-white dark:bg-slate-900 rounded-[2rem] overflow-hidden border border-slate-100 dark:border-slate-800 shadow-sm hover:shadow-xl transition-all duration-300 relative">
                            <!-- Remove Button -->
                            <form action="{{ route('wishlist.toggle', $produk) }}" method="POST" class="absolute top-3 right-3 z-10">
                                @csrf
                                <button type="submit" class="w-10 h-10 bg-white/90 dark:bg-slate-800/90 backdrop-blur-md rounded-xl flex items-center justify-center text-pink-600 shadow-lg active:scale-90 transition-all hover:bg-pink-600 hover:text-white">
                                    <i data-lucide="heart" class="w-5 h-5 fill-current"></i>
                                </button>
                            </form>

                            <a href="{{ route('produks.show', $produk->slug) }}" class="block">
                                <div class="aspect-[4/3] overflow-hidden bg-slate-100 dark:bg-slate-800">
                                    @if($produk->featuredImage)
                                        <img src="{{ asset('storage/' . $produk->featuredImage->image_path) }}" alt="{{ $produk->title }}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                                    @else
                                        <div class="w-full h-full flex items-center justify-center">
                                            <i data-lucide="image" class="w-12 h-12 text-slate-300"></i>
                                        </div>
                                    @endif
                                </div>
                                
                                <div class="p-4 sm:p-5">
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="px-2 py-0.5 bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 text-[10px] font-bold rounded-md uppercase tracking-wider">
                                            {{ $produk->category->name }}
                                        </span>
                                    </div>
                                    <h3 class="font-bold text-slate-900 dark:text-white line-clamp-1 group-hover:text-blue-600 transition-colors">
                                        {{ $produk->title }}
                                    </h3>
                                    <p class="text-blue-600 dark:text-blue-400 font-black text-lg mt-1">
                                        Rp {{ number_format($produk->price, 0, ',', '.') }}
                                    </p>
                                    <div class="flex items-center gap-2 mt-3 text-[10px] text-slate-400 font-medium">
                                        <i data-lucide="map-pin" class="w-3 h-3"></i>
                                        {{ $produk->location ?? 'Indonesia' }}
                                    </div>
                                </div>
                            </a>
                        </div>
                    @endforeach
                </div>

                <div class="mt-8">
                    {{ $wishlists->links() }}
                </div>
            @endif
        </div>
    </div>
</x-app-layout>
