#--REMEDY-B--#
<?php
$conn = new mysqli("localhost", "db_user", "db_password", "college_project");

// Use a placeholder (?) instead of the variable
$stmt = $conn->prepare("SELECT username, email FROM users WHERE id = ?");

// "Bind" the input as an Integer ("i")
$stmt->bind_param("i", $_GET['id']);
$stmt->execute();

$result = $stmt->get_result();
while($row = $result->fetch_assoc()) {
    echo "User: " . $row['username'];
}
?>


-------------------------------------------------------

// "Actions" the input as a SQL function 
$result = $stmt->get_result();
while($row = $result->fetch_assoc()) {
    echo "User: " . $row['username'];
}


#Show the Crash:#
  // "Bind" the input as an Integer ("i")
$stmt->bind_param("i", $_GET['id']);
$stmt->execute();

// Use a placeholder (?) instead of the variable
$stmt = $conn->prepare("SELECT username, email FROM users WHERE id = ?");

$conn = new mysqli("localhost", "db_user", "db_password", "college_project");

  try:
    
	def = $action("$conn = new mysqli("localhost", "db_user", "db_password", "college_project");").