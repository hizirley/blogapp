<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

// Veritabanına bağlan
$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["error" => "Veritabanı bağlantısı başarısız."]);
    exit;
}

// Son 10 postu al
$sql = "SELECT id, title, user_email, picture, created_at FROM posts ORDER BY id DESC;";
$result = $conn->query($sql);

$posts = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $posts[] = $row;
    }
}

// Sonuçları JSON formatında döndür
echo json_encode(["posts" => $posts]);

$conn->close();
?>
