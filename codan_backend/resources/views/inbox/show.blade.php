@extends('inbox.index')

@section('chat_content')
<div class="flex flex-col h-full bg-white dark:bg-slate-900 border-l border-gray-50 dark:border-slate-800 shadow-2xl min-h-0">
    
    <!-- Chat Header -->
    <div class="p-4 sm:p-6 border-b border-gray-50 dark:border-slate-800 flex items-center justify-between bg-white/95 dark:bg-slate-900/95 sticky top-0 z-20 backdrop-blur-md">
        <div class="flex items-center gap-3 sm:gap-4">
            <!-- Back Button Mobile -->
            <a href="{{ route('inbox.index') }}" class="lg:hidden w-10 h-10 rounded-full flex items-center justify-center bg-gray-50 dark:bg-slate-800 text-slate-600 dark:text-gray-400">
                <i data-lucide="chevron-left" class="w-6 h-6"></i>
            </a>
            
            <div class="w-10 h-10 sm:w-12 sm:h-12 rounded-2xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
                <i data-lucide="user" class="w-5 h-5 sm:w-6 sm:h-6 text-blue-600"></i>
            </div>
            <div class="min-w-0 flex-1">
                <h3 class="font-black text-sm text-slate-800 dark:text-gray-100 tracking-tight leading-none truncate max-w-[120px] sm:max-w-[250px]">{{ $activePartner->name }}</h3>
                <div class="flex items-center gap-2 mt-1">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                    <span id="partner-status-text" class="text-[8px] sm:text-[10px] font-black uppercase tracking-widest text-gray-400">Online</span>
                    <span id="typing-indicator" class="hidden text-[8px] sm:text-[10px] font-black uppercase tracking-widest text-blue-500 animate-pulse">
                        <span class="inline-flex gap-0.5 ml-1">
                            <span class="w-1 h-1 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.3s]"></span>
                            <span class="w-1 h-1 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.15s]"></span>
                            <span class="w-1 h-1 bg-blue-500 rounded-full animate-bounce"></span>
                        </span>
                        Sedang Mengetik
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Product Context Card -->
        <a href="{{ route('produks.show', $produk->slug) }}" class="flex items-center gap-2 p-1.5 sm:p-3 rounded-2xl bg-gray-50 dark:bg-slate-800 hover:bg-blue-50 transition-all group max-w-[80px] sm:max-w-[400px] border border-transparent hover:border-blue-100">
            <div class="w-8 h-8 sm:w-12 sm:h-12 rounded-lg sm:rounded-xl overflow-hidden shadow-sm shrink-0">
                <img src="{{ $produk->featuredImage->image_path }}" class="w-full h-full object-cover">
            </div>
            <div class="min-w-0 hidden sm:block">
                <h4 class="text-xs font-black text-slate-800 dark:text-gray-100 truncate">{{ $produk->title }}</h4>
                <p class="text-[10px] font-black text-blue-600 italic">Rp {{ number_format($produk->price, 0, ',', '.') }}</p>
            </div>
            <i data-lucide="chevron-right" class="sm:hidden w-4 h-4 text-gray-400"></i>
            <i data-lucide="external-link" class="hidden sm:block w-4 h-4 text-gray-300 group-hover:text-blue-500"></i>
        </a>
    </div>

    <!-- Messages Container -->
    <div id="chat-messages" class="flex-1 overflow-y-auto p-4 sm:p-8 space-y-4 sm:space-y-8 scroll-smooth" style="background-image: radial-gradient(circle at 2px 2px, rgba(0,0,0,0.02) 1px, transparent 0); background-size: 24px 24px;">
        @foreach($messages as $msg)
            @php $isMe = $msg->sender_id == auth()->id(); @endphp
            <div class="flex {{ $isMe ? 'justify-end' : 'justify-start' }} animate-in fade-in slide-in-from-bottom-2 duration-300 group/msg" id="msg-{{ $msg->id }}">
                <div class="max-w-[85%] sm:max-w-[70%] flex flex-col {{ $isMe ? 'items-end' : 'items-start' }} relative">
                    
                    @if($isMe)
                    <div class="absolute -left-12 top-0 bottom-0 flex items-center opacity-0 group-hover/msg:opacity-100 transition-all duration-200">
                        <button onclick="unsendMessage({{ $msg->id }}, event)" 
                                class="w-8 h-8 rounded-full bg-red-50 dark:bg-red-900/20 text-red-500 hover:bg-red-500 hover:text-white flex items-center justify-center transition-all shadow-sm border border-red-100 dark:border-red-900/30"
                                title="Batalkan pesan">
                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                        </button>
                    </div>
                    @endif

                    @if($msg->image_path)
                    <div class="mb-2 rounded-3xl overflow-hidden shadow-xl border-4 border-white dark:border-slate-800 group relative">
                        <img src="{{ $msg->image_path }}" class="max-h-72 object-cover" alt="Sent image">
                        <a href="{{ $msg->image_path }}" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-all">
                            <i data-lucide="maximize-2" class="text-white w-8 h-8"></i>
                        </a>
                    </div>
                    @endif

                    @if($msg->message || $msg->latitude)
                    <div class="px-4 sm:px-6 py-3 sm:py-4 rounded-[1.5rem] sm:rounded-[2rem] shadow-sm {{ $isMe ? 'bg-blue-600 text-white rounded-br-none' : 'bg-white dark:bg-slate-800 text-slate-800 dark:text-gray-100 border border-gray-100 dark:border-slate-800 rounded-bl-none' }}">
                        @if($msg->latitude && $msg->longitude)
                        <div class="mb-3 rounded-2xl overflow-hidden shadow-inner border border-white/10 bg-slate-100 dark:bg-slate-800">
                            <div id="map-{{ $msg->id }}" class="w-full h-48 chat-map" data-lat="{{ $msg->latitude }}" data-lng="{{ $msg->longitude }}"></div>
                            <div class="p-3 bg-white dark:bg-slate-900 border-t border-gray-100 dark:border-slate-800 flex flex-wrap justify-between items-center gap-2">
                                <span class="text-[8px] font-black uppercase tracking-widest text-slate-500">Lokasi Terbagi</span>
                                <a href="https://www.google.com/maps/search/?api=1&query={{ $msg->latitude }},{{ $msg->longitude }}" target="_blank" class="text-[8px] font-black uppercase text-blue-600 hover:underline shrink-0">Buka Maps</a>
                            </div>
                        </div>
                        @endif
                        @if($msg->message)
                        <p class="text-sm font-bold leading-relaxed">{{ $msg->message }}</p>
                        @endif
                    </div>
                    @endif

                    <div class="mt-2 flex items-center gap-2 px-2">
                        <span class="text-[9px] font-black uppercase tracking-widest text-gray-400">{{ $msg->created_at->format('H:i') }}</span>
                        @if($isMe)
                        <span class="msg-status-container">
                            <i data-lucide="{{ $msg->is_read ? 'check-check' : 'check' }}" class="w-3 h-3 {{ $msg->is_read ? 'text-blue-500' : 'text-gray-300' }}"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </div>
        @endforeach
    </div>

    <!-- Chat Footer (Reply Box) -->
    <div class="p-4 sm:p-8 bg-white dark:bg-slate-900 border-t border-gray-50 dark:border-slate-800" x-data="{ showNegoModal: false }">
        <form action="{{ route('messages.store') }}" method="POST" enctype="multipart/form-data" class="relative">
            @csrf
            <input type="hidden" name="produk_id" value="{{ $produk->id }}">
            <input type="hidden" name="receiver_id" value="{{ $activePartner->id }}">
            
            <div class="flex items-center gap-1.5 sm:gap-4 bg-gray-50 dark:bg-slate-800 p-1 sm:p-2 rounded-[2.5rem] border-2 border-transparent focus-within:border-blue-500 transition-all shadow-inner overflow-hidden">
                <div class="flex items-center px-1 sm:px-2 gap-0.5 sm:gap-2 shrink-0">
                    <!-- Image Upload Button -->
                    <label class="w-10 h-10 sm:w-12 sm:h-12 rounded-xl flex items-center justify-center hover:bg-white dark:hover:bg-slate-700 cursor-pointer transition-all text-blue-500/70 hover:text-blue-500 hover:shadow-lg shrink-0">
                        <i data-lucide="image" class="w-5 h-5 sm:w-6 sm:h-6"></i>
                        <input type="file" name="image" class="hidden" accept="image/*" onchange="previewImage(this)">
                    </label>

                    <!-- Location Button -->
                    <button type="button" onclick="sendLocation(event)" class="w-10 h-10 sm:w-12 sm:h-12 rounded-xl flex items-center justify-center hover:bg-white dark:hover:bg-slate-700 cursor-pointer transition-all text-emerald-500/70 hover:text-emerald-500 hover:shadow-lg shrink-0">
                        <i data-lucide="map-pin" class="w-5 h-5 sm:w-6 sm:h-6"></i>
                    </button>
                    
                    @if(auth()->id() !== $produk->user_id)
                    <!-- Nego Button -->
                    <button type="button" @click="showNegoModal = true" class="w-10 h-10 sm:w-12 sm:h-12 rounded-xl flex items-center justify-center hover:bg-white dark:hover:bg-slate-700 cursor-pointer transition-all text-orange-500/70 hover:text-orange-500 hover:shadow-lg shrink-0">
                        <i data-lucide="handshake" class="w-5 h-5 sm:w-6 sm:h-6"></i>
                    </button>
                    @endif

                    <input type="hidden" name="latitude" id="lat_input_msg">
                    <input type="hidden" name="longitude" id="lng_input_msg">
                </div>

                <input type="text" name="message" id="message-input" autocomplete="off" class="flex-1 min-w-0 bg-transparent border-none focus:ring-0 text-xs sm:text-sm font-bold py-3 sm:py-4 px-2" placeholder="Tulis pesan...">
                
                <button type="submit" class="w-10 h-10 sm:w-14 sm:h-14 bg-blue-600 rounded-full flex items-center justify-center text-white shadow-xl shadow-blue-500/30 hover:scale-105 active:scale-95 transition-all shrink-0 mr-1">
                    <i data-lucide="send" class="w-4 h-4 sm:w-6 sm:h-6 -mr-1"></i>
                </button>
            </div>
            
            <!-- Attachments Preview Section -->
            <div id="preview-area" class="hidden absolute bottom-full left-0 mb-4 flex gap-4 animate-in slide-in-from-bottom-4">
                <!-- Image Preview -->
                <div id="image-preview-container" class="hidden p-4 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-gray-100 dark:border-slate-700">
                    <div class="relative w-32 h-32 rounded-2xl overflow-hidden">
                        <img id="image-preview" class="w-full h-full object-cover">
                        <button type="button" onclick="clearPreview()" class="absolute top-1 right-1 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center shadow-lg">
                            <i data-lucide="x" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>

                <!-- Location Preview -->
                <div id="location-preview-container" class="hidden p-4 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-gray-100 dark:border-slate-700">
                    <div class="relative w-48 p-4 flex flex-col items-center justify-center gap-2">
                        <div class="w-12 h-12 bg-emerald-50 text-emerald-500 rounded-2xl flex items-center justify-center">
                            <i data-lucide="map-pin" class="w-6 h-6"></i>
                        </div>
                        <span class="text-[9px] font-black uppercase tracking-widest text-slate-500">Lokasi Siap Dikirim</span>
                        <button type="button" onclick="clearLocationPreview()" class="absolute top-1 right-1 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center shadow-lg">
                            <i data-lucide="x" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>
            </div>
        </form>

        <!-- Negotiation Modal -->
        <div x-show="showNegoModal" 
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0 scale-90"
             x-transition:enter-end="opacity-100 scale-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100 scale-100"
             x-transition:leave-end="opacity-0 scale-90"
             class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm"
             style="display: none;">
            
            <div class="bg-white dark:bg-slate-900 w-full max-w-md rounded-[2.5rem] shadow-2xl overflow-hidden border border-white/20" @click.away="showNegoModal = false">
                <div class="p-8">
                    <div class="flex items-center justify-between mb-8">
                        <h3 class="text-2xl font-black text-slate-900 dark:text-white italic tracking-tighter">SESI NEGO HARGA</h3>
                        <button @click="showNegoModal = false" class="text-slate-400 hover:text-red-500 transition-colors">
                            <i data-lucide="x" class="w-6 h-6"></i>
                        </button>
                    </div>

                    <form action="{{ route('offers.store') }}" method="POST" class="space-y-6">
                        @csrf
                        <input type="hidden" name="produk_id" value="{{ $produk->id }}">
                        
                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400">Harga Asli</label>
                            <div class="text-xl font-black text-slate-400 line-through italic">Rp {{ number_format($produk->price, 0, ',', '.') }}</div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase tracking-widest text-blue-600">Harga Tawaran Anda</label>
                            <div class="relative">
                                <span class="absolute left-6 top-1/2 -translate-y-1/2 font-black text-slate-400">Rp</span>
                                <input type="number" name="offer_price" required min="1" step="1" 
                                       class="w-full pl-14 pr-8 py-5 rounded-2xl bg-gray-50 dark:bg-slate-800 border-2 border-transparent focus:border-blue-500 text-xl font-black transition-all outline-none"
                                       placeholder="Contoh: 150000">
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400">Pesan (Opsional)</label>
                            <textarea name="message" rows="3" class="w-full p-6 rounded-2xl bg-gray-50 dark:bg-slate-800 border-none text-sm font-bold focus:ring-2 focus:ring-blue-500 transition-all outline-none" placeholder="Tulis alasan nego Anda..."></textarea>
                        </div>

                        <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-3xl font-black text-lg shadow-xl shadow-blue-500/20 hover:scale-[1.02] active:scale-95 transition-all">
                            KIRIM TAWARAN
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('image-preview').src = e.target.result;
                document.getElementById('preview-area').classList.remove('hidden');
                document.getElementById('image-preview-container').classList.remove('hidden');
                lucide.createIcons();
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function clearPreview() {
        const input = document.querySelector('input[name="image"]');
        input.value = '';
        document.getElementById('image-preview-container').classList.add('hidden');
        checkPreviewArea();
    }

    function sendLocation(event) {
        if (navigator.geolocation) {
            const btn = event.currentTarget;
            const originalContent = btn.innerHTML;
            
            btn.disabled = true;
            btn.innerHTML = '<i data-lucide="loader-2" class="w-5 h-5 animate-spin"></i>';
            lucide.createIcons();

            navigator.geolocation.getCurrentPosition((pos) => {
                document.getElementById('lat_input_msg').value = pos.coords.latitude;
                document.getElementById('lng_input_msg').value = pos.coords.longitude;
                document.getElementById('preview-area').classList.remove('hidden');
                document.getElementById('location-preview-container').classList.remove('hidden');
                
                // Restore button
                btn.disabled = false;
                btn.innerHTML = originalContent;
                lucide.createIcons();
            }, (err) => {
                btn.disabled = false;
                btn.innerHTML = originalContent;
                lucide.createIcons();
                alert("Gagal mendapatkan lokasi: " + err.message);
            }, {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 0
            });
        } else {
            alert("Browser Anda tidak mendukung lokasi.");
        }
    }

    function clearLocationPreview() {
        document.getElementById('lat_input_msg').value = '';
        document.getElementById('lng_input_msg').value = '';
        document.getElementById('location-preview-container').classList.add('hidden');
        checkPreviewArea();
    }

    function checkPreviewArea() {
        const imgHidden = document.getElementById('image-preview-container').classList.contains('hidden');
        const locHidden = document.getElementById('location-preview-container').classList.contains('hidden');
        if (imgHidden && locHidden) {
            document.getElementById('preview-area').classList.add('hidden');
        }
    }

    function unsendMessage(id, event) {
        if (!confirm('Batalkan pengiriman pesan ini?')) return;

        const btn = event.currentTarget;
        const originalContent = btn.innerHTML;
        
        // Disable and show loader
        btn.disabled = true;
        btn.innerHTML = '<i data-lucide="loader-2" class="w-4 h-4 animate-spin"></i>';
        lucide.createIcons();

        fetch(`{{ url('messages') }}/${id}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(async res => {
            const isJson = res.headers.get('content-type')?.includes('application/json');
            const data = isJson ? await res.json() : null;
            
            if (!res.ok) {
                throw new Error(data?.error || `Server error: ${res.status}`);
            }
            return data;
        })
        .then(data => {
            if (data.success) {
                const el = document.getElementById(`msg-${id}`);
                if (el) {
                    el.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
                    el.style.transform = 'scale(0.95) translateY(10px)';
                    el.style.opacity = '0';
                    setTimeout(() => el.remove(), 300);
                }
            }
        })
        .catch(err => {
            console.error('Error:', err);
            // Restore button
            btn.disabled = false;
            btn.innerHTML = originalContent;
            lucide.createIcons();
            alert('Gagal membatalkan pesan: ' + err.message);
        });
    }

    // Ajax Form Submission
    document.querySelector('form').addEventListener('submit', function(e) {
        e.preventDefault();
        const form = this;
        const formData = new FormData(form);
        const submitBtn = form.querySelector('button[type="submit"]');
        const input = document.getElementById('message-input');
        
        if (!input.value.trim() && !formData.get('image').size && !formData.get('latitude')) return;

        submitBtn.disabled = true;
        const originalBtn = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i data-lucide="loader-2" class="w-6 h-6 animate-spin"></i>';
        lucide.createIcons();

        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json'
            }
        })
        .then(res => res.json())
        .then(data => {
            if (data.id) {
                appendMessage(data, true);
                form.reset();
                clearPreview();
                clearLocationPreview();
            }
        })
        .catch(err => alert('Gagal mengirim pesan'))
        .finally(() => {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalBtn;
            lucide.createIcons();
        });
    });
</script>

<!-- Leaflet Integration for Free Maps -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<style>
    .chat-map { z-index: 1; border-radius: 1rem; }
    .leaflet-control-attribution { display: none !important; }
</style>

<script>
    function initChatMaps() {
        document.querySelectorAll('.chat-map').forEach(el => {
            if (el.dataset.initialized) return;
            
            const lat = el.dataset.lat;
            const lng = el.dataset.lng;
            const map = L.map(el, {
                center: [lat, lng],
                zoom: 15,
                zoomControl: false,
                dragging: false,
                touchZoom: false,
                doubleClickZoom: false,
                scrollWheelZoom: false,
            });

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
            L.marker([lat, lng]).addTo(map);
            
            el.dataset.initialized = "true";
        });
    }

    function markAsRead() {
        fetch(`{{ route('messages.read', [$produk->id, $activePartner->id]) }}`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json'
            }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                window.dispatchEvent(new CustomEvent('update-unread-count'));
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const container = document.getElementById('chat-messages');
        container.scrollTop = container.scrollHeight;
        initChatMaps();
        markAsRead();

        // Sync with Echo (Real-time)
        if (typeof Echo !== 'undefined') {
            const ids = [{{ auth()->id() }}, {{ $activePartner->id }}].sort((a,b) => a - b);
            const channelName = `chat.{{ $produk->id }}.${ids[0]}.${ids[1]}`;

            const chatChannel = Echo.private(channelName);
            
            chatChannel.listen('MessageSent', (e) => {
                    if (e.receiver_id == {{ auth()->id() }}) {
                        appendMessage(e, false);
                        updateSidebar(e);
                        markAsRead();
                    }
                })
                .listen('MessageDeleted', (e) => {
                    const el = document.getElementById(`msg-${e.messageId}`);
                    if (el) {
                        el.classList.add('scale-75', 'opacity-0');
                        setTimeout(() => el.remove(), 300);
                    }
                })
                .listen('MessageRead', (e) => {
                    if (e.readerId == {{ $activePartner->id }}) {
                        // All my messages are now read by partner
                        document.querySelectorAll('.msg-status-container').forEach(container => {
                            container.innerHTML = '<i data-lucide="check-check" class="w-3 h-3 text-blue-500"></i>';
                        });
                        lucide.createIcons();
                    }
                })
                .listenForWhisper('typing', (e) => {
                    const indicator = document.getElementById('typing-indicator');
                    const statusText = document.getElementById('partner-status-text');
                    
                    if (indicator && statusText) {
                        indicator.classList.remove('hidden');
                        statusText.classList.add('hidden');
                        
                        // Hide after 2 seconds of no whisper
                        clearTimeout(window.typingTimer);
                        window.typingTimer = setTimeout(() => {
                            indicator.classList.add('hidden');
                            statusText.classList.remove('hidden');
                        }, 2000);
                    }
                });

            // Whisper Typing Event
            const messageInput = document.getElementById('message-input');
            if (messageInput) {
                messageInput.addEventListener('input', () => {
                    chatChannel.whisper('typing', {
                        name: '{{ auth()->user()->name }}'
                    });
                });
            }
        }
    });

    function appendMessage(e, isMe) {
        const container = document.getElementById('chat-messages');
        let mediaHtml = '';
        if (e.image_path) {
            mediaHtml = `
                <div class="mb-2 rounded-3xl overflow-hidden shadow-xl border-4 border-white dark:border-slate-800 group relative">
                    <img src="${e.image_path}" class="max-h-72 object-cover">
                    <a href="${e.image_path}" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-all">
                        <i data-lucide="maximize-2" class="text-white w-8 h-8"></i>
                    </a>
                </div>`;
        }

        let locationHtml = '';
        if (e.latitude && e.longitude) {
            locationHtml = `
                <div class="mb-3 rounded-2xl overflow-hidden shadow-inner border border-white/20 bg-slate-100 dark:bg-slate-800">
                    <div id="map-new-${e.id}" class="w-full h-48 chat-map" data-lat="${e.latitude}" data-lng="${e.longitude}"></div>
                    <div class="p-3 bg-white dark:bg-slate-900 border-t border-gray-100 dark:border-slate-800 flex justify-between items-center">
                        <span class="text-[9px] font-black uppercase tracking-widest text-slate-500">Lokasi Terbagi</span>
                        <a href="https://www.google.com/maps/search/?api=1&query=${e.latitude},${e.longitude}" target="_blank" class="text-[9px] font-black uppercase text-blue-600 hover:underline">Buka Maps</a>
                    </div>
                </div>`;
        }

        const messageHtml = `
            <div class="flex ${isMe ? 'justify-end' : 'justify-start'} animate-in fade-in slide-in-from-bottom-2 duration-300 group/msg" id="msg-${e.id}">
                <div class="max-w-[70%] flex flex-col ${isMe ? 'items-end' : 'items-start'} relative">
                    ${isMe ? `
                    <div class="absolute -left-12 top-0 bottom-0 flex items-center opacity-0 group-hover/msg:opacity-100 transition-all duration-200">
                        <button onclick="unsendMessage(${e.id}, event)" 
                                class="w-8 h-8 rounded-full bg-red-50 dark:bg-red-900/20 text-red-500 hover:bg-red-500 hover:text-white flex items-center justify-center transition-all shadow-sm border border-red-100 dark:border-red-900/30">
                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                        </button>
                    </div>` : ''}
                    ${mediaHtml}
                    ${e.message || e.latitude ? `
                    <div class="px-6 py-4 rounded-[2rem] shadow-sm ${isMe ? 'bg-blue-600 text-white rounded-br-none' : 'bg-white dark:bg-slate-800 text-slate-800 dark:text-gray-100 border border-gray-100 dark:border-slate-800 rounded-bl-none'}">
                        ${locationHtml}
                        ${e.message ? `<p class="text-sm font-bold leading-relaxed">${e.message}</p>` : ''}
                    </div>` : ''}
                    <div class="mt-2 flex items-center gap-2 px-2">
                        <span class="text-[9px] font-black uppercase tracking-widest text-gray-400">Baru Saja</span>
                    </div>
                </div>
            </div>`;
        
        container.insertAdjacentHTML('beforeend', messageHtml);
        lucide.createIcons();
        initChatMaps();
        container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' });
    }

    function updateSidebar(e) {
        // Find the conversation item in sidebar
        const convoItem = document.querySelector(`.conversation-item[href*="/inbox/${e.produk_id}/${e.sender_id}"]`);
        if (convoItem) {
            // Update last message text
            const msgPreview = convoItem.querySelector('p.text-xs span:last-child');
            if (msgPreview) {
                msgPreview.textContent = e.message || 'Sent an image';
            }
            
            // Update unread badge or show it if hidden
            let badge = convoItem.querySelector('.bg-blue-600.text-white');
            if (badge) {
                const currentCount = parseInt(badge.textContent) || 0;
                badge.textContent = currentCount + 1;
            } else {
                const container = convoItem.querySelector('.flex.items-center.justify-between');
                if (container) {
                    container.insertAdjacentHTML('beforeend', `<span class="ml-2 px-2 py-0.5 rounded-full bg-blue-600 text-white text-[9px] font-black">1</span>`);
                }
            }
            
            // Move to top of list
            convoItem.parentElement.prepend(convoItem);
        }
    }
</script>
@endpush
@endsection
