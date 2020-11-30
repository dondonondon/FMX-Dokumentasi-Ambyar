unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TmainForm = class(TForm)
    btnCreate: TCornerButton;
    procedure ARecMouseLeave(Sender: TObject);
    procedure ARecMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure ARecMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ARecMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnCreateClick(Sender: TObject);
  private
    ADrag : Boolean;
    tempX, tempY : Single;
    procedure fnCreateRec;
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.fmx}

{ TForm1 }

procedure TmainForm.ARecMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ADrag := True;

  TRectangle(Sender).BringToFront;

  tempX := X;
  tempY := Y;
end;

procedure TmainForm.ARecMouseLeave(Sender: TObject);
begin
  ADrag := False;
end;

procedure TmainForm.ARecMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  newR : TRectangle;
begin
  if not ADrag then
    Exit;

  newR := TRectangle(Sender);

  newR.Position.X := newR.Position.X + (X - tempX);
  newR.Position.Y := newR.Position.Y + (Y - tempY);

  Application.ProcessMessages;
end;

procedure TmainForm.ARecMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ADrag := False;
end;

procedure TmainForm.btnCreateClick(Sender: TObject);
begin
  fnCreateRec;
end;

procedure TmainForm.fnCreateRec;
var
  posX, posY, wRec, hRec : Single;
  ARec : TRectangle;
begin
  wRec := 50;
  hRec := wRec;

  posX := Random(Round(mainForm.Width));
  posY := Random(Round(mainForm.Height));

  if posX > Self.Width then
    posX := posX - wRec;

  if posY > Self.Height then
    posY := posY - hRec;

  ARec := TRectangle.Create(Self);
  ARec.Parent := Self;

  ARec.Width := wRec;
  ARec.Height := hRec;
  ARec.Position.X := posX;
  ARec.Position.Y := posY;


  ARec.OnMouseDown := ARecMouseDown;
  ARec.OnMouseLeave := ARecMouseLeave;
  ARec.OnMouseMove := ARecMouseMove;
  ARec.OnMouseUp := ARecMouseUp;
end;

end.
