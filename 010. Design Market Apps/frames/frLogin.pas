unit frLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Edit,
  FMX.ImgList, FMX.Objects;

type
  TFLogin = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    btnBack: TCornerButton;
    Label1: TLabel;
    imgLogo: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    CornerButton1: TCornerButton;
    PasswordEditButton1: TPasswordEditButton;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    statF : Boolean;
    procedure setFrame;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FLogin : TFLogin;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFLogin.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFLogin.CornerButton1Click(Sender: TObject);
begin
  fnGoFrame(LOGIN, HOME);
end;

procedure TFLogin.FirstShow;
begin
  setFrame;
end;

procedure TFLogin.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFLogin.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFLogin.setFrame;
var
  wi, he : Single;
begin
  fnGetClient(FMain.vsMain, FLogin);
  fnLoadImage(imgLogo, 'Logo.png');
  fnSetFooter(FMain.btnAkun);

  if statF then
    Exit;

  statF := True;
  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
end;

end.
