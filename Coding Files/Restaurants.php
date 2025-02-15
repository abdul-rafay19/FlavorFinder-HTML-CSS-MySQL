<?php
include '../includes/db.php';

// Fetch restaurants along with their cuisine type and location name
$sql = "SELECT r.Name AS RestaurantName, r.Address, c.CuisineName, l.LocationName, r.Rating 
        FROM Restaurants r
        JOIN Cuisines c ON r.CuisineID = c.ID
        JOIN Locations l ON r.LocationID = l.ID";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Restaurants</title>
    <link rel="stylesheet" href="Restaurants.css">
</head>
<body>
    <div class="restaurants-container">
        <h2>Restaurants List</h2>
        <div class="restaurants-grid">
            <?php
            if ($result && $result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo '<div class="restaurant-card">';
                    echo '<h3>🍽️ ' . htmlspecialchars($row["RestaurantName"]) . '</h3>';
                    echo '<p><strong>📍 Location:</strong> ' . htmlspecialchars($row["LocationName"]) . '</p>';
                    echo '<p><strong>🍛 Cuisine:</strong> ' . htmlspecialchars($row["CuisineName"]) . '</p>';
                    echo '<p><strong>🏠 Address:</strong> ' . htmlspecialchars($row["Address"]) . '</p>';
                    echo '<p class="rating">⭐ Rating: ' . htmlspecialchars($row["Rating"]) . '/5</p>';
                    echo '</div>';
                }
            } else {
                echo "<p>No restaurants found.</p>";
            }
            ?>
        </div>
    </div>
</body>
</html>

<?php
$conn->close();
?>
