<x-app-layout>
    <x-slot name="header">
        <h2 class="font-black text-3xl text-slate-900 dark:text-white leading-tight italic tracking-tighter flex items-center gap-4">
            <span class="w-3 h-10 bg-blue-600 rounded-full"></span>
            EDIT IKLAN: {{ $produk->title }}
        </h2>
    </x-slot>

    <div class="py-12 bg-gray-50/50 dark:bg-slate-950/50">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-slate-900 p-10 rounded-[3rem] shadow-sm border border-gray-100 dark:border-slate-800">
                <form action="{{ route('produks.update', $produk->id) }}" method="POST">
                    @csrf
                    @method('PUT')
                    
                    <div class="space-y-8">
                        <div>
                            <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Judul Iklan</label>
                            <input type="text" name="title" value="{{ old('title', $produk->title) }}" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>
                        </div>

                        <div class="grid grid-cols-2 gap-8">
                            <div>
                                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Kategori</label>
                                <select name="category_id" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>
                                    @foreach($categories as $category)
                                    <option value="{{ $category->id }}" {{ $produk->category_id == $category->id ? 'selected' : '' }}>{{ $category->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Kondisi</label>
                                <select name="condition" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>
                                    <option value="baru" {{ $produk->condition == 'baru' ? 'selected' : '' }}>Baru</option>
                                    <option value="bekas" {{ $produk->condition == 'bekas' ? 'selected' : '' }}>Bekas</option>
                                    <option value="refurbished" {{ $produk->condition == 'refurbished' ? 'selected' : '' }}>Refurbished</option>
                                </select>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-8">
                            <div>
                                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Harga (Rp)</label>
                                <input type="number" name="price" value="{{ old('price', $produk->price) }}" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>
                            </div>
                            <div>
                                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Lokasi (Ketik atau pilih di peta)</label>
                                <input type="text" id="location_input" name="location" value="{{ old('location', $produk->location) }}" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>
                                
                                <input type="hidden" name="latitude" id="lat_input" value="{{ old('latitude', $produk->latitude) }}">
                                <input type="hidden" name="longitude" id="lng_input" value="{{ old('longitude', $produk->longitude) }}">

                                <div class="rounded-2x overflow-hidden border border-gray-100 dark:border-slate-800 h-64 mt-4 bg-gray-50 dark:bg-slate-800 relative">
                                    <div id="map_picker" class="w-full h-full"></div>
                                </div>
                            </div>
                        </div>

                        <script>
                            let map, marker, autocomplete;

                            function initMap() {
                                const currentPos = { 
                                    lat: {{ $produk->latitude ?? -6.175392 }}, 
                                    lng: {{ $produk->longitude ?? 106.827153 }} 
                                };
                                
                                map = new google.maps.Map(document.getElementById("map_picker"), {
                                    center: currentPos,
                                    zoom: {{ $produk->latitude ? 15 : 13 }},
                                    mapTypeControl: false,
                                    streetViewControl: false,
                                    styles: [{ "featureType": "poi", "stylers": [{ "visibility": "off" }] }]
                                });

                                marker = new google.maps.Marker({
                                    position: currentPos,
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

                        <div>
                            <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-3">Deskripsi</label>
                            <textarea name="description" rows="5" class="w-full px-6 py-4 rounded-2xl border border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-900 focus:ring-2 focus:ring-blue-500 transition-all outline-none font-bold" required>{{ old('description', $produk->description) }}</textarea>
                        </div>

                        <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-2xl font-black uppercase tracking-widest hover:bg-blue-700 transition-all shadow-xl shadow-blue-500/20 active:scale-95">
                            SIMPAN PERUBAHAN
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>
