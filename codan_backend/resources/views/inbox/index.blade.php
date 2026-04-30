<x-app-layout>
    <div class="bg-white dark:bg-slate-900 border-t border-gray-100 dark:border-slate-800 flex {{ Request::routeIs('inbox.show') ? 'h-[calc(100dvh-160px)] lg:h-[calc(100vh-80px)]' : 'h-[calc(100dvh-170px)] lg:h-[calc(100vh-80px)]' }} overflow-hidden">
        
        <!-- Left Sidebar: Conversation List -->
        <div class="{{ Request::routeIs('inbox.show') ? 'hidden lg:flex' : 'flex' }} w-full lg:w-[400px] border-r border-gray-50 dark:border-slate-800 flex-col bg-white dark:bg-slate-900/50">
            <div class="p-8 border-b border-gray-50 dark:border-slate-800 bg-gradient-to-b from-gray-50/50 to-white dark:from-slate-800/50 dark:to-slate-900">
                <h2 class="text-3xl font-black text-slate-900 dark:text-white italic tracking-tighter flex items-center gap-3">
                    <i data-lucide="message-circle" class="w-8 h-8 text-blue-600"></i>
                    INBOX
                </h2>
                <div class="mt-6 relative">
                    <i data-lucide="search" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400"></i>
                    <input type="text" id="conversation-search" placeholder="Cari percakapan..." class="w-full pl-12 pr-6 py-3.5 rounded-2xl bg-white dark:bg-slate-800 border-2 border-gray-50 dark:border-slate-700 text-sm font-bold focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all outline-none shadow-sm">
                </div>

                <!-- Inbox Tabs -->
                <div class="mt-6 flex bg-gray-50/50 dark:bg-slate-800/50 p-1 rounded-xl">
                    <button id="tab-all" onclick="filterConversations('all')" class="flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all bg-white dark:bg-slate-700 text-blue-600 shadow-sm border border-gray-100 dark:border-slate-600">Semua</button>
                    <button id="tab-unread" onclick="filterConversations('unread')" class="flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all text-gray-400 hover:text-slate-600 dark:hover:text-gray-300">Belum Dibaca</button>
                </div>
            </div>

            <div id="conversation-list" class="flex-1 overflow-y-auto">
                @forelse($conversations as $convo)
                    @php
                        $userId = auth()->id();
                        $partner = $convo->sender_id == $userId ? $convo->receiver : $convo->sender;
                        $isActive = isset($produk) && isset($activePartner) && $produk->id == $convo->produk_id && $partner->id == $activePartner->id;
                    @endphp
                    <a href="{{ route('inbox.show', [$convo->produk_id, $partner->id]) }}" 
                       data-search="{{ strtolower($partner->name . ' ' . $convo->produk->title) }}"
                       data-unread="{{ $convo->unread_count > 0 ? 'true' : 'false' }}"
                       class="conversation-item flex items-center gap-4 p-4 md:p-6 hover:bg-blue-50/30 dark:hover:bg-blue-900/5 transition-all relative group {{ $isActive ? 'bg-blue-50/50 dark:bg-blue-900/10 border-r-4 border-blue-600 active-convo' : 'border-r-4 border-transparent' }}">
                        
                        <div class="relative w-14 h-14 md:w-16 md:h-16 shrink-0 rounded-2xl overflow-hidden shadow-sm">
                            <img src="{{ $convo->produk->featuredImage->image_path }}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" alt="produk">
                            @if(!$convo->is_read && $convo->receiver_id == $userId)
                            <div class="absolute top-1 right-1 w-3 h-3 bg-blue-600 border-2 border-white dark:border-slate-900 rounded-full animate-bounce"></div>
                            @endif
                        </div>

                        <div class="flex-1 min-w-0">
                            <div class="flex justify-between items-start mb-1">
                                <h4 class="font-black text-xs md:text-sm text-slate-800 dark:text-gray-100 truncate flex-1 pr-2 {{ $convo->unread_count > 0 ? 'text-blue-600' : '' }}">{{ $convo->produk->title }}</h4>
                                <span class="text-[9px] font-black uppercase tracking-widest text-gray-400">{{ $convo->created_at->diffForHumans() }}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <p class="text-[11px] md:text-xs font-bold text-gray-400 truncate flex-1">
                                    <span class="text-slate-500 dark:text-gray-300">{{ $partner->name }}:</span> 
                                    {{ $convo->message ?? 'Sent an image' }}
                                </p>
                                @if($convo->unread_count > 0)
                                <span class="ml-2 px-2 py-0.5 rounded-full bg-blue-600 text-white text-[9px] font-black">{{ $convo->unread_count }}</span>
                                @endif
                            </div>
                        </div>
                    </a>
                @empty
                    <div class="p-12 text-center">
                        <i data-lucide="message-square-off" class="w-12 h-12 text-gray-200 mx-auto mb-4"></i>
                        <p class="text-sm font-bold text-gray-400">Belum ada percakapan.</p>
                    </div>
                @endforelse
            </div>
        </div>

        <!-- Right Panel: Active Chat or Placeholder -->
        <div class="{{ Request::routeIs('inbox.show') ? 'flex' : 'hidden lg:flex' }} flex-1 flex-col bg-gray-50/30 dark:bg-slate-900/20 relative min-h-0">
            @yield('chat_content')
            
            @unless(View::hasSection('chat_content'))
            <div class="flex-1 flex flex-col items-center justify-center p-8 sm:p-20 text-center relative overflow-hidden">
                <!-- Decorative background elements -->
                <div class="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-blue-500/5 rounded-full blur-3xl"></div>
                <div class="absolute bottom-0 left-0 -ml-20 -mb-20 w-64 h-64 bg-indigo-500/5 rounded-full blur-3xl"></div>

                <div class="relative z-10">
                    <div class="w-24 h-24 md:w-32 md:h-32 bg-white dark:bg-slate-800 rounded-[2.5rem] md:rounded-[3rem] shadow-2xl border border-gray-100 dark:border-slate-700 flex items-center justify-center mb-8 md:mb-10 mx-auto transform hover:rotate-12 transition-transform duration-500 group">
                        <div class="w-16 h-16 md:w-20 md:h-20 bg-blue-50 dark:bg-blue-900/20 rounded-[1.5rem] md:rounded-[2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                            <i data-lucide="messages-square" class="w-8 h-8 md:w-10 md:h-10 text-blue-600"></i>
                        </div>
                    </div>
                    <h3 class="text-2xl md:text-4xl font-black text-slate-800 dark:text-gray-100 tracking-tighter italic mb-4">Mulai Mengobrol</h3>
                    <p class="text-gray-400 font-medium max-w-sm mx-auto leading-relaxed text-sm md:text-lg">Pilih salah satu diskusi di samping untuk mulai bernegosiasi atau bertanya detail barang secara langsung.</p>
                    
                    <div class="mt-8 md:mt-12 flex items-center justify-center gap-6 md:gap-8 grayscale opacity-30">
                        <div class="flex flex-col items-center gap-2">
                            <i data-lucide="shield-check" class="w-5 h-5 md:w-6 md:h-6"></i>
                            <span class="text-[9px] md:text-[10px] font-black uppercase tracking-widest">Aman</span>
                        </div>
                        <div class="flex flex-col items-center gap-2">
                            <i data-lucide="zap" class="w-5 h-5 md:w-6 md:h-6"></i>
                            <span class="text-[9px] md:text-[10px] font-black uppercase tracking-widest">Cepat</span>
                        </div>
                        <div class="flex flex-col items-center gap-2">
                            <i data-lucide="heart" class="w-5 h-5 md:w-6 md:h-6"></i>
                            <span class="text-[9px] md:text-[10px] font-black uppercase tracking-widest">Mudah</span>
                        </div>
                    </div>
                </div>
            </div>
            @endunless
        </div>
    </div>

    @push('scripts')
    <script>
        let currentFilter = 'all';

        function filterConversations(filter) {
            currentFilter = filter;
            const searchTerm = document.getElementById('conversation-search').value.toLowerCase();
            
            // Update UI Tabs
            const tabAll = document.getElementById('tab-all');
            const tabUnread = document.getElementById('tab-unread');
            
            if (filter === 'all') {
                tabAll.className = 'flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all bg-white dark:bg-slate-700 text-blue-600 shadow-sm border border-gray-100 dark:border-slate-600';
                tabUnread.className = 'flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all text-gray-400 hover:text-slate-600 dark:hover:text-gray-300';
            } else {
                tabUnread.className = 'flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all bg-white dark:bg-slate-700 text-blue-600 shadow-sm border border-gray-100 dark:border-slate-600';
                tabAll.className = 'flex-1 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all text-gray-400 hover:text-slate-600 dark:hover:text-gray-300';
            }

            applyFilters(searchTerm);
        }

        function applyFilters(searchTerm) {
            document.querySelectorAll('.conversation-item').forEach(item => {
                const searchData = item.getAttribute('data-search');
                const isUnread = item.getAttribute('data-unread') === 'true';
                
                const matchesSearch = searchData.includes(searchTerm);
                const matchesFilter = currentFilter === 'all' || (currentFilter === 'unread' && isUnread);
                
                if (matchesSearch && matchesFilter) {
                    item.classList.remove('hidden');
                } else {
                    item.classList.add('hidden');
                }
            });
        }

        document.getElementById('conversation-search')?.addEventListener('input', function(e) {
            applyFilters(e.target.value.toLowerCase());
        });

        // Real-time Sidebar Updates
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof Echo !== 'undefined') {
                Echo.private(`App.Models.User.{{ auth()->id() }}`)
                    .notification((notification) => {
                        if (notification.message_id) {
                            updateSidebarRealtime(notification);
                        }
                    });
            }
        });

        function updateSidebarRealtime(data) {
            const convoList = document.getElementById('conversation-list');
            // Try to find existing conversation item
            // The link format is /inbox/{produk_id}/{partner_id}
            let item = document.querySelector(`.conversation-item[href*="/inbox/${data.produk_id}/${data.sender_id}"]`);
            
            if (item) {
                // Update existing item
                const preview = item.querySelector('p span:last-child');
                if (preview) preview.textContent = 'Pesan baru diterima';
                
                const time = item.querySelector('span.text-[9px]');
                if (time) time.textContent = 'Baru saja';
                
                let badge = item.querySelector('.bg-blue-600.text-white');
                if (badge) {
                    badge.textContent = (parseInt(badge.textContent) || 0) + 1;
                } else {
                    const container = item.querySelector('.flex.items-center.justify-between');
                    container.insertAdjacentHTML('beforeend', `<span class="ml-2 px-2 py-0.5 rounded-full bg-blue-600 text-white text-[9px] font-black">1</span>`);
                }
                
                item.setAttribute('data-unread', 'true');
                
                // Move to top
                convoList.prepend(item);
            } else {
                // If new conversation, we might need to reload or just wait for next refresh
                // For now, let's just highlight that there's something new
                console.log('New conversation received:', data);
            }
            
            // Re-apply current filters
            const searchTerm = document.getElementById('conversation-search')?.value.toLowerCase() || '';
            applyFilters(searchTerm);
        }
    </script>
    @endpush
</x-app-layout>
