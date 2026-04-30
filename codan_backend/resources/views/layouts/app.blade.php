<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'Laravel') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <link rel="icon" type="image/png" href="{{ asset('favicon.png') }}">

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        @stack('styles')
    </head>
    <body class="font-sans antialiased text-slate-900 dark:text-slate-100 selection:bg-blue-500 selection:text-white" style="font-family: 'Plus Jakarta Sans', sans-serif;">


        <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
            @include('layouts.navigation')

            <!-- Page Heading -->
            @isset($header)
                <header class="hidden sm:block bg-white dark:bg-gray-800 shadow">
                    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                        {{ $header }}
                    </div>
                </header>
                <!-- Mobile Header (Only for specific pages like Dashboard) -->
                @if(request()->routeIs('dashboard'))
                <header class="sm:hidden bg-white dark:bg-slate-900 border-b border-gray-100 dark:border-slate-800">
                    <div class="px-4 py-6">
                        {{ $header }}
                    </div>
                </header>
                @endif
            @endisset

            <!-- Page Content -->
            <main class="{{ Request::routeIs('inbox.*') ? '' : 'pb-32' }} sm:pb-0">
                {{ $slot }}
            </main>

            <!-- Mobile Bottom Navigation -->
            <div class="sm:hidden fixed bottom-0 left-0 right-0 z-[100] bg-white dark:bg-slate-900 border-t border-slate-100 dark:border-slate-800 px-2 pb-2 pt-1 flex items-center justify-between shadow-[0_-4px_20px_rgba(0,0,0,0,05)]">
                <a href="{{ route('home') }}" class="flex flex-col items-center justify-center w-full py-1 transition-all {{ request()->routeIs('home') ? 'text-blue-600' : 'text-slate-400' }}">
                    <i data-lucide="home" class="w-5 h-5 {{ request()->routeIs('home') ? 'fill-blue-600/10' : '' }}"></i>
                    <span class="text-[9px] font-bold uppercase mt-1">Home</span>
                    @if(request()->routeIs('home'))
                        <div class="w-8 h-1 bg-blue-600 rounded-full mt-0.5"></div>
                    @endif
                </a>
                
                <a href="{{ route('inbox.index') }}" class="flex flex-col items-center justify-center w-full py-1 transition-all {{ request()->routeIs('inbox.*') ? 'text-blue-600' : 'text-slate-400' }}">
                    <i data-lucide="message-square" class="w-5 h-5 {{ request()->routeIs('inbox.*') ? 'fill-blue-600/10' : '' }}"></i>
                    <span class="text-[9px] font-bold uppercase mt-1">Chat</span>
                    @if(request()->routeIs('inbox.*'))
                        <div class="w-8 h-1 bg-blue-600 rounded-full mt-0.5"></div>
                    @endif
                </a>

                <!-- Centered Sell Button -->
                <div class="flex items-center justify-center w-full">
                    <a href="{{ route('produks.create') }}" class="w-14 h-14 bg-blue-600 rounded-full flex items-center justify-center text-white shadow-lg shadow-blue-500/40 active:scale-90 transition-all">
                        <i data-lucide="plus" class="w-7 h-7"></i>
                    </a>
                </div>

                <div x-data="{ 
                    unreadCount: 0, 
                    async fetchCount() {
                        try {
                            const response = await fetch('{{ route('notifications.unread') }}');
                            const data = await response.json();
                            this.unreadCount = data.unreadCount;
                        } catch (e) {}
                    },
                    init() {
                        this.fetchCount();
                        @auth
                        if (typeof Echo !== 'undefined') {
                            Echo.private(`App.Models.User.{{ auth()->id() }}`)
                                .notification((notification) => {
                                    this.unreadCount++;
                                    // Play sound or show toast if needed
                                });
                        }
                        @endauth
                        // Listen for local updates
                        window.addEventListener('update-unread-count', () => this.fetchCount());
                        
                        // Fallback polling (longer interval)
                        setInterval(() => this.fetchCount(), 60000);
                    }
                }" class="w-full">
                    <a href="{{ route('notifications.index') }}" class="flex flex-col items-center justify-center w-full py-1 relative transition-all {{ request()->routeIs('notifications.index') ? 'text-blue-600' : 'text-slate-400' }}">
                        <i data-lucide="bell" class="w-5 h-5 {{ request()->routeIs('notifications.index') ? 'fill-blue-600/10' : '' }}"></i>
                        <span class="text-[9px] font-bold uppercase mt-1">Notif</span>
                        <template x-if="unreadCount > 0">
                            <span class="absolute top-0 right-[20%] w-4 h-4 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center border-2 border-white dark:border-slate-900" x-text="unreadCount"></span>
                        </template>
                        @if(request()->routeIs('notifications.index'))
                            <div class="w-8 h-1 bg-blue-600 rounded-full mt-0.5"></div>
                        @endif
                    </a>
                </div>

                <a href="{{ route('profile.show') }}" class="flex flex-col items-center justify-center w-full py-1 transition-all {{ request()->routeIs('profile.*') ? 'text-blue-600' : 'text-slate-400' }}">
                    <i data-lucide="user" class="w-5 h-5 {{ request()->routeIs('profile.*') ? 'fill-blue-600/10' : '' }}"></i>
                    <span class="text-[9px] font-bold uppercase mt-1">Profile</span>
                    @if(request()->routeIs('profile.*'))
                        <div class="w-8 h-1 bg-blue-600 rounded-full mt-0.5"></div>
                    @endif
                </a>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            });
        </script>
        @stack('scripts')
    </body>
</html>
