<section class="splide" id="homepage-carousel">
  <div class="splide__track">
    <ul class="splide__list">
      <?php

      $connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

      $images = $connection->query("SELECT event_id, cover_image_url FROM event;", PDO::FETCH_ASSOC);

      foreach ($images as $image) {
        echo "<li class='splide__slide h-[50vh]'><a href=event.php?id=" . $image['event_id']  . "><img class='w-full object-contain' src=" . $image['cover_image_url'] . " /></a></li>";
      }

      ?>
    </ul>
  </div>
</section>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var splide = new Splide('#homepage-carousel', {
      type: 'fade',
      perPage: 1,
      arrows: true,
      drag: true
    });
    splide.mount();
  });
</script>