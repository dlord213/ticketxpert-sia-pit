<?php
session_start();

$connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'public_user', 'public_user');
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$ticket_details = null;
$price = null;

if (!isset($_SESSION['isLoggedIn'])) {
  header('Location: ./logins/login.php');
  exit();
}

if (isset($_GET['ticket_id']) && is_numeric($_GET['ticket_id'])) {
  $ticket_id = intval($_GET['ticket_id']);

  $ticket_details = $connection->query("SELECT ticket_id, quantity, price, location, _date, event.name AS event_name, 
  _date, cover_image_url, seat_plan_image_url, venue.name AS venue_name 
  FROM tickets.ticket
  JOIN events.event ON ticket.event_id = event.event_id
  JOIN events.venue ON event.venue_id = venue.venue_id
  WHERE ticket_id = " . $ticket_id)->fetch(PDO::FETCH_ASSOC);

  $price = number_format($ticket_details['price'], 2, '.', ',');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

  $ticket_id = intval($_POST['ticket_id']);
  $ticket_quantity = intval($_POST['ticket_quantity']);
  $new_quantity = max(0, $ticket_details['quantity'] - $ticket_quantity);

  try {
    $connection->beginTransaction();

    $preparedTransactionStmt = $connection->prepare("INSERT INTO transactions.transaction(attendee_id, ticket_id, transaction_date, amount)
    VALUES (?, ?, CURRENT_TIMESTAMP, ?)");

    $preparedTransactionStmt->execute([$_SESSION['user_id'], $ticket_id, $ticket_quantity]);

    $updateStmt = $connection->prepare("UPDATE tickets.ticket SET quantity = :new_quantity WHERE ticket_id = :ticket_id");
    $updateStmt->bindParam(':new_quantity', $new_quantity, PDO::PARAM_INT);
    $updateStmt->bindParam(':ticket_id', $ticket_id, PDO::PARAM_INT);
    $updateStmt->execute();

    $transaction_id = $connection->lastInsertId('transactions.transaction_transaction_id_seq');
    $connection->commit();

    header("Location: ./buy_confirmation.php?transaction_id=" . $transaction_id);
    exit();
  } catch (PDOException $e) {
    $connection->rollBack();
    $error_message = "Error:" . $e->getMessage();
  }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">

  <?php if ($ticket_details) : ?>
    <?php if ($ticket_details['quantity'] == 0) : ?>
      <meta http-equiv="refresh" content="<?php echo $delay; ?>;url=<?php echo $redirect_url; ?>">
    <?php else : ?>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php endif; ?>
  <?php endif; ?>
  <title>Ticketxpert / <?php echo $ticket_details['event_name'] ?></title>
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
  <main class="relative h-[100vh] flex flex-col justify-center items-center">
    <?php if ($ticket_details && $ticket_details['quantity'] >= 1) : ?>
      <div class="flex flex-col drop-shadow-xl bg-white rounded-lg w-[50vw]" id="content-container">
        <img src=<?php echo $ticket_details['cover_image_url'] ?> class="w-full object-fit rounded-tr-lg rounded-tl-lg" />
        <div class="flex flex-col p-8">
          <h1 class="text-slate-800 font-[900] text-2xl"><?php echo $ticket_details['event_name'] ?></h1>
          <p class="text-slate-800 text-lg font-[400]"><?php echo $ticket_details['venue_name'] ?></p>
          <div class="flex flex-row gap-2 items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="text-slate-800" width="20" height="20" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
              <path d="M128 0c17.7 0 32 14.3 32 32V64H288V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64h48c26.5 0 48 21.5 48 48v48H0V112C0 85.5 21.5 64 48 64H96V32c0-17.7 14.3-32 32-32zM0 192H448V464c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V192zm64 80v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H80c-8.8 0-16 7.2-16 16zm128 0v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H208c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H336zM64 400v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H80c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H208zm112 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H336c-8.8 0-16 7.2-16 16z" fill="currentColor" />
            </svg>
            <p class="text-slate-800 text-lg font-[400]"><?php echo $ticket_details['_date'] ?></p>
          </div>
          <div class="flex flex-row">
            <button class="cursor-pointer mt-1 block p-2 px-4 text-slate-800 hover:bg-slate-800 hover:text-slate-50 transition-all delay-0 duration-250 ease-in-out bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" onclick="showSeatPlan()">View seat plan</button>
          </div>
          <hr class="w-full bg-slate-800 my-4 border-dashed">
          <form action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" method="POST" class="flex flex-col gap-2 w-full">
            <input type="hidden" name="ticket_id" value="<?php echo $ticket_id; ?>">
            <div class="flex flex-row">
              <div class="flex flex-col w-full">
                <h1 class="text-slate-800 font-[900] text-2xl"><?php echo $ticket_details['location'] ?></h1>
                <p class="text-slate-800 text-lg font-[400]">₱ <?php echo $price ?></p>
              </div>
              <input type="text" min="0" max=<?php echo (int) $ticket_details['quantity'] ?> maxlength="16" name="ticket_promo" placeholder="Promo/Voucher Code" class="mt-1 block p-4 text-slate-800 bg-white w-full border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500 hidden" />
            </div>
            <input type="number" required min="0" max=<?php echo (int) $ticket_details['quantity'] ?> name="ticket_quantity" placeholder="Quantity" class="mt-1 block p-4 text-slate-800 bg-white w-full border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
            <div class="flex flex-row gap-2">
              <a href="/index.php" class="mt-1 block w-full p-4 text-slate-800 hover:bg-slate-800 hover:text-slate-50 transition-all delay-0 duration-250 ease-in-out bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500 text-center">Cancel</a>
              <input type="submit" value="Confirm" class="cursor-pointer mt-1 block w-full p-4 text-slate-800 hover:bg-slate-800 hover:text-slate-50 transition-all delay-0 duration-250 ease-in-out bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
            </div>
          </form>
        </div>
      </div>
      <div class="hidden transition-all delay-0 duration-250 ease-in-out absolute backdrop-brightness-50 w-full h-full justify-center items-center backdrop-blur-sm" id="seat-plan-container">
        <img src=<?php echo $ticket_details['seat_plan_image_url'] ?> class="rounded-lg drop-shadow-xl" />
      </div>
      <script>
        let seatPlanContainer = document.getElementById("seat-plan-container");

        function showSeatPlan() {
          if (seatPlanContainer.classList.contains('flex')) {
            seatPlanContainer.classList.remove('flex');
            seatPlanContainer.classList.add('hidden');
          } else {
            seatPlanContainer.classList.remove('hidden');
            seatPlanContainer.classList.add('flex');
          }
        }

        document.addEventListener('click', function(event) {
          if (seatPlanContainer.classList.contains('flex') && !event.target.closest('#content-container')) {
            seatPlanContainer.classList.remove('flex');
            seatPlanContainer.classList.add('hidden');
          }
        });
      </script>
    <?php else : ?>
      <div class="flex flex-col drop-shadow-xl bg-white rounded-lg w-[50vw]" id="content-container">
        <img src=<?php echo $ticket_details['cover_image_url'] ?> class="w-full object-fit rounded-tr-lg rounded-tl-lg" />
        <div class="flex flex-col p-8">
          <h1 class="text-slate-800 font-[900] text-2xl"><?php echo $ticket_details['event_name'] ?></h1>
          <p class="text-slate-800 text-lg font-[400]"><?php echo $ticket_details['venue_name'] ?></p>
          <div class="flex flex-row gap-2 items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="text-slate-800" width="20" height="20" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
              <path d="M128 0c17.7 0 32 14.3 32 32V64H288V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64h48c26.5 0 48 21.5 48 48v48H0V112C0 85.5 21.5 64 48 64H96V32c0-17.7 14.3-32 32-32zM0 192H448V464c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V192zm64 80v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H80c-8.8 0-16 7.2-16 16zm128 0v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H208c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V272c0-8.8-7.2-16-16-16H336zM64 400v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H80c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H208zm112 16v32c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16V400c0-8.8-7.2-16-16-16H336c-8.8 0-16 7.2-16 16z" fill="currentColor" />
            </svg>
            <p class="text-slate-800 text-lg font-[400]"><?php echo $ticket_details['_date'] ?></p>
          </div>
          <hr class="w-full bg-slate-800 my-4 border-dashed">
          <h1 class="text-slate-800 font-[900] text-2xl">Unfortunately, tickets are sold out!</h1>
          <p class="text-slate-800 text-lg font-[400]">We're sorry to say that <b><?php echo $ticket_details['event_name'] ?></b> tickets aren't available anymore.</p>
          <p class="text-sm text-slate-600 mt-8">You'll be redirected to your profile page in a few seconds... <br><a href="./profile.php" class="text-slate-300">Click here if you're not redirected.</a></p>
        </div>
        <script>
          setTimeout(function() {
            window.location.href = "./index.php";
          }, 5000);
        </script>
      <?php endif; ?>
  </main>
</body>

</html>