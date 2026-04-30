<x-app-layout>
    <x-slot name="header">
        <h2 class="font-black text-3xl text-slate-900 dark:text-white leading-tight flex items-center gap-3 italic">
            <span class="w-2 h-8 bg-blue-600 rounded-full"></span>
            PASANG IKLAN
        </h2>
    </x-slot>

    <div class="py-6 sm:py-12">
        <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-slate-900 overflow-hidden shadow-2xl sm:rounded-[2.5rem] border-y sm:border border-gray-100 dark:border-slate-800">
                <div class="p-6 sm:p-10 lg:p-16">
                    <form method="POST" action="{{ route('produks.store') }}" enctype="multipart/form-data" class="space-y-6 sm:space-y-10">
                        @csrf

                        <!-- Multiple Image Upload (Simplified) -->
                        <div class="space-y-4">
                            <label class="block text-sm font-black uppercase tracking-widest text-gray-400">Foto Barang (Maks 5)</label>
                            <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                                @for($i = 0; $i < 5; $i++)
                                <div x-data="{ 
                                    imageUrl: null, 
                                    isDragging: false,
                                    handleFile(file) {
                                        if (!file) return;
                                        const reader = new FileReader();
                                        reader.onload = (e) => this.imageUrl = e.target.result;
                                        reader.readAsDataURL(file);
                                    }
                                }" class="relative group">
                                    <!-- Preview State -->
                                    <div x-show="imageUrl" class="relative aspect-square rounded-2xl overflow-hidden border-2 border-blue-500 shadow-md group/preview transition-all duration-300">
                                        <img :src="imageUrl" class="w-full h-full object-cover">
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover/preview:opacity-100 transition-opacity flex items-center justify-center">
                                            <button type="button" @click="imageUrl = null; $refs.imageInput{{ $i }}.value = ''" class="bg-red-500 text-white p-2 rounded-xl hover:bg-red-600 transition-colors shadow-lg">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash-2"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/><line x1="10" x2="10" y1="11" y2="17"/><line x1="14" x2="14" y1="11" y2="17"/></svg>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Upload State -->
                                    <label 
                                        x-show="!imageUrl" 
                                        @dragover.prevent="isDragging = true"
                                        @dragleave.prevent="isDragging = false"
                                        @drop.prevent="
                                            isDragging = false;
                                            const file = $event.dataTransfer.files[0];
                                            if (file) {
                                                $refs.imageInput{{ $i }}.files = $event.dataTransfer.files;
                                                handleFile(file);
                                            }
                                        "
                                        :class="isDragging ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20 scale-105' : 'border-gray-200 dark:border-slate-800'"
                                        class="aspect-square flex flex-col items-center justify-center rounded-2xl border-2 border-dashed hover:border-blue-500 hover:bg-blue-50 dark:hover:bg-blue-900/10 cursor-pointer transition-all duration-300">
                                        
                                        <div class="flex flex-col items-center group-hover:scale-110 transition-transform duration-300">
                                            <i data-lucide="camera" class="w-8 h-8 text-gray-300 group-hover:text-blue-500 mb-2"></i>
                                            <span class="text-[10px] font-bold text-gray-400">Pilih Foto</span>
                                        </div>

                                        <input type="file" 
                                            name="images[]" 
                                            x-ref="imageInput{{ $i }}"
                                            class="hidden" 
                                            accept="image/*"
                                            @change="handleFile($event.target.files[0])">
                                    </label>
                                </div>
                                @endfor
                            </div>
                        </div>

                        <!-- Basic Details -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 sm:gap-8">
                            <div class="space-y-3 sm:space-y-4">
                                <x-input-label for="title" value="Judul Iklan" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                                <x-text-input id="title" name="title" type="text" class="block w-full !rounded-xl sm:!rounded-2xl !py-3 sm:!py-4 text-sm sm:text-base" placeholder="Contoh: Honda Civic 2019 Mulus" required autofocus />
                                <x-input-error class="mt-2" :messages="$errors->get('title')" />
                            </div>
 
                            <div class="space-y-3 sm:space-y-4">
                                <x-input-label for="category_id" value="Kategori" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                                <select id="category_id" name="category_id" class="block w-full rounded-xl sm:rounded-2xl py-3 sm:py-4 border-gray-300 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300 focus:border-indigo-500 focus:ring-indigo-500 shadow-sm text-sm sm:text-base font-bold" required>
                                    <option value="">Pilih Kategori</option>
                                    @foreach($categories as $category)
                                        <option value="{{ $category->id }}">{{ $category->name }}</option>
                                    @endforeach
                                </select>
                                <x-input-error class="mt-2" :messages="$errors->get('category_id')" />
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 sm:gap-8">
                            <div class="space-y-3 sm:space-y-4">
                                <x-input-label for="price" value="Harga (Rp)" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                                <x-text-input id="price" name="price" type="number" class="block w-full !rounded-xl sm:!rounded-2xl !py-3 sm:!py-4 text-sm sm:text-base font-bold text-blue-600" placeholder="Contoh: 150000000" required />
                                <x-input-error class="mt-2" :messages="$errors->get('price')" />
                            </div>
 
                            <div class="space-y-3 sm:space-y-4">
                                <x-input-label for="condition" value="Kondisi" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                                <select id="condition" name="condition" class="block w-full rounded-xl sm:rounded-2xl py-3 sm:py-4 border-gray-300 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm font-bold text-sm sm:text-base" required>
                                    <option value="baru">Baru</option>
                                    <option value="bekas" selected>Bekas</option>
                                    <option value="refurbished">Refurbished</option>
                                </select>
                                <x-input-error class="mt-2" :messages="$errors->get('condition')" />
                            </div>
 
                            <div class="space-y-3 sm:space-y-4 sm:col-span-3">
                                <x-input-label for="location" value="Lokasi" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                                <x-text-input id="location_input" name="location" type="text" class="block w-full !rounded-xl sm:!rounded-2xl !py-3 sm:!py-4 text-sm sm:text-base" :value="old('location', auth()->user()->location)" placeholder="Ketik lokasi atau klik pada peta..." required />
                                <x-input-error class="mt-2" :messages="$errors->get('location')" />
                                
                                <input type="hidden" name="latitude" id="lat_input" value="{{ old('latitude') }}">
                                <input type="hidden" name="longitude" id="lng_input" value="{{ old('longitude') }}">
 
                                <div class="rounded-xl sm:rounded-2xl overflow-hidden border border-gray-100 dark:border-slate-800 h-48 sm:h-64 mt-2 bg-gray-50 dark:bg-slate-800 relative">
                                    <div id="map_picker" class="w-full h-full"></div>
                                    <div class="absolute bottom-2 left-2 right-2 sm:bottom-4 sm:left-4 sm:right-4 bg-white/95 dark:bg-slate-900/95 backdrop-blur-md p-2 sm:p-3 rounded-lg sm:rounded-xl text-[8px] sm:text-[9px] font-black uppercase tracking-widest text-slate-500 shadow-xl border border-gray-50 dark:border-slate-800">
                                        Klik pada peta untuk menentukan lokasi tepat.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            let map, marker, autocomplete;

                            function initMap() {
                                const defaultPos = { lat: -6.175392, lng: 106.827153 }; // Jakarta
                                
                                map = new google.maps.Map(document.getElementById("map_picker"), {
                                    center: defaultPos,
                                    zoom: 13,
                                    mapTypeControl: false,
                                    streetViewControl: false,
                                    styles: [{ "featureType": "poi", "stylers": [{ "visibility": "off" }] }]
                                });

                                marker = new google.maps.Marker({
                                    position: defaultPos,
                                    map: map,
                                    draggable: true,
                                    animation: google.maps.Animation.DROP
                                });

                                const input = document.getElementById('location_input');
                                autocomplete = new google.maps.places.Autocomplete(input);
                                autocomplete.bindTo('bounds', map);

                                autocomplete.addListener('place_changed', () => {
                                    const place = autocomplete.getPlace();
                                    if (!place.geometry) return;

                                    if (place.geometry.viewport) {
                                        map.fitBounds(place.geometry.viewport);
                                    } else {
                                        map.setCenter(place.geometry.location);
                                        map.setZoom(17);
                                    }

                                    marker.setPosition(place.geometry.location);
                                    updateInputs(place.geometry.location.lat(), place.geometry.location.lng(), place.name || place.formatted_address);
                                });

                                map.addListener('click', (e) => {
                                    marker.setPosition(e.latLng);
                                    updateInputs(e.latLng.lat(), e.latLng.lng());
                                });

                                marker.addListener('dragend', () => {
                                    const pos = marker.getPosition();
                                    updateInputs(pos.lat(), pos.lng());
                                });
                            }

                            function updateInputs(lat, lng, address = null) {
                                document.getElementById('lat_input').value = lat;
                                document.getElementById('lng_input').value = lng;
                                if (address) {
                                    document.getElementById('location_input').value = address;
                                }
                            }
                        </script>
                        <script src="https://maps.googleapis.com/maps/api/js?key={{ env('GOOGLE_MAPS_API_KEY') }}&libraries=places&callback=initMap" async defer></script>

                        <div class="space-y-3 sm:space-y-4">
                            <x-input-label for="description" value="Deskripsi" class="uppercase tracking-widest font-black text-[9px] sm:text-[10px] text-gray-400" />
                            <textarea id="description" name="description" rows="5" class="block w-full rounded-xl sm:rounded-2xl border-gray-300 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300 focus:border-indigo-500 focus:ring-indigo-500 shadow-sm text-sm sm:text-base font-medium" placeholder="Jelaskan kondisi barang, kelengkapan, dll..." required></textarea>
                            <x-input-error class="mt-2" :messages="$errors->get('description')" />
                        </div>

                        <div class="pt-4 sm:pt-6">
                            <button type="submit" class="w-full py-4 sm:py-5 rounded-2xl sm:rounded-3xl bg-blue-600 text-white font-black text-lg sm:text-xl hover:scale-[1.01] hover:shadow-2xl active:scale-95 transition-all shadow-xl shadow-blue-500/20">
                                PASANG IKLAN SEKARANG
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
