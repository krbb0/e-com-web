<?php
header('Content-Type: application/json');
session_start();

require_once __DIR__ . '/../../config/Database.php';
require_once __DIR__ . '/../../classes/Auth.php';
require_once __DIR__ . '/../../classes/Cart.php';

$db = new Database();
$pdo = $db->connect();
$auth = new Auth($pdo);

// Vérifier si connecté
if (!$auth->isLoggedIn()) {
    echo json_encode(['success' => false, 'message' => 'Non connecté']);
    exit;
}

$user_id = $_SESSION['user_id'];
$cart_id = intval($_POST['cart_id'] ?? 0);
$quantity = intval($_POST['quantity'] ?? 1);

if ($cart_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Données invalides']);
    exit;
}

$cart = new Cart($pdo, $user_id);
$result = $cart->updateQuantity($cart_id, $quantity);

echo json_encode($result);
?>
