<?php
include '../includes/db.php';

// Check if table parameter is provided
if (isset($_GET['table'])) {
    $table = $_GET['table'];
    
    // Fetch data from the specified table
    $sql = "SELECT * FROM $table";
    $result = $conn->query($sql);
} else {
    echo "Table parameter is missing.";
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Table Information</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h2><?php echo ucfirst($table); ?></h2>
        <?php
        if ($result->num_rows > 0) {
            echo "<table>";
            echo "<thead>";
            echo "<tr>";
            while ($row = $result->fetch_assoc()) {
                foreach ($row as $key => $value) {
                    echo "<th>" . htmlspecialchars($key) . "</th>";
                }
                break; // Only fetch column names from the first row
            }
            echo "</tr>";
            echo "</thead>";
            echo "<tbody>";
            // Fetch and display table data
            mysqli_data_seek($result, 0); // Reset result pointer
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                foreach ($row as $value) {
                    echo "<td>" . htmlspecialchars($value) . "</td>";
                }
                echo "</tr>";
            }
            echo "</tbody>";
            echo "</table>";
        } else {
            echo "<p>No data found in the $table table.</p>";
        }
        ?>
    </div>
</body>
</html>

<?php
$conn->close();
?>
