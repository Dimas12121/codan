<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OTPLog extends Model
{
    protected $table = 'otp_logs';

    protected $fillable = [
        'phone',
        'email',
        'otp',
        'purpose',
        'channel',
        'provider',
        'status',
        'response',
    ];

    protected $casts = [
        'response' => 'array',
    ];
}