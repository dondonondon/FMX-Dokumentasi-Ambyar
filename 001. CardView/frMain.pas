unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.Threading,
  FMX.Effects;

type
  TFMain = class(TForm)
    vsMain: TVertScrollBox;
    loTemp: TLayout;
    reTempBg: TRectangle;
    reTempImg: TRectangle;
    lblNama: TLabel;
    lblTgl: TLabel;
    SB: TStyleBook;
    loLoad: TLayout;
    aniLoad: TAniIndicator;
    btnRefresh: TCornerButton;
    reFooter: TRectangle;
    seFooter: TShadowEffect;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    YY : Single;
    procedure setForm;
    procedure addItem(nmProduk, tgl, locImg : String; posX, posY : Single);
    procedure fnLoadData;
    procedure fnLoadLoading(stat : Boolean);

    procedure fnClickBtn(Sender : TObject);
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

{ TFMain }

const
  pad = 8;
  spc = 12;
  cKol = 2;

procedure TFMain.addItem(nmProduk, tgl, locImg: String; posX, posY: Single);
var
  lo : TLayout;
  eSE : TShadowEffect;
begin
  lblNama.Text := nmProduk;
  lblTgl.Text := tgl;

  //reTempImg.Fill.Bitmap.Bitmap.LoadFromFile(locImg); //load image berdasarkan lokasi gambar

  lo := TLayout(loTemp.Clone(vsMain));
  lo.Parent := vsMain;

  lo.Position.X := posX;
  lo.Position.Y := posY;

  lo.Visible := True;

  eSE := TShadowEffect.Create(lo);
  eSE.Parent := lo;
  eSE.Enabled := True;
  eSE.Opacity := 0.25;

  lo.Repaint;

  Application.ProcessMessages;
end;

procedure TFMain.btnRefreshClick(Sender: TObject);
begin
  vsMain.Content.DeleteChildren;

  YY := pad;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFMain.fnClickBtn(Sender: TObject);
var
  B : TCornerButton;
begin
  B := TCornerButton(Sender);

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;

  B.Parent.DisposeOf;
end;

procedure TFMain.fnLoadData;
var
  kol, bar, i, j, totData : Integer;
  posX, posY : Single;
  lo : TLayout;
  B : TCornerButton;
begin
  fnLoadLoading(True);   //optional
  try
    totData := 10;
    kol := 0;

    posX := pad;
    posY := YY;

    for i := 0 to totData - 1 do begin
      TThread.Synchronize(nil, procedure begin
        addItem('Kaos Kaki Merah', 'Sampai 20 Agt', 'img.png', posX, posY);
      end);

      Sleep(5); // reduce lag

      Inc(kol);
      if kol = cKol then begin
        posY := posY + pad + loTemp.Height;
        posX := pad;
        kol := 0;

        YY := posY;
      end else begin
        posX := posX + pad + loTemp.Width;
      end;
    end;

    TThread.Synchronize(nil, procedure begin
      lo := TLayout.Create(vsMain);
      lo.Parent := vsMain;

      lo.Width := vsMain.Width;
      lo.Height := 35 + pad;

      lo.Position.X := 0;
      lo.Position.Y := posY;

        B := TCornerButton.Create(lo);
        B.Parent := lo;

        B.Width := 150;
        B.Height := 35;

        B.Position.X := (vsMain.Width / 2) - (B.Width / 2);
        B.Position.Y := 0;

        B.Text := 'Next';
        B.Font.Size := 13;
        B.FontColor := TAlphaColorRec.White;

        B.StyleLookup := 'btnMain'; //cek style manager

        B.StyledSettings := [];

        B.OnClick := fnClickBtn;
    end);
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMain.fnLoadLoading(stat: Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    loLoad.BringToFront;
    loLoad.Visible := stat;
    aniLoad.Enabled := stat;
  end);
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  setForm;
  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFMain.setForm;
var
  wi, he, ww, hh : Single;
begin
  wi := ClientWidth;
  he := ClientHeight;

  ww := (wi - (pad * 3)) / cKol;
  hh := ww + 65;

  loTemp.Width := ww;
  loTemp.Height := hh;

  reTempImg.Width := ww;
  reTempImg.Height := ww;

  loTemp.Position.X := pad;
  loTemp.Position.Y := pad;

  YY := pad;
end;

end.
