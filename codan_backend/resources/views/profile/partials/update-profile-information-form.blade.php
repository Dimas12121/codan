<section>
    <header class="mb-8">
        <h2 class="text-xl font-bold text-slate-900 dark:text-white flex items-center gap-2">
            <i data-lucide="user-cog" class="w-5 h-5 text-blue-500"></i>
            {{ __('Informasi Profil') }}
        </h2>
        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
            {{ __("Perbarui informasi profil dan alamat email akun Anda.") }}
        </p>
    </header>

    <form id="send-verification" method="post" action="{{ route('verification.send') }}">
        @csrf
    </form>

    <form method="post" action="{{ route('profile.update') }}" enctype="multipart/form-data" class="space-y-6 sm:space-y-8">
        @csrf
        @method('patch')

        <!-- Avatar Upload -->
        <div class="space-y-4">
            <x-input-label for="avatar" :value="__('Foto Profil')" class="text-slate-700 dark:text-slate-300 font-bold" />
            <div class="flex flex-col sm:flex-row items-center sm:items-center gap-4 sm:gap-6">
                <div class="relative group">
                    <div id="avatar-preview" class="w-20 h-20 sm:w-24 sm:h-24 rounded-2xl bg-slate-100 dark:bg-slate-800 border-2 border-dashed border-slate-200 dark:border-slate-700 overflow-hidden flex items-center justify-center transition-all group-hover:border-blue-500">
                        @if($user->avatar)
                            <img src="{{ asset('storage/' . $user->avatar) }}" class="w-full h-full object-cover">
                        @else
                            <i data-lucide="image" class="w-8 h-8 text-slate-300"></i>
                        @endif
                    </div>
                    <label for="avatar" class="absolute -bottom-2 -right-2 w-8 h-8 bg-blue-600 text-white rounded-lg shadow-lg flex items-center justify-center cursor-pointer hover:bg-blue-700 transition-colors">
                        <i data-lucide="plus" class="w-4 h-4"></i>
                    </label>
                </div>
                <div class="flex-1 text-center sm:text-left">
                    <input type="file" id="avatar" name="avatar" class="hidden" accept="image/*" onchange="previewAvatar(this)">
                    <p class="text-[10px] sm:text-xs text-slate-500 leading-relaxed">
                        Format: JPG, PNG, atau WEBP. Maks 2MB.
                    </p>
                </div>
            </div>
            <x-input-error class="mt-2" :messages="$errors->get('avatar')" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
            <!-- Name -->
            <div class="space-y-2">
                <x-input-label for="name" :value="__('Nama Lengkap')" class="text-slate-700 dark:text-slate-300 font-bold" />
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                        <i data-lucide="user" class="w-4 h-4"></i>
                    </div>
                    <x-text-input id="name" name="name" type="text" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" :value="old('name', $user->name)" required autofocus autocomplete="name" />
                </div>
                <x-input-error class="mt-2" :messages="$errors->get('name')" />
            </div>

            <!-- Email -->
            <div class="space-y-2">
                <x-input-label for="email" :value="__('Email')" class="text-slate-700 dark:text-slate-300 font-bold" />
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                        <i data-lucide="mail" class="w-4 h-4"></i>
                    </div>
                    <x-text-input id="email" name="email" type="email" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" :value="old('email', $user->email)" required autocomplete="username" />
                </div>
                <x-input-error class="mt-2" :messages="$errors->get('email')" />

                @if ($user instanceof \Illuminate\Contracts\Auth\MustVerifyEmail && ! $user->hasVerifiedEmail())
                    <div class="mt-2 text-center sm:text-left">
                        <p class="text-[10px] sm:text-xs text-slate-600 dark:text-slate-400 italic">
                            {{ __('Email belum diverifikasi.') }}
                            <button form="send-verification" class="text-blue-600 hover:underline font-bold ml-1">
                                {{ __('Kirim ulang') }}
                            </button>
                        </p>
                    </div>
                @endif
            </div>

            <!-- Phone -->
            <div class="space-y-2">
                <x-input-label for="phone" :value="__('Nomor Telepon')" class="text-slate-700 dark:text-slate-300 font-bold" />
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                        <i data-lucide="phone" class="w-4 h-4"></i>
                    </div>
                    <x-text-input id="phone" name="phone" type="text" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" :value="old('phone', $user->phone)" placeholder="08123456789" required />
                </div>
                <x-input-error class="mt-2" :messages="$errors->get('phone')" />
            </div>

            <!-- Location -->
            <div class="space-y-2">
                <x-input-label for="location" :value="__('Lokasi')" class="text-slate-700 dark:text-slate-300 font-bold" />
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                        <i data-lucide="map-pin" class="w-4 h-4"></i>
                    </div>
                    <x-text-input id="location" name="location" type="text" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" :value="old('location', $user->location)" placeholder="Jakarta Selatan" />
                </div>
                <x-input-error class="mt-2" :messages="$errors->get('location')" />
            </div>
        </div>

        <!-- Bio -->
        <div class="space-y-2">
            <x-input-label for="bio" :value="__('Bio / Deskripsi')" class="text-slate-700 dark:text-slate-300 font-bold" />
            <textarea id="bio" name="bio" rows="3" class="w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl transition-all text-sm sm:text-base" placeholder="Ceritakan sedikit tentang Anda...">{{ old('bio', $user->bio) }}</textarea>
            <x-input-error class="mt-2" :messages="$errors->get('bio')" />
        </div>

        <div class="flex flex-col sm:flex-row items-center gap-4 pt-4">
            <button type="submit" class="w-full sm:w-auto px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-2xl shadow-lg shadow-blue-500/20 transition-all active:scale-95 flex items-center justify-center gap-2">
                <i data-lucide="save" class="w-4 h-4"></i>
                {{ __('Simpan Perubahan') }}
            </button>

            @if (session('status') === 'profile-updated')
                <div
                    x-data="{ show: true }"
                    x-show="show"
                    x-transition
                    x-init="setTimeout(() => show = false, 3000)"
                    class="w-full sm:w-auto flex items-center justify-center gap-2 text-emerald-600 font-bold text-sm bg-emerald-50 dark:bg-emerald-900/20 px-4 py-2 rounded-xl"
                >
                    <i data-lucide="check-circle" class="w-4 h-4"></i>
                    {{ __('Berhasil disimpan') }}
                </div>
            @endif
        </div>
    </form>

    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('avatar-preview');
                    preview.innerHTML = `<img src="${e.target.result}" class="w-full h-full object-cover">`;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</section>
