<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$conn = new mysqli("localhost", "root", "", "hivemind");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $full_name = ucwords(strtolower(trim($_POST['full_name'])));
    $dob = $_POST['dob'];
    $phone = $_POST['phone_number'];
    $gender = strtolower($_POST['gender']);
    $role = strtolower($_POST['role']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];
    $hashed_password = hash('sha256', $password);

    // Email check
    $check_email = $conn->prepare("SELECT email FROM users WHERE email = ?");
    $check_email->bind_param("s", $email);
    $check_email->execute();
    $check_email->store_result();

    if ($check_email->num_rows > 0) {
        echo "<script>alert('Email already exists. Please use another email.'); window.location.href='signup.html';</script>";
    } else {
        // Insert into users
        $stmt1 = $conn->prepare("INSERT INTO users (email, password, role, status) VALUES (?, ?, ?, 'active')");
        $stmt1->bind_param("sss", $email, $hashed_password, $role);

        if ($stmt1->execute()) {
            $user_id = $stmt1->insert_id;

            // Insert into user_profiles
            $stmt2 = $conn->prepare("INSERT INTO user_profiles (user_id, full_name, dob, phone_number, gender) VALUES (?, ?, ?, ?, ?)");
            $stmt2->bind_param("issss", $user_id, $full_name, $dob, $phone, $gender);

            if ($stmt2->execute()) {
                echo "<script>alert('Account created successfully'); window.location.href='login.html';</script>";
            } else {
                echo "Error in profile insert: " . $stmt2->error;
            }

            $stmt2->close();
        } else {
            echo "Error in user insert: " . $stmt1->error;
        }

        $stmt1->close();
    }

    $check_email->close();
} else {
    echo "No form data submitted.";
}

$conn->close();
?>