<?php

namespace App\Controller;

use App\Dto\UserDto;
use App\Form\UserType;
use App\Service\PhoenixApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpKernel\Exception\UnprocessableEntityHttpException;

class UserController extends AbstractController
{
    public function __construct(private PhoenixApiClient $apiClient) {}

    #[Route('/', name: 'user_index', methods: ['GET'])]
    public function index(Request $request): Response
    {
        // Filtrowanie i sortowanie z Query Params
        $filters = [
            'first_name' => $request->query->get('first_name'),
            'last_name'  => $request->query->get('last_name'),
            'gender'     => $request->query->get('gender'),
            'start_date' => $request->query->get('start_date'),
            'end_date'   => $request->query->get('end_date'),
            'sort'       => $request->query->get('sort', 'id'),
            'direction'  => $request->query->get('direction', 'asc'),
            'page'       => $request->query->get('page', 1),
        ];

        $result = $this->apiClient->getUsers($filters);

        return $this->render('user/index.html.twig', [
            'users' => $result['entries'], 
            'meta' => $result['meta'],
            'filters' => $filters
        ]);
    }

    #[Route('/user/new', name: 'user_new', methods: ['GET', 'POST'])]
    #[Route('/user/{id}/edit', name: 'user_edit', methods: ['GET', 'POST'])]
    public function form(Request $request, ?int $id = null): Response
    {
        $userDto = $id ? $this->apiClient->getUser($id) : new UserDto();
        $form = $this->createForm(UserType::class, $userDto);
        
        $form->handleRequest($request);
        try {
            if ($form->isSubmitted() && $form->isValid()) {
                $this->apiClient->save($userDto);
                $this->addFlash('success', 'Użytkownik zapisany!');
                return $this->redirectToRoute('user_index');
            }
        } catch (UnprocessableEntityHttpException $e) {
            $apiErrors = json_decode($e->getMessage(), true);
    
            foreach ($apiErrors as $field => $messages) {
            // Mapowanie nazw pól z API (snake_case) na pola Symfony (camelCase)
            $formField = $this->mapApiFieldToFormField($field);
        
                foreach ($messages as $message) {
                    if ($form->has($formField)) {
                        $form->get($formField)->addError(new FormError($message));
                    } else {
                        $form->addError(new FormError("$field: $message")); // Błąd ogólny
                    }
                }
            }
        }
    
        return $this->render('user/form.html.twig', [
            'form' => $form->createView(),
            'is_edit' => $id !== null
        ]);
    }
        
    private function mapApiFieldToFormField(string $apiField): string {
        return match($apiField) {
            'first_name' => 'firstName',
            'last_name' => 'lastName',
            'birthdate' => 'birthDate',
            default => $apiField
        };
    }

    #[Route('/user/{id}/delete', name: 'user_delete', methods: ['POST'])]
    public function delete(int $id): Response
    {
        $this->apiClient->delete($id);
    
        // To wywoła zielony pasek sukcesu dzięki nowemu base.html.twig
        $this->addFlash('success', 'Użytkownik został pomyślnie usunięty.');
        
        return $this->redirectToRoute('user_index');
    }
}