<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'] ?? ""; // Mevcut e-posta
$newEmail = $data['newEmail'] ?? $email; // Yeni e-posta, verilmezse mevcut e-posta kullanılır
$name = $data['name'] ?? "";
$surname = $data['surname'] ?? "";
$phone = $data['phone'] ?? "";

if (empty($email)) {
    echo json_encode(["success" => false, "message" => "Mevcut e-posta eksik."]);
    exit;
}

// Eğer yeni bir e-posta verilmişse, başka bir kullanıcıda olup olmadığını kontrol et
if ($newEmail !== $email) {
    $checkEmailStmt = $conn->prepare("SELECT email FROM users WHERE email = ?");
    $checkEmailStmt->bind_param("s", $newEmail);
    $checkEmailStmt->execute();
    $checkEmailResult = $checkEmailStmt->get_result();

    if ($checkEmailResult->num_rows > 0) {
        echo json_encode(["success" => false, "message" => "Bu e-posta başka bir kullanıcı tarafından kullanılıyor."]);
        exit;
    }

    $checkEmailStmt->close();
}

// Kullanıcı bilgilerini güncelle
$stmt = $conn->prepare("UPDATE users SET name = ?, surname = ?, phone = ?, email = ? WHERE email = ?");
$stmt->bind_param("sssss", $name, $surname, $phone, $newEmail, $email);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Profil başarıyla güncellendi."]);
} else {
    echo json_encode(["success" => false, "message" => "Profil güncellenirken bir hata oluştu."]);
}

$stmt->close();
$conn->close();
?>
