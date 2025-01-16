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

if (empty($postId) || empty($userEmail)) {
    echo json_encode(["success" => false, "message" => "Post ID ve kullanıcı e-postası gereklidir."]);
    exit;
}

// Kullanıcı beğenmiş mi kontrol et
$sqlCheck = "SELECT id FROM likes WHERE post_id = ? AND user_email = ?";
$stmtCheck = $conn->prepare($sqlCheck);
$stmtCheck->bind_param("is", $postId, $userEmail);
$stmtCheck->execute();
$resultCheck = $stmtCheck->get_result();

if ($resultCheck->num_rows > 0) {
    // Eğer beğeni varsa kaldır
    $sqlDelete = "DELETE FROM likes WHERE post_id = ? AND user_email = ?";
    $stmtDelete = $conn->prepare($sqlDelete);
    $stmtDelete->bind_param("is", $postId, $userEmail);
    $stmtDelete->execute();
    echo json_encode(["success" => true, "message" => "Beğeni kaldırıldı."]);
    $stmtDelete->close();
} else {
    // Eğer beğeni yoksa ekle
    $sqlInsert = "INSERT INTO likes (post_id, user_email) VALUES (?, ?)";
    $stmtInsert = $conn->prepare($sqlInsert);
    $stmtInsert->bind_param("is", $postId, $userEmail);
    if ($stmtInsert->execute()) {
        echo json_encode(["success" => true, "message" => "Post beğenildi."]);
    } else {
        echo json_encode(["success" => false, "message" => "Beğeni eklenirken bir hata oluştu."]);
    }
    $stmtInsert->close();
}

$stmtCheck->close();
$conn->close();
?>
