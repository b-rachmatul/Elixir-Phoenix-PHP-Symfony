<?php

namespace App\Dto;

use Symfony\Component\Validator\Constraints as Assert;

class UserDto
{
    public ?int $id = null;

    #[Assert\NotBlank]
    public ?string $firstName = null;

    #[Assert\NotBlank]
    public ?string $lastName = null;

    #[Assert\NotBlank]
    public ?string $gender = null; // 'male', 'female'

    #[Assert\NotBlank]
    #[Assert\Date]
    public ?string $birthDate = null;

    public static function fromArray(array $data): self
    {
        $dto = new self();
        $dto->id = $data['id'] ?? null;
        $dto->firstName = $data['first_name'] ?? null;
        $dto->lastName = $data['last_name'] ?? null;
        $dto->gender = $data['gender'] ?? null;
        $dto->birthDate = $data['birthdate'] ?? null;
        return $dto;
    }

    public function toArray(): array
    {
        return [
            'first_name' => $this->firstName,
            'last_name' => $this->lastName,
            'gender' => $this->gender,
            'birthdate' => $this->birthDate,
        ];
    }
}