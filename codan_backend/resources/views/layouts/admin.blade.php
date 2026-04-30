<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>Admin Central | {{ config('app.name', 'Laravel') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <link rel="icon" type="image/png" href="{{ asset('favicon.png') }}">

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        
        <style>
            body { font-family: 'Plus Jakarta Sans', sans-serif; }
            .admin-sidebar { background: #0b0f1a; }
            .admin-card { background: #131b2e; border-radius: 2.5rem; border: 1px solid #1e293b; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 10px 30px -5px rgba(0,0,0,0.3); }
            .admin-card:hover { transform: translateY(-6px); border-color: #3b82f6; box-shadow: 0 25px 50px -12px rgba(59, 130, 246, 0.2); }
            .active-link { background: linear-gradient(to right, rgba(59, 130, 246, 0.1), transparent); color: #3b82f6; border-right: 4px solid #3b82f6; }
            
            .bg-slate-50, .bg-gray-50, .bg-gray-100 { background-color: #0b0f1a !important; }
            .text-slate-800, .text-slate-900 { color: #f1f5f9 !important; }
            .bg-white { background: #131b2e !important; }
            .border-gray-100, .border-slate-200 { border-color: #1e293b !important; }
            .admin-header { background: #0b0f1a; border-bottom: 1px solid #1e293b; }
            
            /* Table Neutralization */
            th { border-bottom: 2px solid #1e293b !important; }
            td { border-bottom: 1px solid #1e293b !important; }
            .bg-gray-50\/50 { background-color: rgba(15, 23, 42, 0.5) !important; }

            /* Text Contrast */
            .text-gray-400 { color: #64748b !important; }
            .text-slate-400 { color: #94a3b8 !important; }
            
            ::-webkit-scrollbar { width: 4px; }
            ::-webkit-scrollbar-thumb { background: #3b82f6; border-radius: 10px; }
        </style>
    </head>
    <body class="bg-gray-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 antialiased overflow-hidden">
        <!-- Splash Screen -->
        <div id="splash-screen" class="fixed inset-0 z-[9999] flex items-center justify-center bg-[#0b0f1a] transition-all duration-1000">
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 bg-blue-600 rounded-[2rem] flex items-center justify-center animate-bounce shadow-2xl shadow-blue-500/40 mb-10">
                    <i data-lucide="shield-check" class="w-10 h-10 text-white fill-white"></i>
                </div>
                <div class="flex flex-col items-center gap-6">
                    <div class="h-1 w-40 bg-slate-900 rounded-full overflow-hidden">
                        <div id="splash-progress" class="h-full bg-blue-600 w-0 transition-all duration-500 ease-out"></div>
                    </div>
                    <span class="text-[9px] font-black uppercase tracking-[0.4em] text-blue-500 animate-pulse">Authenticating Admin...</span>
                </div>
            </div>
        </div>

        <script>
            // Splash Screen Logic
            (function() {
                const progress = document.getElementById('splash-progress');
                let width = 0;
                const interval = setInterval(() => {
                    width += Math.random() * 30;
                    if (width >= 100) {
                        width = 100;
                        clearInterval(interval);
                        setTimeout(() => {
                            const splash = document.getElementById('splash-screen');
                            splash.style.opacity = '0';
                            splash.style.visibility = 'hidden';
                            setTimeout(() => splash.remove(), 1000);
                        }, 200);
                    }
                    progress.style.width = width + '%';
                }, 100);
            })();
        </script>
        
        <div class="flex h-screen">
            <!-- Sidebar -->
            <aside class="w-72 admin-sidebar hidden lg:flex flex-col h-full border-r border-slate-800 shrink-0">
                <div class="p-8">
                    <a href="{{ route('home') }}" class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-500/40">
                            <i data-lucide="shield-check" class="text-white w-6 h-6"></i>
                        </div>
                        <span class="text-xl font-black tracking-tighter text-white uppercase italic">CODE<span class="text-blue-500">HN</span></span>
                    </a>
                </div>

                <nav class="flex-1 px-4 space-y-2 overflow-y-auto">
                    <div class="px-4 py-4 text-[10px] font-black uppercase tracking-[0.3em] text-slate-500">Menu Utama</div>
                    <a href="{{ route('admin.dashboard') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl transition-all {{ request()->routeIs('admin.dashboard') ? 'active-link' : 'text-slate-400 hover:bg-slate-800/50 hover:text-white' }}">
                        <i data-lucide="layout-grid" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Dashboard</span>
                    </a>
                    <a href="{{ route('admin.users') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl transition-all {{ request()->routeIs('admin.users*') ? 'active-link' : 'text-slate-400 hover:bg-slate-800/50 hover:text-white' }}">
                        <i data-lucide="users" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Pengguna</span>
                    </a>
                    <a href="{{ route('admin.produks') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl transition-all {{ request()->routeIs('admin.produks*') ? 'active-link' : 'text-slate-400 hover:bg-slate-800/50 hover:text-white' }}">
                        <i data-lucide="shopping-bag" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Iklan</span>
                    </a>
                    <a href="{{ route('admin.categories') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl transition-all {{ request()->routeIs('admin.categories*') ? 'active-link' : 'text-slate-400 hover:bg-slate-800/50 hover:text-white' }}">
                        <i data-lucide="tag" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Kategori</span>
                    </a>
                    <a href="{{ route('admin.reports') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl transition-all {{ request()->routeIs('admin.reports*') ? 'active-link' : 'text-slate-400 hover:bg-slate-800/50 hover:text-white' }}">
                        <i data-lucide="alert-octagon" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Laporan</span>
                    </a>

                    <div class="px-4 py-8 text-[10px] font-black uppercase tracking-[0.3em] text-slate-500">Akun Anda</div>
                    <a href="{{ route('profile.edit') }}" class="flex items-center gap-4 px-6 py-4 rounded-2xl text-slate-400 hover:bg-slate-800/50 hover:text-white transition-all">
                        <i data-lucide="user" class="w-5 h-5"></i>
                        <span class="text-sm font-bold">Profil</span>
                    </a>
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button class="w-full flex items-center gap-4 px-6 py-4 rounded-2xl text-red-400 hover:bg-red-400/10 transition-all font-bold">
                            <i data-lucide="log-out" class="w-5 h-5"></i>
                            <span class="text-sm">Keluar</span>
                        </button>
                    </form>
                </nav>

                <div class="p-8 border-t border-slate-800">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center text-white font-black">
                            {{ substr(auth()->user()->name, 0, 1) }}
                        </div>
                        <div class="min-w-0">
                            <div class="text-sm font-bold text-white truncate">{{ auth()->user()->name }}</div>
                            <div class="text-[10px] font-black text-slate-500 uppercase tracking-widest">Master Admin</div>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="flex-1 flex flex-col min-w-0 overflow-hidden">
                <!-- Top Header -->
                <header class="h-20 bg-[#0b0f1a] border-b border-slate-800 flex items-center justify-between px-8 shrink-0">
                    <div class="flex items-center gap-4">
                        <button class="lg:hidden p-2 text-slate-400">
                            <i data-lucide="menu" class="w-6 h-6"></i>
                        </button>
                        <h1 class="text-xl font-black uppercase tracking-tighter italic text-white">
                            @yield('title', 'Admin Control Panel')
                        </h1>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="text-[10px] font-black uppercase tracking-widest text-slate-500 hidden sm:block italic">{{ now()->format('l, d F Y') }}</div>
                        <div class="w-px h-6 bg-slate-800"></div>
                        <button class="p-2.5 rounded-xl bg-slate-800 text-slate-400 hover:text-blue-500 hover:scale-110 transition-all">
                            <i data-lucide="bell" class="w-5 h-5"></i>
                        </button>
                    </div>
                </header>

                <!-- Page Content -->
                <div class="flex-1 overflow-y-auto p-8 no-scrollbar bg-[#0b0f1a]">
                    @yield('content')
                </div>
            </main>
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
