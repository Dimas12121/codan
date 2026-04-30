<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Str;

class GoogleController extends Controller
{
    /**
     * Redirect the user to the Google authentication page.
     *
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function redirectToGoogle()
    {
        return Socialite::driver('google')->redirect();
    }

    /**
     * Obtain the user information from Google.
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handleGoogleCallback()
    {
        try {
            $googleUser = Socialite::driver('google')->user();
            
            $user = User::where('google_id', $googleUser->id)
                        ->orWhere('email', $googleUser->email)
                        ->first();

            if ($user) {
                // Update user if they exist but haven't linked google
                if (!$user->google_id) {
                    $user->update([
                        'google_id' => $googleUser->id,
                        'google_token' => $googleUser->token,
                        'google_refresh_token' => $googleUser->refreshToken,
                        'avatar' => $googleUser->avatar ?? $user->avatar,
                    ]);
                } else {
                    $user->update([
                        'google_token' => $googleUser->token,
                        'google_refresh_token' => $googleUser->refreshToken,
                    ]);
                }
            } else {
                // Create new user
                $user = User::create([
                    'name' => $googleUser->name,
                    'email' => $googleUser->email,
                    'google_id' => $googleUser->id,
                    'google_token' => $googleUser->token,
                    'google_refresh_token' => $googleUser->refreshToken,
                    'password' => Hash::make(Str::random(24)),
                    'avatar' => $googleUser->avatar,
                    'role' => 'buyer', // Default role
                    'is_active' => true,
                ]);
            }

            Auth::login($user);

            return redirect()->intended('/dashboard');

        } catch (Exception $e) {
            return redirect('/login')->with('error', 'Something went wrong while logging in with Google.');
        }
    }
}
