<?php
include '../includes/db.php'; // Include your database connection

$error_message = '';
$success_message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];

    // Check if the email exists in the database
    $sql = "SELECT id FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // Generate a unique token for the password reset link
        $token = bin2hex(random_bytes(32)); // Secure random token
        $expiry = date("Y-m-d H:i:s", time() + 3600); // Token expires in 1 hour

        // Save the token in the database
        $sql = "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE email = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sss", $token, $expiry, $email);
        $stmt->execute();

        // Send the password reset link to the user's email (simulated here)
        $reset_link = "http://yourwebsite.com/reset-password.php?token=$token";
        $subject = "Password Reset Request";
        $message = "Click the link below to reset your password:\n\n$reset_link";
        $headers = "From: no-reply@yourwebsite.com";

        // Simulate sending the email
        if (mail($email, $subject, $message, $headers)) {
            $success_message = "A password reset link has been sent to your email.";
        } else {
            $error_message = "Failed to send the password reset email.";
        }
    } else {
        $error_message = "Email not found.";
    }

    $stmt->close();
    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password</title>
  <link rel="stylesheet" href="login.css"> <!-- Reuse your login page styles -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>Forgot Password?</h1>
        <p>Enter your email to reset your password.</p>
      </div>
      <?php if ($error_message): ?>
        <div class="error-message"><?php echo $error_message; ?></div>
      <?php endif; ?>
      <?php if ($success_message): ?>
        <div class="success-message"><?php echo $success_message; ?></div>
      <?php endif; ?>
      <form class="login-form" method="POST" action="">
        <div class="input-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" placeholder="Enter your email" required>
        </div>
        <button type="submit" class="login-button">Send Reset Link</button>
      </form>
      <div class="login-footer">
        <p>Remember your password? <a href="login.php">Login</a></p>
      </div>
    </div>
  </div>
</body>
</html>