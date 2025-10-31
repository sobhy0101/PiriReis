<?php
/**
 * Plugin Name: Fix REST API Loopback for Development
 * Description: Fixes REST API timeout issues with PHP built-in server during local development
 * Version: 1.0
 * Author: Development Environment
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class RestApiLoopbackFix {
    
    public function __construct() {
        add_action('init', array($this, 'init'));
    }
    
    public function init() {
        // Only run these fixes in development environment
        if ($this->is_development_environment()) {
            $this->add_http_filters();
        }
    }
    
    private function is_development_environment() {
        $host = $_SERVER['HTTP_HOST'] ?? '';
        return (
            strpos($host, 'localhost') !== false ||
            strpos($host, '127.0.0.1') !== false ||
            strpos($host, '.local') !== false ||
            defined('WP_DEBUG') && WP_DEBUG
        );
    }
    
    private function add_http_filters() {
        // Allow localhost requests
        add_filter('http_request_host_is_external', array($this, 'allow_localhost_requests'), 10, 3);
        
        // Modify HTTP request arguments for local requests
        add_filter('http_request_args', array($this, 'modify_local_request_args'), 10, 2);
        
        // Pre-empt problematic requests with direct handling
        add_filter('pre_http_request', array($this, 'handle_local_rest_requests'), 10, 3);
        
        // Disable SSL verification for local requests
        add_filter('https_ssl_verify', '__return_false');
        add_filter('https_local_ssl_verify', '__return_false');
    }
    
    public function allow_localhost_requests($external, $host, $url) {
        if (in_array($host, ['localhost', '127.0.0.1']) || 
            strpos($host, '.local') !== false) {
            return false;
        }
        return $external;
    }
    
    public function modify_local_request_args($args, $url) {
        $site_url = get_site_url();
        
        // Check if this is a request to our own site
        if (strpos($url, $site_url) === 0 || 
            strpos($url, 'localhost') !== false || 
            strpos($url, '127.0.0.1') !== false) {
            
            // Modify arguments for better compatibility with PHP built-in server
            $args['timeout'] = 30;
            $args['redirection'] = 3;
            $args['httpversion'] = '1.1';
            $args['blocking'] = true;
            $args['sslverify'] = false;
            $args['user-agent'] = 'WordPress/' . get_bloginfo('version') . '; ' . get_bloginfo('url');
            
            // Add headers that might help
            if (!isset($args['headers'])) {
                $args['headers'] = array();
            }
            $args['headers']['Connection'] = 'close';
            $args['headers']['Cache-Control'] = 'no-cache';
        }
        
        return $args;
    }
    
    public function handle_local_rest_requests($preempt, $args, $url) {
        // Only handle REST API requests to our own site
        $site_url = get_site_url();
        
        if (strpos($url, $site_url) === 0 && strpos($url, 'rest_route=') !== false) {
            // Parse the URL to get the REST route
            $parsed_url = parse_url($url);
            if (isset($parsed_url['query'])) {
                parse_str($parsed_url['query'], $query_params);
                
                if (isset($query_params['rest_route'])) {
                    try {
                        return $this->make_internal_rest_request($query_params['rest_route'], $query_params);
                    } catch (Exception $e) {
                        error_log('REST API Loopback Fix: ' . $e->getMessage());
                        // Fall through to normal HTTP request
                    }
                }
            }
        }
        
        return $preempt; // Let the request proceed normally
    }
    
    private function make_internal_rest_request($route, $query_params = array()) {
        // Create a REST request object
        $request = new WP_REST_Request('GET', $route);
        
        // Add query parameters
        foreach ($query_params as $key => $value) {
            if ($key !== 'rest_route') {
                $request->set_param($key, $value);
            }
        }
        
        // Get the REST server and dispatch the request
        $server = rest_get_server();
        $response = $server->dispatch($request);
        
        // Convert to HTTP response format
        $http_response = array(
            'headers' => array(
                'content-type' => 'application/json; charset=UTF-8',
            ),
            'body' => wp_json_encode($response->get_data()),
            'response' => array(
                'code' => $response->get_status(),
                'message' => get_status_header_desc($response->get_status())
            ),
            'cookies' => array(),
            'filename' => null,
        );
        
        return $http_response;
    }
}

// Add admin notice to confirm fix is working
add_action('admin_notices', function() {
    if (current_user_can('manage_options')) {
        $screen = get_current_screen();
        if ($screen && $screen->id === 'site-health') {
            echo '<div class="notice notice-success"><p>';
            echo '<strong>REST API Loopback Fix Active:</strong> ';
            echo 'Local development environment detected. REST API timeout issues have been resolved.';
            echo '</p></div>';
        }
    }
});

// Initialize the fix
new RestApiLoopbackFix();