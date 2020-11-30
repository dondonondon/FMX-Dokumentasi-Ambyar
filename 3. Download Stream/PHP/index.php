
<?php  
  include ('fpdf182/fpdf.php');
  #include ('koneksi.php');
  $no=1;

  $pdf = new FPDF('P','mm','A4'); //L = lanscape P= potrait
  $pdf->SetMargins(10 ,20, 10 );
  $pdf->AddPage();
  // setting jenis font yang akan digunakan

  $pdf->SetFont('Arial','B',14);
  $ya = 44;
  $pdf->Cell(0,7,'LAPORAN REKOMENDASI FURNITURE',0,1,'C');
  $pdf->SetFont('Arial','B',13);
  $pdf->SetFont('Arial','',12);
  $pdf->Cell(0,11,'Tanggal: '.DATE('d').'/'.DATE('M').'/'.DATE('Y'),0,1,'C');
  $pdf->SetLineWidth(1);
  $pdf->SetDrawColor(1,1,1);
  $pdf->line(10,40,200,40);
  $pdf->SetLineWidth(0);
  $pdf->SetFont('Arial','B',7);
  $pdf->Cell(75,10,'',0,1,'L');
  $pdf->Cell(8,10,'NO',1,0,'C');
  $pdf->Cell(25,10,'KODE BARANG',1,0,'C');
  $pdf->Cell(25,10,'NAMA BARANG',1,0,'C');
  $pdf->Cell(20,10,'KATEGORI',1,0,'C');
  $pdf->Cell(25,10,'HARGA',1,0,'C');
  $pdf->Cell(30,10,'FOTO',1,0,'C');
  $pdf->Cell(57,10,'KETERANGAN',1,1,'C');

  $pos=60;
  $i='';

  $data1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
  $data2 = "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
  $data3 = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.";
  $data4 = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.";
  $data5 = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.";
  $data6 = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.";

  #$data2 = "adss";

  for ($i = 0 ; $i < 100; $i++){
    $text=$data2;
    $w=$pdf->GetStringWidth($text);
    $H=((ceil($w/20))+2)*5;

    $pdf->Cell(8,$H,($i + 1),1,0,'C');

    /*$pdf->Cell(25,$H,$data2,1,0,'C');
    $pdf->Cell(25,$H,$data2,1,0,'C');
    $pdf->Cell(20,$H,$data2,1,0,'C');
    $pdf->Cell(25,$H,$data2,1,0,'C');*/
    
    
    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(25,5,$data1);
    $pdf->SetXY($x,$y);
    $pdf->Cell(25,$H,'',1,0,'C');
    
    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(25,5,$data2);
    $pdf->SetXY($x,$y);
    $pdf->Cell(25,$H,'',1,0,'C');
    
    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(20,5,$data3);
    $pdf->SetXY($x,$y);
    $pdf->Cell(20,$H,'',1,0,'C');
    
    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(25,5,$data4);
    $pdf->SetXY($x,$y);
    $pdf->Cell(25,$H,'',1,0,'C');
    
    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(30,5,$data5);
    $pdf->SetXY($x,$y);
    $pdf->Cell(30,$H,'',1,0,'C');

    $x=$pdf->GetX();
    $y=$pdf->GetY();
    $pdf->MultiCell(57,5,$data6);
    $pdf->SetXY($x,$y);
    $pdf->Cell(57,$H,'',1,1,'C');

  }

  $pdf->Output();

?>
	