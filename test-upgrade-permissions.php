<?php
/**
 * Test WordPress Upgrade Directory Write Permissions
 */

define('WP_USE_THEMES', false);
require_once(__DIR__ . '/website/wp-load.php');

echo "Testing WordPress Upgrade Directory Permissions\n";
echo "===============================================\n\n";

$upgrade_dir = WP_CONTENT_DIR . '/upgrade';

echo "Upgrade Directory: $upgrade_dir\n";

// Check if directory exists
if (!is_dir($upgrade_dir)) {
    echo "❌ Directory does not exist\n";
    exit(1);
}

echo "✅ Directory exists\n";

// Check if directory is readable
if (!is_readable($upgrade_dir)) {
    echo "❌ Directory is not readable\n";
} else {
    echo "✅ Directory is readable\n";
}

// Check if directory is writable
if (!is_writable($upgrade_dir)) {
    echo "❌ Directory is not writable\n";
} else {
    echo "✅ Directory is writable\n";
}

// Test creating a file in the directory
$test_file = $upgrade_dir . '/test-write-permissions.txt';
$test_content = "Test file created at " . date('Y-m-d H:i:s');

echo "\nTesting file creation...\n";

if (file_put_contents($test_file, $test_content) !== false) {
    echo "✅ Successfully created test file\n";
    
    // Test reading the file
    if (file_get_contents($test_file) === $test_content) {
        echo "✅ Successfully read test file\n";
        
        // Clean up test file
        if (unlink($test_file)) {
            echo "✅ Successfully deleted test file\n";
        } else {
            echo "⚠️  Warning: Could not delete test file\n";
        }
    } else {
        echo "❌ Could not read test file\n";
    }
} else {
    echo "❌ Could not create test file\n";
    
    // Get more detailed error information
    $error = error_get_last();
    if ($error) {
        echo "Error: " . $error['message'] . "\n";
    }
    
    // Check file permissions in detail
    $perms = fileperms($upgrade_dir);
    echo "Directory permissions: " . substr(sprintf('%o', $perms), -4) . "\n";
}

echo "\nTesting WordPress filesystem functions...\n";

// Test WordPress filesystem
global $wp_filesystem;
if (empty($wp_filesystem)) {
    require_once(ABSPATH . '/wp-admin/includes/file.php');
    WP_Filesystem();
}

if ($wp_filesystem->is_writable($upgrade_dir)) {
    echo "✅ WordPress filesystem reports directory as writable\n";
} else {
    echo "❌ WordPress filesystem reports directory as NOT writable\n";
}

// Test WordPress temporary file creation
$temp_file = wp_tempnam('upgrade-test');
if ($temp_file) {
    echo "✅ WordPress can create temporary files\n";
    if (file_exists($temp_file)) {
        unlink($temp_file);
    }
} else {
    echo "❌ WordPress cannot create temporary files\n";
}

echo "\nPermissions test completed.\n";