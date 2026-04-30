<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class OTPController extends Controller
{
    /**
     * Send OTP via WhatsApp using Fonnte
     */
    public function sendOTPviaWhatsApp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|max:20',
            'otp' => 'required|string|size:6',
            'email' => 'nullable|email|max:255',
            'purpose' => 'required|in:register,login,reset_password,update_phone',
            'channel' => 'required|in:whatsapp,sms',
            'provider' => 'required|in:fonnte',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $phone = $this->formatPhoneNumber($request->phone);
        $otp = $request->otp;
        $purpose = $request->purpose;
        $email = $request->email;

        // Check if phone already registered (for registration purpose)
        if ($purpose === 'register') {
            // Handle legacy 08... format
            $localPhone = str_starts_with($phone, '+62') ? '0' . substr($phone, 3) : $phone;
            
            $existingUser = User::where('phone', $phone)
                                ->orWhere('phone', $request->phone)
                                ->orWhere('phone', $localPhone)
                                ->first();
            if ($existingUser) {
                return response()->json([
                    'success' => false,
                    'message' => 'Nomor telepon sudah terdaftar'
                ], 409);
            }
        }

        // Check if email already registered (for registration purpose)
        if ($purpose === 'register' && $email) {
            $existingUser = User::where('email', $email)->first();
            if ($existingUser) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email sudah terdaftar'
                ], 409);
            }
        }

        // Send OTP via Fonnte WhatsApp API
        $fonnteToken = env('FONNTE_TOKEN');
        
        if (!$fonnteToken) {
            return response()->json([
                'success' => false,
                'message' => 'Fonnte token tidak dikonfigurasi'
            ], 500);
        }

        $message = $this->generateOTPMessage($otp, $purpose);
        
        try {
            $response = Http::withHeaders([
                'Authorization' => $fonnteToken,
            ])->post('https://api.fonnte.com/send', [
                'target' => $phone,
                'message' => $message,
                'countryCode' => '62',
            ]);

            $responseData = $response->json();

            if ($response->successful() && isset($responseData['status']) && ($responseData['status'] === true || $responseData['status'] === 'success')) {
                // Store OTP in cache with 5 minute expiration
                $cacheKey = "otp:{$phone}:{$purpose}";
                Cache::put($cacheKey, $otp, now()->addMinutes(5));

                // Also store in database for audit trail
                \App\Models\OTPLog::create([
                    'phone' => $phone,
                    'otp' => $otp,
                    'purpose' => $purpose,
                    'channel' => $request->channel,
                    'provider' => $request->provider,
                    'status' => 'sent',
                    'response' => json_encode($responseData),
                ]);

                return response()->json([
                    'success' => true,
                    'message' => 'OTP berhasil dikirim ke WhatsApp',
                    'data' => [
                        'phone' => $this->maskPhoneNumber($phone),
                        'expires_in' => 300, // 5 minutes in seconds
                    ]
                ]);
            } else {
                \App\Models\OTPLog::create([
                    'phone' => $phone,
                    'otp' => $otp,
                    'purpose' => $purpose,
                    'channel' => $request->channel,
                    'provider' => $request->provider,
                    'status' => 'failed',
                    'response' => json_encode($responseData),
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'Gagal mengirim OTP: ' . ($responseData['message'] ?? $responseData['detail'] ?? 'Unknown error'),
                    'data' => $responseData
                ], 500);
            }
        } catch (\Exception $e) {
            \App\Models\OTPLog::create([
                'phone' => $phone,
                'otp' => $otp,
                'purpose' => $purpose,
                'channel' => $request->channel,
                'provider' => $request->provider,
                'status' => 'error',
                'response' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error mengirim OTP: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Verify OTP
     */
    public function verifyOTP(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|max:20',
            'otp' => 'required|string|size:6',
            'purpose' => 'required|in:register,login,reset_password,update_phone',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $phone = $this->formatPhoneNumber($request->phone);
        $otp = $request->otp;
        $purpose = $request->purpose;

        $cacheKey = "otp:{$phone}:{$purpose}";
        $storedOTP = Cache::get($cacheKey);

        if (!$storedOTP) {
            return response()->json([
                'success' => false,
                'message' => 'OTP tidak ditemukan atau sudah kadaluarsa'
            ], 404);
        }

        if ($storedOTP !== $otp) {
            // Increment failed attempts
            $attemptsKey = "otp_attempts:{$phone}:{$purpose}";
            $attempts = Cache::get($attemptsKey, 0) + 1;
            Cache::put($attemptsKey, $attempts, now()->addMinutes(30));

            if ($attempts >= 5) {
                Cache::forget($cacheKey); // Clear OTP after too many attempts
                return response()->json([
                    'success' => false,
                    'message' => 'Terlalu banyak percobaan gagal. Silakan minta OTP baru.'
                ], 429);
            }

            return response()->json([
                'success' => false,
                'message' => 'OTP tidak valid',
                'remaining_attempts' => 5 - $attempts
            ], 422);
        }

        // OTP verified successfully
        Cache::forget($cacheKey);
        Cache::forget("otp_attempts:{$phone}:{$purpose}");

        // Mark OTP as verified in cache for 10 minutes
        $verifiedKey = "otp_verified:{$phone}:{$purpose}";
        Cache::put($verifiedKey, true, now()->addMinutes(10));

        return response()->json([
            'success' => true,
            'message' => 'OTP berhasil diverifikasi',
            'data' => [
                'phone' => $this->maskPhoneNumber($phone),
                'verified_for' => $purpose,
                'expires_in' => 600, // 10 minutes in seconds
            ]
        ]);
    }

    /**
     * Check phone availability
     */
    public function checkPhoneAvailability(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $phone = $this->formatPhoneNumber($request->phone);
        
        // Handle legacy 08... format
        $localPhone = str_starts_with($phone, '+62') ? '0' . substr($phone, 3) : $phone;
        
        $existingUser = User::where('phone', $phone)
                            ->orWhere('phone', $request->phone)
                            ->orWhere('phone', $localPhone)
                            ->first();

        return response()->json([
            'success' => true,
            'data' => [
                'phone' => $this->maskPhoneNumber($phone),
                'available' => !$existingUser,
                'message' => $existingUser ? 'Nomor telepon sudah terdaftar' : 'Nomor telepon tersedia'
            ]
        ]);
    }

    /**
     * Update phone number with OTP verification
     */
    public function updatePhone(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|max:20',
            'otp' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        $phone = $this->formatPhoneNumber($request->phone);
        $otp = $request->otp;

        // Check if phone already registered by another user
        $existingUser = User::where('phone', $phone)->where('id', '!=', $user->id)->first();
        if ($existingUser) {
            return response()->json([
                'success' => false,
                'message' => 'Nomor telepon sudah digunakan oleh pengguna lain'
            ], 409);
        }

        // Verify OTP for update_phone purpose
        $cacheKey = "otp:{$phone}:update_phone";
        $storedOTP = Cache::get($cacheKey);

        if (!$storedOTP || $storedOTP !== $otp) {
            return response()->json([
                'success' => false,
                'message' => 'OTP tidak valid atau sudah kadaluarsa'
            ], 422);
        }

        // Update user phone
        $user->phone = $phone;
        $user->save();

        // Clear OTP cache
        Cache::forget($cacheKey);

        return response()->json([
            'success' => true,
            'message' => 'Nomor telepon berhasil diperbarui',
            'data' => [
                'phone' => $this->maskPhoneNumber($phone),
                'user' => $user
            ]
        ]);
    }

    /**
     * Format phone number to Indonesian format
     */
    private function formatPhoneNumber($phone)
    {
        // Remove all non-digit characters
        $digits = preg_replace('/[^0-9]/', '', $phone);

        // If starts with 0, convert to +62
        if (str_starts_with($digits, '0')) {
            return '+62' . substr($digits, 1);
        }

        // If starts with 62, add +
        if (str_starts_with($digits, '62')) {
            return '+' . $digits;
        }

        // If starts with +62, return as is
        if (str_starts_with($digits, '+62')) {
            return $digits;
        }

        // Default: assume it's Indonesian number without country code
        return '+62' . $digits;
    }

    /**
     * Mask phone number for display
     */
    private function maskPhoneNumber($phone)
    {
        if (strlen($phone) <= 8) {
            return $phone;
        }

        $formatted = $this->formatPhoneNumber($phone);
        $length = strlen($formatted);

        if ($length <= 8) {
            return substr($formatted, 0, 3) . '***' . substr($formatted, -2);
        } else {
            return substr($formatted, 0, 4) . '****' . substr($formatted, -3);
        }
    }

    /**
     * Generate OTP message based on purpose
     */
    private function generateOTPMessage($otp, $purpose)
    {
        $appName = env('APP_NAME', 'CODAN');
        
        $messages = [
            'register' => "Kode OTP untuk pendaftaran di $appName: $otp\nKode berlaku 5 menit. Jangan berikan kode ini kepada siapapun.",
            'login' => "Kode OTP untuk login di $appName: $otp\nKode berlaku 5 menit. Jangan berikan kode ini kepada siapapun.",
            'reset_password' => "Kode OTP untuk reset password di $appName: $otp\nKode berlaku 5 menit. Jangan berikan kode ini kepada siapapun.",
            'update_phone' => "Kode OTP untuk memperbarui nomor telepon di $appName: $otp\nKode berlaku 5 menit. Jangan berikan kode ini kepada siapapun.",
        ];

        return $messages[$purpose] ?? "Kode OTP Anda: $otp\nKode berlaku 5 menit. Jangan berikan kode ini kepada siapapun.";
    }
}