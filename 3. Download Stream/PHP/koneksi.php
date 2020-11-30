<?php 
	$koneksi = @mysqli_connect("host","user","password");
	$database = mysqli_select_db($koneksi,"database");

	if (!$koneksi) {
		die("koneksi gagal");
	}
 
?>