<?php

namespace App\Service;

use App\Dto\UserDto;
use Symfony\Contracts\HttpClient\HttpClientInterface;
use Symfony\Component\HttpKernel\Exception\UnprocessableEntityHttpException;

class PhoenixApiClient
{
    public function __construct(
        private HttpClientInterface $phoenixClient //Konfiguracja w framework.yaml
    ) {}

    public function getUsers(array $filters = []): array
    {
        if (isset($filters['sort'])) {
            $filters['sort_by'] = $filters['sort'];
            unset($filters['sort']);
        }
        if (isset($filters['direction'])) {
            $filters['sort_order'] = $filters['direction'];
            unset($filters['direction']);
        }

        $response = $this->phoenixClient->request('GET', '/api/users', [
            'query' => array_filter($filters, fn($value) => $value !== null && $value !== '')
        ]);

        $data = $response->toArray();

        return [
            'entries' => array_map(fn($u) => UserDto::fromArray($u), $data['data']),
            'meta' => $data['meta']
        ];
    }

    public function getUser(int $id): UserDto
    {
        $response = $this->phoenixClient->request('GET', "/api/users/$id");
        return UserDto::fromArray($response->toArray()['data']);
    }

    public function save(UserDto $user): void
    {
        $method = $user->id ? 'PUT' : 'POST';
        $url = $user->id ? "/api/users/{$user->id}" : '/api/users';

        $response = $this->phoenixClient->request($method, $url, [
            'json' => [
                'user' => $user->toArray()
            ]
        ]);
        $statusCode = $response->getStatusCode();
        if ($statusCode === 422) {
            throw new UnprocessableEntityHttpException(json_encode($response->toArray()['errors']));
        }

        if ($statusCode >= 400) {
            throw new \Exception("Błąd API: " . $statusCode);
        }
    }

    public function delete(int $id): void
    {
        $this->phoenixClient->request('DELETE', "/api/users/$id");
    }
}