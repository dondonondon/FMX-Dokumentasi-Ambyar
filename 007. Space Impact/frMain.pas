unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.DialogService,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base, System.Permissions,
  FMX.ListView, FMX.ScrollBox, FMX.Memo, FMX.TabControl, System.ImageList, System.Math,
  FMX.ImgList, FMX.MultiView, FMXTee.Engine, FMXTee.Series, FMX.VirtualKeyboard,
  FMXTee.Procs, FMXTee.Chart, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Gestures, FMX.Effects, FMX.Platform,
  FMX.DateTimeCtrls, System.Actions, FMX.ActnList, FMX.StdActns, System.Generics.Collections,
  FMX.MediaLibrary.Actions, FMX.Edit, System.Threading, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, FMX.LoadingIndicator,
  FMX.ListBox, UI.Toast, System.Sensors, System.Sensors.Components, FMX.Maps;

type
  TFMain = class(TForm)
    rePlane: TRectangle;
    tiBullet: TTimer;
    ciAreaJoystick: TCircle;
    ciJoystick: TCircle;
    lblXY: TLabel;
    tiMove: TTimer;
    reEnemy: TRectangle;
    pbEnemy: TProgressBar;
    btnNew: TCornerButton;
    lblHPEnemy: TLabel;
    Edit1: TEdit;
    StyleBook1: TStyleBook;
    Edit2: TEdit;
    procedure FormShow(Sender: TObject);
    procedure ciJoystickMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure ciJoystickMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ciJoystickMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure tiMoveTimer(Sender: TObject);
    procedure tiBulletTimer(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
  private
    tCreate : Integer;
    oPosX, oPosY, mPosX, mPosY : Single;
    ADrag, sMove : Boolean;
    sBullet : TList<TCircle>;

    stEnemyMove : Integer;

    function fnCheckNumber(value : Single): Boolean;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}
const
  coCreate = 10;
  dmg = 15;
  mUp = 0;
  mDw = 1;

procedure TFMain.btnNewClick(Sender: TObject);
var
  tCi : TCircle;
begin
  for tCi in sBullet do begin
    tCi.DisposeOf;
    sBullet.Remove(tCi);
  end;

  pbEnemy.Max := pbEnemy.Max * 1.5;
  pbEnemy.Value := pbEnemy.Max;
  lblHPEnemy.Text := pbEnemy.Value.ToString + '/' + pbEnemy.Max.ToString;

  btnNew.Visible := False;
  tiBullet.Enabled := True;
  tiMove.Enabled := True;
end;

procedure TFMain.ciJoystickMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ADrag := True;
end;

procedure TFMain.ciJoystickMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  pls : Single;
begin
  if not ADrag then
    Exit;

  pls := -1;

  if (ciJoystick.Position.X > (ciAreaJoystick.Width - (ciJoystick.Width * pls))) or (ciJoystick.Position.X < (- (ciJoystick.Width - ciJoystick.Width * pls))) or
     (ciJoystick.Position.Y > (ciAreaJoystick.Height - (ciJoystick.Height * pls))) or (ciJoystick.Position.Y < (- (ciJoystick.Height - ciJoystick.Height * pls))) then begin
    ADrag := False;
    ciJoystick.Position := TPosition.Create(TPointF.Create(oPosX, oPosY));
  end else begin
    ciJoystick.Position := TPosition.Create(TPointF.Create(ciJoystick.Position.X + (X - oPosX), ciJoystick.Position.Y + (Y - oPosY)));
  end;
end;

procedure TFMain.ciJoystickMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ADrag := False;
  ciJoystick.Position := TPosition.Create(TPointF.Create(oPosX, oPosY));
end;

function TFMain.fnCheckNumber(value: Single): Boolean;
var
  txt : String;
  xx : Single;
begin
  txt := value.ToString;

  xx := StrToFloatDef(txt, 0);

  if xx = 0 then
    Result := False
  else
    Result := True;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  oPosX := ciJoystick.Position.X;
  oPosY := ciJoystick.Position.Y;

  mPosX := ciAreaJoystick.Width / 2;
  mPosY := ciAreaJoystick.Height / 2;

  lblXY.Text := mPosX.ToString + ',' + mPosY.ToString;

  sBullet := TList<TCircle>.Create;

  stEnemyMove := mUp;

  tCreate := coCreate;
  tiBullet.Enabled := True;
  tiMove.Enabled := True;
