<?php
session_start();
$connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'public_user', 'public_user');
?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Ticketxpert</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/js/splide.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/css/splide.min.css" rel="stylesheet">
  <style>
    * {
      font-family: Work Sans, 'sans-serif'
    }
  </style>
</head>

<body>
  <?php require './components/headerComponent.php' ?>
  <main class="min-h-[100vh]">
    <?php require './components/homepageCoverCarouselComponent.php' ?>
    <?php require './components/eventSectionComponent.php' ?>
  </main>
  <?php require './components/footerComponent.php' ?>
</body>

</html>