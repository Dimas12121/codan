<x-app-layout>
    <x-slot name="header">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-6 sm:gap-4">
            <div>
                <h2 class="font-black text-3xl sm:text-4xl text-slate-900 dark:text-white leading-tight flex items-center gap-3 sm:gap-4 italic tracking-tighter">
                    <span class="w-3 h-8 sm:h-10 bg-blue-600 rounded-full"></span>
                    {{ auth()->user()->role == 'seller' ? 'DASHBOARD PENJUAL' : 'DASHBOARD PEMBELI' }}
                </h2>
                <div class="flex items-center gap-2 mt-2 sm:mt-1">
                    <p class="text-slate-500 font-medium text-sm sm:text-base">Hello, {{ auth()->user()->name }}!</p>
                    <span class="px-2 py-0.5 rounded-md bg-blue-100 text-blue-600 text-[9px] font-black uppercase tracking-widest">{{ auth()->user()->role }}</span>
                </div>
            </div>
            @if(auth()->user()->role == 'seller')
            <a href="{{ route('produks.create') }}" class="inline-flex items-center justify-center gap-3 px-6 sm:px-8 py-3.5 sm:py-4 rounded-2xl bg-blue-600 text-white text-xs sm:text-sm font-black hover:scale-105 transition-all shadow-xl shadow-blue-500/20 active:scale-95">
                <i data-lucide="plus" class="w-5 h-5"></i>
                IKLAN BARU
            </a>
            @else
            <a href="{{ route('home') }}" class="inline-flex items-center justify-center gap-3 px-6 sm:px-8 py-3.5 sm:py-4 rounded-2xl bg-indigo-600 text-white text-xs sm:text-sm font-black hover:scale-105 transition-all shadow-xl shadow-indigo-500/20 active:scale-95">
                <i data-lucide="shopping-bag" class="w-5 h-5"></i>
                MULAI BELANJA
            </a>
            @endif
        </div>
    </x-slot>

    <div class="py-12 bg-gray-50/50 dark:bg-slate-950/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            
            @if(auth()->user()->role == 'buyer')
                <!-- Buyer View: Welcome Page Style -->
                
                <!-- Search Integration for Buyer Dashboard -->
                <div class="mb-12">
                    <form action="{{ route('dashboard') }}" method="GET" class="flex flex-col lg:flex-row items-center gap-4 bg-white dark:bg-slate-900 border border-gray-100 dark:border-slate-800 p-2 rounded-[2rem] shadow-sm">
                        <div class="relative w-full lg:w-1/3">
                            <div class="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none">
                                <i data-lucide="map-pin" class="h-5 w-5 text-gray-400"></i>
                            </div>
                            <input type="text" class="block w-full pl-14 pr-3 py-4 border-none bg-transparent focus:ring-0 text-sm font-semibold" placeholder="Seluruh Indonesia">
                        </div>
                        <div class="hidden lg:block w-px h-8 bg-gray-100 dark:bg-slate-800"></div>
                        <div class="relative flex-1 w-full">
                            <div class="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none">
                                <i data-lucide="search" class="h-5 w-5 text-gray-400"></i>
                            </div>
                            <input type="text" name="search" value="{{ request('search') }}" class="block w-full pl-14 pr-3 py-4 border-none bg-transparent focus:ring-0 text-sm font-semibold" placeholder="Temukan Mobil Bekas, Elektronik, dan lainnya...">
                        </div>
                        <button type="submit" class="w-full lg:w-auto px-10 py-4 bg-blue-600 text-white rounded-[1.5rem] font-black uppercase tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 active:scale-95">
                            CARI
                        </button>
                    </form>
                </div>

                <div class="mb-12 relative group/scroll">
                    <!-- Left/Right Fade Indicators -->
                    <div class="absolute left-0 top-0 bottom-0 w-12 bg-gradient-to-r from-gray-50 dark:from-slate-950 to-transparent z-10 pointer-events-none opacity-0 group-hover/scroll:opacity-100 transition-opacity"></div>
                    <div class="absolute right-0 top-0 bottom-0 w-12 bg-gradient-to-l from-gray-50 dark:from-slate-950 to-transparent z-10 pointer-events-none opacity-0 group-hover/scroll:opacity-100 transition-opacity"></div>

                    <div id="category-scroll" class="flex items-center gap-4 overflow-x-auto pb-6 cursor-grab active:cursor-grabbing no-scrollbar scroll-smooth select-none">
                        <span class="whitespace-nowrap font-black text-[10px] uppercase text-gray-400 mr-4 tracking-widest shrink-0">Geser Kategori:</span>
                        <a href="{{ route('dashboard') }}" class="flex items-center gap-3 px-6 py-3 rounded-2xl border {{ !request('category') ? 'border-blue-500 bg-blue-50 text-blue-600 shadow-md shadow-blue-500/10' : 'bg-white dark:bg-slate-900 border-gray-100 dark:border-slate-800' }} hover:border-blue-500 hover:shadow-lg transition-all flex-shrink-0 group">
                            <div class="w-8 h-8 rounded-xl {{ !request('category') ? 'bg-blue-600 text-white' : 'bg-gray-50 dark:bg-slate-800 text-gray-500' }} flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all">
                                <i data-lucide="layout-grid" class="w-4 h-4"></i>
                            </div>
                            <span class="text-xs font-black uppercase tracking-tight">Semua</span>
                        </a>
                        @foreach($categories as $category)
                        <a href="{{ route('dashboard', array_merge(request()->query(), ['category' => $category->slug])) }}" 
                           class="flex items-center gap-3 px-6 py-3 rounded-2xl border relative transition-all flex-shrink-0 group
                           {{ request('category') == $category->slug 
                               ? 'border-blue-500 bg-blue-50 text-blue-600 shadow-md shadow-blue-500/10' 
                               : 'bg-white dark:bg-slate-900 border-gray-100 dark:border-slate-800' }} hover:border-blue-500 hover:shadow-lg">
                            
                            @if(request('category') == $category->slug)
                            <span class="absolute -top-1 -right-1 w-3 h-3 bg-blue-600 rounded-full border-2 border-white dark:border-slate-900 animate-pulse"></span>
                            @endif

                            <div class="w-8 h-8 rounded-xl {{ request('category') == $category->slug ? 'bg-blue-600 text-white' : 'bg-gray-50 dark:bg-slate-800 text-gray-500' }} flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all">
                                <i data-lucide="{{ $category->icon ?: 'tag' }}" class="w-4 h-4"></i>
                            </div>

                            <div class="flex flex-col">
                                <span class="text-xs font-black uppercase tracking-tight">{{ $category->name }}</span>
                                <span class="text-[9px] font-bold {{ request('category') == $category->slug ? 'text-blue-500' : 'text-gray-400' }}">{{ $category->produks_count }} Iklan</span>
                            </div>
                        </a>
                        @endforeach
                    </div>
                </div>

                <!-- Condition Filter for Buyer Dashboard -->
                <div class="mb-12 flex bg-gray-100 dark:bg-slate-800 p-1.5 rounded-2xl w-fit">
                    <a href="{{ route('dashboard', array_merge(request()->query(), ['condition' => ''])) }}" class="px-6 py-2.5 rounded-[1rem] text-[10px] font-black uppercase tracking-widest transition-all {{ !request('condition') ? 'bg-white dark:bg-slate-700 text-blue-600 shadow-sm' : 'text-gray-400 hover:text-slate-600' }}">Semua Kondisi</a>
                    <a href="{{ route('dashboard', array_merge(request()->query(), ['condition' => 'baru'])) }}" class="px-6 py-2.5 rounded-[1rem] text-[10px] font-black uppercase tracking-widest transition-all {{ request('condition') == 'baru' ? 'bg-white dark:bg-slate-700 text-emerald-600 shadow-sm' : 'text-gray-400 hover:text-slate-600' }}">Baru</a>
                    <a href="{{ route('dashboard', array_merge(request()->query(), ['condition' => 'bekas'])) }}" class="px-6 py-2.5 rounded-[1rem] text-[10px] font-black uppercase tracking-widest transition-all {{ request('condition') == 'bekas' ? 'bg-white dark:bg-slate-700 text-amber-600 shadow-sm' : 'text-gray-400 hover:text-slate-600' }}">Bekas</a>
                </div>

                <!-- Recommendations Grid -->
                <div class="flex items-center justify-between mb-8">
                    <h3 class="text-2xl font-black flex items-center gap-3 tracking-tight">
                        <span class="w-2.5 h-8 bg-blue-600 rounded-full"></span>
                        REKOMENDASI UNTUK ANDA
                    </h3>
                </div>

                <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-8">
                    @forelse($recommendations as $produk)
                    <a href="{{ route('produks.show', $produk->slug) }}" class="bg-white dark:bg-slate-900 rounded-[2.5rem] overflow-hidden border border-gray-100 dark:border-slate-800 hover:shadow-2xl hover:shadow-blue-500/5 transition-all group flex flex-col h-full relative shadow-sm">
                        <div class="relative aspect-[4/3] overflow-hidden m-3 rounded-[1.8rem]">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-all duration-700" alt="{{ $produk->title }}">
                            <div class="absolute top-3 right-3">
                                <button class="p-2.5 rounded-full bg-white/40 backdrop-blur-md text-slate-900 hover:bg-white hover:text-red-500 transition-all shadow-lg">
                                    <i data-lucide="heart" class="w-4 h-4"></i>
                                </button>
                            </div>
                            <div class="absolute top-3 left-3 px-3 py-1.5 rounded-xl bg-white/90 dark:bg-slate-800/90 backdrop-blur-md text-[9px] font-black uppercase tracking-widest {{ $produk->condition == 'baru' ? 'text-emerald-600' : 'text-amber-600' }} shadow-sm">
                                {{ $produk->condition }}
                            </div>
                        </div>
                        <div class="px-4 sm:px-7 pb-4 sm:pb-7 pt-2 flex-1 flex flex-col">
                            <div class="text-xl sm:text-2xl font-black text-blue-600 mb-1 sm:mb-2 tracking-tighter italic">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                            <h4 class="text-slate-800 dark:text-gray-100 font-bold text-sm sm:text-lg line-clamp-2 leading-tight sm:leading-snug mb-auto group-hover:text-blue-600 transition-colors">{{ $produk->title }}</h4>
                            
                            <div class="mt-4 sm:mt-6 pt-4 sm:pt-6 border-t border-gray-50 dark:border-slate-800/50 flex flex-col sm:flex-row sm:items-center justify-between text-[8px] sm:text-[10px] text-gray-400 uppercase tracking-[0.1em] font-black gap-2">
                                <span class="flex items-center gap-1.5 font-bold">
                                    <i data-lucide="tag" class="w-3 h-3 text-blue-500"></i>
                                    {{ $produk->category->name }}
                                </span>
                                <span>{{ $produk->created_at->diffForHumans() }}</span>
                            </div>
                        </div>
                    </a>
                    @empty
                    <div class="col-span-full py-20 text-center">
                        <i data-lucide="package-search" class="w-12 h-12 text-gray-200 mx-auto mb-4"></i>
                        <h4 class="text-lg font-bold text-gray-400 uppercase tracking-widest">Belum ada rekomendasi</h4>
                    </div>
                    @endforelse
                </div>

                <div class="mt-12">
                    {{ $recommendations->appends(request()->query())->links() }}
                </div>

            @else
                <!-- Seller View: Manage produks Style -->
                
                <!-- Quick Stats -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-8 mb-12">
                    <div class="bg-white dark:bg-slate-900 p-6 sm:p-8 rounded-3xl sm:rounded-[2.5rem] shadow-sm border border-gray-100 dark:border-slate-800 flex items-center gap-4 sm:gap-6 group hover:border-blue-500 transition-all">
                        <div class="w-12 h-12 sm:w-16 sm:h-16 rounded-2xl sm:rounded-3xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center group-hover:scale-110 transition-transform shrink-0">
                            <i data-lucide="layout-grid" class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600"></i>
                        </div>
                        <div>
                            <div class="text-[8px] sm:text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mb-0.5 sm:mb-1">Total Iklan</div>
                            <div class="text-xl sm:text-3xl font-black">{{ $produks->count() }}</div>
                        </div>
                    </div>
                    <div class="bg-white dark:bg-slate-900 p-6 sm:p-8 rounded-3xl sm:rounded-[2.5rem] shadow-sm border border-gray-100 dark:border-slate-800 flex items-center gap-4 sm:gap-6 group hover:border-emerald-500 transition-all">
                        <div class="w-12 h-12 sm:w-16 sm:h-16 rounded-2xl sm:rounded-3xl bg-emerald-50 dark:bg-emerald-900/20 flex items-center justify-center group-hover:scale-110 transition-transform shrink-0">
                            <i data-lucide="eye" class="w-6 h-6 sm:w-8 sm:h-8 text-emerald-600"></i>
                        </div>
                        <div>
                            <div class="text-[8px] sm:text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mb-0.5 sm:mb-1">Total Dilihat</div>
                            <div class="text-xl sm:text-3xl font-black">{{ number_format($totalViews ?? 0, 0, ',', '.') }}</div>
                        </div>
                    </div>
                    <div class="bg-white dark:bg-slate-900 p-6 sm:p-8 rounded-3xl sm:rounded-[2.5rem] shadow-sm border border-gray-100 dark:border-slate-800 flex items-center gap-4 sm:gap-6 group hover:border-amber-500 transition-all sm:col-span-2 lg:col-span-1">
                        <div class="w-12 h-12 sm:w-16 sm:h-16 rounded-2xl sm:rounded-3xl bg-amber-50 dark:bg-amber-900/20 flex items-center justify-center group-hover:scale-110 transition-transform shrink-0">
                            <i data-lucide="message-square" class="w-6 h-6 sm:w-8 sm:h-8 text-amber-600"></i>
                        </div>
                        <div>
                            <div class="text-[8px] sm:text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mb-0.5 sm:mb-1">Chat Aktif</div>
                            <div class="text-xl sm:text-3xl font-black">{{ $activeChats ?? 0 }}</div>
                        </div>
                    </div>
                </div>

                <!-- Header Tabs -->
                <div class="flex items-center justify-between mb-8 border-b border-gray-100 dark:border-slate-800 pb-4">
                    <div class="flex gap-8">
                        <a href="{{ route('dashboard', ['status' => 'active']) }}" class="text-sm font-black uppercase tracking-widest {{ ($status ?? 'active') == 'active' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-400 hover:text-slate-600' }} pb-4 -mb-4.5">Iklan Aktif</a>
                        <a href="{{ route('dashboard', ['status' => 'sold']) }}" class="text-sm font-black uppercase tracking-widest {{ ($status ?? '') == 'sold' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-400 hover:text-slate-600' }} pb-4 -mb-4.5">Terjual</a>
                    </div>
                </div>

                <!-- produks Grid -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 sm:gap-8">
                    @forelse($produks as $produk)
                    <div class="bg-white dark:bg-slate-900 rounded-3xl sm:rounded-[2.5rem] overflow-hidden border border-gray-100 dark:border-slate-800 shadow-sm flex flex-col sm:flex-row group hover:shadow-2xl hover:shadow-blue-500/5 transition-all">
                        <div class="relative h-48 sm:h-auto sm:w-48 shrink-0 overflow-hidden">
                            <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700" alt="produk">
                            <div class="absolute top-4 left-4 flex flex-row sm:flex-col gap-2">
                                <span class="px-3 py-1.5 rounded-xl bg-white/90 dark:bg-slate-900/90 backdrop-blur-md text-[9px] font-black uppercase tracking-widest {{ $produk->status == 'active' ? 'text-emerald-600' : 'text-amber-600' }} shadow-lg">
                                    {{ $produk->status }}
                                </span>
                                <span class="px-3 py-1.5 rounded-xl bg-white/90 dark:bg-slate-900/90 backdrop-blur-md text-[9px] font-black uppercase tracking-widest text-slate-500 shadow-lg">
                                    {{ $produk->condition }}
                                </span>
                            </div>
                        </div>
                        <div class="p-6 sm:p-8 flex-1 flex flex-col">
                            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-4 mb-4">
                                <div class="flex-1 min-w-0">
                                    <h3 class="font-black text-lg sm:text-xl text-slate-800 dark:text-gray-100 line-clamp-2 sm:line-clamp-1 group-hover:text-blue-600 transition-colors">{{ $produk->title }}</h3>
                                    <div class="flex items-center gap-2 mt-2 text-[10px] text-gray-400 font-black uppercase tracking-widest">
                                        <i data-lucide="tag" class="w-3 h-3 text-blue-500"></i>
                                        {{ $produk->category->name }}
                                    </div>
                                </div>
                                <div class="text-xl sm:text-2xl font-black text-blue-600 italic tracking-tighter shrink-0">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3 sm:gap-4 mt-6 sm:mt-auto">
                                <a href="{{ route('produks.show', $produk->slug) }}" class="flex items-center justify-center gap-2 py-3.5 rounded-2xl bg-gray-50 dark:bg-slate-800 text-[10px] font-black uppercase tracking-widest hover:bg-blue-600 hover:text-white transition-all">
                                    <i data-lucide="external-link" class="w-3.5 h-3.5"></i>
                                    Detail
                                </a>
                                <div class="flex gap-2">
                                    @if($produk->status == 'active')
                                    <form action="{{ route('produks.status', $produk->id) }}" method="POST" class="flex-1">
                                        @csrf
                                        @method('PATCH')
                                        <input type="hidden" name="status" value="sold">
                                        <button type="submit" class="w-full flex items-center justify-center py-3.5 rounded-2xl border border-gray-100 dark:border-slate-800 text-slate-400 hover:bg-emerald-50 hover:text-emerald-600 hover:border-emerald-500 transition-all" title="Tandai Terjual">
                                            <i data-lucide="check-circle" class="w-4 h-4"></i>
                                        </button>
                                    </form>
                                    @endif
                                    <a href="{{ route('produks.edit', $produk->id) }}" class="flex-1 flex items-center justify-center py-3.5 rounded-2xl border border-gray-100 dark:border-slate-800 text-slate-400 hover:bg-blue-50 hover:text-blue-600 hover:border-blue-500 transition-all" title="Edit">
                                        <i data-lucide="edit-3" class="w-4 h-4"></i>
                                    </a>
                                    <form action="{{ route('produks.destroy', $produk->id) }}" method="POST" class="flex-1" onsubmit="return confirm('Hapus iklan ini?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="w-full flex items-center justify-center py-3.5 rounded-2xl border border-gray-100 dark:border-slate-800 text-slate-400 hover:bg-red-50 hover:text-red-600 hover:border-red-500 transition-all" title="Hapus">
                                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    @empty
                    <div class="col-span-full py-24 text-center bg-white dark:bg-slate-900 rounded-[3rem] border border-dashed border-gray-200 dark:border-slate-800">
                        <div class="w-24 h-24 bg-blue-50 dark:bg-blue-900/10 rounded-full flex items-center justify-center mx-auto mb-8">
                            <i data-lucide="package-search" class="w-12 h-12 text-blue-200"></i>
                        </div>
                        <h3 class="text-2xl font-black text-slate-800 dark:text-gray-100 tracking-tight">Belum Ada Iklan</h3>
                        <p class="text-gray-500 font-medium mt-2 max-w-sm mx-auto leading-relaxed italic">"Barang lama Anda bisa jadi harta karun bagi orang lain. Ayo mulai jualan!"</p>
                        <a href="{{ route('produks.create') }}" class="mt-10 inline-flex items-center gap-3 px-10 py-5 rounded-3xl bg-blue-600 text-white font-black hover:scale-105 active:scale-95 transition-all shadow-2xl shadow-blue-500/30">
                            <i data-lucide="plus-circle" class="w-6 h-6"></i>
                            PASANG IKLAN SEKARANG
                        </a>
                    </div>
                    @endforelse
                </div>
            @endif
    </div>
    
    <script>
        window.addEventListener('load', () => {
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        });
    </script>
    @push('scripts')
    <script>
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
                const walk = (x - startX) * 2; // scroll-fast
                slider.scrollLeft = scrollLeft - walk;
            });
        });
    </script>
    @endpush
</x-app-layout>
