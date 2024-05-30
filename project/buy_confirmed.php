<?php
session_start();

if (!isset($_SESSION['isLoggedIn'])) {
  header('Location: ./logins/login.php');
  exit();
}

try {
  $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

  if (isset($_GET['transaction_id']) && is_numeric($_GET['transaction_id'])) {
    $redirect_url = "./profile.php";
    $delay = 5;

    $transaction_id = intval($_GET['transaction_id']);

    $transaction_details = $connection->query("SELECT users.user.name AS user_name, ticket.*, amount, event.name, event.portrait_image_url FROM transactions.transaction
    JOIN users.user ON transaction.attendee_id = users.user.user_id
    JOIN tickets.ticket ON transaction.ticket_id = ticket.ticket_id
    JOIN events.event ON ticket.event_id = event.event_id
    WHERE transaction_id = $transaction_id")->fetch(PDO::FETCH_ASSOC);

    $amount = $transaction_details['amount'];

    try {
      $connection->beginTransaction();
      $connection->query("UPDATE ticket SET quantity = quantity - $amount WHERE ticket_id = " . $transaction_details['ticket_id'] . " AND quantity > 0;");
      $connection->commit();
      header("Refresh: $delay; url=$redirect_url");
    } catch (PDOException $e) {
      $connection->rollBack();
      $e->getMessage();
    }
  }
} catch (PDOException $e) {
  echo "Error: " . $e->getMessage();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="<?php echo $delay; ?>;url=<?php echo $redirect_url; ?>">
  <title>Ticketxpert / Confirmation</title>
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

<body class="bg-slate-100">
  <main class="h-[100vh] flex flex-col justify-center">
    <div class="flex flex-col p-4 bg-white rounded-lg drop-shadow-xl gap-1 max-w-lg mx-auto">
      <div class="flex flex-row gap-4 items-center text-slate-700">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 512 512"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
          <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM369 209L241 337c-9.4 9.4-24.6 9.4-33.9 0l-64-64c-9.4-9.4-9.4-24.6 0-33.9s24.6-9.4 33.9 0l47 47L335 175c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9z" fill="currentColor" />
        </svg>
        <h1 class="font-[900] text-4xl">Transaction successful</h1>
      </div>
      <p class="text-slate-800 text-center">Please check your profile for the ticket and the transaction details.</p>
      <hr class="w-full bg-slate-800 my-4 border-dashed">
      <p class="text-sm text-slate-600">You'll be redirected to your profile page in a few seconds... <br><a href="./profile.php" class="text-slate-300">Click here if you're not redirected.</a></p>
    </div>
  </main>
</body>

</html>