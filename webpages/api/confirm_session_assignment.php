<?php

if (!include ('../../db_name.php')) {
	include ('../../db_name.php');
}

session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_SESSION['badgeid'])) {

    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if ($data && array_key_exists('sessionId', $data) && array_key_exists('value', $data)) {

        // TODO: update the database...

        http_response_code(201);

    } else {
        http_response_code(400); // badly-formatted request
    }

} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    http_response_code(401); // not authenticated
} else {
    http_response_code(405); // method not allowed
}
?>