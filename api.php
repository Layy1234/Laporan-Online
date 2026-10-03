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

// Membuat koneksi ke database MySQL
$conn = new mysqli($servername, $username, $password, $dbname);

// Cek koneksi
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// ==========================================
// HANDLE REQUEST POST DARI FLUTTER
// ==========================================
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    // 1. Ambil data teks dari form
    $storeName = $_POST['storeName'] ?? '';
    $ownerName = $_POST['ownerName'] ?? '';
    $picName = $_POST['picName'] ?? '';
    $address = $_POST['address'] ?? '';
    $volx = $_POST['volx'] ?? '';
    $takis = $_POST['takis'] ?? '';
    $tribe = $_POST['tribe'] ?? '';
    $pod_volx = $_POST['pod_volx'] ?? '';
    $pod_takis = $_POST['pod_takis'] ?? '';
    $pod_tribe = $_POST['pod_tribe'] ?? '';
    $ct = $_POST['ct'] ?? '';
    $inside = $_POST['inside'] ?? '';
    $reporterName = $_POST['reporterName'] ?? '';
    $createdAt = date('Y-m-d H:i:s');

    // 2. Handle Upload Gambar
    $uploadedImages = [];
    $uploadDir = "uploads/";

    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    if (isset($_FILES['images'])) {
        $totalFiles = count($_FILES['images']['name']);
        
        for ($i = 0; $i < $totalFiles; $i++) {
            $tmpFilePath = $_FILES['images']['tmp_name'][$i];
            
            if ($tmpFilePath != "") {
                $newFileName = time() . '_' . basename($_FILES['images']['name'][$i]);
                $targetFilePath = $uploadDir . $newFileName;

                if (move_uploaded_file($tmpFilePath, $targetFilePath)) {
                    $uploadedImages[] = "https://" . $_SERVER['HTTP_HOST'] . dirname($_SERVER['REQUEST_URI']) . "/" . $targetFilePath;
                }
            }
        }
    }

    $imagePathsJson = json_encode($uploadedImages);

    // 3. Simpan data ke Database MySQL
    $id = $_POST['id'] ?? null;
    
    if ($id) {
        if (!empty($uploadedImages)) {
            $stmt = $conn->prepare("UPDATE stores SET storeName=?, ownerName=?, picName=?, address=?, volx=?, takis=?, tribe=?, pod_volx=?, pod_takis=?, pod_tribe=?, ct=?, inside=?, reporterName=?, imagePaths=? WHERE id=?");
            $stmt->bind_param("ssssssssssssssi", $storeName, $ownerName, $picName, $address, $volx, $takis, $tribe, $pod_volx, $pod_takis, $pod_tribe, $ct, $inside, $reporterName, $imagePathsJson, $id);
        } else {
            $stmt = $conn->prepare("UPDATE stores SET storeName=?, ownerName=?, picName=?, address=?, volx=?, takis=?, tribe=?, pod_volx=?, pod_takis=?, pod_tribe=?, ct=?, inside=?, reporterName=? WHERE id=?");
            $stmt->bind_param("sssssssssssssi", $storeName, $ownerName, $picName, $address, $volx, $takis, $tribe, $pod_volx, $pod_takis, $pod_tribe, $ct, $inside, $reporterName, $id);
        }
    } else {
        $stmt = $conn->prepare("INSERT INTO stores (storeName, ownerName, picName, address, volx, takis, tribe, pod_volx, pod_takis, pod_tribe, ct, inside, reporterName, imagePaths, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("sssssssssssssss", $storeName, $ownerName, $picName, $address, $volx, $takis, $tribe, $pod_volx, $pod_takis, $pod_tribe, $ct, $inside, $reporterName, $imagePathsJson, $createdAt);
    }

    if ($stmt->execute()) {
        $inserted_id = $id ? $id : $conn->insert_id;
        echo json_encode([
            "status" => "success", 
            "message" => "Data berhasil disimpan ke server!",
            "images" => $uploadedImages,
            "id" => $inserted_id
        ]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Gagal menyimpan data ke database: " . $stmt->error
        ]);
    }

    $stmt->close();
} else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    // GET UNTUK MENAMPILKAN DATA
    $sql = "SELECT * FROM stores ORDER BY id DESC";
    $result = $conn->query($sql);

    $data = [];
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $row['imagePaths'] = json_decode($row['imagePaths']);
            $data[] = $row;
        }
    }
    echo json_encode([
        "status" => "success",
        "data" => $data
    ]);
}

$conn->close();
?>
