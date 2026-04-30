<?php
// Test connection script for codean.brodims.my.id
// Place this in public directory and access via browser

header('Content-Type: application/json');

$response = [
    'status' => 'success',
    'message' => 'CODean API is running',
    'timestamp' => date('Y-m-d H:i:s'),
    'environment' => getenv('APP_ENV') ?: 'not_set',
    'domain' => $_SERVER['HTTP_HOST'] ?? 'unknown',
    'php_version' => phpversion(),
    'server_software' => $_SERVER['SERVER_SOFTWARE'] ?? 'unknown',
];

// Test database connection if configured
try {
    $db_host = getenv('DB_HOST');
    $db_name = getenv('DB_DATABASE');
    $db_user = getenv('DB_USERNAME');
    
    if ($db_host && $db_name && $db_user) {
        $response['database'] = [
            'host' => $db_host,
            'database' => $db_name,
            'user' => $db_user,
            'status' => 'configured'
        ];
        
        // Try to connect
        $pdo = new PDO(
            "mysql:host=$db_host;dbname=$db_name",
            $db_user,
            getenv('DB_PASSWORD')
        );
        $response['database']['connection'] = 'success';
        $response['database']['version'] = $pdo->getAttribute(PDO::ATTR_SERVER_VERSION);
    } else {
        $response['database'] = [
            'status' => 'not_configured',
            'message' => 'Database configuration missing in .env'
        ];
    }
} catch (Exception $e) {
    $response['database'] = [
        'status' => 'error',
        'message' => $e->getMessage()
    ];
}

// Test Fonnte configuration
$fonnte_token = getenv('FONNTE_TOKEN');
$response['fonnte'] = [
    'configured' => !empty($fonnte_token),
    'token_length' => strlen($fonnte_token),
    'status' => $fonnte_token ? 'ready' : 'missing_token'
];

// Check required PHP extensions
$required_extensions = ['pdo_mysql', 'mbstring', 'xml', 'curl', 'json'];
$response['extensions'] = [];
foreach ($required_extensions as $ext) {
    $response['extensions'][$ext] = extension_loaded($ext);
}

// Check writable directories
$writable_dirs = ['storage', 'bootstrap/cache'];
$response['permissions'] = [];
foreach ($writable_dirs as $dir) {
    $path = __DIR__ . '/../' . $dir;
    $response['permissions'][$dir] = is_writable($path);
}

echo json_encode($response, JSON_PRETTY_PRINT);