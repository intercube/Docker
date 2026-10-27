# PHP CLI build images

These images extend Chialab's PHP CLI images with FTP and FTPS for Composer and
Magento build steps. They preserve the base image's extensions, Composer, entry
point and support for GoCD's arbitrary non-root user. They are separate from the
older PHP-FPM development image in this repository.

`images.json` lists the PHP versions used by the active GoCD configurations on
27 October 2026: 7.4 and 8.0–8.5. Each build pulls the current Chialab tag for that
PHP minor version. Legacy
versions are included for existing projects; this does not change their PHP
support lifecycle or the PHP versions a particular Magento release supports.

## Build and test

```bash
base_image=$(jq -r '.images[] | select(.version == "8.4") | .baseImage' php-cli/images.json)
docker build --build-arg "BASE_IMAGE=$base_image" -t intercube-php-cli:test php-cli
bash php-cli/test-image.sh intercube-php-cli:test "$base_image" 8.4
```

Pull requests build and test every listed version without publishing. Changes
merged to `master` publish tested `linux/amd64` images to
`ghcr.io/intercube/docker/php-cli`, matching the current GoCD runner architecture.
Build pipelines use version-specific moving tags such as
`ghcr.io/intercube/docker/php-cli:8.4-latest`. Every published image also gets a
unique tag containing the PHP version, source commit, workflow run and attempt
for diagnostics and rollback. These are build images and do not configure the
PHP runtime on hosting servers.

## Nexus rollout

1. Verify the published image can be pulled by the GoCD agents.
2. In Nexus, create project overrides for every PHP build step of the initial
   development project: Composer install, dependency compilation and static
   content deployment. Preserve the task, ordering and working directory.
3. Set each override's Docker image to the same PHP version's `-latest` tag.
   Nexus pulls Intercube PHP CLI `-latest` images before use, so cached images do
   not prevent published updates reaching build agents.
   Synchronize that project's template through Nexus; do not hand-edit its
   generated GoCD JSON, which Nexus would overwrite on the next sync.
4. Run the development pipeline and verify Composer, Magento compilation, release
   artifact upload, deployment and the site's response. Also verify FTP in the
   target server's PHP CLI separately; the build image does not change hosting.
5. After the pilot succeeds, migrate shared defaults and existing image overrides
   deliberately. Preserve custom third-party images and each project's PHP
   version. Retain the previous image reference for rollback.

Keep Composer's platform checks enabled and keep the application's lock file.
Additional extensions should come from a demonstrated application requirement,
with matching image checks, rather than bypassing Composer requirements.

## Updates

Run the PHP CLI build workflow on `master` to refresh from Chialab's current
version-specific tags. A version's compatibility checks must pass before its
`-latest` tag is published. Existing pipelines using that tag receive the updated
image on their next build. For an image regression, switch the affected project's
build steps to the previous run's unique image tag while investigating.

Adding a PHP version or changing image behavior requires a reviewed change and
the complete version matrix to pass. Check application lock files as part of the
development rollout; the smoke fixture checks FTP without downloading Magento.
