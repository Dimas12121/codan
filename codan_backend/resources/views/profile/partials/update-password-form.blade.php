<section>
    <header class="mb-8">
        <h2 class="text-xl font-bold text-slate-900 dark:text-white flex items-center gap-2">
            <i data-lucide="key-round" class="w-5 h-5 text-blue-500"></i>
            {{ __('Update Kata Sandi') }}
        </h2>
        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
            {{ __('Pastikan akun Anda menggunakan kata sandi yang panjang dan acak untuk tetap aman.') }}
        </p>
    </header>

    <form method="post" action="{{ route('password.update') }}" class="space-y-6">
        @csrf
        @method('put')

        <div class="space-y-2">
            <x-input-label for="update_password_current_password" :value="__('Kata Sandi Saat Ini')" class="text-slate-700 dark:text-slate-300 font-bold" />
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                    <i data-lucide="lock" class="w-4 h-4"></i>
                </div>
                <x-text-input id="update_password_current_password" name="current_password" type="password" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" autocomplete="current-password" />
            </div>
            <x-input-error :messages="$errors->updatePassword->get('current_password')" class="mt-2" />
        </div>

        <div class="space-y-2">
            <x-input-label for="update_password_password" :value="__('Kata Sandi Baru')" class="text-slate-700 dark:text-slate-300 font-bold" />
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                    <i data-lucide="shield-check" class="w-4 h-4"></i>
                </div>
                <x-text-input id="update_password_password" name="password" type="password" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" autocomplete="new-password" />
            </div>
            <x-input-error :messages="$errors->updatePassword->get('password')" class="mt-2" />
        </div>

        <div class="space-y-2">
            <x-input-label for="update_password_password_confirmation" :value="__('Konfirmasi Kata Sandi')" class="text-slate-700 dark:text-slate-300 font-bold" />
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                    <i data-lucide="shield-alert" class="w-4 h-4"></i>
                </div>
                <x-text-input id="update_password_password_confirmation" name="password_confirmation" type="password" class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-blue-500 focus:border-blue-500 rounded-xl" autocomplete="new-password" />
            </div>
            <x-input-error :messages="$errors->updatePassword->get('password_confirmation')" class="mt-2" />
        </div>

        <div class="flex flex-col sm:flex-row items-center gap-4 pt-4">
            <button type="submit" class="w-full sm:w-auto px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-2xl shadow-lg shadow-blue-500/20 transition-all active:scale-95 flex items-center justify-center gap-2">
                <i data-lucide="save" class="w-4 h-4"></i>
                {{ __('Update Kata Sandi') }}
            </button>

            @if (session('status') === 'password-updated')
                <div
                    x-data="{ show: true }"
                    x-show="show"
                    x-transition
                    x-init="setTimeout(() => show = false, 3000)"
                    class="w-full sm:w-auto flex items-center justify-center gap-2 text-emerald-600 font-bold text-sm bg-emerald-50 dark:bg-emerald-900/20 px-4 py-2 rounded-xl"
                >
                    <i data-lucide="check-circle" class="w-4 h-4"></i>
                    {{ __('Berhasil diperbarui') }}
                </div>
            @endif
        </div>
    </form>
</section>
