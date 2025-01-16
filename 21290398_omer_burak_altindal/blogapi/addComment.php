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

$postId = $data['post_id'];
$userEmail = $data['user_email'];
$content = $data['content'];

if (empty($postId) || empty($userEmail) || empty($content)) {
    echo json_encode(["success" => false, "message" => "Tüm alanlar doldurulmalıdır."]);
    exit;
}

$sql = "INSERT INTO comments (post_id, user_email, content) VALUES (?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("iss", $postId, $userEmail, $content);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Yorum başarıyla eklendi."]);
} else {
    echo json_encode(["success" => false, "message" => "Yorum eklenirken bir hata oluştu."]);
}

$stmt->close();
$conn->close();
?>
