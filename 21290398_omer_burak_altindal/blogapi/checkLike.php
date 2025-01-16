<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Veritabanı bağlantısı başarısız."]);
    exit;
}

$postId = $_GET['post_id'];
$userEmail = $_GET['user_email'];

if (empty($postId) || empty($userEmail)) {
    echo json_encode(["success" => false, "message" => "Post ID ve kullanıcı e-postası gereklidir."]);
    exit;
}

$sql = "SELECT id FROM likes WHERE post_id = ? AND user_email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("is", $postId, $userEmail);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(["isLiked" => true]);
} else {
    echo json_encode(["isLiked" => false]);
}

$stmt->close();
$conn->close();
?>
