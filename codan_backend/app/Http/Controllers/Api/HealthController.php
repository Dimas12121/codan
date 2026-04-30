<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Redis;

class HealthController extends Controller
{
    /**
     * Health check endpoint
     */
    public function index()
    {
        $status = 'healthy';
        $checks = [];
        
        // Database check
        try {
            DB::connection()->getPdo();
            $checks['database'] = [
                'status' => 'connected',
                'version' => DB::connection()->getPdo()->getAttribute(\PDO::ATTR_SERVER_VERSION),
            ];
        } catch (\Exception $e) {
            $status = 'unhealthy';
            $checks['database'] = [
                'status' => 'disconnected',
                'error' => $e->getMessage(),
            ];
        }
        
        // Cache check
        try {
            Cache::put('health_check', 'ok', 10);
            $cacheValue = Cache::get('health_check');
            $checks['cache'] = [
                'status' => $cacheValue === 'ok' ? 'working' : 'failed',
                'driver' => config('cache.default'),
            ];
        } catch (\Exception $e) {
            $checks['cache'] = [
                'status' => 'failed',
                'error' => $e->getMessage(),
            ];
        }
        
        // Redis check (if using redis)
        if (config('cache.default') === 'redis') {
            try {
                Redis::ping();
                $checks['redis'] = [
                    'status' => 'connected',
                ];
            } catch (\Exception $e) {
                $checks['redis'] = [
                    'status' => 'disconnected',
                    'error' => $e->getMessage(),
                ];
            }
        }
        
        // Environment info
        $checks['environment'] = [
            'app_env' => config('app.env'),
            'app_debug' => config('app.debug'),
            'app_url' => config('app.url'),
            'timezone' => config('app.timezone'),
        ];
        
        // PHP info
        $checks['php'] = [
            'version' => phpversion(),
            'memory_limit' => ini_get('memory_limit'),
            'max_execution_time' => ini_get('max_execution_time'),
        ];
        
        // Server info
        $checks['server'] = [
            'software' => $_SERVER['SERVER_SOFTWARE'] ?? 'unknown',
            'protocol' => $_SERVER['SERVER_PROTOCOL'] ?? 'unknown',
            'host' => $_SERVER['HTTP_HOST'] ?? 'unknown',
        ];
        
        // Uptime
        $checks['uptime'] = [
            'server_time' => now()->toDateTimeString(),
            'timestamp' => time(),
        ];
        
        return response()->json([
            'status' => $status,
            'service' => 'CODean API',
            'version' => '1.0.0',
            'timestamp' => now()->toDateTimeString(),
            'checks' => $checks,
        ]);
    }
    
    /**
     * Database check endpoint
     */
    public function dbCheck()
    {
        try {
            DB::connection()->getPdo();
            
            // Get some stats
            $tables = DB::select('SHOW TABLES');
            $tableCount = count($tables);
            
            // Get user count
            $userCount = \App\Models\User::count();
            
            return response()->json([
                'status' => 'connected',
                'database' => config('database.connections.mysql.database'),
                'host' => config('database.connections.mysql.host'),
                'tables' => $tableCount,
                'users' => $userCount,
                'message' => 'Database connection successful',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'disconnected',
                'error' => $e->getMessage(),
                'database' => config('database.connections.mysql.database'),
                'host' => config('database.connections.mysql.host'),
                'message' => 'Database connection failed',
            ], 500);
        }
    }
    
    /**
     * API status endpoint
     */
    public function apiStatus()
    {
        $endpoints = [
            '/api/health' => 'Health check',
            '/api/health/db' => 'Database check',
            '/api/login' => 'User login',
            '/api/register' => 'User registration',
            '/api/send-otp-whatsapp' => 'Send OTP via WhatsApp',
            '/api/verify-otp' => 'Verify OTP',
            '/api/check-phone' => 'Check phone availability',
        ];
        
        return response()->json([
            'status' => 'operational',
            'service' => 'CODean API',
            'version' => '1.0.0',
            'endpoints' => $endpoints,
            'timestamp' => now()->toDateTimeString(),
            'documentation' => 'https://codean.brodims.my.id/api-docs',
        ]);
    }
}