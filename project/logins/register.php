<?php

session_start();

if (isset($_SESSION['isLoggedIn'])) {
  header('Location: ../index.php');
  exit();
}

$connection = new PDO("pgsql:host=localhost;port=5432;dbname=ticketxpert", 'administrator', 'admin');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  $fullName = $_POST['full_name'];
  $phoneNumber = $_POST['phone_number'];
  $address = $_POST['address'];
  $username = $_POST['username'];
  $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

  try {

    $connection->beginTransaction();

    $stmt = $connection->prepare("INSERT INTO users(name, address, contact_number, username, password) VALUES(?, ?, ?, ?, ?)");
    $stmt->execute([$fullName, $address, $phoneNumber, $username, $password]);

    $connection->commit();
    header('Location: ./login.php');
    exit();
  } catch (PDOException $e) {
    $connection->rollBack();
    echo "Error:" . $e->getMessage();
  }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Ticketxpert / Register</title>
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
            <h1 class="text-slate-800 font-[900] text-4xl">Register</h1>
            <p class="text-slate-500">Get your tickets now!</p>
          </div>
          <div class="flex flex-col mt-2">
            <input type="text" placeholder="Full Name" name="full_name" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800" required />
            <input type="text" placeholder="Phone Number" name="phone_number" maxlength="12" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800" required />
            <input type="text" placeholder="Address" name="address" class=" mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800" required />
            <div class="w-full h-[2px] bg-slate-300 mb-2 mt-4"></div>
            <input type="text" placeholder="Username" name="username" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800" required />
            <input type="password" placeholder="Password" name="password" class="mt-1 block w-full p-4 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:border-slate-800 focus:ring-1 focus:ring-slate-800" required />
            <input type="submit" value="Register" class="cursor-pointer mt-1 block w-full p-2 text-slate-800 bg-white border border-slate-300 rounded-md shadow-sm transition-all delay-0 duration-250 ease-in-out hover:bg-slate-500 hover:text-slate-50 hover:border-slate-500" />
          </div>
        </form>
      </div>
      <div class="max-w-xl w-full mx-auto mt-6">
        <h1 class="font-[500] text-lg text-slate-500">Already have an account? <a href="./index.php" class="text-slate-800 transition-all duration-250 delay-0 ease-in hover:text-green-600">Sign-in</a>
        </h1>
      </div>
    </div>
    <div class="p-8 flex flex-row-reverse">
      ticketxpert © 2024
    </div>
  </main>
</body>

</html>