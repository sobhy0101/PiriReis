<?php
/**
 * Test script to verify REST API functionality
 * Run this to check if the REST API timeout issue is resolved
 */

// Test the REST API endpoint that was failing
$test_url = "http://localhost:8000/index.php?rest_route=%2Fwp%2Fv2%2Ftypes%2Fpost&context=edit";

echo "Testing REST API endpoint: $test_url\n";
echo "===========================================\n";

// Use cURL to test the endpoint
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $test_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
curl_setopt($ch, CURLOPT_HEADER, true);

$start_time = microtime(true);
$response = curl_exec($ch);
$end_time = microtime(true);

$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curl_error = curl_error($ch);
$response_time = round(($end_time - $start_time) * 1000, 2);

curl_close($ch);

echo "Response Time: {$response_time}ms\n";
echo "HTTP Status Code: $http_code\n";

if ($curl_error) {
    echo "cURL Error: $curl_error\n";
} else {
    echo "Success: No cURL errors\n";
}

if ($http_code === 200 || $http_code === 401) {
    echo "✅ REST API is working correctly!\n";
    echo "Note: HTTP 401 is expected for edit context without authentication\n";
} else {
    echo "❌ REST API has issues\n";
}

echo "\nResponse Headers:\n";
echo "================\n";
$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
if ($response) {
    $headers = substr($response, 0, strpos($response, "\r\n\r\n"));
    echo $headers . "\n";
}