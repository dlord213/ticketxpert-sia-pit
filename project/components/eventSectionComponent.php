<div class="flex flex-col max-w-7xl w-full mx-auto py-8 gap-4">
  <h1 class="text-slate-800 font-[700] text-3xl">EVENTS</h1>
  <div class="h-[4px] w-full bg-slate-600 rounded-lg"></div>
  <section class="splide" id="events-carousel">
    <div class="splide__track">
      <ul class="splide__list">

        <?php

        $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

        try {

          $eventQuery = $connection->query("SELECT event_id, event.name AS event_name, event._date, venue.name AS venue_name, portrait_image_url 
          FROM events.event 
          JOIN events.venue ON event.venue_id = venue.venue_id;");

          $events = $eventQuery->fetchAll(PDO::FETCH_ASSOC);

          if ($events) {
            foreach ($events as $event) {
              echo "<li class='splide__slide flex flex-col gap-2 p-4'>
              <img src=" . $event['portrait_image_url'] . " class='rounded-lg w-full h-full' />
              <div>
                <h1 class='text-slate-900 font-bold text-xl'>" . $event['event_name'] . "</h1>
                <p class='text-slate-400 mt-1'>" . $event['venue_name'] . "</p>
                <div class='flex flex-row gap-2 items-center mt-2'>
                  <p class='bg-slate-800 text-slate-100 p-2 rounded-lg w-full text-center'>" . $event['_date'] . "</p>
                  <a href=event.php?id=" . $event['event_id']  . " class='bg-green-500 text-slate-100 p-2 rounded-lg w-full text-center transition-all delay-0 duration-250 ease-in hover:bg-green-600'>Buy
                    ticket</a>
                </div>
              </div>
            </li>";
            }
          }
        } catch (PDOException $e) {
          echo "Error: " . $e->getMessage();
        }





        ?>
      </ul>
    </div>
  </section>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var splide = new Splide('#events-carousel', {
      type: 'loop',
      perPage: 4
    });
    splide.mount();
  });
</script>