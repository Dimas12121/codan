<nav x-data="{ open: false }" class="bg-white/80 dark:bg-slate-900/80 backdrop-blur-md sticky top-0 z-50 border-b border-gray-100 dark:border-slate-800 transition-all">
    <!-- Primary Navigation Menu -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-20">
            <div class="flex items-center">
                <!-- Logo -->
                <div class="shrink-0 flex items-center">
                    <a href="/" class="flex items-center gap-2 group transition-all">
                        <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-500/20 group-hover:scale-110 transition-transform">
                            <i data-lucide="shopping-bag" class="text-white w-6 h-6"></i>
                        </div>
                        <span class="text-xl font-black tracking-tight text-slate-900 dark:text-white uppercase">CODean</span>
                    </a>
                </div>

                <!-- Navigation Links -->
                <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
                    <a href="{{ route('home') }}" class="inline-flex items-center px-1 pt-1 border-b-2 {{ request()->routeIs('home') ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-400 hover:text-slate-600 hover:border-gray-300' }} text-sm font-black uppercase tracking-widest transition-all">Beranda</a>
                    <a href="{{ route('dashboard') }}" class="inline-flex items-center px-1 pt-1 border-b-2 {{ request()->routeIs('dashboard') ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-400 hover:text-slate-600 hover:border-gray-300' }} text-sm font-black uppercase tracking-widest transition-all">Dashboard</a>
                    <a href="{{ route('inbox.index') }}" class="inline-flex items-center px-1 pt-1 border-b-2 {{ request()->routeIs('inbox.*') ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-400 hover:text-slate-600 hover:border-gray-300' }} text-sm font-black uppercase tracking-widest transition-all">Inbox</a>
                    @if(auth()->user()->role === 'admin')
                    <a href="{{ route('admin.dashboard') }}" class="inline-flex items-center px-1 pt-1 border-b-2 {{ request()->routeIs('admin.*') ? 'border-red-500 text-red-600' : 'border-transparent text-gray-400 hover:text-slate-600 hover:border-gray-300' }} text-sm font-black uppercase tracking-widest transition-all italic">Admin</a>
                    @endif
                </div>
            </div>

            <!-- Settings Dropdown -->
            <div class="hidden sm:flex sm:items-center sm:ms-6 gap-4">
                <!-- Notifications Dropdown -->
                <div class="relative" x-data="{ 
                    open: false, 
                    unreadCount: 0, 
                    notifications: [],
                    async fetchNotifications() {
                        const response = await fetch('{{ route('notifications.unread') }}');
                        const data = await response.json();
                        this.notifications = data.notifications;
                        this.unreadCount = data.unreadCount;
                    },
                    async markAllAsRead() {
                        await fetch('{{ route('notifications.read-all') }}', {
                            method: 'POST',
                            headers: {
                                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                                'Accept': 'application/json'
                            }
                        });
                        this.unreadCount = 0;
                        this.notifications = [];
                    }
                }" x-init="fetchNotifications(); setInterval(() => fetchNotifications(), 30000)">
                    <button @click="open = !open; if(open) fetchNotifications()" class="relative p-2 text-slate-400 hover:text-blue-600 bg-gray-50 dark:bg-slate-800 rounded-xl transition-all">
                        <i data-lucide="bell" class="w-5 h-5"></i>
                        <template x-if="unreadCount > 0">
                            <span class="absolute top-1 right-1 w-4 h-4 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center border-2 border-white dark:border-slate-900" x-text="unreadCount"></span>
                        </template>
                    </button>

                    <div x-show="open" @click.away="open = false" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0 scale-95" x-transition:enter-end="opacity-100 scale-100" class="absolute right-0 mt-3 w-80 bg-white dark:bg-slate-900 rounded-[2rem] shadow-2xl border border-slate-100 dark:border-slate-800 z-50 overflow-hidden">
                        <div class="p-4 border-b border-slate-50 dark:border-slate-800 flex items-center justify-between">
                            <h3 class="font-bold text-slate-900 dark:text-white">Notifikasi</h3>
                            <button @click="markAllAsRead" class="text-xs text-blue-600 hover:underline font-bold" x-show="unreadCount > 0">Tandai semua dibaca</button>
                        </div>
                        <div class="max-h-96 overflow-y-auto">
                            <template x-if="notifications.length === 0">
                                <div class="p-8 text-center">
                                    <div class="w-12 h-12 bg-slate-50 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-3">
                                        <i data-lucide="bell-off" class="w-6 h-6 text-slate-300"></i>
                                    </div>
                                    <p class="text-slate-400 text-sm italic">Tidak ada notifikasi baru</p>
                                </div>
                            </template>
                            <template x-for="notification in notifications" :key="notification.id">
                                <a :href="'/notifications'" class="block p-4 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors border-b border-slate-50 dark:border-slate-800">
                                    <div class="flex gap-3">
                                        <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center shrink-0">
                                            <i data-lucide="message-square" class="w-5 h-5 text-blue-600"></i>
                                        </div>
                                        <div>
                                            <p class="text-sm text-slate-700 dark:text-slate-200 leading-snug" x-text="notification.data.message || 'Pesan baru diterima'"></p>
                                            <p class="text-[10px] text-slate-400 mt-1" x-text="new Date(notification.created_at).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})"></p>
                                        </div>
                                    </div>
                                </a>
                            </template>
                        </div>
                        <a href="{{ route('notifications.index') }}" class="block p-4 text-center text-xs font-bold text-slate-500 hover:text-blue-600 transition-colors bg-slate-50/50 dark:bg-slate-800/50">
                            Lihat Semua Notifikasi
                        </a>
                    </div>
                </div>

                <a href="{{ route('produks.create') }}" class="px-5 py-2.5 rounded-xl bg-blue-600 text-white text-xs font-black uppercase tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/10 active:scale-95">Jual</a>
                
                <x-dropdown align="right" width="48">
                    <x-slot name="trigger">
                        <button class="flex items-center gap-3 p-1.5 rounded-2xl bg-gray-50 dark:bg-slate-800 border border-transparent hover:border-gray-200 dark:hover:border-slate-700 transition-all">
                        <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-blue-100 to-indigo-100 dark:from-slate-700 dark:to-slate-600 flex items-center justify-center text-blue-600 font-black text-xs overflow-hidden">
                            @if(Auth::user()->avatar)
                                <img src="{{ asset('storage/' . Auth::user()->avatar) }}" class="w-full h-full object-cover">
                            @else
                                {{ substr(Auth::user()->name, 0, 1) }}
                            @endif
                        </div>
                            <div class="text-sm font-bold text-gray-600 dark:text-gray-300 pr-2">{{ Auth::user()->name }}</div>
                        </button>
                    </x-slot>

                    <x-slot name="content">
                        <x-dropdown-link :href="route('profile.show')" class="font-bold flex items-center gap-2">
                             <i data-lucide="user" class="w-4 h-4"></i> Profile
                        </x-dropdown-link>

                        <!-- Authentication -->
                        <form method="POST" action="{{ route('logout') }}">
                            @csrf
                            <x-dropdown-link :href="route('logout')"
                                    onclick="event.preventDefault();
                                                this.closest('form').submit();" class="text-red-600 font-bold flex items-center gap-2">
                                <i data-lucide="log-out" class="w-4 h-4 text-red-600"></i> Keluar
                            </x-dropdown-link>
                        </form>
                    </x-slot>
                </x-dropdown>
            </div>

            <!-- Hamburger -->
            <div class="-me-2 flex items-center sm:hidden">
                <button @click="open = ! open" class="inline-flex items-center justify-center p-3 rounded-xl bg-gray-50 dark:bg-slate-800 text-gray-400 hover:text-gray-500 transition-all focus:outline-none">
                    <i data-lucide="menu" x-show="!open" class="w-6 h-6"></i>
                    <i data-lucide="x" x-show="open" class="w-6 h-6"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Responsive Navigation Menu -->
    <div x-show="open" x-transition class="sm:hidden bg-white dark:bg-slate-900 border-t border-gray-100 dark:border-slate-800 pb-6">
        <div class="pt-4 pb-3 space-y-1 px-4">
            <x-responsive-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')" class="rounded-xl font-bold">
                Dashboard
            </x-responsive-nav-link>
            <x-responsive-nav-link :href="route('inbox.index')" :active="request()->routeIs('inbox.index')" class="rounded-xl font-bold">
                Inbox
            </x-responsive-nav-link>
            <x-responsive-nav-link :href="route('produks.create')" class="rounded-xl font-bold bg-blue-600 text-white !border-none mt-2">
                Pasang Iklan
            </x-responsive-nav-link>
        </div>

        <!-- Responsive Settings Options -->
        <div class="pt-4 pb-1 border-t border-gray-100 dark:border-slate-800 mx-4">
            <div class="flex items-center gap-3 py-4">
                <div class="w-10 h-10 rounded-xl bg-blue-100 dark:bg-slate-800 flex items-center justify-center text-blue-600 font-black overflow-hidden">
                    @if(Auth::user()->avatar)
                        <img src="{{ asset('storage/' . Auth::user()->avatar) }}" class="w-full h-full object-cover">
                    @else
                        {{ substr(Auth::user()->name, 0, 1) }}
                    @endif
                </div>
                <div>
                    <div class="font-bold text-base text-gray-800 dark:text-gray-200">{{ Auth::user()->name }}</div>
                    <div class="font-medium text-xs text-gray-500">{{ Auth::user()->email }}</div>
                </div>
            </div>

            <div class="space-y-1">
                <x-responsive-nav-link :href="route('profile.edit')" class="rounded-xl font-bold">
                    Edit Profil
                </x-responsive-nav-link>

                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <x-responsive-nav-link :href="route('logout')"
                            onclick="event.preventDefault();
                                        this.closest('form').submit();" class="rounded-xl font-bold text-red-600">
                        Keluar
                    </x-responsive-nav-link>
                </form>
            </div>
        </div>
    </div>
</nav>
