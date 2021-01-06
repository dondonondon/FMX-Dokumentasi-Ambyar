unit frGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Effects, FMX.Layouts, FMX.Ani,
  FMX.ScrollBox, FMX.Memo;

type
  TFGame = class(TFrame)
    btnBack: TCornerButton;
    background: TImage;
    loMain: TLayout;
    seMain: TShadowEffect;
    imgMain: TImage;
    bgMain: TRectangle;
    reTemp: TRectangle;
    imgTemp: TImage;
    reScan: TRectangle;
    flMain: TLayout;
    faX: TFloatAnimation;
    faY: TFloatAnimation;
    coA2: TColorAnimation;
    loGame: TLayout;
    lblXY: TLabel;
    btnLog: TCornerButton;
    loResult: TLayout;
    bgResult: TRectangle;
    memResult: TMemo;
    lblNama: TLabel;
    btnClose: TCornerButton;
    faResult: TFloatAnimation;
    lblSelamat: TLabel;
    faFont: TFloatAnimation;
    faOpaFont: TFloatAnimation;
    loHide: TLayout;
    btnShow: TCornerButton;
    procedure btnBackClick(Sender: TObject);
    procedure faXFinish(Sender: TObject);
    procedure reTempClick(Sender: TObject);
    procedure loGameClick(Sender: TObject);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure reScanMouseEnter(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure faResultFinish(Sender: TObject);
    procedure faFontFinish(Sender: TObject);
    procedure faOpaFontFinish(Sender: TObject);
    procedure faFontProcess(Sender: TObject);
  private
    xxx, yyy : Single;
    newPosX, newPosY : Single;
    tempImage : TImage;
    newFX, newFY : TFloatAnimation;
    newR : TRectangle;
    statMessage, statPosResult, statShowResult : Boolean;
    arrPosAns : array of record
      posX, posY : Single;
      index : Integer;
    end;
    transID, transTag : Integer;
    { Private declarations }
    procedure fnGetE(Msg, Cls : String); overload;
    procedure fnGetE(Msg : String); overload;
    function fnMaxMinPos(AParentVal, valParent, oldPos : Single): Single;
    procedure setFrame;
    procedure cropImg(AParent : TRectangle; From, Dest : TImage);
    procedure addRectI(xx, yy, posX, posY : Single; tg : Integer);
    procedure addRectT(xx, yy, posX, posY : Single; tg : Integer);
    procedure fnAnimateFloat(const AParent: TControl; const fX, fY : TFloatAnimation; stopX, stopY : Single; Duration : Single; stat : Boolean = False);
    procedure delPuzzle;
    procedure newGame;
    procedure setHasil(index, str: Integer);
    function CheckSpell: Boolean;
    procedure fnShowHasil;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure FirstShow;
  end;

var
  FGame : TFGame;

implementation

{$R *.fmx}

uses uFunc, frMain;

const
  baris = 3;
  kolom = 3;

{ TFGame }

procedure TFGame.addRectI(xx, yy, posX, posY : Single; tg : Integer);
var
  R : TRectangle;
  i: Integer;
begin
  R := TRectangle(reTemp.Clone(loGame));
  R.Parent := loGame;
  R.HitTest := True;
  R.Tag := tg;
  R.Width := xx;
  R.Height := yy;
  R.Position.X := posX;
  R.Position.Y := posY;
  R.Stroke.Kind := TBrushKind.None;

  R.Hint := 'temp';

  R.Visible := True;

  R.OnClick := reTempClick;
  R.OnMouseMove := FrameMouseMove;

  for i := 0 to R.ChildrenCount - 1 do begin
    if R.Children[i] is TFloatAnimation then begin
      TFloatAnimation(R.Children[i]).OnFinish := faXFinish;
    end else if R.Children[i] is TImage then begin
      tempImage := TImage(R.Children[i]);
    end;
  end;
end;

procedure TFGame.addRectT(xx, yy, posX, posY: Single; tg: Integer);
var
  R : TRectangle;
begin
  R := TRectangle(reScan.Clone(flMain));
  R.Parent := flMain;
  R.HitTest := True;
  R.Tag := tg;
  R.Width := xx;
  R.Height := yy;
  R.Position.X := posX;
  R.Position.Y := posY;
  R.Stroke.Color := $FFE3E3E3;
  R.Stroke.Kind := TBrushKind.Solid;
  R.Stroke.Thickness := 0.5;

  R.Hint := 'temp';

  R.Visible := True;

  R.OnClick := loGameClick;
  R.OnMouseMove := FrameMouseMove;
  R.OnMouseEnter := reScanMouseEnter;
end;

procedure TFGame.btnBackClick(Sender: TObject);
begin
  delPuzzle;
  FirstShow;
end;

procedure TFGame.btnCloseClick(Sender: TObject);
begin
  statShowResult := True;

  faResult.Inverse := True;
  faResult.Enabled := True;
end;

procedure TFGame.btnLogClick(Sender: TObject);
begin
  //FMain.tcMain.Next();
end;

procedure TFGame.cropImg(AParent : TRectangle; From, Dest : TImage);
var
  Bmp: TBitmap;
  xScale, yScale: extended;
  iRect: TRect;
begin
  Bmp := TBitmap.Create;
  xScale := From.Bitmap.Width / From.Width;
  yScale := From.Bitmap.Height / From.Height;
  try
    Bmp.Width := round(AParent.Width * xScale);
    Bmp.Height := round(AParent.Height * yScale);
    iRect.Left := round(AParent.Position.X * xScale);
    iRect.Top := round(AParent.Position.Y * yScale);
    iRect.Width := round(AParent.Width * xScale);
    iRect.Height := round(AParent.Height * yScale);
    Bmp.CopyFromBitmap(From.Bitmap, iRect, 0, 0);
    Dest.Bitmap := Bmp;
  finally
    Bmp.Free;
  end;
end;

procedure TFGame.delPuzzle;
var
  i : Integer;
begin
  newR := nil;
  newFX := nil;
  newFY := nil;

  for i := flMain.ControlsCount - 1 downto 0 do begin
    if flMain.Controls[i] is TRectangle then begin
      if TRectangle(flMain.Controls[i]).Hint = 'temp' then
        TRectangle(flMain.Controls[i]).DisposeOf;
    end;
  end;
  
  for i := loGame.ControlsCount - 1 downto 0 do begin
    if loGame.Controls[i] is TRectangle then begin
      if TRectangle(loGame.Controls[i]).Hint = 'temp' then
        TRectangle(loGame.Controls[i]).DisposeOf;
    end;
  end;
end;

procedure TFGame.faFontFinish(Sender: TObject);
begin
  faFont.Enabled := False;
  faOpaFont.Enabled := True;
end;

procedure TFGame.faFontProcess(Sender: TObject);
begin
  fnGetCenter(loGame, lblSelamat);
  Application.ProcessMessages;
end;

procedure TFGame.faOpaFontFinish(Sender: TObject);
begin
  faOpaFont.Enabled := False;
  lblSelamat.Visible := False;
end;

procedure TFGame.faResultFinish(Sender: TObject);
begin
  faResult.Enabled := False;

  if statShowResult = True then begin
    loResult.Visible := False;
    delPuzzle;
    FirstShow;
  end;
end;

procedure TFGame.faXFinish(Sender: TObject);
var
  F : TFloatAnimation;
begin
  F := TFloatAnimation(Sender);
  F.Enabled := False;

  if (Assigned(newR)) AND (Assigned(newFX)) AND (Assigned(newFY)) then begin
    if transTag >= 0 then
    begin
      setHasil(transTag, newR.Tag);
      transTag := -1; // -1 untuk rect puzzle -2 untuk jawaban di array
    end;

    if CheckSpell then
    begin
      if statMessage = True then
      begin
        statMessage := False;
        fnShowHasil;
      end;
    end;

    newR := nil;
    newFX := nil;
    newFY := nil;
  end;
end;

function TFGame.CheckSpell: Boolean;
var
  i, xx, yy : Integer;
  hasil : String;
  compares : Boolean;
begin
  try
    fnGetE('===================================');
    compares := False;
    hasil := '';
    for i := 0 to flMain.ControlsCount - 1 do begin
      xx := TControl(flMain.Controls[i]).Tag;
      yy := arrPosAns[xx].index;
      if xx = yy then begin
        hasil := hasil + '(' + xx.ToString + ',' + yy.ToString + ')';
        compares := True;
      end else begin
        compares := False;
        Break;
      end;
      fnGetE(hasil);
    end;
    Result := compares;
  except
    Result := compares;
  end;
end;

procedure TFGame.FirstShow;
var
  xx : Integer;
begin
  xx := Random(8);
  if xx = 0 then
    xx := 1;
    
  fnLoadImage(imgMain, xx.ToString + '.jpeg');
  fnLoadImage(background, 'bg.jpg');
  
  setFrame;
  newGame;
end;

procedure TFGame.fnAnimateFloat(const AParent: TControl; const fX,
  fY: TFloatAnimation; stopX, stopY, Duration: Single; stat: Boolean);
begin
  try
    //stopX := fnMaxMinPos(loGame.Width, AParent.Width, stopX);
    //stopY := fnMaxMinPos(loGame.Height, AParent.Height, stopY);

    fX.Duration := Duration;
    fX.StopValue := stopX;

    fY.Duration := Duration;
    fY.StopValue := stopY;

    fX.Enabled := True;
    fY.Enabled := True;
  finally

  end;
end;

procedure TFGame.fnGetE(Msg: String);
begin
  {TThread.Synchronize(nil, procedure
  begin
    memLog.BeginUpdate;
    memLog.Lines.Add('PESAN : ' + Msg);
    memLog.EndUpdate;
    memLog.GoToTextEnd;
  end);      }
end;

procedure TFGame.fnGetE(Msg, Cls: String);
begin

end;

function TFGame.fnMaxMinPos(AParentVal, valParent, oldPos: Single): Single;
var
  newPos : Single;
begin
  if oldPos > (AParentVal - (valParent * 1)) then
    oldPos := (AParentVal - (valParent * 1))
  else if oldPos < 0 then
    newPos := oldPos + valParent
  else
    newPos := oldPos;

  Result := newPos;
end;

procedure TFGame.fnShowHasil;
begin
  statShowResult := False;
  
  loResult.Opacity := 0;
  loResult.Visible := True;

  lblSelamat.Visible := True;
  lblSelamat.Opacity := 1;
  lblSelamat.Font.Size := 10;

  faResult.Inverse := False;

  faResult.Enabled := True;   
  faFont.Enabled := True;
end;

procedure TFGame.FrameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  newPosX := X;
  newPosY := Y;
  lblXY.Text := 'POS (X,Y) : (' +  FormatFloat('###,#00.00', newPosX) + ',' + FormatFloat('###,#00.00', newPosY) + ')';
end;

procedure TFGame.loGameClick(Sender: TObject);
var
  RR : TRectangle;
  TT : TLayout;
  i: Integer;
begin  
  statMessage := True;
  
  if (Assigned(newR)) AND (Assigned(newFX)) AND (Assigned(newFY)) then begin
    if Sender is TLayout then begin
      xxx := newPosX;
      yyy := newPosY;

      if transID >= 0 then begin
        arrPosAns[transID].index := -2;
        transID := -1;
      end;
      
      fnAnimateFloat(newR, newFX, newFY, xxx - (newR.Width / 2), yyy - (newR.Height / 2), 0.2);
    end else if Sender is TRectangle then begin
      RR := Sender as TRectangle;
      transTag := RR.Tag;

      xxx := RR.Position.X + loMain.Position.X + flMain.Position.X + (RR.Width / 2);
      yyy := RR.Position.Y + loMain.Position.Y + flMain.Position.Y + (RR.Height / 2);

      newR.BringToFront;
      fnAnimateFloat(newR, newFX, newFY, xxx - (newR.Width / 2), yyy - (newR.Height / 2), 0.2, True);
    end;
  end;
end;

procedure TFGame.newGame;
var
  xx, yy, bar, kol, tg : Integer;
  posX, posY, posXR, posYR : Single;
  i: Integer;
begin
  reScan.Visible := True;

  xx := Round(flMain.Width / kolom);
  yy := Round(flMain.Height / baris);

  reScan.Width := xx;
  reScan.Height := yy;

  reTemp.Width := xx;
  reTemp.Height := yy;

  fnGetClient(reTemp, imgTemp);

  tg := 0;

  fnGetE('HEIGTH : ' + loGame.Height.ToString);
  fnGetE('WIDTH : ' + loGame.Width.ToString);
  
  SetLength(arrPosAns, kolom * baris);
  for bar := 0 to baris - 1 do begin
    posY := bar * yy;
    for kol := 0 to kolom - 1 do begin
      posXR := fnMaxMinPos(loGame.Width, xx, Random(loGame.Width.ToString.ToInteger));
      posYR := fnMaxMinPos(loGame.Height, yy, Random(loGame.Height.ToString.ToInteger));

      if (posXR > loGame.Width) or (posXR < 0) then
        posXR := 50;

      if (posYR > loGame.Height) or (posYR < 0) then
        posYR := 50;

      posX := kol * xx;

      reScan.Position.X := posX;
      reScan.Position.Y := posY;

      addRectT(xx, yy, posX, posY, tg);
      addRectI(xx, yy, posXR, posYR, tg);
      cropImg(reScan, imgMain, tempImage);

      fnGetE('X : ' + posXR.ToString, 'Y : ' + posYR.ToString);
      fnGetE('TAG : ' + tg.ToString);
      fnGetE('===============================');

      arrPosAns[tg].posX := posX + loMain.Position.X + flMain.Position.X;
      arrPosAns[tg].posY := posY + loMain.Position.Y + flMain.Position.Y;
      arrPosAns[tg].index := -2;
            
      Inc(tg);
      Application.ProcessMessages;
    end;
  end;
  reScan.Visible := False;
end;

procedure TFGame.ReleaseFrame;
begin
  DisposeOf;
  FGame := nil;
end;

procedure TFGame.reScanMouseEnter(Sender: TObject);
var
  temp : TRectangle;
begin
  temp := Sender as TRectangle;
  try
    newPosX := temp.Position.X + (temp.Width / 2);
    newPosY := temp.Position.Y + (temp.Height / 2);
  finally
    temp := nil;
  end;
end;

procedure TFGame.reTempClick(Sender: TObject);
var
  i : Integer;
  posX, posY : Single;
begin
  newR := TRectangle(Sender);
  posX := newR.Position.X;
  posY := newR.Position.Y;
  
  for i := 0 to Length(arrPosAns) - 1 do
  begin
    if (posX = arrPosAns[i].posX) AND (posY = arrPosAns[i].posY) then begin
      transID := i;
      Break;
    end;
  end;
  
  for i := 0 to newR.ChildrenCount - 1 do begin
    if newR.Children[i] is TFloatAnimation then
      if TFloatAnimation(newR.Children[i]).Tag = 1 then
        newFX := TFloatAnimation(newR.Children[i])
      else
        newFY := TFloatAnimation(newR.Children[i]);
  end;
end;

procedure TFGame.setFrame;
var
  wi, he : Single;
  xx : Integer;
begin
  wi := FGame.Width;
  he := FGame.Height;

  fnGetClient(FGame, background);
  fnGetClient(FGame, loGame);

  xx := Round(he - ((he * 0.1) * 2));
  if (xx mod 2) = 0 then
    xx := xx
  else
    xx := xx + 1;

  loMain.Height := xx;
  loMain.Width := xx;
  fnGetCenter(loGame, loMain);
    fnGetClient(loMain, bgMain);
      imgMain.Height := loMain.Height - 8;   //8 = margin
      imgMain.Width := imgMain.Height;
      fnGetCenter(loMain, imgMain);
        flMain.Width := imgMain.Width;
        flMain.Height := imgMain.Height;
        fnGetCenter(loMain, flMain);

  reScan.Stroke.Kind := TBrushKind.None;

  fnGetClient(reTemp, imgTemp);
  fnGetTop(loGame, lblXY);
  lblXY.Position.Y := 20;

  wi := FGame.Width - 50;
  he := FGame.Height - 50;

  loResult.Width := wi;
  loResult.Height := he;

  fnGetCenter(loGame, loResult);
  fnGetClient(loResult, bgResult);
    memResult.Width := wi - 30;
    memResult.Height := he - (35 + lblNama.Height + 15);
    fnGetBottom(loResult, memResult);
    memResult.Position.Y := memResult.Position.Y - 15;
      lblNama.Width := wi - 50;
      fnGetTop(loResult, lblNama);
      lblNama.Position.Y := 15; 

  lblSelamat.Width := wi;
  fnGetCenter(loGame, lblSelamat);
end;

procedure TFGame.setHasil(index, str: Integer);
var
  i : Integer;
begin
  arrPosAns[index].index := str;
end;

end.
