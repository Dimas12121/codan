<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Daftar Akun | CODean Marketplace</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        <style>
            body { font-family: 'Plus Jakarta Sans', sans-serif; }
            .bg-overlay {
                background: radial-gradient(circle at center, rgba(15, 23, 42, 0.4) 0%, rgba(15, 23, 42, 0.9) 100%);
            }
            .cyan-register-box {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 3rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 242, 234, 0.3);
                border: 1px solid rgba(0, 242, 234, 0.2);
                position: relative;
                overflow: hidden;
            }
            .cyan-register-box::before {
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
                padding: 0.8rem 1.2rem;
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
            .btn-register {
                background: linear-gradient(135deg, #00f2ea 0%, #00c2ba 100%);
                color: #0f172a;
                font-weight: 800;
                padding: 1rem 2rem;
                border-radius: 9999px;
                box-shadow: 0 10px 15px -3px rgba(0, 242, 234, 0.3);
                transition: all 0.3s ease;
                border: none;
            }
            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 20px 25px -5px rgba(0, 242, 234, 0.4);
                filter: brightness(1.1);
            }
        </style>
    </head>
    <body class="h-full bg-slate-950 overflow-x-hidden">
        
        <!-- Background Image with Overlay -->
        <div class="fixed inset-0 z-0">
            <img src="{{ asset('images/tech_office.png') }}" class="w-full h-full object-cover">
            <div class="absolute inset-0 bg-overlay"></div>
        </div>

        <!-- Main Content -->
        <div class="relative z-10 min-h-full flex flex-col p-6 lg:p-12" style="zoom: 0.8;">
            
            <!-- Header -->
            <header class="flex justify-between items-center mb-8 shrink-0">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center">
                        <i data-lucide="shopping-bag" class="text-[#00f2ea] w-6 h-6"></i>
                    </div>
                    <span class="hidden sm:block text-xl font-black text-white tracking-tighter uppercase italic">CODean Marketplace</span>
                </div>

                <nav class="flex gap-6 lg:gap-12">
                    <a href="/" class="text-white hover:text-white font-bold tracking-tight transition-colors">Home</a>
                    <a href="#" class="text-white hover:text-white font-bold tracking-tight transition-colors">About Us</a>
                    <a href="#" class="text-white hover:text-white font-bold tracking-tight transition-colors">Help</a>
                </nav>
            </header>

            <!-- Registration Section -->
            <div class="flex-1 flex items-center justify-center">
                
                <!-- Registration Box Centered -->
                <div class="w-full max-w-2xl animate-in zoom-in duration-500">
                    <div class="cyan-register-box p-8 lg:p-12 overflow-hidden">
                        <h1 class="text-center text-2xl font-black text-slate-900 mb-8 tracking-tight uppercase leading-none">SIGN UP FOR <br> A NEW ACCOUNT</h1>
                        
                        <div x-data="registrationForm()" class="space-y-4">
                            <!-- Step 1: Form Input -->
                            <form x-show="step === 'form'" @submit.prevent="sendOtp()" class="space-y-4">
                                @csrf
                                
                                <div class="grid grid-cols-1 gap-4">
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">Full Name :</label>
                                        <input type="text" name="name" x-model="formData.name" required class="custom-input" placeholder="John Doe">
                                        <template x-if="errors.name"><p class="text-xs text-red-600 font-bold mt-1 ml-2" x-text="errors.name[0]"></p></template>
                                    </div>
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">Email Address :</label>
                                        <input type="email" name="email" x-model="formData.email" required class="custom-input" placeholder="john@example.com">
                                        <template x-if="errors.email"><p class="text-xs text-red-600 font-bold mt-1 ml-2" x-text="errors.email[0]"></p></template>
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 gap-4">
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">WhatsApp Number :</label>
                                        <input type="text" name="phone" x-model="formData.phone" required class="custom-input" placeholder="08123456789">
                                        <template x-if="errors.phone"><p class="text-xs text-red-600 font-bold mt-1 ml-2" x-text="errors.phone[0]"></p></template>
                                    </div>
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">User Role :</label>
                                        <select name="role" x-model="formData.role" class="custom-input appearance-none bg-no-repeat cursor-pointer">
                                            <option value="buyer">Pembeli (Buyer)</option>
                                            <option value="seller">Penjual (Seller)</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="space-y-1.5" x-show="formData.role === 'seller'" x-transition>
                                    <label class="text-slate-900 font-black text-xs ml-2 uppercase">Location/Address :</label>
                                    <input type="text" name="location" x-model="formData.location" :required="formData.role === 'seller'" class="custom-input" placeholder="Nama Kota atau Alamat">
                                    <template x-if="errors.location"><p class="text-xs text-red-600 font-bold mt-1 ml-2" x-text="errors.location[0]"></p></template>
                                </div>

                                <div class="grid grid-cols-1 gap-1">
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">Password :</label>
                                        <input type="password" name="password" x-model="formData.password" required class="custom-input" placeholder="••••••••">
                                    </div>
                                    <div class="space-y-1.5">
                                        <label class="text-slate-900 font-black text-xs ml-2 uppercase">Confirm :</label>
                                        <input type="password" name="password_confirmation" x-model="formData.password_confirmation" required class="custom-input" placeholder="••••••••">
                                    </div>
                                    <div class="col-span-full">
                                        <template x-if="errors.password"><p class="text-xs text-red-600 font-bold mt-1 ml-2" x-text="errors.password[0]"></p></template>
                                    </div>
                                </div>

                                <div class="pt-6 flex flex-col items-center lg:items-end gap-6">
                                    <button type="submit" :disabled="loading" class="btn-register uppercase tracking-widest text-lg w-full flex items-center justify-center gap-3">
                                        <span x-show="!loading">REGISTER NOW</span>
                                        <span x-show="loading" class="flex items-center gap-2">
                                            <svg class="animate-spin h-5 w-5 text-slate-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                            </svg>
                                            PROCESSING...
                                        </span>
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
                                        <span>Sign up with Google</span>
                                    </a>
                                    
                                    <div class="text-center w-full lg:text-right">
                                        <p class="text-slate-900 font-bold text-sm">Already have an account?</p>
                                        <a href="{{ route('login') }}" class="text-blue-600 font-black hover:underline transition-all">Login here</a>
                                    </div>
                                </div>
                            </form>

                            <!-- Step 2: OTP Verification -->
                            <div x-show="step === 'otp'" x-transition class="py-4 text-center">
                                <div class="w-20 h-20 bg-white/20 rounded-3xl flex items-center justify-center border-2 border-white/40 mx-auto mb-8 animate-bounce">
                                    <i data-lucide="shield-check" class="text-white w-10 h-10"></i>
                                </div>
                                <h3 class="text-2xl font-black text-slate-900 mb-2 uppercase">Verify Your Identity</h3>
                                <p class="text-slate-800 font-bold text-sm mb-10 px-4">Kami telah mengirimkan 4 digit kode verifikasi ke WhatsApp: <br> <span class="text-white bg-slate-900/20 px-2 py-0.5 rounded" x-text="formData.phone"></span></p>

                                <div class="flex justify-center gap-4 mb-10">
                                    <template x-for="(i, index) in 4" :key="index">
                                        <input 
                                            type="text" 
                                            maxlength="1" 
                                            class="w-16 h-20 text-center text-3xl font-black text-slate-900 bg-white border-none rounded-2xl shadow-xl focus:ring-4 focus:ring-white/50 transition-all outline-none"
                                            x-model="otpParts[index]"
                                            @input="handleOtpInput($event, index)"
                                            @keydown.backspace="handleOtpBackspace($event, index)"
                                            :id="'otp-' + index"
                                        >
                                    </template>
                                </div>

                                <div class="flex flex-col gap-6 items-center">
                                    <button @click="verifyOtp()" :disabled="loading || otpParts.join('').length < 4" 
                                        class="btn-register uppercase tracking-widest text-lg w-full max-w-[300px] flex items-center justify-center gap-3">
                                        <span x-show="!loading">VERIFY & FINISH</span>
                                        <span x-show="loading" class="flex items-center gap-2">
                                            <svg class="animate-spin h-5 w-5 text-slate-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                            </svg>
                                        </span>
                                    </button>

                                    <div class="flex flex-col gap-2">
                                        <template x-if="timer > 0">
                                            <p class="text-slate-900 font-bold text-sm uppercase">Resend code in <span class="text-white" x-text="timer"></span>s</p>
                                        </template>
                                        <template x-if="timer === 0">
                                            <button @click="sendOtp()" class="text-white font-black hover:underline transition-all uppercase text-sm">Resend OTP Code</button>
                                        </template>
                                        <button @click="step = 'form'" class="text-slate-800/60 font-bold hover:text-slate-900 transition-all text-xs uppercase underline">Back to Edit Info</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            function registrationForm() {
                                return {
                                    step: 'form',
                                    loading: false,
                                    timer: 0,
                                    timerInterval: null,
                                    formData: {
                                        name: '',
                                        email: '',
                                        phone: '',
                                        role: 'buyer',
                                        location: '',
                                        password: '',
                                        password_confirmation: ''
                                    },
                                    errors: {},
                                    otpParts: ['', '', '', ''],
                                    
                                    sendOtp() {
                                        this.loading = true;
                                        this.errors = {};
                                        
                                        fetch('{{ route('otp.send') }}', {
                                            method: 'POST',
                                            headers: {
                                                'Accept': 'application/json',
                                                'Content-Type': 'application/json',
                                                'X-CSRF-TOKEN': '{{ csrf_token() }}'
                                            },
                                            body: JSON.stringify(this.formData)
                                        })
                                        .then(async response => {
                                            const data = await response.json();
                                            if (response.ok) return data;
                                            throw data;
                                        })
                                        .then(data => {
                                            this.loading = false;
                                            if (data.success) {
                                                this.step = 'otp';
                                                this.startTimer();
                                                
                                                // Debug OTP (hanya muncul jika APP_DEBUG=true)
                                                if (data.debug_otp) {
                                                    console.log('DEBUG OTP:', data.debug_otp);
                                                    console.log('Nomor WhatsApp:', this.formData.phone);
                                                }
                                                
                                                setTimeout(() => document.getElementById('otp-0').focus(), 100);
                                            }
                                        })
                                        .catch(error => {
                                            this.loading = false;
                                            this.errors = error.errors || { email: [error.message || 'Server error occurred'] };
                                            console.error('Error:', error);
                                        });
                                    },
                                    
                                    verifyOtp() {
                                        this.loading = true;
                                        const otp = this.otpParts.join('');
                                        
                                        fetch('{{ route('otp.verify') }}', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/json',
                                                'X-CSRF-TOKEN': '{{ csrf_token() }}'
                                            },
                                            body: JSON.stringify({ otp: otp })
                                        })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                window.location.href = data.redirect;
                                            } else {
                                                this.loading = false;
                                                alert(data.message);
                                                this.otpParts = ['', '', '', ''];
                                                document.getElementById('otp-0').focus();
                                            }
                                        })
                                        .catch(error => {
                                            this.loading = false;
                                            console.error('Error:', error);
                                        });
                                    },
                                    
                                    handleOtpInput(e, index) {
                                        const value = e.target.value;
                                        if (value.length === 1 && index < 3) {
                                            document.getElementById('otp-' + (index + 1)).focus();
                                        }
                                    },
                                    
                                    handleOtpBackspace(e, index) {
                                        if (e.key === 'Backspace' && !this.otpParts[index] && index > 0) {
                                            document.getElementById('otp-' + (index - 1)).focus();
                                        }
                                    },
                                    
                                    startTimer() {
                                        this.timer = 60;
                                        if (this.timerInterval) clearInterval(this.timerInterval);
                                        this.timerInterval = setInterval(() => {
                                            if (this.timer > 0) this.timer--;
                                            else clearInterval(this.timerInterval);
                                        }, 1000);
                                    }
                                }
                            }
                        </script>
                    </div>
                </div>
            </div>

            <!-- Footer Info -->
            <footer class="mt-12 lg:mt-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="flex items-center gap-4 text-white hover:bg-white/5 p-3 rounded-2xl transition-all cursor-pointer">
                    <div class="w-10 h-10 rounded-full border border-white/50 flex items-center justify-center"><i data-lucide="phone" class="w-4 h-4"></i></div>
                    <div><p class="text-[8px] font-black uppercase tracking-widest text-[#00f2ea]">Phone</p><p class="text-[10px] font-bold">+62-812-3456-7890</p></div>
                </div>
                <div class="flex items-center gap-4 text-white hover:bg-white/5 p-3 rounded-2xl transition-all cursor-pointer">
                    <div class="w-10 h-10 rounded-full border border-white/50 flex items-center justify-center"><i data-lucide="mail" class="w-4 h-4"></i></div>
                    <div><p class="text-[8px] font-black uppercase tracking-widest text-[#00f2ea]">E-Mail</p><p class="text-[10px] font-bold">support@codean.com</p></div>
                </div>
                <div class="flex items-center gap-4 text-white hover:bg-white/5 p-3 rounded-2xl transition-all cursor-pointer">
                    <div class="w-10 h-10 rounded-full border border-white/50 flex items-center justify-center"><i data-lucide="globe" class="w-4 h-4"></i></div>
                    <div><p class="text-[8px] font-black uppercase tracking-widest text-[#00f2ea]">Web</p><p class="text-[10px] font-bold">www.codean.com</p></div>
                </div>
                <div class="flex items-center gap-4 text-white hover:bg-white/5 p-3 rounded-2xl transition-all cursor-pointer">
                    <div class="w-10 h-10 rounded-full border border-white/50 flex items-center justify-center"><i data-lucide="map-pin" class="w-4 h-4"></i></div>
                    <div><p class="text-[8px] font-black uppercase tracking-widest text-[#00f2ea]">Address</p><p class="text-[10px] font-bold">Jakarta, Indonesia</p></div>
                </div>
            </footer>
        </div>

        <script>lucide.createIcons();</script>
    </body>
</html>
