<?php
session_start();

$error_message = "";

if (isset($_SESSION['isLoggedIn'])) {
  header('Location: ../index.php');
  exit();
}

$connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'public_user', 'public_user');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

  $username = $_POST['username'];
  $password = $_POST['password'];

  try {
    $query = $connection->query("SELECT * FROM users.user WHERE username = '$username'");

    $user = $query->fetch(PDO::FETCH_ASSOC);



    if ($user) {
      if (password_verify($password, $user['password'])) {
        $_SESSION['user_id'] = $user['user_id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['password'] = $user['password'];
        $_SESSION['name'] = $user['name'];
        $_SESSION['address'] = $user['address'];
        $_SESSION['contact_number'] = $user['contact_number'];
        $_SESSION['isLoggedIn'] = true;

        $user_id = $_SESSION['user_id'];

        $attendeeCheck = $connection->query("SELECT user_id FROM events.attendee WHERE user_id = " . $user_id)->fetch(PDO::FETCH_ASSOC);

        if (!$attendeeCheck) {
          try {
            $insertAttendeeStmt = $connection->prepare("INSERT INTO events.attendee(user_id) VALUES (?)");
            $insertAttendeeStmt->execute([$user_id]);
          } catch (PDOException $e) {
            $connection->rollBack();
            echo "Error inserting attendee: " . $e->getMessage();
            exit();
          }
        }

        header('Location: ../index.php');
        exit();
      } else {
        $error_message = "Incorrect password.";
      }
    } else {
      $error_message = "The provided credentials might be incorrect or the user doesn't exist.";
    }
  } catch (PDOException $e) {
    $error_message = "Error: " . $e->getMessage();
  }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Ticketxpert / Login</title>
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
  <main class="h-[100vh] flex flex-col justify-between gap-4">
    <h1 class="font-[900] text-4xl text-slate-800 italic p-8">ticketxpert</h1>
    <div>
      <div class="max-w-xl w-full mx-auto">
        <form action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" method="POST" class="flex flex-col p-8 bg-slate-50 text-slate-800 shadow-lg rounded-lg">
          <div>
            <h1 class="text-slate-800 font-[900] text-4xl">Login</h1>
            <p class="text-slate-500">Get your tickets now!</p>
          </div>
          <div class="flex flex-col mt-2">
            <input type="text" placeholder="Username" name="username" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
            <input type="password" placeholder="Password" name="password" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800 invalid:border-red-500 invalid:text-red-600 focus:invalid:border-red-500 focus:invalid:ring-red-500" />
            <input type="submit" value="Login" class="cursor-pointer mt-1 block w-full p-2 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm transition-all delay-0 duration-250 ease-in-out hover:bg-slate-500 hover:text-slate-50 hover:border-slate-500" />
          </div>
          <?php if ($error_message !== "") : ?>
            <p class="p-4 mt-2 bg-red-500 text-white rounded-lg"><?php echo $error_message; ?></p>
          <?php endif; ?>
        </form>
      </div>
      <div class="max-w-xl w-full mx-auto mt-6">
        <h1 class="font-[500] text-lg text-slate-500">New to Ticketxpert? <a href="./register.php" class="text-slate-800 transition-all duration-250 delay-0 ease-in hover:text-green-600">Sign up</a>
        </h1>
      </div>
    </div>
    <div class="p-8 flex flex-row-reverse">
      ticketxpert © 2024
    </div>
  </main>
</body>

</html>