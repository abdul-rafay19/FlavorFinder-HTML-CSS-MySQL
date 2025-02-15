<?php
include '../includes/db.php';
session_start();

// Check if the user is logged in
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

// Fetch all users from the database
$sql = "SELECT id, username, email FROM users"; // Adjust the query to match your table structure
$result = $conn->query($sql);
$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - GPS Based Restaurant Finder</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: url('background_local.jpg') no-repeat center center/cover;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background: rgba(0, 0, 0, 0.8);
            padding: 20px 0;
            color: #fff;
            text-align: center;
        }

        header h1 {
            margin: 0;
            font-size: 36px;
            font-weight: 600;
        }

        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 10px;
        }

        nav a {
            color: #f4f4f4;
            text-decoration: none;
            font-size: 18px;
            font-weight: 400;
            transition: 0.3s;
        }

        nav a:hover {
            color: #ffd700;
        }

        .container {
            flex: 1;
            padding: 40px 20px;
            max-width: 900px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
        }

        h2 {
            text-align: center;
            color: #fff;
            font-weight: 600;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            color: #fff;
            font-size: 16px;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
        }

        tr:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        footer {
            background: rgba(0, 0, 0, 0.8);
            color: #fff;
            text-align: center;
            padding: 15px 0;
        }
    </style>
</head>
<body>
    <header>
        <h1>Flavor Finder</h1>
        <nav>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="about.html">About Us</a></li>
                <li><a href="register.php">Register</a></li>
                <li><a href="login.php">Login</a></li>
            </ul>
        </nav>
    </header>

    <section id="users">
        <div class="container">
            <h2>Registered Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if ($result->num_rows > 0): ?>
                        <?php while ($row = $result->fetch_assoc()): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($row['id']); ?></td>
                                <td><?php echo htmlspecialchars($row['username']); ?></td>
                                <td><?php echo htmlspecialchars($row['email']); ?></td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="3" style="text-align: center;">No users found</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </section>

    <footer>
        <p>&copy; 2025 GPS Based Restaurant Finder. All rights reserved.</p>
    </footer>
</body>
</html>
