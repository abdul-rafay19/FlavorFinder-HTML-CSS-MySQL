<?php
include '../includes/db.php';

// Corrected SQL Query - Match the exact column names in your database
$sql = "SELECT r.Name AS RestaurantName, v.Rating, v.Comment, v.ReviewDate 
        FROM Reviews v 
        JOIN Restaurants r ON v.RestaurantID = r.ID";  // Change 'r.ID' if needed

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Restaurant Reviews</title>
    <link rel="stylesheet" href="Reviews.css">
</head>
<body>
    <div class="reviews-container">
        <h2>Customer Reviews</h2>
        <div class="reviews-grid">
            <?php
            if ($result && $result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo '<div class="review-card">';
                    echo '<h3>' . htmlspecialchars($row["RestaurantName"] ?? "Unknown Restaurant") . '</h3>';
                    echo '<div class="rating">⭐ ' . htmlspecialchars($row["Rating"] ?? "N/A") . ' / 5</div>';
                    echo '<p class="comment">"' . htmlspecialchars($row["Comment"] ?? "No comment") . '"</p>';
                    echo '<p class="date">📅 ' . htmlspecialchars($row["ReviewDate"] ?? "Unknown Date") . '</p>';
                    echo '</div>';
                }
            } else {
                echo "<p>No reviews found.</p>";
            }
            ?>
        </div>
    </div>
</body>
</html>

<?php
$conn->close();
?>
