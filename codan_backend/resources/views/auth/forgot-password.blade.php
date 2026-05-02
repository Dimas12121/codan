<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Lupa Sandi | codan Marketplace</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        <style>
            body { font-family: 'Plus Jakarta Sans', sans-serif; }
            .bg-overlay {
                background: radial-gradient(circle at center, rgba(15, 23, 42, 0.4) 0%, rgba(15, 23, 42, 0.9) 100%);
            }
            .cyan-password-box {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 3rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 242, 234, 0.3);
                border: 1px solid rgba(0, 242, 234, 0.2);
                position: relative;
                overflow: hidden;
            }
            .cyan-password-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 6px;
                background: linear-gradient(90deg, #00f2ea, #00c2ba);
            }
            .custom-input {
                border-radius: 1.5rem;
                border: none;
                background-color: #f8fafc;
                padding: 1rem 1.5rem;
                box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
                width: 100%;
                transition: all 0.3s ease;
                font-size: 0.875rem;
                font-weight: 600;
            }
            .custom-input:focus {
                background-color: white;
                box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.3);
                outline: none;
            }
            .btn-reset {
                background: linear-gradient(135deg, #00f2ea 0%, #00c2ba 100%);
                color: #0f172a;
                font-weight: 800;
                padding: 1rem 2rem;
                border-radius: 9999px;
                box-shadow: 0 10px 15px -3px rgba(0, 242, 234, 0.3);
                transition: all 0.3s ease;
                border: none;
            }
            .btn-reset:hover {
                transform: translateY(-2px);
                box-shadow: 0 20px 25px -5px rgba(0, 242, 234, 0.4);
                filter: brightness(1.1);
            }
        </style>
    </head>
    <body class="h-full bg-slate-950 overflow-hidden">
        
        <!-- Background Image with Overlay -->
        <div class="fixed inset-0 z-0">
            <img src="{{ asset('images/tech_office.png') }}" class="w-full h-full object-cover">
            <div class="absolute inset-0 bg-overlay"></div>
        </div>

        <!-- Main Content -->
        <div class="relative z-10 h-full flex flex-col p-8 lg:p-16" style="zoom: 0.8;">
            
            <!-- Header -->
            <header class="flex justify-between items-center mb-auto shrink-0">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center">
                        <i data-lucide="key" class="text-[#00f2ea] w-6 h-6"></i>
                    </div>
                    <span class="hidden sm:block text-2xl font-black text-white tracking-tighter uppercase italic">codan Marketplace</span>
                </div>

                <nav class="flex gap-8 lg:gap-16">
                    <a href="/" class="text-white/80 hover:text-white font-bold tracking-tight transition-colors">Home</a>
                    <a href="#" class="text-white/80 hover:text-white font-bold tracking-tight transition-colors">About Us</a>
                    <a href="#" class="text-white/80 hover:text-white font-bold tracking-tight transition-colors">Help</a>
                </nav>
            </header>

            <!-- Reset Section -->
            <div class="flex-1 flex items-center justify-center">
                
                <!-- Reset Box Centered -->
                <div class="w-full max-w-md animate-in zoom-in duration-500">
                    <div class="cyan-password-box p-10 lg:p-14">
                        <h1 class="text-center text-3xl font-black text-slate-900 mb-10 tracking-tight uppercase leading-none">RESET YOUR <br> PASSWORD</h1>
                        
                        <x-auth-session-status class="mb-8 p-4 bg-white/30 rounded-2xl text-slate-900 font-bold border border-white/40" :status="session('status')" />

                        <form method="POST" action="{{ route('password.email') }}" class="space-y-8">
                            @csrf
                            
                            <div class="space-y-4">
                                <label for="email" class="text-slate-900 font-black ml-2 uppercase tracking-widest text-xs">Registered Email :</label>
                                <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus
                                    class="custom-input">
                                <x-input-error :messages="$errors->get('email')" class="mt-1" />
                            </div>

                            <div class="pt-10 flex flex-col items-center lg:items-end gap-8">
                                <button type="submit" class="btn-reset uppercase tracking-widest text-lg w-full lg:w-auto shadow-2xl">
                                    SEND RESET LINK
                                </button>
                                
                                <div class="text-center w-full lg:text-right">
                                    <a href="{{ route('login') }}" class="flex items-center justify-center lg:justify-end gap-2 text-slate-900 font-black hover:text-white transition-all">
                                        <i data-lucide="arrow-left" class="w-4 h-4"></i>
                                        Back to Login
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Footer Info -->
            <footer class="mt-auto hidden lg:grid grid-cols-4 gap-8">
               <!-- Kept for layout balance -->
            </footer>
        </div>

        <script>lucide.createIcons();</script>
    </body>
</html>
