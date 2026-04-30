<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login | CODean Marketplace</title>
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
            .cyan-login-box {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 3rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 242, 234, 0.3);
                border: 1px solid rgba(0, 242, 234, 0.2);
                position: relative;
                overflow: hidden;
            }
            .cyan-login-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 6px;
                background: linear-gradient(90deg, #00f2ea, #00c2ba);
            }
            .custom-input {
                border-radius: 2rem;
                border: none;
                background-color: #f8fafc;
                padding: 1rem 1.5rem;
                box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
                width: 100%;
                transition: all 0.3s ease;
            }
            .custom-input:focus {
                background-color: white;
                box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.3);
                outline: none;
            }
            .btn-login {
                background: linear-gradient(135deg, #00f2ea 0%, #00c2ba 100%);
                color: #0f172a;
                font-weight: 800;
                padding: 1rem 3rem;
                border-radius: 9999px;
                box-shadow: 0 10px 15px -3px rgba(0, 242, 234, 0.3);
                transition: all 0.3s ease;
                border: none;
            }
            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 20px 25px -5px rgba(0, 242, 234, 0.4);
                filter: brightness(1.1);
            }
        </style>
    </head>
    <body class="h-full overflow-hidden bg-slate-950">
        
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
                        <i data-lucide="shopping-bag" class="text-[#00f2ea] w-6 h-6"></i>
                    </div>
                    <span class="text-2xl font-black text-white tracking-tighter uppercase italic">CODean Marketplace</span>
                </div>

                <nav class="flex gap-8 lg:gap-16">
                    <a href="/" class="text-white hover:text-white font-bold tracking-tight transition-colors">Home</a>
                    <a href="#" class="text-white hover:text-white font-bold tracking-tight transition-colors">About Us</a>
                    <a href="#" class="text-white hover:text-white font-bold tracking-tight transition-colors">Help</a>
                </nav>
            </header>

            <!-- Login Section -->
            <div class="flex-1 flex items-center justify-center">
                
                <!-- Right Login Box Centered -->
                <div class="w-full max-w-md">
                    <div class="cyan-login-box p-10 lg:p-14">
                        <h1 class="text-center text-3xl font-black text-slate-900 mb-10 tracking-tight uppercase">LOGIN TO YOUR <br> ACCOUNT</h1>
                        
                        <form method="POST" action="{{ route('login') }}" class="space-y-6">
                            @csrf
                            
                            <div class="space-y-2">
                                <label for="email" class="text-slate-900 font-bold ml-2">Email Address :</label>
                                <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus autocomplete="username"
                                    class="custom-input">
                                <x-input-error :messages="$errors->get('email')" class="mt-1" />
                            </div>

                            <div class="space-y-2">
                                <div class="flex justify-between items-center">
                                    <label for="password" class="text-slate-900 font-bold ml-2">Password :</label>
                                    @if (Route::has('password.request'))
                                        <a href="{{ route('password.request') }}" class="text-xs font-bold text-slate-700 hover:text-white transition-colors">Forgot?</a>
                                    @endif
                                </div>
                                <input id="password" type="password" name="password" required autocomplete="current-password"
                                    class="custom-input">
                                <x-input-error :messages="$errors->get('password')" class="mt-1" />
                            </div>

                            <div class="pt-4 flex flex-col items-end gap-6">
                                <button type="submit" class="btn-login uppercase tracking-widest text-xl w-full">
                                    LOGIN
                                </button>

                                <div class="w-full flex items-center gap-4 py-2">
                                    <div class="h-px bg-slate-200 flex-1"></div>
                                    <span class="text-slate-500 text-xs font-bold uppercase tracking-widest">OR</span>
                                    <div class="h-px bg-slate-200 flex-1"></div>
                                </div>

                                <a href="{{ route('auth.google') }}" class="w-full flex items-center justify-center gap-3 bg-white border border-slate-200 text-slate-700 font-bold py-3 rounded-full hover:bg-slate-50 transition-all shadow-sm">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24">
                                        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                                        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                                        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l3.66-2.85z" fill="#FBBC05"/>
                                        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.85c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                                    </svg>
                                    <span>Sign in with Google</span>
                                </a>
                                
                                <div class="text-center w-full lg:text-right mt-4">
                                    <p class="text-slate-900 font-bold text-sm">Don't have an account?</p>
                                    <a href="{{ route('register') }}" class="text-blue-600 font-black hover:underline transition-all">Sign Up now</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Footer Info -->
            <footer class="mt-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div class="flex items-center gap-4 group cursor-pointer">
                    <div class="w-12 h-12 rounded-full border-2 border-white flex items-center justify-center text-white group-hover:bg-white group-hover:text-slate-900 transition-all">
                        <i data-lucide="phone" class="w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-[10px] font-black uppercase tracking-widest text-white">Phone</p>
                        <p class="text-xs font-bold text-white">+62-812-3456-7890</p>
                    </div>
                </div>
                
                <div class="flex items-center gap-4 group cursor-pointer">
                    <div class="w-12 h-12 rounded-full border-2 border-white flex items-center justify-center text-white group-hover:bg-white group-hover:text-slate-900 transition-all">
                        <i data-lucide="mail" class="w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-[10px] font-black uppercase tracking-widest text-white">E-Mail</p>
                        <p class="text-xs font-bold text-white">support@codean.com</p>
                    </div>
                </div>

                <div class="flex items-center gap-4 group cursor-pointer">
                    <div class="w-12 h-12 rounded-full border-2 border-white flex items-center justify-center text-white group-hover:bg-white group-hover:text-slate-900 transition-all">
                        <i data-lucide="globe" class="w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-[10px] font-black uppercase tracking-widest text-white">Website</p>
                        <p class="text-xs font-bold text-white">www.codean-marketplace.com</p>
                    </div>
                </div>

                <div class="flex items-center gap-4 group cursor-pointer">
                    <div class="w-12 h-12 rounded-full border-2 border-white flex items-center justify-center text-white group-hover:bg-white group-hover:text-slate-900 transition-all">
                        <i data-lucide="map-pin" class="w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-[10px] font-black uppercase tracking-widest text-white">Address</p>
                        <p class="text-xs font-bold text-white">Jakarta City, Indonesia</p>
                    </div>
                </div>
            </footer>
        </div>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
