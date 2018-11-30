<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class LuckyController extends AbstractController
{
    /**
     * @Route("/api/welcome")
     */
    public function number()
    {
        $number = random_int(0, 100);

        return new JsonResponse(
            array(
                "title" => "Docker Nginx PHP Mysql template (backend)",
                "lucky number" => $number
            )
        );
    }
}
