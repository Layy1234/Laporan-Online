<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// ==========================================
// KONFIGURASI DATABASE
// ==========================================
$servername = "localhost";
$username = "namadom2_hendra";
$password = "Legalayy!23";
$dbname = "namadom2_hendra";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

$raw_json = file_get_contents('php://input');
if (!empty($raw_json)) {
    $decoded = json_decode($raw_json, true);
    if (is_array($decoded)) {
        $_POST = array_merge($_POST, $decoded);
    }
}

$action = $_POST['action'] ?? '';

if ($action == 'register') {
    $nama = trim($_POST['nama'] ?? '');
    $user = trim($_POST['username'] ?? '');

    if ($nama === '' || $user === '') {
        echo json_encode(["status" => "error", "message" => "Data tidak boleh kosong"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $stmt->bind_param("s", $user);
    $stmt->execute();
    $stmt->store_result();
    
    if ($stmt->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Username sudah digunakan"]);
    } else {
        $stmt2 = $conn->prepare("INSERT INTO users (nama, username) VALUES (?, ?)");
        $stmt2->bind_param("ss", $nama, $user);
        if ($stmt2->execute()) {
            echo json_encode(["status" => "success", "message" => "Registrasi berhasil", "data" => ["nama" => $nama, "username" => $user]]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal registrasi"]);
        }
        $stmt2->close();
    }
    $stmt->close();

} elseif ($action == 'login') {
    $user = trim($_POST['username'] ?? '');

    if ($user === '') {
        echo json_encode(["status" => "error", "message" => "Username tidak boleh kosong"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT id, nama, username FROM users WHERE username = ?");
    $stmt->bind_param("s", $user);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            "status" => "success", 
            "message" => "Login berhasil", 
            "data" => [
                "id" => $row['id'], 
                "nama" => $row['nama'], 
                "username" => $row['username']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Username tidak ditemukan"]);
    }
    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Aksi tidak valid"]);
}

$conn->close();
?>
