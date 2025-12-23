# Wybieramy obraz PHP 8.4 z FPM (FastCGI Process Manager)
FROM php:8.4-fpm-alpine

# Instalacja zależności systemowych i narzędzi
RUN apk add --no-cache \
    git \
    icu-dev \
    libpq-dev \
    libzip-dev \
    unzip \
    zlib-dev \
    bash

# Instalacja i konfiguracja rozszerzeń PHP
RUN docker-php-ext-configure intl \
    && docker-php-ext-install \
    intl \
    pdo \
    pdo_pgsql \
    zip \
    opcache

# Instalacja Composera z oficjalnego obrazu
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Ustawienie katalogu roboczego
WORKDIR /var/www/symfony

# Instalacja Symfony CLI (opcjonalnie, ale przydatne do serwera lokalnego)
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Expose portu dla FPM
EXPOSE 9000

CMD ["php-fpm"]