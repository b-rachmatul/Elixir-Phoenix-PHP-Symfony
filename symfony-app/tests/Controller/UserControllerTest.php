<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use App\Service\PhoenixApiClient;
use App\Dto\UserDto;

class UserControllerTest extends WebTestCase
{
    public function testIndexPageIsSuccessful(): void
    {
        $client = static::createClient();
        
        // Symulujemy wejście na stronę główną
        $crawler = $client->request('GET', '/user/');

        $this->assertResponseIsSuccessful();
        $this->assertSelectorTextContains('h1', 'Zarządzanie Użytkownikami');
    }

    public function testAddNewUserForm(): void
    {
        $client = static::createClient();
        $crawler = $client->request('GET', '/user/new');

        // Sprawdzamy czy formularz ma odpowiednie pola
        $this->assertSelectorExists('form');
        
        // Wypełniamy formularz
        $form = $crawler->selectButton('Zapisz użytkownika')->form([
            'user[firstName]' => 'TestoweImie',
            'user[lastName]'  => 'TestoweNazwisko',
            'user[gender]'    => 'male',
            'user[birthDate]' => '1990-01-01',
        ]);

        $client->submit($form);

        // Po udanym zapisie spodziewamy się przekierowania na listę
        $this->assertResponseRedirects('/user/');
    }

    public function testFilterPresence(): void
    {
        $client = static::createClient();
        $client->request('GET', '/user/');

        // Sprawdzamy czy inputs do filtrowania istnieją
        $this->assertSelectorExists('input[name="first_name"]');
        $this->assertSelectorExists('select[name="gender"]');
    }
}