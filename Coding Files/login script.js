// Get the modal and links
const forgotPasswordModal = document.getElementById('forgotPasswordModal');
const forgotPasswordLink = document.querySelector('.forgot-password');
const closeModal = document.querySelector('.close-modal');

// Open the modal when "Forgot Password" is clicked
forgotPasswordLink.addEventListener('click', (e) => {
  e.preventDefault(); // Prevent default link behavior
  forgotPasswordModal.style.display = 'flex';
});

// Close the modal when the close button is clicked
closeModal.addEventListener('click', () => {
  forgotPasswordModal.style.display = 'none';
});

// Close the modal when clicking outside the modal
window.addEventListener('click', (e) => {
  if (e.target === forgotPasswordModal) {
    forgotPasswordModal.style.display = 'none';
  }
});

// Handle form submission (forgot password)
document.getElementById('forgotPasswordForm').addEventListener('submit', (e) => {
  e.preventDefault();
  const email = document.getElementById('recovery-email').value;
  alert(`A password reset link has been sent to ${email}`);
  forgotPasswordModal.style.display = 'none'; // Close the modal
});