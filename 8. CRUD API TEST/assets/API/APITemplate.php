<?php
	$koneksi = @mysqli_connect("localhost","root","");
	$database = mysqli_select_db($koneksi,"dbTemplate");
    
    
	$respon = array(); 
	$keyAkses = 'apiapi';
	
	$key = $_GET['key'];
	$act = $_GET['act'];

    //http://localhost/appru/API/GIS/APIGIS.php?key=apiapi&act=
	
	if ($key == $keyAkses){
		$index = 0;
		if (!$koneksi) {
			$respon[$index]['result'] = 'null';
		} else {
			if ($act=='simpan'){ 
				$nm = $_POST['nm'];
				$kelas = $_POST['kelas'];
				$alamat = $_POST['alamat'];

				$SQLAdd = 
					"INSERT INTO siswa (nm, kelas, alamat) VALUES ('".$nm."', '".$kelas."', '".$alamat."')";

				if (mysqli_query($koneksi, $SQLAdd)) {
					$respon[$index]['result'] = "SUKSES";
					$respon[$index]['pesan'] = "BERHASIL SIMPAN";
				} else {
					$respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = "GAGAL SIMPAN";
				}
			} elseif ($act=='ubah') {
				$id = $_POST['id'];
				$nm = $_POST['nm'];
				$kelas = $_POST['kelas'];
				$alamat = $_POST['alamat'];

				$SQLAdd = 
					"UPDATE siswa SET
						nm = '".$nm."',
						kelas = '".$kelas."',
						alamat = '".$alamat."'
					WHERE id = '".$id."'";

				if (mysqli_query($koneksi, $SQLAdd)) {
					$respon[$index]['result'] = "SUKSES";
					$respon[$index]['pesan'] = "BERHASIL UBAH";
				} else {
					$respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = "GAGAL UBAH";
				}
			} elseif ($act=='hapus') {
				$id = $_POST['id'];

				$SQLAdd = 
					"DELETE FROM siswa WHERE id = '".$id."'";

				if (mysqli_query($koneksi, $SQLAdd)) {
					$respon[$index]['result'] = "SUKSES";
					$respon[$index]['pesan'] = "BERHASIL HAPUS";
				} else {
					$respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = "GAGAL HAPUS";
				}
			} elseif ($act=='loadData'){

				$SQLAdd = 
					"SELECT * FROM siswa ORDER BY nm ASC";

				$query = mysqli_query($koneksi, $SQLAdd);

				if (mysqli_num_rows($query) > 0){
					while ($list = mysqli_fetch_array($query)) {
						$respon[$index]['id'] = $list['id'];  
						$respon[$index]['nm'] = $list['nm'];  
						$respon[$index]['kelas'] = $list['kelas'];  
						$respon[$index]['alamat'] = $list['alamat'];    

						$index++;
					}
				} else {
					$respon[$index]['result'] = 'null';	
					$respon[$index]['pesan'] = 'MAAF, TIDAK ADA DATA';	
				}
				
			} else {
				$respon[$index]['result'] = "null";
			}
		}
	} else {
		$respon[$index]['result'] = 'null';
	}
	echo json_encode($respon,JSON_PRETTY_PRINT);
	?>