<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center gap-3">
            <div class="p-2 bg-blue-500/10 rounded-xl">
                <i data-lucide="user" class="w-5 h-5 text-blue-600 dark:text-blue-400"></i>
            </div>
            <h2 class="font-bold text-2xl text-slate-800 dark:text-white leading-tight">
                {{ __('Pengaturan Akun') }}
            </h2>
        </div>
    </x-slot>

    <div class="py-6 sm:py-12 bg-slate-50 dark:bg-slate-950 min-h-screen">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-6 sm:space-y-8">
            
            <!-- Profile Header Card -->
            <div class="relative bg-white dark:bg-slate-900 rounded-3xl sm:rounded-[2rem] shadow-xl shadow-slate-200/50 dark:shadow-none border border-slate-100 dark:border-slate-800 overflow-hidden">
                <!-- Cover Gradient -->
                <div class="h-28 sm:h-48 bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600"></div>
                
                <div class="px-5 sm:px-10 pb-6 sm:pb-8 -mt-10 sm:-mt-16">
                    <div class="flex flex-col sm:flex-row items-center sm:items-center gap-4 sm:gap-6">
                        <!-- Avatar Display -->
                        <div class="relative">
                            <div class="w-20 h-20 sm:w-32 sm:h-32 rounded-2xl sm:rounded-3xl border-4 border-white dark:border-slate-900 bg-slate-100 dark:bg-slate-800 overflow-hidden shadow-2xl">
                                @if($user->avatar)
                                    <img src="{{ asset('storage/' . $user->avatar) }}" alt="{{ $user->name }}" class="w-full h-full object-cover">
                                @else
                                    <div class="w-full h-full flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-slate-800 dark:to-slate-700">
                                        <i data-lucide="user" class="w-10 h-10 sm:w-12 sm:h-12 text-blue-500"></i>
                                    </div>
                                @endif
                            </div>
                            <div class="absolute -bottom-1 -right-1 sm:-bottom-2 sm:-right-2 p-1.5 sm:p-2 bg-white dark:bg-slate-800 rounded-lg sm:rounded-xl shadow-lg border border-slate-100 dark:border-slate-700">
                                <i data-lucide="camera" class="w-3.5 h-3.5 sm:w-4 h-4 text-slate-600 dark:text-slate-400"></i>
                            </div>
                        </div>

                        <div class="flex-1 text-center sm:text-left mt-2 sm:mt-12">
                            <h3 class="text-xl sm:text-2xl font-bold text-slate-900 dark:text-white">{{ $user->name }}</h3>
                            <p class="text-sm sm:text-base text-slate-500 dark:text-slate-400 flex items-center justify-center sm:justify-start gap-2 mt-1">
                                <i data-lucide="mail" class="w-4 h-4"></i>
                                {{ $user->email }}
                            </p>
                            <div class="flex flex-wrap items-center justify-center sm:justify-start gap-2 sm:gap-3 mt-3 sm:mt-4">
                                <span class="px-2.5 py-0.5 sm:px-3 sm:py-1 bg-blue-500/10 text-blue-600 dark:text-blue-400 text-[10px] sm:text-xs font-bold rounded-full uppercase tracking-wider">
                                    {{ $user->role }}
                                </span>
                                <span class="px-2.5 py-0.5 sm:px-3 sm:py-1 bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 text-[10px] sm:text-xs font-bold rounded-full flex items-center gap-1">
                                    <span class="w-1 h-1 sm:w-1.5 sm:h-1.5 bg-emerald-500 rounded-full"></span>
                                    Aktif
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 sm:gap-8">
                <!-- Main Forms (Appears first on mobile) -->
                <div class="lg:col-span-2 order-1 lg:order-2 space-y-6 sm:space-y-8">
                    <!-- Update Profile Form -->
                    <div class="bg-white dark:bg-slate-900 p-6 sm:p-10 rounded-3xl sm:rounded-[2rem] shadow-sm border border-slate-100 dark:border-slate-800">
                        @include('profile.partials.update-profile-information-form')
                    </div>

                    <!-- Update Password Form -->
                    <div class="bg-white dark:bg-slate-900 p-6 sm:p-10 rounded-3xl sm:rounded-[2rem] shadow-sm border border-slate-100 dark:border-slate-800">
                        @include('profile.partials.update-password-form')
                    </div>

                    <!-- Delete User Form -->
                    <div class="bg-red-50 dark:bg-red-900/10 p-6 sm:p-10 rounded-3xl sm:rounded-[2rem] border border-red-100 dark:border-red-900/20">
                        @include('profile.partials.delete-user-form')
                    </div>
                </div>

                <!-- Sidebar Info (Appears second on mobile) -->
                <div class="space-y-6 order-2 lg:order-1">
                    <div class="bg-white dark:bg-slate-900 p-6 rounded-3xl sm:rounded-[2rem] shadow-sm border border-slate-100 dark:border-slate-800">
                        <h4 class="font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
                            <i data-lucide="info" class="w-5 h-5 text-blue-500"></i>
                            Ringkasan Profil
                        </h4>
                        <div class="space-y-4">
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-8 h-8 rounded-lg bg-slate-50 dark:bg-slate-800 flex items-center justify-center">
                                    <i data-lucide="calendar" class="w-4 h-4 text-slate-400"></i>
                                </div>
                                <div>
                                    <p class="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Bergabung</p>
                                    <p class="text-slate-700 dark:text-slate-200 font-medium">{{ $user->created_at->format('d M Y') }}</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-8 h-8 rounded-lg bg-slate-50 dark:bg-slate-800 flex items-center justify-center">
                                    <i data-lucide="phone" class="w-4 h-4 text-slate-400"></i>
                                </div>
                                <div>
                                    <p class="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Telepon</p>
                                    <p class="text-slate-700 dark:text-slate-200 font-medium">{{ $user->phone ?? '-' }}</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-8 h-8 rounded-lg bg-slate-50 dark:bg-slate-800 flex items-center justify-center">
                                    <i data-lucide="map-pin" class="w-4 h-4 text-slate-400"></i>
                                </div>
                                <div>
                                    <p class="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Lokasi</p>
                                    <p class="text-slate-700 dark:text-slate-200 font-medium">{{ $user->location ?? '-' }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-blue-600 to-indigo-700 p-6 rounded-3xl sm:rounded-[2rem] shadow-lg shadow-blue-500/20 text-white">
                        <i data-lucide="shield-check" class="w-8 h-8 mb-4"></i>
                        <h4 class="font-bold text-lg mb-2">Keamanan Akun</h4>
                        <p class="text-blue-100 text-sm mb-4 leading-relaxed">
                            Pastikan kata sandi Anda kuat dan perbarui secara berkala untuk menjaga keamanan akun Anda.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
