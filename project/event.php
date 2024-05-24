<?php
session_start();

$attendeesNumber = null;

try {
  $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

  if (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $event_id = intval($_GET['id']);

    $event = $connection->query("SELECT event.name AS event_name, venue.name AS venue_name, description, _date, portrait_image_url, cover_image_url, seat_plan_image_url, customer_support.name AS support_name, contact_number AS support_number
    FROM event 
    JOIN venue ON event.venue_id = venue.venue_id
    JOIN customer_support ON event.customer_support_id = customer_support.customer_support_id
    WHERE event_id = $event_id")->fetch(PDO::FETCH_ASSOC);
    $tickets = $connection->query("SELECT * FROM ticket WHERE event_id = $event_id")->fetchAll(PDO::FETCH_ASSOC);

    $attendees = $connection->query("SELECT amount FROM transaction
    JOIN ticket ON transaction.ticket_id = ticket.ticket_id
    JOIN event ON ticket.event_id = event.event_id
    WHERE event.event_id = $event_id")->fetchAll(PDO::FETCH_ASSOC);

    if ($attendees) {
      foreach ($attendees as $attendee) {
        $attendeesNumber += (int) $attendee['amount'];
      }
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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?php echo isset($event) ? htmlspecialchars($event['event_name'], ENT_QUOTES, 'UTF-8') : 'Event Not Found'; ?></title>
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
  <?php require './components/headerComponent.php' ?>

  <main class='min-h-[100vh] relative'>
    <?php if ($event) : ?>
      <div class="fixed right-8 bottom-4 p-4 bg-slate-800 z-10 rounded-lg text-slate-50 w-[320px] text-right flex flex-col">
        <div class=" flex flex-row items-center gap-4">
          <p class="text-slate-300">Please contact <b><?php echo $event['support_name'] ?></b> or contact their number.</p>
          <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 512 512">
            <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" fill="currentColor" />
          </svg>
        </div>
        <div class="h-[1px] w-full bg-slate-300 rounded-lg"></div>
        <p class="text-slate-300"><?php echo $event['support_name'] ?></p>
        <p class="text-slate-300"><?php echo $event['support_number'] ?> (PH)</p>
      </div>
      <img src=<?php echo $event['cover_image_url'] ?> class='absolute w-full top-0 left-0 h-[420px] object-cover -z-10 brightness-50'>

      <div class='backdrop-blur-[3px]'>
        <div class="max-w-7xl w-full mx-auto flex flex-col gap-4 py-8">

          <!-- Header -->
          <div class='flex flex-row gap-4'>
            <?php ?>
            <img src=<?php echo $event["portrait_image_url"] ?> class='h-[360px] aspect-auto rounded-md object-fit' />
            <div class="flex flex-col w-full">
              <h1 class='font-[900] text-white drop-shadow-xl text-4xl'><?php echo $event['event_name'] ?></h1>
              <p class='font-[300] text-slate-300 drop-shadow-xl text-xl'><?php echo $event['venue_name'] ?></p>
              <?php if ($attendeesNumber >= 1) : ?>
                <p class='font-[300] text-slate-300 drop-shadow-xl'>There are <?php echo $attendeesNumber ?> attendee/s on this event.</p>
              <?php else : ?>
                <p class='font-[300] text-slate-300 drop-shadow-xl'>There are no attendee/s yet on this event.</p>
              <?php endif ?>
              <div class="flex flex-col gap-6 my-8">
                <h1 class="text-2xl font-[400] text-white drop-shadow-xl">About</h1>
                <div class="h-[1px] w-full bg-slate-300 rounded-lg"></div>
                <p class="text-white drop-shadow-xl"><?php echo $event['description'] ?></p>
              </div>
            </div>
          </div>

          <!-- Event Section -->
          <div class="flex flex-row gap-4 my-6">
            <div class="flex flex-col gap-4">
              <h1 class="text-slate-800 drop-shadow-xl text-2xl font-[900]">Seat Plan</h1>
              <div class="h-[1px] w-full bg-slate-300 rounded-lg"></div>
              <img src=<?php echo $event['seat_plan_image_url'] ?> class='w-full aspect-auto rounded-md' />
            </div>
            <div class="flex flex-col gap-4 w-full">
              <h1 class="text-slate-800 drop-shadow-xl text-2xl font-[900]">Tickets</h1>
              <div class="h-[1px] w-full bg-slate-300 rounded-lg"></div>
              <?php if ($tickets) : ?>
                <div class="grid grid-cols-2">
                  <h1 class="text-slate-600 text-lg">Location</h1>
                  <h1 class="text-slate-600 text-lg">Price</h1>
                </div>

                <?php
                foreach ($tickets as $ticket) {
                  $ticket_price = $ticket['price'];
                  $price = number_format($ticket_price, 2, '.', ',');
                  if ($ticket['quantity']) {
                    echo "
                    <div class='grid grid-cols-2 text-slate-800 p-4 rounded-md transition-all delay-0 duration-250 hover:translate-x-1 hover:bg-slate-200 hover:text-slate-950'>
                      <a href='buy.php?ticket_id=" . $ticket['ticket_id'] . "' class=''>" . $ticket['location'] . "</a>
                      <a href='buy.php?ticket_id=" . $ticket['ticket_id'] . "' class=''>₱ " . $price . "</a>
                    </div>
                    <div class='h-[1px] w-full bg-slate-300 rounded-lg'></div>
                    ";
                  } else {
                    echo "
                    <div class='grid grid-cols-2 text-slate-800 p-4 rounded-md transition-all delay-0 duration-250 hover:translate-x-1 hover:bg-red-500 hover:text-slate-50'>
                      <a href='buy.php?ticket_id=" . $ticket['ticket_id'] . "' class='cursor-default pointer-events-none'>" . $ticket['location'] . "</a>
                      <a href='buy.php?ticket_id=" . $ticket['ticket_id'] . "' class='cursor-default pointer-events-none'>₱ " . $price . "</a>
                    </div>
                    <div class='h-[1px] w-full bg-slate-300 rounded-lg'></div>
                    ";
                  }
                }
                ?>
              <?php else : ?>
                <h1 class="text-slate-600">No tickets available.</h1>
              <?php endif; ?>
            </div>
          </div>



        </div>
      </div>
    <?php else : ?>
      <p><?php echo $error_message; ?></p>
    <?php endif; ?>
  </main>
  <?php require './components/footerComponent.php' ?>
</body>

</html>