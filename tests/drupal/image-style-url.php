<?php

/**
 * @file
 * Prints the relative URL of an image style derivative, with its token.
 *
 * Usage: php image-style-url.php <style> <source uri>
 */

use Drupal\Core\DrupalKernel;
use Drupal\image\Entity\ImageStyle;
use Symfony\Component\HttpFoundation\Request;

chdir('/opt/drupal/web');
$autoloader = require 'autoload.php';
$request = Request::create('/');
$kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod');
$kernel->boot();
$kernel->preHandle($request);

$url = ImageStyle::load($argv[1])->buildUrl($argv[2]);
echo \Drupal::service('file_url_generator')->transformRelative($url);
