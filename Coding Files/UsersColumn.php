<?php
include '../includes/db.php';

// Fetch users from the database
$sql = "SELECT ID, Username, Email, RegistrationDate FROM Users"; // Password column excluded
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Users List</title>
    <link rel="stylesheet" href="UsersColumn.css">
</head>
<body>
    <div class="users-container">
        <h2>Registered Users</h2>
        <div class="users-grid">
            <?php
            if ($result && $result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo '<div class="user-card">';
                    echo '<h3>👤 ' . htmlspecialchars($row["Username"]) . '</h3>';
                    echo '<p><strong>Email:</strong> ' . htmlspecialchars($row["Email"]) . '</p>';
                    echo '<p class="date">📅 Registered on: ' . htmlspecialchars($row["RegistrationDate"]) . '</p>';
                    echo '</div>';
                }
            } else {
                echo "<p>No users found.</p>";
            }
            ?>
        </div>
    </div>
</body>
</html>

<?php
$conn->close();
?>
