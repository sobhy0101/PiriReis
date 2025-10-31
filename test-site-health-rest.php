<?php
/**
 * Test Site Health REST API Check
 * This simulates what WordPress Site Health does internally
 */

// Set up WordPress environment
define('WP_USE_THEMES', false);
require_once(__DIR__ . '/website/wp-load.php');

echo "Testing Site Health REST API Check\n";
echo "==================================\n\n";

// This is similar to what WordPress Site Health does
$test_url = home_url('index.php?rest_route=%2Fwp%2Fv2%2Ftypes%2Fpost&context=edit');

echo "Test URL: $test_url\n\n";

// Use WordPress HTTP API (same as Site Health)
$response = wp_remote_get($test_url, array(
    'timeout' => 10,
    'redirection' => 5,
    'user-agent' => 'WordPress/' . get_bloginfo('version') . '; ' . get_bloginfo('url'),
));

$start_time = microtime(true);

if (is_wp_error($response)) {
    echo "❌ Error occurred:\n";
    echo "Error Code: " . $response->get_error_code() . "\n";
    echo "Error Message: " . $response->get_error_message() . "\n";
} else {
    $end_time = microtime(true);
    $response_time = round(($end_time - $start_time) * 1000, 2);
    
    $response_code = wp_remote_retrieve_response_code($response);
    $response_body = wp_remote_retrieve_body($response);
    
    echo "✅ Success!\n";
    echo "Response Code: $response_code\n";
    echo "Response Time: {$response_time}ms\n";
    
    if ($response_code == 401) {
        echo "Note: HTTP 401 is expected for edit context without authentication\n";
    }
    
    // Try to decode JSON to ensure it's valid
    $json_data = json_decode($response_body, true);
    if (json_last_error() === JSON_ERROR_NONE) {
        echo "Response Body: Valid JSON received\n";
        if (isset($json_data['code'])) {
            echo "API Response Code: " . $json_data['code'] . "\n";
            echo "API Message: " . $json_data['message'] . "\n";
        }
    } else {
        echo "Response Body: " . substr($response_body, 0, 200) . "...\n";
    }
}

echo "\n";

// Also test the basic REST API root
echo "Testing REST API Root\n";
echo "====================\n";

$root_url = home_url('index.php?rest_route=/');
$root_response = wp_remote_get($root_url, array('timeout' => 5));

if (is_wp_error($root_response)) {
    echo "❌ REST API Root failed: " . $root_response->get_error_message() . "\n";
} else {
    $root_code = wp_remote_retrieve_response_code($root_response);
    echo "✅ REST API Root working (HTTP $root_code)\n";
}

echo "\nTest completed.\n";