<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Veritabanına bağlan
$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Veritabanı bağlantısı başarısız."]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_email = $_POST['user_email'];
    $title = $_POST['title'];
    $content = $_POST['content'];

    // Alanların boş olup olmadığını kontrol et
    if (empty($user_email) || empty($title) || empty($content) || !isset($_FILES['picture'])) {
        echo json_encode(["success" => false, "message" => "Tüm alanları doldurun."]);
        exit;
    }

    // Resim işlemleri
    $picture = $_FILES['picture'];
    $uploadDir = 'uploads/';
    $fileName = uniqid() . '_' . basename($picture['name']);
    $targetFile = $uploadDir . $fileName;

    if (move_uploaded_file($picture['tmp_name'], $targetFile)) {
        // Veritabanına ekleme
        $sql = "INSERT INTO posts (user_email, title, content, picture) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssss", $user_email, $title, $content, $fileName);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Post başarıyla eklendi."]);
        } else {
            echo json_encode(["success" => false, "message" => "Veritabanı hatası."]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Dosya yüklenemedi."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Geçersiz istek."]);
}

$conn->close();
?>
