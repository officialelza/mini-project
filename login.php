<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$conn = new mysqli("localhost", "root", "", "hivemind");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST['email'], $_POST['password'])) {
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    echo "Debug Info:<br>";
    echo "Email received: " . htmlspecialchars($email) . "<br>";
    echo "Password length: " . strlen($password) . "<br>";

    $hashed_password = hash('sha256', $password);
    echo "Hashed password: " . $hashed_password . "<br>";

    // Check if user exists first
    $check_stmt = $conn->prepare("SELECT email, password FROM users WHERE email = ?");
    $check_stmt->bind_param("s", $email);
    $check_stmt->execute();
    $check_stmt->store_result();

    if ($check_stmt->num_rows > 0) {
        $check_stmt->bind_result($db_email, $db_password);
        $check_stmt->fetch();
        echo "User found in database<br>";
        echo "DB Email: " . htmlspecialchars($db_email) . "<br>";
        echo "DB Password: " . $db_password . "<br>";
        echo "Passwords match: " . ($hashed_password === $db_password ? "YES" : "NO") . "<br>";
    } else {
        echo "No user found with this email<br>";
    }
    $check_stmt->close();

    // Your original query
    $stmt = $conn->prepare("SELECT user_id, role FROM users WHERE email = ? AND password = ?");
    $stmt->bind_param("ss", $email, $hashed_password);
    $stmt->execute();
    $stmt->store_result();

    echo "Query result rows: " . $stmt->num_rows . "<br>";

    if ($stmt->num_rows === 1) {
        $stmt->bind_result($user_id, $role);
        $stmt->fetch();

        session_start();
        $_SESSION['user_id'] = $user_id;
        $_SESSION['role'] = $role;

        echo "<script>alert('Login successful!'); window.location.href='homepage.html';</script>";
    } else {
        echo "<script>alert('Invalid email or password. Please try again.');</script>";
    }

    $stmt->close();
}

$conn->close();
?>