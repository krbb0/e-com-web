<?php
header('Content-Type: application/json');
session_start();

require_once __DIR__ . '/../../config/Database.php';
require_once __DIR__ . '/../../classes/Auth.php';
require_once __DIR__ . '/../../classes/Book.php';

$db = new Database();
$pdo = $db->connect();
$auth = new Auth($pdo);

// Vérifier si connecté
if (!$auth->isLoggedIn()) {
    echo json_encode(['success' => false, 'message' => 'Non connecté']);
    exit;
}

$keyword = htmlspecialchars($_POST['keyword'] ?? $_GET['keyword'] ?? '');
$category_id = isset($_POST['category_id']) || isset($_GET['category_id']) ? intval($_POST['category_id'] ?? $_GET['category_id']) : null;
$min_price = isset($_POST['min_price']) || isset($_GET['min_price']) ? floatval($_POST['min_price'] ?? $_GET['min_price']) : null;
$max_price = isset($_POST['max_price']) || isset($_GET['max_price']) ? floatval($_POST['max_price'] ?? $_GET['max_price']) : null;

$book = new Book($pdo);
$results = $book->search($keyword, $category_id, $min_price, $max_price);

echo json_encode([
    'success' => true,
    'results' => $results,
    'count' => count($results)
]);
?>
