unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts;

type
  TFMain = class(TForm)
    loMain: TLayout;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses frGame, uFunc, uHelper;

procedure TFMain.FormShow(Sender: TObject);
begin
  if Assigned(FGame) then
    FGame.Visible := True
  else begin
    FGame := TFGame.Create(Self);
    FGame.Parent := loMain;
    FGame.Align := TAlignLayout.Client;
  end;

  FGame.FirstShow;
end;

end.
