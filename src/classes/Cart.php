<?php
/**
 * Classe Cart - Gestion du panier
 * Stocké en base de données pour persistance
 */

class Cart {
    private $pdo;
    private $user_id;
    
    public function __construct($pdo, $user_id) {
        $this->pdo = $pdo;
        $this->user_id = $user_id;
    }
    
    /**
     * Ajouter un livre au panier
     */
    public function addItem($book_id, $quantity = 1) {
        // Vérifier que le livre existe
        $stmt = $this->pdo->prepare("SELECT id, stock FROM books WHERE id = ?");
        $stmt->execute([$book_id]);
        $book = $stmt->fetch();
        
        if (!$book) {
            return ['success' => false, 'message' => 'Livre non trouvé'];
        }
        
        if ($book['stock'] < $quantity) {
            return ['success' => false, 'message' => 'Stock insuffisant'];
        }
        
        // Vérifier si le livre est déjà dans le panier
        $stmt = $this->pdo->prepare("SELECT id, quantity FROM cart WHERE user_id = ? AND book_id = ?");
        $stmt->execute([$this->user_id, $book_id]);
        $item = $stmt->fetch();
        
        if ($item) {
            // Augmenter la quantité
            $new_quantity = $item['quantity'] + $quantity;
            $stmt = $this->pdo->prepare("UPDATE cart SET quantity = ? WHERE user_id = ? AND book_id = ?");
            $stmt->execute([$new_quantity, $this->user_id, $book_id]);
        } else {
            // Ajouter le nouvel article
            $stmt = $this->pdo->prepare("INSERT INTO cart (user_id, book_id, quantity) VALUES (?, ?, ?)");
            $stmt->execute([$this->user_id, $book_id, $quantity]);
        }
        
        return ['success' => true, 'message' => 'Ajouté au panier'];
    }
    
    /**
     * Obtenir tous les articles du panier
     */
    public function getItems() {
        $stmt = $this->pdo->prepare("
            SELECT c.id, c.quantity, b.id as book_id, b.title, b.author, b.price, b.cover_image
            FROM cart c
            JOIN books b ON c.book_id = b.id
            WHERE c.user_id = ?
            ORDER BY c.added_at DESC
        ");
        $stmt->execute([$this->user_id]);
        return $stmt->fetchAll();
    }
    
    /**
     * Mettre à jour la quantité d'un article
     */
    public function updateQuantity($cart_id, $quantity) {
        if ($quantity <= 0) {
            return $this->removeItem($cart_id);
        }
        
        // Vérifier le stock
        $stmt = $this->pdo->prepare("
            SELECT b.stock FROM cart c
            JOIN books b ON c.book_id = b.id
            WHERE c.id = ? AND c.user_id = ?
        ");
        $stmt->execute([$cart_id, $this->user_id]);
        $result = $stmt->fetch();
        
        if (!$result) {
            return ['success' => false, 'message' => 'Article non trouvé'];
        }
        
        if ($result['stock'] < $quantity) {
            return ['success' => false, 'message' => 'Stock insuffisant'];
        }
        
        $stmt = $this->pdo->prepare("UPDATE cart SET quantity = ? WHERE id = ? AND user_id = ?");
        $stmt->execute([$quantity, $cart_id, $this->user_id]);
        
        return ['success' => true, 'message' => 'Quantité mise à jour'];
    }
    
    /**
     * Supprimer un article du panier
     */
    public function removeItem($cart_id) {
        $stmt = $this->pdo->prepare("DELETE FROM cart WHERE id = ? AND user_id = ?");
        $result = $stmt->execute([$cart_id, $this->user_id]);
        
        return ['success' => $result, 'message' => $result ? 'Supprimé du panier' : 'Erreur'];
    }
    
    /**
     * Calculer le total du panier
     */
    public function getTotal() {
        $stmt = $this->pdo->prepare("
            SELECT SUM(c.quantity * b.price) as total
            FROM cart c
            JOIN books b ON c.book_id = b.id
            WHERE c.user_id = ?
        ");
        $stmt->execute([$this->user_id]);
        $result = $stmt->fetch();
        return floatval($result['total'] ?? 0);
    }
    
    /**
     * Obtenir le nombre d'articles dans le panier
     */
    public function getItemCount() {
        $stmt = $this->pdo->prepare("SELECT COUNT(*) as count FROM cart WHERE user_id = ?");
        $stmt->execute([$this->user_id]);
        $result = $stmt->fetch();
        return $result['count'];
    }
    
    /**
     * Vider le panier
     */
    public function clear() {
        $stmt = $this->pdo->prepare("DELETE FROM cart WHERE user_id = ?");
        return $stmt->execute([$this->user_id]);
    }
}
?>
