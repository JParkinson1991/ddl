<?php
/**
 * @file
 * bootstrap.php
 *
 * Responsible for loading environment variables etc.
 */

use Dotenv\Dotenv;

// Safely load any defined environment variables
// .env file should sit along in the project root, the parent directory of 'app'
// Loading will silently fail if .env not found, expected behaviour outside of dev
$dotEnv = Dotenv::createImmutable(dirname(__DIR__));
$dotEnv->safeLoad();

// Validate environment variables
$dotEnv->required('APP_ENV')->allowedValues(['dev', 'prod']);

