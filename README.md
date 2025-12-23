# Phoenix Admin - User Management System

System zarządzania użytkownikami oparty na architekturze mikroserwisowej:
- **Backend**: Elixir (Phoenix Framework) jako API JSON z bazą PostgreSQL.
- **Frontend**: PHP (Symfony Framework) jako interfejs użytkownika (Bootstrap 5).

## 🚀 Wymagania
- Docker i Docker Compose
- PHP 8.4, composer, mix (dla Phoenix)

## 📦 Instalacja i uruchomienie

1. **Sklonuj repozytorium**
   ```bash
   git clone https://github.com/b-rachmatul/Elixir-Phoenix-PHP-Symfony.git
   cd symfony-app
   composer install
   w .env lub .env.local dodać PHOENIX_API_URL=http://web:4000
   cd ../phoenix-api
   mix deps.get
   ```

   web to nazwa kontenera, a 4000 to port na którym nasłuchuje Phoenix

2. Uruchom kontenery
W celu uruchomienia buildu kontenerów trzeba uruchomić
```bash

docker-compose up -d --build

```

Komenda 
```bash
docker-compose up --abort-on-container-exit
```
uruchomi kontenery, parametr --abort-on-container-exit, jest bezpiecznikiem, jeżeli jakiś kontener będzie miał błąd całość się nie uruchomi

3. Dostęp do apikacji

    - Frontend (Symfony): http://localhost:8080

    - Backend API (Phoenix): http://localhost:4000/api/users

Import danych, każde wywołanie 
```bash
curl -X POST http://localhost:4000/api/import
```
doda 100 nowych użytkowników

4. Przykładowe akcje curl dla Phoenix Api
Akcja	Przykład curl
Paginacja	curl "http://localhost:4000/api/users?page=2&page_size=10"
Szczegóły	curl http://localhost:4000/api/users/1
Tworzenie	curl -X POST http://localhost:4000/api/users -H "Content-Type: application/json" -d '{"user": {"first_name": "Adam", "last_name": "Mix", "gender": "male" "birthdate": "1995-05-05"}}'
Edycja	curl -X PUT http://localhost:4000/api/users/1 -H "Content-Type: application/json" -d '{"user": {"first_name": "Zmienione"}}'
Usuwanie	curl -X DELETE http://localhost:4000/api/users/1


Dodatkowe rzeczy
🛠 Architektura

    DTO (Data Transfer Object): Komunikacja Symfony -> API odbywa się przez klasę UserDto, co zapewnia spójność typów.

    Filtering & Pagination: Paginacja odbywa się po stronie bazy danych w Elixirze (scry_paginate), co gwarantuje wydajność przy dużej ilości danych.

📁 Struktura projektu

    /lib - Kod źródłowy Phoenixa (Logic & API)

    /src - Kod źródłowy Symfony (Controllers & Services)

    /templates - Widoki Twig (UI)

