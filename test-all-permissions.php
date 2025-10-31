<?php
/**
 * Comprehensive WordPress Filesystem Test
 * Tests all critical directories for WordPress updates and file operations
 */

define('WP_USE_THEMES', false);
require_once(__DIR__ . '/website/wp-load.php');

echo "WordPress Filesystem Permissions Test\n";
echo "=====================================\n\n";

// Test directories
$test_dirs = array(
    'wp-content' => WP_CONTENT_DIR,
    'uploads' => WP_CONTENT_DIR . '/uploads',
    'plugins' => WP_CONTENT_DIR . '/plugins',
    'themes' => WP_CONTENT_DIR . '/themes',
    'upgrade' => WP_CONTENT_DIR . '/upgrade',
);

$all_passed = true;

foreach ($test_dirs as $name => $path) {
    echo "Testing $name directory: $path\n";
    
    if (!is_dir($path)) {
        echo "  ❌ Directory does not exist\n";
        $all_passed = false;
        continue;
    }
    
    $tests_passed = 0;
    $total_tests = 3;
    
    // Test 1: Readable
    if (is_readable($path)) {
        echo "  ✅ Readable\n";
        $tests_passed++;
    } else {
        echo "  ❌ Not readable\n";
        $all_passed = false;
    }
    
    // Test 2: Writable
    if (is_writable($path)) {
        echo "  ✅ Writable\n";
        $tests_passed++;
    } else {
        echo "  ❌ Not writable\n";
        $all_passed = false;
    }
    
    // Test 3: Can create and delete files
    $test_file = $path . '/wp-permissions-test-' . time() . '.tmp';
    if (file_put_contents($test_file, 'test') !== false) {
        if (unlink($test_file)) {
            echo "  ✅ File operations work\n";
            $tests_passed++;
        } else {
            echo "  ❌ Can create but not delete files\n";
            $all_passed = false;
        }
    } else {
        echo "  ❌ Cannot create files\n";
        $all_passed = false;
    }
    
    echo "  Result: $tests_passed/$total_tests tests passed\n\n";
}

echo "WordPress Filesystem API Test\n";
echo "=============================\n";

// Initialize WordPress filesystem
global $wp_filesystem;
if (empty($wp_filesystem)) {
    require_once(ABSPATH . '/wp-admin/includes/file.php');
    WP_Filesystem();
}

if ($wp_filesystem) {
    echo "✅ WordPress Filesystem API initialized\n";
    
    // Test upgrade directory specifically
    if ($wp_filesystem->is_writable(WP_CONTENT_DIR . '/upgrade')) {
        echo "✅ WordPress confirms upgrade directory is writable\n";
    } else {
        echo "❌ WordPress says upgrade directory is not writable\n";
        $all_passed = false;
    }
} else {
    echo "❌ Could not initialize WordPress Filesystem API\n";
    $all_passed = false;
}

echo "\nSite Health Compatibility Test\n";
echo "==============================\n";

// Simulate what Site Health checks
$site_health_checks = array();

// Check if WordPress can write to wp-content
if (wp_is_writable(WP_CONTENT_DIR)) {
    $site_health_checks['wp_content_writable'] = true;
    echo "✅ wp-content directory is writable\n";
} else {
    $site_health_checks['wp_content_writable'] = false;
    echo "❌ wp-content directory is not writable\n";
    $all_passed = false;
}

// Check upgrade directory specifically
if (is_dir(WP_CONTENT_DIR . '/upgrade') && wp_is_writable(WP_CONTENT_DIR . '/upgrade')) {
    $site_health_checks['upgrade_writable'] = true;
    echo "✅ upgrade directory exists and is writable\n";
} else {
    $site_health_checks['upgrade_writable'] = false;
    echo "❌ upgrade directory has issues\n";
    $all_passed = false;
}

echo "\nOverall Result\n";
echo "==============\n";

if ($all_passed) {
    echo "🎉 ALL TESTS PASSED!\n";
    echo "✅ WordPress file permissions are correctly configured\n";
    echo "✅ Plugin and theme updates should work properly\n";
    echo "✅ Site Health should no longer show upgrade directory errors\n";
} else {
    echo "❌ Some tests failed. Check the output above for details.\n";
}

echo "\nYou can now check Site Health at: http://localhost:8000/wp-admin/site-health.php\n";