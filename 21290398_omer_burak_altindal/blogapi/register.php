<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Gelen JSON verisini al
$data = json_decode(file_get_contents("php://input"), true);

// Gelen verileri kontrol et
if (!isset($data['name'], $data['surname'], $data['phone'], $data['email'], $data['password'])) {
    echo json_encode(["error" => "Invalid input data. All fields are required."]);
    exit;
}

$name = $data['name'];
$surname = $data['surname'];
$phone = $data['phone'];
$email = $data['email'];
$password = $data['password'];

// Verilerin boş olup olmadığını kontrol et
if (empty($name) || empty($surname) || empty($phone) || empty($email) || empty($password)) {
    echo json_encode(["error" => "All fields are required."]);
    exit;
}

// Veritabanı bağlantısı
$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed."]);
    exit;
}

// Şifreyi hash'le
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

// Kullanıcıyı eklemek için hazırlanan sorgu
$stmt = $conn->prepare("INSERT INTO users (name, surname, phone, email, password) VALUES (?, ?, ?, ?, ?)");
if (!$stmt) {
    echo json_encode(["error" => "SQL statement preparation failed: " . $conn->error]);
    exit;
}

$stmt->bind_param("sssss", $name, $surname, $phone, $email, $hashedPassword);

// Kullanıcıyı ekle ve sonucu kontrol et
if ($stmt->execute()) {
    echo json_encode(["message" => "User registered successfully"]);
} else {
    echo json_encode(["error" => "Registration failed: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
