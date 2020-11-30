unit frTemp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TFTemp = class(TFrame)
  private
    { Private declarations }
    procedure setFrame;
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  FTemp : TFTemp;

implementation

{$R *.fmx}

uses frMain, uFunc;

{ TFTemp }

procedure TFTemp.FirstShow;
begin
  setFrame;
end;

procedure TFTemp.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFTemp.setFrame;
var
  wi, he, pad : Single;
begin
  wi := FTemp.Width;
  he := FTemp.Height;
end;

end.
