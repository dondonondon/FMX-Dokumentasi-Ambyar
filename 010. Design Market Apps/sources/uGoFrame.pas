unit uGoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.Rtti, System.Threading,
  FMX.ListView.Adapters.Base,
  {$IFDEF ANDROID}
    Androidapi.Helpers, FMX.Platform.Android, System.Android.Service, System.IOUtils,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
  {$ENDIF}
  System.Generics.Collections;

type
  TFrameClass = class of TFrame;
  TExec = procedure of object;

procedure fnCallFrame(AParent: TVertScrollBox; FrameClass: TFrameClass);
procedure createFrame;

procedure fnGetFrame(st, transFR : String);
procedure fnShowFrame;

var
  genFrame: TFrame;
  frFrom, frGo, tFR : TControl;

const
  sFrom = 'FROM';
  sGo = 'GO';

implementation

uses frMain, frLoading, uFunc, uMain, frLogin, frHome;

procedure fnCallFrame(AParent: TVertScrollBox; FrameClass: TFrameClass);
begin
  genFrame := FrameClass.Create(FMain);
  genFrame.Parent := AParent;
  //fnGetClient(AParent, genFrame);
end;

procedure createFrame;
begin
  try
    fnCallFrame(FMain.vsMain, frLoading.TFLoading);
    FLoading := TFLoading(genFrame);
    FLoading.Visible := False;

    fnCallFrame(FMain.vsMain, frLogin.TFLogin);
    FLogin := TFLogin(genFrame);
    FLogin.Visible := False;

    fnCallFrame(FMain.vsMain, frHome.TFHome);
    FHome := TFHome(genFrame);
    FHome.Visible := False;
  except

  end;
end;

procedure fnGetFrame(st, transFR : String);
begin
  if transFR = '' then
    Exit;

  if transFR = Loading then
    tFR := FLoading
  else if transFR = LOGIN then
    tFR := FLogin
  else if transFR = HOME then
    tFR := FHome;

  if st = sFrom then
    frFrom := tFR
  else if st = sGo then
    frGo := tFR;
end;

procedure fnShowFrame;
var
  Routine : TMethod;
  Exec : TExec;
begin
  Routine.Data := Pointer(frGo);
  Routine.Code := frGo.MethodAddress('FirstShow');
  if NOT Assigned(Routine.Code) then
    Exit;

  Exec := TExec(Routine);
  Exec;
end;

end.

