<?php
/**
 * Clear Site Health Cache and Force Re-test
 */

define('WP_USE_THEMES', false);
require_once(__DIR__ . '/website/wp-load.php');

echo "Clearing Site Health Cache\n";
echo "==========================\n\n";

// Clear any cached site health results
delete_transient('health-check-site-status-result');
delete_option('_site_transient_health-check-site-status-result');

// Clear any REST API related transients
global $wpdb;
$wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_transient_health-check%'");
$wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_site_transient_health-check%'");

echo "✅ Cleared all Site Health transients and cache\n\n";

// Force a fresh REST API test
echo "Running Fresh REST API Test\n";
echo "===========================\n";

// Simulate the exact WordPress Site Health test
$url = home_url('index.php?rest_route=%2Fwp%2Fv2%2Ftypes%2Fpost&context=edit');
$start_time = microtime(true);

$response = wp_remote_get($url, array(
    'timeout' => 10,
    'user-agent' => 'WordPress/' . get_bloginfo('version') . '; ' . home_url(),
));

$end_time = microtime(true);
$elapsed = round(($end_time - $start_time) * 1000, 2);

echo "Test URL: $url\n";
echo "Elapsed Time: {$elapsed}ms\n";

if (is_wp_error($response)) {
    echo "❌ FAILED: " . $response->get_error_message() . "\n";
    $error_data = $response->get_error_data();
    if ($error_data) {
        echo "Error Data: " . print_r($error_data, true) . "\n";
    }
} else {
    $response_code = wp_remote_retrieve_response_code($response);
    $response_message = wp_remote_retrieve_response_message($response);
    
    echo "✅ SUCCESS: HTTP {$response_code} {$response_message}\n";
    
    if (in_array($response_code, [200, 401])) {
        echo "🎉 Site Health REST API test should now PASS!\n";
    }
}

echo "\nNow visit the Site Health page to see the updated results:\n";
echo "http://localhost:8000/wp-admin/site-health.php\n";