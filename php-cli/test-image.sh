#!/usr/bin/env bash
set -euo pipefail

image="${1:?Usage: test-image.sh IMAGE BASE_IMAGE PHP_VERSION}"
base_image="${2:?Base image is required}"
php_version="${3:?PHP minor version is required}"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
chmod 777 "$fixture"

# Keep every extension supplied by Chialab, in addition to FTP and FTPS.
docker run --rm "$base_image" php -r 'echo json_encode(get_loaded_extensions());' > "$fixture/base-extensions.json"
cat > "$fixture/check.php" <<'PHP'
<?php
$expected = json_decode(file_get_contents(__DIR__ . '/base-extensions.json'), true);
$missing = array_diff($expected, get_loaded_extensions());
if ($missing || !extension_loaded('ftp') || !function_exists('ftp_connect') || !function_exists('ftp_ssl_connect')) {
    fwrite(STDERR, 'Missing PHP extensions or FTP functions: ' . implode(', ', $missing) . PHP_EOL);
    exit(1);
}
if (PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION !== $argv[1]) {
    fwrite(STDERR, 'Unexpected PHP version: ' . PHP_VERSION . PHP_EOL);
    exit(1);
}
echo 'PHP ' . PHP_VERSION . ': original extensions, FTP and FTPS available' . PHP_EOL;
PHP
cat > "$fixture/composer.json" <<'JSON'
{
  "name": "intercube/php-build-smoke-test",
  "require": { "ext-ftp": "*" },
  "repositories": [ { "packagist.org": false } ]
}
JSON

# Match GoCD's arbitrary non-root UID, writable source directory and Composer cache.
docker run --rm --user 12345:12345 \
  -e COMPOSER_HOME=/mnt/pipeline/.composer \
  -w /mnt/pipeline -v "$fixture:/mnt/pipeline" \
  "$image" sh -ec 'php check.php "$1"; composer install --no-dev --no-plugins --no-scripts --no-interaction --no-progress; composer check-platform-reqs --no-dev' sh "$php_version"
