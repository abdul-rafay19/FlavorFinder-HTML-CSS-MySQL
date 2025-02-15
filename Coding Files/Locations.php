<?php
include '../includes/db.php';

// Fetch locations from the database
$sql = "SELECT LocationName, Latitude, Longitude FROM Locations"; 
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Explore Locations</title>
    <link rel="stylesheet" href="Locations.css">
</head>
<body>
    <div class="locations-container">
        <h2>Find Restaurants by Location</h2>
        <div class="location-grid">
            <?php
            if ($result && $result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo '<div class="location-card">';
                    echo '<h3>' . htmlspecialchars($row["LocationName"] ?? "Unknown") . '</h3>';
                    echo '<p><strong>Latitude:</strong> ' . htmlspecialchars($row["Latitude"] ?? "N/A") . '</p>';
                    echo '<p><strong>Longitude:</strong> ' . htmlspecialchars($row["Longitude"] ?? "N/A") . '</p>';
                    echo '</div>';
                }
            } else {
                echo "<p>No locations found.</p>";
            }
            ?>
        </div>
    </div>
</body>
</html>

<?php
$conn->close();
?>
