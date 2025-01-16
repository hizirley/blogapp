<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

$conn = new mysqli("localhost", "root", "", "blogapp");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Veritabanı bağlantısı başarısız."]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_FILES['profile_picture']) || !isset($_POST['email'])) {
        echo json_encode(["success" => false, "message" => "Gerekli veriler eksik."]);
        exit;
    }

    $email = $_POST['email'];
    $targetDir = "uploads/";

    // Eski profil fotoğrafını bul
    $stmt = $conn->prepare("SELECT profile_picture FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $oldProfilePicture = null;

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $oldProfilePicture = $row['profile_picture']; // Eski profil fotoğrafının yolu
    }

    $stmt->close();

    // Yeni dosya yolunu oluştur
    if (!is_dir($targetDir)) {
        mkdir($targetDir, 0777, true); // Eğer dizin yoksa oluştur
    }

    $fileName = uniqid() . "_" . basename($_FILES['profile_picture']['name']);
    $targetFilePath = $targetDir . $fileName;

    if (move_uploaded_file($_FILES['profile_picture']['tmp_name'], $targetFilePath)) {
        // Veritabanını güncelle
        $stmt = $conn->prepare("UPDATE users SET profile_picture = ? WHERE email = ?");
        $stmt->bind_param("ss", $targetFilePath, $email);

        if ($stmt->execute()) {
            // Eski profil fotoğrafını sil
            if ($oldProfilePicture && file_exists($oldProfilePicture)) {
                unlink($oldProfilePicture); // Eski dosyayı sil
            }

            echo json_encode(["success" => true, "message" => "Fotoğraf yüklendi.", "path" => $targetFilePath]);
        } else {
            echo json_encode(["success" => false, "message" => "Veritabanı güncellenemedi."]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Dosya yüklenemedi."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Geçersiz istek yöntemi."]);
}

$conn->close();
?>
