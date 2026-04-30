<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center gap-3">
            <div class="p-2 bg-blue-500/10 rounded-xl">
                <i data-lucide="bell" class="w-5 h-5 text-blue-600 dark:text-blue-400"></i>
            </div>
            <h2 class="font-bold text-2xl text-slate-800 dark:text-white leading-tight">
                {{ __('Notifikasi Saya') }}
            </h2>
        </div>
    </x-slot>

    <div class="py-8 sm:py-12 bg-slate-50 dark:bg-slate-950 min-h-screen">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
            
            <div class="bg-white dark:bg-slate-900 rounded-[2.5rem] shadow-xl shadow-slate-200/50 dark:shadow-none border border-slate-100 dark:border-slate-800 overflow-hidden">
                <div class="p-6 border-b border-slate-50 dark:border-slate-800 flex items-center justify-between bg-slate-50/50 dark:bg-slate-800/50">
                    <p class="text-sm font-bold text-slate-500">{{ $notifications->total() }} Notifikasi</p>
                    <form action="{{ route('notifications.read-all') }}" method="POST">
                        @csrf
                        <button type="submit" class="text-xs text-blue-600 hover:underline font-bold">Tandai semua dibaca</button>
                    </form>
                </div>

                <div class="divide-y divide-slate-50 dark:divide-slate-800">
                    @forelse($notifications as $notification)
                        <div class="p-6 transition-all {{ $notification->read_at ? 'opacity-60' : 'bg-blue-50/20 dark:bg-blue-900/5' }}">
                            <div class="flex gap-4">
                                <div class="w-12 h-12 rounded-2xl {{ $notification->read_at ? 'bg-slate-100 dark:bg-slate-800 text-slate-400' : 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' }} flex items-center justify-center shrink-0">
                                    <i data-lucide="{{ $notification->read_at ? 'mail-open' : 'mail' }}" class="w-6 h-6"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="flex items-start justify-between gap-4">
                                        <h3 class="font-bold text-slate-900 dark:text-white leading-snug">
                                            {{ $notification->data['message'] ?? 'Pesan Sistem' }}
                                        </h3>
                                        <span class="text-[10px] text-slate-400 font-bold uppercase tracking-widest whitespace-nowrap">
                                            {{ $notification->created_at->diffForHumans() }}
                                        </span>
                                    </div>
                                    <p class="text-sm text-slate-500 dark:text-slate-400 mt-1 leading-relaxed">
                                        {{ $notification->data['description'] ?? 'Anda menerima notifikasi baru dari sistem.' }}
                                    </p>
                                    @if(!$notification->read_at)
                                        <form action="{{ route('notifications.read', $notification->id) }}" method="POST" class="mt-3">
                                            @csrf
                                            <button type="submit" class="text-xs font-black text-blue-600 uppercase tracking-widest hover:underline">
                                                Tandai Dibaca
                                            </button>
                                        </form>
                                    @endif
                                </div>
                            </div>
                        </div>
                    @empty
                        <div class="p-16 text-center">
                            <div class="w-20 h-20 bg-slate-50 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i data-lucide="bell-off" class="w-10 h-10 text-slate-300"></i>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">Belum ada notifikasi</h3>
                            <p class="text-slate-400 max-w-xs mx-auto text-sm leading-relaxed">
                                Semua pemberitahuan tentang iklan, pesan, dan aktivitas akun Anda akan muncul di sini.
                            </p>
                        </div>
                    @endforelse
                </div>

                @if($notifications->hasPages())
                    <div class="p-6 bg-slate-50/50 dark:bg-slate-800/50 border-t border-slate-50 dark:border-slate-800">
                        {{ $notifications->links() }}
                    </div>
                @endif
            </div>
        </div>
    </div>
</x-app-layout>
