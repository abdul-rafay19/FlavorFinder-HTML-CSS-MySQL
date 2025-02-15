<?php
include '../includes/db.php';

// Fetch cuisines from the database
$sql = "SELECT * FROM Cuisines"; // Ensure the table name is correct
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cuisines</title>
    <link rel="stylesheet" href="cuisines.css">
</head>
<body>
    <div class="cuisines-container">
        <h2>Explore Cuisines</h2>
        <div class="cuisine-grid">
            <?php
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo '<div class="cuisine-card">';
                    echo '<h3>' . htmlspecialchars($row["CuisineName"]) . '</h3>';
                    echo '</div>';
                }
            } else {
                echo "<p>No cuisines found.</p>";
            }
            ?>
        </div>
    </div>
</body>
</html>

<?php
$conn->close();
?>
