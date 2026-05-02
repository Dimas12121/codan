<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Auth\Events\Registered;
use Illuminate\Validation\Rules;

class OtpController extends Controller
{
    private function sendWhatsApp($target, $message)
    {
        $token = config('services.fonnte.token');
        
        // Bersihkan spasi atau karakter non-digit
        $target = preg_replace('/[^0-9]/', '', $target);

        // Format nomor: ubah 08... menjadi 628...
        if (str_starts_with($target, '0')) {
            $target = '62' . substr($target, 1);
        } elseif (str_starts_with($target, '+')) {
            $target = substr($target, 1);
        }
        
        try {
            $response = Http::withHeaders([
                'Authorization' => $token,
            ])->asForm()->post('https://api.fonnte.com/send', [
                'target' => $target,
                'message' => $message,
            ]);

            \Log::info("Fonnte Send Attempt to {$target}: Status " . ($response->json('status') ? 'Success' : 'Failed'));
            \Log::info("Fonnte Response Body: " . $response->body());

            return $response;
        } catch (\Exception $e) {
            \Log::error("Fonnte Error: " . $e->getMessage());
            return null;
        }
    }

    public function send(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', 'unique:'.User::class],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
            'role' => ['required', 'string', 'in:buyer,seller'],
            'phone' => ['required', 'string', 'max:20'],
            'location' => ['required_if:role,seller', 'nullable', 'string', 'max:255'],
        ]);

        $otp = rand(1000, 9999);
        
        // Simpan ke session
        session([
            'registration_otp' => $otp, 
            'registration_data' => $request->all(),
            'otp_expires_at' => now()->addMinutes(5)
        ]);

        // Kirim OTP via WhatsApp (Fonnte)
        $message = "Halo {$request->name}! \n\n" . 
                   "Kode verifikasi (OTP) untuk pendaftaran Anda di codan Marketplace adalah: *{$otp}* \n\n" .
                   "Kode ini berlaku selama 5 menit. Jangan berikan kode ini kepada siapapun.";
                   
        $this->sendWhatsApp($request->phone, $message);

        return response()->json([
            'success' => true,
            'message' => 'OTP has been sent to your device!',
            'debug_otp' => config('app.debug') ? $otp : null
        ]);
    }

    public function verify(Request $request)
    {
        $request->validate([
            'otp' => 'required|string|size:4',
        ]);

        $sessionOtp = session('registration_otp');
        $expiresAt = session('otp_expires_at');

        if (!$sessionOtp || now()->gt($expiresAt)) {
            return response()->json([
                'success' => false,
                'message' => 'OTP expired or not found. Please resend.'
            ], 422);
        }

        if ($request->otp != $sessionOtp) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid OTP code. Please try again.'
            ], 422);
        }

        $data = session('registration_data');
        
        if (!$data) {
            return response()->json([
                'success' => false,
                'message' => 'Registration data lost. Please restart.'
            ], 422);
        }

        // Buat user
        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => $data['role'],
            'phone' => $data['phone'],
            'location' => $data['location'] ?? null,
            'is_active' => true,
        ]);

        event(new Registered($user));

        Auth::login($user);

        // Hapus session
        session()->forget(['registration_otp', 'registration_data', 'otp_expires_at']);

        return response()->json([
            'success' => true,
            'redirect' => route('dashboard')
        ]);
    }
}
