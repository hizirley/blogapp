<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Veritabanı bağlantısı başarısız."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$query = $data['query'] ?? '';

if (empty($query)) {
    echo json_encode(["success" => false, "message" => "Arama sorgusu gereklidir."]);
    exit;
}

$sql = "SELECT id, name, email, profile_picture FROM users WHERE name LIKE CONCAT('%', ?, '%') OR email LIKE CONCAT('%', ?, '%')";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $query, $query);
$stmt->execute();
$result = $stmt->get_result();

$users = [];

while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode(["success" => true, "users" => $users]);

$stmt->close();
$conn->close();
?>
