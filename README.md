### [Our images](https://github.com/orgs/intercube/packages?repo_name=Docker)
- Symfony: [`docker.pkg.github.com/intercube/docker/php-fpm:latest`](https://github.com/intercube/Docker/packages/39613)
- Magento 2: [`docker.pkg.github.com/intercube/docker/nginx-magento2:latest`](https://github.com/intercube/Docker/packages/70039)
- WordPress: [`docker.pkg.github.com/intercube/docker/nginx-wordpress:latest`](https://github.com/intercube/Docker/packages/642306)

### Example usage
```yaml
version: '3.7'
services:
    db:
        environment:
            MYSQL_DATABASE: my_database
            MYSQL_PASSWORD: my_password
            MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
            MYSQL_USER: my_user
        image: 'mariadb/server:10.4'
        ports:
            - '3306:3306'
        volumes:
            - 'db-data:/var/lib/mysql'

    php:
        image: 'chialab/php:7.4-fpm'
        links:
            - 'db:localhost.intercube.cloud'
        volumes:
            - './:/var/www/website:cached'

    web:
        image: 'docker.pkg.github.com/intercube/docker/nginx-symfony:latest'
        links:
            - php
        ports:
            - '80:80'
        volumes:
            - './:/var/www/website:cached'
```

And now you can access the web through localhost:80 and the MariaDB database on localhost:3306.  
If you wish to access the database through localhost **and** through your application, set the database host in your application to `localhost.intercube.cloud`.

Example of a complete docker file using .env:
```yaml
version: '3.7'
services:
    db:
        environment:
            MYSQL_DATABASE: ${DATABASE_NAME}
            MYSQL_PASSWORD: ${DATABASE_PASSWORD}
            MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
            MYSQL_USER: ${DATABASE_USERNAME}
        image: 'mariadb/server:10.4'
        ports:
            - '3306:3306'
        volumes:
            - 'db-data:/var/lib/mysql'

    php:
        image: 'chialab/php:7.4-fpm'
        links:
            - 'db:localhost.intercube.cloud'
        volumes:
            - './:/var/www/website:cached'

    web:
        image: 'docker.pkg.github.com/intercube/docker/nginx-symfony:latest'
        links:
            - php
        ports:
            - '80:80'
        volumes:
            - './:/var/www/website:cached'

volumes:
    db-data:
        name: ${PROJECT_NAME}
        external: false
```
