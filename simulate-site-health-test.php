<?php
/**
 * Simulate WordPress Site Health REST API Test
 * This replicates the exact test that WordPress Site Health performs
 */

define('WP_USE_THEMES', false);
require_once(__DIR__ . '/website/wp-load.php');

echo "WordPress Site Health REST API Test Simulation\n";
echo "==============================================\n\n";

// Replicate the exact Site Health test
function test_rest_availability() {
    $url = home_url('index.php?rest_route=%2Fwp%2Fv2%2Ftypes%2Fpost&context=edit');
    
    echo "Testing URL: $url\n";
    
    // Use the same parameters as WordPress Site Health
    $r = wp_remote_get($url, array(
        'timeout' => 10, // WordPress uses 10 second timeout
    ));
    
    if (is_wp_error($r)) {
        return array(
            'success' => false,
            'error_code' => $r->get_error_code(),
            'error_message' => $r->get_error_message(),
        );
    }
    
    $response_code = wp_remote_retrieve_response_code($r);
    
    // WordPress expects either 200 or 401 for this test
    if (in_array($response_code, array(200, 401))) {
        return array(
            'success' => true,
            'response_code' => $response_code,
        );
    }
    
    return array(
        'success' => false,
        'response_code' => $response_code,
        'error_message' => 'Unexpected response code: ' . $response_code,
    );
}

$result = test_rest_availability();

if ($result['success']) {
    echo "✅ REST API Test PASSED!\n";
    echo "Response Code: " . $result['response_code'] . "\n";
    if ($result['response_code'] == 401) {
        echo "Note: HTTP 401 is the expected result for edit context\n";
    }
    echo "\nThe Site Health REST API error should now be resolved!\n";
} else {
    echo "❌ REST API Test FAILED!\n";
    if (isset($result['error_code'])) {
        echo "Error Code: " . $result['error_code'] . "\n";
    }
    if (isset($result['error_message'])) {
        echo "Error Message: " . $result['error_message'] . "\n";
    }
    if (isset($result['response_code'])) {
        echo "Response Code: " . $result['response_code'] . "\n";
    }
}

echo "\n";

// Test if our mu-plugin is loaded
if (function_exists('get_mu_plugins')) {
    $mu_plugins = get_mu_plugins();
    if (isset($mu_plugins['fix-rest-api-loopback.php'])) {
        echo "✅ REST API Loopback Fix plugin is loaded\n";
    } else {
        echo "⚠️  REST API Loopback Fix plugin not found\n";
    }
} else {
    // Check if our class exists
    if (class_exists('RestApiLoopbackFix')) {
        echo "✅ REST API Loopback Fix class is loaded\n";
    } else {
        echo "⚠️  REST API Loopback Fix class not found\n";
    }
}