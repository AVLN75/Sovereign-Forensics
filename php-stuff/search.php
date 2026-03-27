<?php
// Database connection
$conn = mysqli_connect("localhost", "db_user", "db_password", "college_project");

// GET the ID from the URL (e.g., search.php?id=1)
$id = $_GET['id']; 

// VULNERABLE QUERY: Data is concatenated directly into the string
$query = "SELECT username, email FROM users WHERE id = $id";
$result = mysqli_query($conn, $query);

// If the query fails, the server "leaks" the error to the user
if (!$result) {
    die("Database Error: " . mysqli_error($conn)); 
}

while($row = mysqli_fetch_assoc($result)) {
    echo "User: " . $row['username'] . " | Email: " . $row['email'];
}
?>