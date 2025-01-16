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
$email = $data['email'] ?? '';

if (empty($email)) {
    echo json_encode(["success" => false, "message" => "Kullanıcı e-postası gereklidir."]);
    exit;
}

$sql = "SELECT id, title, content, picture, created_at 
        FROM posts 
        WHERE user_email = ? 
        ORDER BY created_at DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

$posts = [];

while ($row = $result->fetch_assoc()) {
    $posts[] = $row;
}

echo json_encode(["success" => true, "posts" => $posts]);

$stmt->close();
$conn->close();
?>