end;

procedure TFMain.tiBulletTimer(Sender: TObject);
var
  ci, tCi : TCircle;
  i: Integer;
  mv, sz : Single;
begin
  mv := 10; //Pindah posisi oldPosX ke X baru
  sz := 20; //size peluru

  if tCreate = coCreate then begin
    tCreate := 0;

    ci := TCircle.Create(FMain);
    ci.Parent := FMain;

    ci.Size.Size := TSizeF.Create(sz, sz);
    ci.Position := TPosition.Create(TPointF.Create(rePlane.Position.X + rePlane.Width, (rePlane.Position.Y + rePlane.Height / 2) - (ci.Height / 2)));

    sBullet.Add(TCircle(ci));
  end;

  if tCreate >= Round(coCreate / 2) then begin
    if stEnemyMove = mUp then begin
      reEnemy.Position.Y := reEnemy.Position.Y - mv;

      if reEnemy.Position.Y <= 0 then
        stEnemyMove := mDw;
    end else if stEnemyMove = mDw then begin
      reEnemy.Position.Y := reEnemy.Position.Y + mv;

      if reEnemy.Position.Y >= FMain.ClientHeight - reEnemy.Height then
        stEnemyMove := mUp;
    end;

  end;

  Inc(tCreate);

  for tCi in sBullet do begin
    tCi.Position := TPosition.Create(TPointF.Create(tCi.Position.X + mv, tCi.Position.Y));

    if ((tCi.Position.X + sz >= reEnemy.Position.X) and (tCi.Position.X <= reEnemy.Position.X + reEnemy.Width)) and ((tCi.Position.Y >= reEnemy.Position.Y - (tCi.Height * 0.85)) and (tCi.Position.Y <= (reEnemy.Position.Y + reEnemy.Height))) then begin
      tCi.DisposeOf;
      sBullet.Remove(tCi);


      pbEnemy.Value := pbEnemy.Value - dmg;
      lblHPEnemy.Text := pbEnemy.Value.ToString + '/' + pbEnemy.Max.ToString;
    end else if tCi.Position.X >= FMain.ClientWidth then begin
      tCi.DisposeOf;
      sBullet.Remove(tCi);
    end;
  end;

  if pbEnemy.Value <= 0 then begin
    ADrag := False;
    ciJoystick.Position := TPosition.Create(TPointF.Create(oPosX, oPosY));

    tiBullet.Enabled := False;
    tiMove.Enabled := False;

    ShowMessage('MENANG YEEEY');
    btnNew.Visible := True;
  end;
end;

procedure TFMain.tiMoveTimer(Sender: TObject);
var
  tX, tY, pX, pY, hg, pls : Single;
begin
  if not ADrag then
    Exit;

  if not ((ciJoystick.Position.X = oPosX) and (ciJoystick.Position.Y = oPosY)) then begin
    pX := ciJoystick.Position.X + (ciJoystick.Width / 2);
    pY := ciJoystick.Position.Y + (ciJoystick.Height / 2);

    tX := pX - mPosX;
    tY := pY - mPosY;

    if Abs(tX) > Abs(tY) then
      hg := tX
    else if Abs(tX) < Abs(tY) then
      hg := tY;

    hg := Abs(hg);

    if hg = 0 then
      Exit;

    try
      pls := 2;

      tX := (tX * pls) / hg;
      tY := (ty * pls) / hg;

      if not fnCheckNumber(tX) then
        Exit;

      if not fnCheckNumber(tY) then
        Exit;

      if (tX > pls) or (tY > pls) or (tX < -pls) or (tY < -pls) then
        Exit;

      if (rePlane.Position.X <= pls) and (tX <= 0) then
        tX := 0;

      if (rePlane.Position.Y <= pls) and (tY <= 0) then
        tY := 0;

      if (rePlane.Position.X >= (FMain.ClientWidth - rePlane.Width)) and (tX >= 0) then
        tX := 0;

      if (rePlane.Position.Y >= (FMain.ClientHeight - rePlane.Height)) and (tY >= 0) then
        tY := 0;

      rePlane.Position := TPosition.Create(TPointF.Create(rePlane.Position.X + tX, rePlane.Position.Y + tY));
    except

    end;
  end;
end;

end.
