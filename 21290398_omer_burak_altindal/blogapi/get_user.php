<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'];

if (empty($email)) {
    echo json_encode(["error" => "E-posta adresi gereklidir."]);
    exit;
}

// Sorguya profile_picture sütununu ekleyin
$stmt = $conn->prepare("SELECT name, surname, phone, email, profile_picture FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode($user); // Kullanıcı bilgilerini JSON olarak döndür
} else {
    echo json_encode(["error" => "Kullanıcı bulunamadı."]);
}

$stmt->close();
$conn->close();
?>
