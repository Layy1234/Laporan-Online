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

$action = $_POST['action'] ?? '';

if ($action == 'register') {
    $nama = $_POST['nama'] ?? '';
    $user = $_POST['username'] ?? '';
    $pass = $_POST['password'] ?? '';

    if (empty($nama) || empty($user) || empty($pass)) {
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
        $hashed_password = password_hash($pass, PASSWORD_DEFAULT);
        $stmt2 = $conn->prepare("INSERT INTO users (nama, username, password) VALUES (?, ?, ?)");
        $stmt2->bind_param("sss", $nama, $user, $hashed_password);
        if ($stmt2->execute()) {
            echo json_encode(["status" => "success", "message" => "Registrasi berhasil", "data" => ["nama" => $nama, "username" => $user]]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal registrasi"]);
        }
        $stmt2->close();
    }
    $stmt->close();

} elseif ($action == 'login') {
    $user = $_POST['username'] ?? '';
    $pass = $_POST['password'] ?? '';

    if (empty($user) || empty($pass)) {
        echo json_encode(["status" => "error", "message" => "Username dan Password tidak boleh kosong"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT id, nama, password FROM users WHERE username = ?");
    $stmt->bind_param("s", $user);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        if (password_verify($pass, $row['password'])) {
            echo json_encode([
                "status" => "success", 
                "message" => "Login berhasil", 
                "data" => [
                    "id" => $row['id'], 
                    "nama" => $row['nama'], 
                    "username" => $user
                ]
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Password salah"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Username tidak ditemukan"]);
    }
    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Aksi tidak valid"]);
}

$conn->close();
?>
