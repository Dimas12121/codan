<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'required|in:buyer,seller',
            'phone' => 'required|string|max:20',
            'location' => 'required_if:role,seller|nullable|string|max:255',
        ]);

        // Format phone number
        $phone = $this->formatPhoneNumber($request->phone);
        
        // Handle legacy 08... format
        $localPhone = str_starts_with($phone, '+62') ? '0' . substr($phone, 3) : $phone;

        // Check if phone already registered
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

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role,
            'phone' => $phone,
            'is_phone_verified' => false, // Phone not verified yet
            'location' => $request->location,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'data' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 201);
    }

    public function registerWithPhone(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:20',
            'password' => 'required|string|min:8',
            'role' => 'nullable|in:buyer,seller',
        ]);

        // Format phone number
        $phone = $this->formatPhoneNumber($request->phone);
        
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role ?? 'buyer',
            'phone' => $phone,
            'is_phone_verified' => true,
            'phone_verified_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil',
            'data' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'data' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ]);
    }

    public function loginPhone(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'otp' => 'required|string|size:6',
        ]);

        // Format phone number
        $phone = $this->formatPhoneNumber($request->phone);
        $otp = $request->otp;

        // Verify OTP from cache
        $cacheKey = "otp:{$phone}:login";
        $storedOTP = \Illuminate\Support\Facades\Cache::get($cacheKey);

        if (!$storedOTP || $storedOTP !== $otp) {
            return response()->json([
                'success' => false,
                'message' => 'OTP tidak valid atau sudah kadaluarsa'
            ], 422);
        }

        // Handle legacy 08... format
        $localPhone = str_starts_with($phone, '+62') ? '0' . substr($phone, 3) : $phone;

        // Find user by phone
        $user = User::where('phone', $phone)
                    ->orWhere('phone', $request->phone)
                    ->orWhere('phone', $localPhone)
                    ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Nomor telepon tidak terdaftar. Silakan daftar terlebih dahulu.'
            ], 404);
        }

        // Clear OTP cache
        \Illuminate\Support\Facades\Cache::forget($cacheKey);

        // Issue token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'data' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ]);
    }

    private function formatPhoneNumber($phone)
    {
        $digits = preg_replace('/[^0-9]/', '', $phone);
        if (str_starts_with($digits, '0')) {
            return '+62' . substr($digits, 1);
        }
        if (str_starts_with($digits, '62')) {
            return '+' . $digits;
        }
        if (str_starts_with($digits, '+62')) {
            return $digits;
        }
        return '+62' . $digits;
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully'
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => $request->user()
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'location' => 'sometimes|nullable|string|max:255',
            'latitude' => 'sometimes|nullable|numeric',
            'longitude' => 'sometimes|nullable|numeric',
            'bio' => 'sometimes|nullable|string|max:500',
            'avatar' => 'sometimes|nullable|image|max:2048',
            'role' => 'sometimes|in:buyer,seller',
        ]);

        $data = $request->only(['name', 'phone', 'location', 'latitude', 'longitude', 'bio', 'role']);

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists
            if ($user->avatar) {
                \Storage::disk('public')->delete($user->avatar);
            }
            $path = $request->file('avatar')->store('avatars', 'public');
            $data['avatar'] = $path;
        }

        $user->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data' => $user
        ]);
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Current password does not match'
            ], 422);
        }

        $user->update([
            'password' => Hash::make($request->password)
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Password changed successfully'
        ]);
    }

    /**
     * Verify phone number after OTP verification
     */
    public function verifyPhone(Request $request)
    {
        $request->validate([
            'phone' => 'required|string|max:20',
        ]);

        $user = $request->user();

        // Check if phone belongs to another user
        $existingUser = User::where('phone', $request->phone)
            ->where('id', '!=', $user->id)
            ->first();

        if ($existingUser) {
            return response()->json([
                'success' => false,
                'message' => 'Nomor telepon sudah digunakan oleh pengguna lain'
            ], 409);
        }

        // Update user phone verification status
        $user->update([
            'phone' => $request->phone,
            'is_phone_verified' => true,
            'phone_verified_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Nomor telepon berhasil diverifikasi',
            'data' => $user
        ]);
    }
}
