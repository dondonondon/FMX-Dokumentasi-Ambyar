unit frLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, System.Threading;

type
  TFLoading = class(TFrame)
    background: TRectangle;
    logo: TImage;
  private
    { Private declarations }
    procedure setFrame;
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  FLoading : TFLoading;

implementation

{$R *.fmx}

uses frMain, uFunc, uMain;

{ TFTemp }

procedure TFLoading.FirstShow;
begin
  setFrame;

  TTask.Run(procedure begin
    try
      sleep(idle * 3); //TESTING, HILANGKAN JIKA TIDAK PERLU
      //PROSES AMBIL DATA DARI SERVER TARUH DISINI {UPDATE, CEK NOTIF DLL} (OPTIONAL)
    finally
      fnThreadSyncGoFrame(goFrame, Home); //PROCEDUR PERPINDAHAN FRAME
    end;
  end).Start;
end;

procedure TFLoading.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFLoading.setFrame;
var
  wi, he, pad : Single;
begin
  wi := FLoading.Width;
  he := FLoading.Height;

  pad := 8; //margin / padding

  fnGetClient(FLoading, background);
  fnGetCenter(FLoading, logo);

  fnLoadImage(logo, 'load_images.png');
end;

end.