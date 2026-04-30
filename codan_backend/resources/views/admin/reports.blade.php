@extends('layouts.admin')

@section('title', 'Moderasi Laporan')

@section('content')
<div class="max-w-7xl mx-auto">
    <!-- Success Alert -->
    @if(session('success'))
    <div class="mb-8 p-6 bg-emerald-500/10 border border-emerald-500/20 rounded-[2rem] flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
        <i data-lucide="check-circle" class="w-6 h-6 text-emerald-500"></i>
        <div class="text-emerald-500 font-bold">{{ session('success') }}</div>
    </div>
    @endif

    <!-- Reports Table Card -->
    <div class="admin-card overflow-hidden">
        <div class="overflow-x-auto lg:overflow-visible no-scrollbar">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-900/50">
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Kasus / Pelapor</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Target Pelanggaran</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Alasan Pelaporan</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Status</th>
                        <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-800">
                    @forelse($reports as $report)
                    <tr class="group hover:bg-white/5 transition-all">
                        <td class="px-8 py-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-2xl bg-slate-800/50 flex items-center justify-center text-slate-400 group-hover:text-amber-500 transition-colors">
                                    <i data-lucide="alert-circle" class="w-5 h-5"></i>
                                </div>
                                <div>
                                    <div class="font-black text-white italic tracking-tighter">{{ $report->user->name }}</div>
                                    <div class="text-[9px] font-bold text-slate-500 uppercase tracking-widest">{{ $report->created_at->diffForHumans() }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex flex-col gap-1">
                                <a href="{{ route('produks.show', $report->produk->slug) }}" target="_blank" class="font-black text-blue-500 hover:text-blue-400 transition-colors italic">
                                    {{ $report->produk->title }}
                                </a>
                                <div class="text-[9px] font-bold text-slate-500 uppercase tracking-widest">Penjual: {{ $report->produk->user->name }}</div>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="max-w-xs">
                                <span class="px-2.5 py-1 rounded-lg bg-red-500/10 text-red-500 text-[9px] font-black uppercase tracking-widest border border-red-500/20">{{ $report->reason }}</span>
                                @if($report->details)
                                <p class="text-xs text-slate-400 mt-2 italic line-clamp-2 leading-relaxed">{{ $report->details }}</p>
                                @endif
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            @php
                                $statusIcons = [
                                    'pending' => ['bg-amber-500/10', 'text-amber-500', 'clock'],
                                    'resolved' => ['bg-emerald-500/10', 'text-emerald-500', 'check-circle'],
                                    'ignored' => ['bg-slate-500/10', 'text-slate-500', 'slash'],
                                ];
                                $current = $statusIcons[$report->status] ?? $statusIcons['pending'];
                            @endphp
                            <div class="flex items-center gap-2 px-3 py-1.5 rounded-xl {{ $current[0] }} {{ $current[1] }} border border-transparent w-fit">
                                <i data-lucide="{{ $current[2] }}" class="w-3.5 h-3.5"></i>
                                <span class="text-[9px] font-black uppercase tracking-widest">{{ $report->status }}</span>
                            </div>
                        </td>
                        <td class="px-8 py-6">
                            <div class="flex items-center justify-center gap-3">
                                <!-- Action Popover -->
                                <div class="relative group/pop">
                                    <button class="p-4 rounded-2xl bg-[#0b0f1a] text-slate-400 hover:bg-blue-600 hover:text-white transition-all shadow-sm" title="Proses Laporan">
                                        <i data-lucide="shield" class="w-5 h-5"></i>
                                    </button>
                                    <div class="absolute right-0 top-full mt-3 w-80 bg-[#1e293b] rounded-[2.5rem] shadow-2xl border border-blue-500/30 z-[100] opacity-0 invisible group-hover/pop:opacity-100 group-hover/pop:visible transition-all duration-300 scale-95 group-hover/pop:scale-100 origin-top-right">
                                        <div class="p-8">
                                            <div class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-6 text-center border-b border-slate-700/50 pb-3 italic">Investigasi & Keputusan</div>
                                            <form action="{{ route('admin.reports.update-status', $report->id) }}" method="POST" class="space-y-6">
                                                @csrf @method('PATCH')
                                                <div>
                                                    <label class="block text-[9px] font-black uppercase tracking-widest text-slate-500 mb-3">Tindakan Admin</label>
                                                    <select name="status" class="w-full px-5 py-3 rounded-2xl bg-[#0b0f1a] border-none text-xs font-bold text-white focus:ring-1 focus:ring-blue-500">
                                                        <option value="pending" {{ $report->status == 'pending' ? 'selected' : '' }}>Biarkan Pending</option>
                                                        <option value="resolved" {{ $report->status == 'resolved' ? 'selected' : '' }}>Tandai Selesai</option>
                                                        <option value="ignored" {{ $report->status == 'ignored' ? 'selected' : '' }}>Abaikan Laporan</option>
                                                    </select>
                                                </div>
                                                <div>
                                                    <label class="block text-[9px] font-black uppercase tracking-widest text-slate-500 mb-3">Catatan Internal</label>
                                                    <textarea name="admin_notes" class="w-full px-5 py-3 rounded-2xl bg-[#0b0f1a] border-none text-xs font-bold text-white focus:ring-1 focus:ring-blue-500" rows="3" placeholder="Masukkan alasan keputusan...">{{ $report->admin_notes }}</textarea>
                                                </div>
                                                <button type="submit" class="w-full py-4 bg-red-600 text-white rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-xl shadow-red-600/20 active:scale-95 transition-all">Eksekusi Keputusan</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Delete Data Laporan -->
                                <form action="{{ route('admin.reports.delete', $report->id) }}" method="POST" onsubmit="return confirm('Hapus data laporan ini?')">
                                    @csrf @method('DELETE')
                                    <button type="submit" class="p-4 rounded-2xl bg-red-500/10 text-red-500 hover:bg-red-500 hover:text-white transition-all shadow-sm" title="Hapus Data Laporan">
                                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="px-8 py-24 text-center">
                            <div class="flex flex-col items-center gap-4 opacity-40">
                                <i data-lucide="shield-check" class="w-16 h-16 text-emerald-500"></i>
                                <span class="font-black italic uppercase tracking-widest text-slate-500">Aman Terkendali. Tidak ada laporan masuk.</span>
                            </div>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        @if($reports->hasPages())
        <div class="px-8 py-8 border-t border-slate-800 bg-[#0b0f1a]/30">
            {{ $reports->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
