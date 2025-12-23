<?php

namespace App\Tests\Dto;

use App\Dto\UserDto;
use PHPUnit\Framework\TestCase;

class UserDtoTest extends TestCase
{
    /**
     * Testuje, czy dane z API Phoenix (snake_case) 
     * są poprawnie mapowane na właściwości DTO (camelCase).
     */
    public function testFromArrayMapping(): void
    {
        $apiData = [
            'id' => 123,
            'first_name' => 'Jan',
            'last_name' => 'Kowalski',
            'gender' => 'male',
            'birthdate' => '1990-05-15'
        ];

        $dto = UserDto::fromArray($apiData);

        $this->assertEquals(123, $dto->id);
        $this->assertEquals('Jan', $dto->firstName);
        $this->assertEquals('Kowalski', $dto->lastName);
        $this->assertEquals('male', $dto->gender);
        $this->assertEquals('1990-05-15', $dto->birthDate);
    }

    /**
     * Testuje, czy obiekt DTO poprawnie przygotowuje dane 
     * do wysyłki powrotnej do API (format oczekiwany przez Ecto).
     */
    public function testToArrayMapping(): void
    {
        $dto = new UserDto();
        $dto->id = 1;
        $dto->firstName = 'Anna';
        $dto->lastName = 'Nowak';
        $dto->gender = 'female';
        $dto->birthDate = '1995-10-20';

        $result = $dto->toArray();

        $this->assertArrayHasKey('first_name', $result);
        $this->assertEquals('Anna', $result['first_name']);
        
        $this->assertArrayHasKey('birthdate', $result);
        $this->assertEquals('1995-10-20', $result['birthdate']);
        
        // ID nie powinno być w toArray, bo zazwyczaj przesyłamy je w URL, 
        // a Phoenix oczekuje w body tylko pól modelu.
        $this->assertArrayNotHasKey('id', $result);
    }

    /**
     * Testuje zachowanie przy brakujących danych (null safety).
     */
    public function testFromEmptyArray(): void
    {
        $dto = UserDto::fromArray([]);

        $this->assertNull($dto->id);
        $this->assertNull($dto->firstName);
        $this->assertNull($dto->lastName);
    }
}