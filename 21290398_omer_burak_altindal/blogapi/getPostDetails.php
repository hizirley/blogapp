<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

// Veritabanına bağlan
$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed."]);
    exit;
}

// Gelen post ID'sini al
$postId = isset($_GET['id']) ? intval($_GET['id']) : 0;

if ($postId === 0) {
    echo json_encode(["error" => "Post ID gereklidir."]);
    exit;
}

// Post bilgilerini al
$sql = "SELECT title, picture, content FROM posts WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $postId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $post = $result->fetch_assoc();
    echo json_encode($post); // Post bilgilerini JSON formatında döndür
} else {
    echo json_encode(["error" => "Post bulunamadı."]);
}

$stmt->close();
$conn->close();
?>
