<?php
session_start();

if (!isset($_SESSION['isLoggedIn'])) {
  header('Location: ./logins/login.php');
  exit();
}

try {
  $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

  if (isset($_GET['transaction_id']) && is_numeric($_GET['transaction_id'])) {
    $transaction_id = intval($_GET['transaction_id']);

    $transaction_details = $connection->query("SELECT users.user.name AS user_name, ticket.*, amount, event.name, event.portrait_image_url FROM transactions.transaction
    JOIN users.user ON transaction.attendee_id = users.user.user_id
    JOIN tickets.ticket ON transaction.ticket_id = ticket.ticket_id
    JOIN events.event ON ticket.event_id = event.event_id
    WHERE transaction_id = $transaction_id")->fetch(PDO::FETCH_ASSOC);

    $amount = $transaction_details['amount'];
  }
} catch (PDOException $e) {
  echo "Error: " . $e->getMessage();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ticketxpert / Confirmation</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-slate-100">
  <main class="h-[100vh] flex flex-col justify-center">
    <div class="flex flex-row gap-4 mx-auto w-full max-w-xl items-center justify-center rounded-lg bg-white my-4 text-slate-700 py-4 shadow-md">
      <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 512 512"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
        <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" fill="currentColor" />
      </svg>
      <h1 class="font-[900] text-4xl">Transaction confirmation</h1>
    </div>
    <form class="flex flex-col p-4 bg-white rounded-lg drop-shadow-xl gap-1 max-w-xl mx-auto">
      <img src="./qrcode.png" class="rounded-lg w-full" />
      <p class="text-slate-600">Please scan the QR code in your GCash app and pay, enter the reference number of the transaction after paying.</p>
      <input type="text" maxlength="16" name="ticket_promo" placeholder="Reference Number" class="mt-1 block p-4 text-slate-800 bg-white w-full border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
      <div class="flex flex-row gap-2">
        <a href="/index.php" class="mt-1 block w-full p-4 text-slate-800 hover:bg-slate-800 hover:text-slate-50 transition-all delay-0 duration-250 ease-in-out bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500 text-center">Cancel</a>
        <input type="submit" value="Confirm" class="cursor-pointer mt-1 block w-full p-4 text-slate-800 hover:bg-slate-800 hover:text-slate-50 transition-all delay-0 duration-250 ease-in-out bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
      </div>
    </form>

  </main>
</body>

</html>