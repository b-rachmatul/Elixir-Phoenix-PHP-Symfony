<?php

namespace App\Form;

use App\Dto\UserDto;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\DateType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class UserType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('firstName', TextType::class, ['label' => 'Imię'])
            ->add('lastName', TextType::class, ['label' => 'Nazwisko'])
            ->add('gender', ChoiceType::class, [
                'choices' => ['Mężczyzna' => 'male', 'Kobieta' => 'female'],
                'label' => 'Płeć'
            ])
            ->add('birthDate', TextType::class, [
                'label' => 'Data urodzenia (YYYY-MM-DD)',
                'attr' => ['placeholder' => '1990-01-01']
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => UserDto::class]);
    }
}