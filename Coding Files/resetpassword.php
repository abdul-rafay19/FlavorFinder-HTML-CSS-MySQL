<?php
include '../includes/db.php'; // Include your database connection

$error_message = '';
$success_message = '';

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['token'])) {
    $token = $_GET['token'];

    // Check if the token is valid and not expired
    $sql = "SELECT id FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // Token is valid
        $user_id = $stmt->fetch_assoc()['id'];
    } else {
        $error_message = "Invalid or expired token.";
    }

    $stmt->close();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $token = $_POST['token'];
    $new_password = $_POST['new_password'];
    $confirm_password = $_POST['confirm_password'];

    if ($new_password !== $confirm_password) {
        $error_message = "Passwords do not match.";
    } else {
        // Hash the new password
        $hashed_password = password_hash($new_password, PASSWORD_BCRYPT);

        // Update the user's password and clear the reset token
        $sql = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE reset_token = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ss", $hashed_password, $token);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            $success_message = "Your password has been reset successfully.";
        } else {
            $error_message = "Failed to reset your password.";
        }

        $stmt->close();
    }

    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password</title>
  <link rel="stylesheet" href="login.css"> <!-- Reuse your login page styles -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>Reset Password</h1>
        <p>Enter your new password.</p>
      </div>
      <?php if ($error_message): ?>
        <div class="error-message"><?php echo $error_message; ?></div>
      <?php endif; ?>
      <?php if ($success_message): ?>
        <div class="success-message"><?php echo $success_message; ?></div>
      <?php endif; ?>
      <form class="login-form" method="POST" action="">
        <input type="hidden" name="token" value="<?php echo htmlspecialchars($_GET['token'] ?? ''); ?>">
        <div class="input-group">
          <label for="new_password">New Password</label>
          <input type="password" id="new_password" name="new_password" placeholder="Enter new password" required>
        </div>
        <div class="input-group">
          <label for="confirm_password">Confirm Password</label>
          <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm new password" required>
        </div>
        <button type="submit" class="login-button">Reset Password</button>
      </form>
      <div class="login-footer">
        <p>Remember your password? <a href="login.php">Login</a></p>
      </div>
    </div>
  </div>
</body>
</html>