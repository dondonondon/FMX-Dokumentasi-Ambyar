unit frHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Edit,
  FMX.Objects, UI.Base, UI.Standard, FMX.ListBox, UI.Frame, System.ImageList,
  FMX.ImgList, FMX.Ani, FMX.TabControl, System.Actions, FMX.ActnList;

type
  TFHome = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    bntSearch: TCornerButton;
    btnCart: TCornerButton;
    reAds: TRectangle;
    Label1: TLabel;
    reHeader: TRectangle;
    vsMain: TVertScrollView;
    loTop: TLayout;
    lbData: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    img: TImageList;
    Label3: TLabel;
    Layout3: TLayout;
    hsMenu: THorzScrollView;
    Layout1: TLayout;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    Layout2: TLayout;
    loMenu: TLayout;
    lblRec: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Rectangle1: TRectangle;
    faMove: TFloatAnimation;
    tcProduk: TTabControl;
    tiRec: TTabItem;
    tiPopular: TTabItem;
    tiTop: TTabItem;
    Label7: TLabel;
    Label8: TLabel;
    AL: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    ChangeTabAction3: TChangeTabAction;
    loTemp: TLayout;
    reBackground: TRectangle;
    reFoto: TRectangle;
    lblNama: TLabel;
    lblPrice: TLabel;
    btnAdd: TCornerButton;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure faMoveFinish(Sender: TObject);
    procedure lblRecClick(Sender: TObject);
  private
    YY, XX : Single;
    statF : Boolean;
    procedure setFrame;
    procedure addItem(Tab : TTabItem);
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FHome : TFHome;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;


procedure TFHome.addItem(Tab : TTabItem);
var
  lo : TLayout;
  B : TCornerButton;
begin
  lo := TLayout(loTemp.Clone(Tab));
  lo.Parent := Tab;

  lo.Position.Y := YY;
  lo.Position.X := XX;

  lo.Visible := True;

  B := TCornerButton(lo.FindStyleResource('btnAdd'));
  B.Images := img;
  B.ImageIndex := 4;
end;

procedure TFHome.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFHome.faMoveFinish(Sender: TObject);
begin
  faMove.Enabled := False;
end;

procedure TFHome.FirstShow;
var
  i: Integer;
begin
  setFrame;
end;

procedure TFHome.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFHome.lblRecClick(Sender: TObject);
var
  L : TLabel;
  i: Integer;
begin
  for i := 0 to loMenu.ControlsCount - 1 do begin
    if loMenu.Controls[i] is TLabel then begin
      TLabel(loMenu.Controls[i]).Font.Size := 14;
      TLabel(loMenu.Controls[i]).FontColor := $FFABABAB;
      TLabel(loMenu.Controls[i]).StyledSettings := [];
    end;
  end;

  L := TLabel(Sender);
  L.Font.Size := 18;
  L.FontColor := $FF000000;
  L.StyledSettings := [];

  faMove.StartFromCurrent := True;
  faMove.StopValue := L.Position.X;

  faMove.Enabled := True;

  AL.Actions[L.Tag].Execute;
end;

procedure TFHome.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFHome.setFrame;
var
  i: Integer;
  tempHeight : Single;
begin
  fnGetClient(FMain, FHome);
  fnSetFooter(FMain.btnHome);

  FHome.Height := FMain.Height - FMain.loFooter.Height;

  if statF then
    Exit;

  for i := 0 to vsMain.ContentControlsCount - 1 do begin
    vsMain.ContentControls[i].Width := vsMain.Width;
  end;

  loTemp.Width := (tcProduk.Width / 2) - (pad * 2);
  statF := True;
  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
  
  
  {======================INSERT DATA ASAL=========================}
  fnLoadImage(reFoto, '1.jpg');
  YY := 0;
  XX := pad;
  for i := 0 to 11 do begin
    addItem(tiRec);

    XX := XX + loTemp.Width + pad + pad;

    if (i mod 2) = 1 then begin
      XX := pad;
      YY := YY + loTemp.Height + Pad;
    end;
  end;

  fnLoadImage(reFoto, '2.jpg');
  YY := 0;
  XX := pad;
  for i := 0 to 11 do begin
    addItem(tiPopular);

    XX := XX + loTemp.Width + pad;

    if (i mod 2) = 1 then begin
      XX := pad;
      YY := YY + loTemp.Height + Pad;
    end;
  end;

  fnLoadImage(reFoto, '3.jpg');
  YY := 0;
  XX := pad;
  for i := 0 to 11 do begin
    addItem(tiTop);

    XX := XX + loTemp.Width + pad;
    tempHeight := YY;

    if (i mod 2) = 1 then begin
      XX := pad;
      YY := YY + loTemp.Height + Pad;
    end;
  end;

  tcProduk.Height := YY;
  //tcProduk.Height := (loTemp.Height * 6) + (pad * 2) + tcProduk.TabHeight;
end;

end.
