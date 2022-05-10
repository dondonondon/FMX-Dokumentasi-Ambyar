unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Ani;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    SB: TStyleBook;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Edit1Typing(Sender: TObject);
  private
    procedure setEdit(E : TEdit);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.Edit1Typing(Sender: TObject);
begin
  setEdit(TEdit(Sender));
end;

procedure TForm1.setEdit(E: TEdit);
var
  L : TLabel;
  T : TFloatAnimation;
  i: Integer;
begin
  L := nil;

  for i := 0 to E.ControlsCount - 1 do begin
    if E.Controls[i] is TLabel then
      L := TLabel(E.Controls[i]);
  end;

  if not Assigned(L) then begin
    L := TLabel.Create(E);
    L.Parent := E;
    L.Width := E.Width;
    L.Text := E.TextPrompt;

    L.Position.X := 0;
    L.Font.Size := E.Font.Size + 0.75;
    L.FontColor := $FF000000;
    L.Font.Style := [TFontStyle.fsBold];
    L.TextSettings.WordWrap := True;
    L.StyledSettings := [];

    L.Visible := False;

    T := TFloatAnimation.Create(L);
    T.Parent := L;
    T.Interpolation := TInterpolationType.Quadratic;
    T.PropertyName := 'Position.Y';
    T.Duration := 0.15;
    T.StartValue := L.Position.Y;
    T.StopValue := -17;

    T.Trigger := 'IsVisible=true';
    T.TriggerInverse := 'IsVisible=false';
  end;

  if E.Text <> '' then begin
    L.Visible := True;
  end else begin
    L.Visible := False;
  end;
end;

end.
