<?php
/**
 * @file
 * bootstrap.php
 *
 * Responsible for loading environment variables etc.
 */

use Dotenv\Dotenv;
use DrupalFinder\DrupalFinder;

// Initialise drupal finder
$drupalFinder = new DrupalFinder();
$drupalFinder->locateRoot(__DIR__);

// Safely load any defined environment variables
// .env file should sit along composer.json so create from there
// Loading will silently fail if .env not found, expected behaviour outside of dev
$dotEnv = Dotenv::createImmutable($drupalFinder->getComposerRoot());
$dotEnv->safeLoad();

// Validate environment variables
$dotEnv->required('APP_ENV')->allowedValues(['dev', 'prod']);
