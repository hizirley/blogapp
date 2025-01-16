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

if (empty($postId)) {
    echo json_encode(["success" => false, "message" => "Post ID gereklidir."]);
    exit;
}

$sql = "SELECT user_email, content, created_at FROM comments WHERE post_id = ? ORDER BY created_at DESC LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $postId);
$stmt->execute();
$result = $stmt->get_result();

$comments = [];

while ($row = $result->fetch_assoc()) {
    $comments[] = $row;
}

echo json_encode(["success" => true, "comments" => $comments]);

$stmt->close();
$conn->close();
?>
