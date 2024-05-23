<?php
if (isset($_POST['logout'])) {

  $_SESSION['isLoggedIn'] = false;

  session_unset();
  session_destroy();
  session_abort();

  header("Location: ./index.php");
  exit();
}
?>

<header class="flex flex-col items-center bg-slate-900 p-4 text-[#fafafa]">
  <div class="max-w-7xl w-full mx-auto flex flex-row justify-between items-center">
    <h1 class="font-[900] italic text-2xl cursor-pointer"><a href="/project/index.php">ticketxpert</a></h1>
    <?php if (!isset($_SESSION['isLoggedIn'])) : ?>
      <div class="flex flex-row gap-4">
        <a href="logins/login.php" class="border border-slate-900 p-2 hover:bg-slate-400 transition-all delay-0 duration-250 ease-in-out rounded-lg hover:px-4">Login</a>
        <a href="logins/register.php" class="border border-slate-900 p-2 hover:bg-slate-400 transition-all delay-0 duration-250 ease-in-out rounded-lg hover:px-4">Register</a>
      </div>
    <?php endif; ?>
    <?php if (isset($_SESSION['isLoggedIn'])) : ?>
      <div class="flex flex-row gap-4 items-center">
        <div class="flex flex-row border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4 gap-4 items-center justify-center">
          <svg class="text-slate-100 w-[24px]" viewBox="0 0 24 24">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
              <path d="M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512H418.3c16.4 0 29.7-13.3 29.7-29.7C448 383.8 368.2 304 269.7 304H178.3z" fill="currentColor" />
            </svg>
          </svg>
          <a href="./profile.php"><?php echo $_SESSION['name'] ?></a>
        </div>
        <div class="w-[4px] h-[32px] rounded-full bg-white"></div>
        <form action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" method="POST">
          <input type="submit" value="Logout" name="logout" class="cursor-pointer border border-slate-900 p-2 hover:bg-slate-400 transition-all delay-0 duration-250 ease-in-out rounded-lg hover:px-4" />
        </form>
      </div>
    <?php endif; ?>
  </div>
  <div class="max-w-7xl mt-2 w-full mx-auto hidden flex-row justify-between items-center">
    <nav>
      <a href="#" class="border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4">Music</a>
      <a href="#" class="border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4">Arts</a>
      <a href="#" class="border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4">Science</a>
      <a href="#" class="border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4">Sports</a>
      <a href="#" class="border-2 border-slate-900 p-2 hover:border-b-slate-200 transition-all delay-0 duration-250 ease-in-out hover:px-4">Attractions</a>
    </nav>
  </div>
</header>