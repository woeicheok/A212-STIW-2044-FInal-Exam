<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['customer_email'];
$sqlloadcart = "SELECT tbl_carts.cart_id, tbl_carts.subject_id, tbl_carts.cart_qty, tbl_subjects.subject_name, tbl_subjects.subject_price, tbl_subjects.subject_sessions FROM tbl_carts INNER JOIN tbl_subjects ON tbl_carts.subject_id = tbl_subjects.subject_id WHERE tbl_carts.customer_email = '$email' AND tbl_carts.cart_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    //do something
    $total_payable = 0;
    $carts["cart"] = array();
    while ($rows = $result->fetch_assoc()) {
        
        $subjectlist = array();
        $subjectlist['cart_id'] = $rows['cart_id'];
        $subjectlist['subject_name'] = $rows['subject_name'];
        $subjectprice = $rows['subject_price'];
        $subjectlist['price'] = number_format((float)$subjectprice, 2, '.', '');
        $subjectlist['cart_qty'] = $rows['cart_qty'];
        $subjectlist['subject_sessions'] = $rows['subject_sessions'];
        $subjectlist['subject_id'] = $rows['subject_id'];
        $price = $rows['cart_qty'] * $subjectprice;
        $total_payable = $total_payable + $price;
        $subjectlist['price_total'] = number_format((float)$price, 2, '.', ''); 
        array_push($carts["cart"],$subjectlist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>