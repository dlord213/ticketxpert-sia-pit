<?php
session_start();

if (!isset($_SESSION['isLoggedIn'])) {
  header('Location: ../index.php');
  exit();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ticketxpert / Profile</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    * {
      font-family: Work Sans, 'sans-serif'
    }
  </style>
</head>

<body>
  <?php include './components/headerComponent.php' ?>
  <main class="min-h-[100vh] max-w-7xl mx-auto">
    <div class="flex flex-col my-8 bg-white rounded-lg text-slate-800">
      <div class="flex flex-row justify-between items-center">
        <h1 class="text-4xl font-[700]"><?php echo $_SESSION['name'] ?></h1>
        <div class="flex flex-row gap-6">
          <div class="flex flex-col">
            <h1 class="text-lg text-slate-600 font-[700]">Phone Number</h1>
            <p><?php echo $_SESSION['contact_number'] ?></p>
          </div>
          <div class="flex flex-col">
            <h1 class="text-lg text-slate-600 font-[700]">Address</h1>
            <p><?php echo $_SESSION['address'] ?></p>
          </div>
        </div>
      </div>
    </div>
    <hr class="w-full bg-slate-700 my-4 border-slate-700">
    <h1 class="text-2xl text-slate-800 font-[300]">Unpaid Tickets / Transactions</h1>
    <?php
    $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

    $transactions = $connection->query("SELECT transaction_id, ticket.*, event.name, event.portrait_image_url, transaction_date, transaction.amount AS ticket_amount FROM transactions.transaction
    JOIN users.user ON transaction.attendee_id = users.user.user_id
    JOIN tickets.ticket ON transaction.ticket_id = ticket.ticket_id
    JOIN events.event ON ticket.event_id = event.event_id
    WHERE attendee_id = " . $_SESSION['user_id'] . " AND is_confirmed = false")->fetchAll(PDO::FETCH_ASSOC);

    if ($transactions) {
      foreach ($transactions as $transaction) {
        echo "
      <a href='./buy_confirmation.php?transaction_id=" . $transaction['transaction_id'] . "' class='group relative block'>
        <div class='relative p-4 rounded-lg my-4 flex flex-row gap-4 transition-all delay-0 duration-250 ease-in-out'>
          <img src='" . htmlspecialchars($transaction['portrait_image_url']) . "' class='absolute w-full top-0 left-0 h-full object-cover rounded-lg -z-10 brightness-50 bg-center'>
          <div class='flex flex-col'>
            <h1 class='text-slate-100 font-[700] text-4xl'>" . htmlspecialchars($transaction['name']) . "</h1>
            <h1 class='text-slate-300'>" . htmlspecialchars($transaction['location']) . "</h1>
            <h1 class='text-slate-300'>" . htmlspecialchars(date_format(date_create($transaction['transaction_date']), "M d, Y (g:i A)")) . "</h1>
            <h1 class='text-slate-300'>Tickets: " . htmlspecialchars($transaction['ticket_amount']) . "</h1>
          </div>
        </div>
        <div class='absolute inset-0 flex flex-col items-center justify-center bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-lg'>
        <span class='text-white text-lg font-bold'>CLICK TO PAY FOR THIS TICKET</span>
        <span class='text-slate-200 text-lg'>You have a day to pay for this ticket.</span>
        </div>
      </a>";
      }
    } else {
      echo "<h1 class='text-lg text-slate-700 my-2'>No tickets bought/confirmed.</h1>";
    }

    ?>
    <h1 class="text-2xl text-slate-800 font-[300]">Confirmed Tickets / Transactions</h1>
    <?php
    $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

    $transactions = $connection->query("SELECT ticket.*, event.name, event.portrait_image_url, transaction_date, transaction.amount AS ticket_amount FROM transactions.transaction
    JOIN users.user ON transaction.attendee_id = users.user.user_id
    JOIN tickets.ticket ON transaction.ticket_id = ticket.ticket_id
    JOIN events.event ON ticket.event_id = event.event_id
    WHERE attendee_id = " . $_SESSION['user_id'] . " AND is_confirmed = true")->fetchAll(PDO::FETCH_ASSOC);

    if ($transactions) {
      foreach ($transactions as $transaction) {
        echo "<div class='relative p-4 rounded-lg my-4 flex flex-row gap-4 transition-all delay-0 duration-250 ease-in-out'>
        <img src=" . $transaction['portrait_image_url'] . " class='absolute w-full top-0 left-0 h-full object-cover rounded-lg -z-10 brightness-50'>
        <div class='flex flex-col'>
          <h1 class='text-slate-100 font-[700] text-4xl'>" . $transaction['name'] . "</h1>
          <h1 class='text-slate-300'>" . $transaction['location'] . "</h1>
          <h1 class='text-slate-300'>" . date_format(date_create($transaction['transaction_date']), "M d, Y (g:i A)") . "</h1>
          <h1 class='text-slate-300'>Tickets: " . $transaction['ticket_amount'] . "</h1>
        </div>
      </div>";
      }
    } else {
      echo "<h1 class='text-lg text-slate-700 my-2'>No tickets bought/confirmed.</h1>";
    }
    ?>
  </main>
  <?php include './components/footerComponent.php' ?>
</body>

</html>