<section class="space-y-6">
    <header>
        <h2 class="text-xl font-bold text-red-600 dark:text-red-400 flex items-center gap-2">
            <i data-lucide="alert-triangle" class="w-5 h-5"></i>
            {{ __('Hapus Akun') }}
        </h2>
        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
            {{ __('Setelah akun Anda dihapus, semua sumber daya dan datanya akan dihapus secara permanen. Sebelum menghapus akun Anda, harap unduh data atau informasi apa pun yang ingin Anda simpan.') }}
        </p>
    </header>

    <button
        x-data=""
        x-on:click.prevent="$dispatch('open-modal', 'confirm-user-deletion')"
        class="w-full sm:w-auto px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-2xl shadow-lg shadow-red-500/20 transition-all active:scale-95 flex items-center justify-center gap-2"
    >
        <i data-lucide="trash-2" class="w-4 h-4"></i>
        {{ __('Hapus Akun Saya') }}
    </button>

    <x-modal name="confirm-user-deletion" :show="$errors->userDeletion->isNotEmpty()" focusable>
        <form method="post" action="{{ route('profile.destroy') }}" class="p-8 bg-white dark:bg-slate-900 rounded-[2.5rem]">
            @csrf
            @method('delete')

            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-2">
                {{ __('Apakah Anda yakin ingin menghapus akun?') }}
            </h2>

            <p class="text-slate-500 dark:text-slate-400 leading-relaxed mb-8">
                {{ __('Setelah akun Anda dihapus, semua sumber daya dan datanya akan dihapus secara permanen. Silakan masukkan kata sandi Anda untuk mengonfirmasi bahwa Anda ingin menghapus akun Anda secara permanen.') }}
            </p>

            <div class="space-y-2">
                <x-input-label for="password" value="{{ __('Password') }}" class="sr-only" />

                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                        <i data-lucide="lock" class="w-4 h-4"></i>
                    </div>
                    <x-text-input
                        id="password"
                        name="password"
                        type="password"
                        class="pl-10 w-full bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 focus:ring-red-500 focus:border-red-500 rounded-xl"
                        placeholder="{{ __('Masukkan Kata Sandi Anda') }}"
                    />
                </div>

                <x-input-error :messages="$errors->userDeletion->get('password')" class="mt-2" />
            </div>

            <div class="mt-8 flex justify-end gap-3">
                <button type="button" x-on:click="$dispatch('close')" class="px-6 py-3 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 font-bold rounded-xl hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors">
                    {{ __('Batal') }}
                </button>

                <button type="submit" class="px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-xl shadow-lg shadow-red-500/20 transition-all active:scale-95">
                    {{ __('Ya, Hapus Akun') }}
                </button>
            </div>
        </form>
    </x-modal>
</section>
