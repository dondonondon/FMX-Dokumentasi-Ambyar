unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.ImageList, FMX.ImgList, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid,FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListBox, FMX.Ani, System.Threading,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.LoadingIndicator, FMX.Memo, FMX.Edit,
  {$IFDEF ANDROID}
    Androidapi.Helpers, FMX.Platform.Android, System.Android.Service, System.IOUtils,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
  {$ENDIF}
  System.Generics.Collections;

const
  //FRAME
  Loading = 'loading';
  Home = 'Home';

  //Proses
  PBack = 'go Back';
  pGo = 'go Go';
  idle = 350; //

procedure fnTransitionFrame(from, go : TControl; faFrom, faGo : TFloatAnimation; prs : String);

procedure fnGoFrame(from, go : String; stat : Boolean = False);
procedure fnHideFrame(from : String);
procedure fnGetFromFrame(from : String);
procedure fnChangeFrame(go : String; stat : Boolean = False);
procedure fnBack;
procedure setNone;

procedure fnLoadLoading(lo : TLayout; ani : TFMXLoadingIndicator; stat : Boolean); overload;  //ganti ini
procedure fnLoadLoading(stat : Boolean); overload;

procedure fnGetE(Msg, Cls : String); overload;
procedure fnGetE(mem : TMemo; str : String); overload;
procedure fnShowE(str : String);

procedure fnThreadSyncGoFrame(from, go : String);

var
  FCorner : TList<TCornerButton>;
  goFrame, fromFrame : String;
  frFrom, frGo : TControl;
  statTransition : Boolean;
  tabCount : Integer;

  //PERMISSION
  FPermissionReadExternalStorage, FAccess_Coarse_Location, FAccess_Fine_Location,
  FPermissionWriteExternalStorage: string;

implementation

uses frMain, frHome, frLoading;

procedure fnTransitionFrame(from, go : TControl; faFrom, faGo : TFloatAnimation; prs : String);
var
  i : Integer;
begin
  statTransition := True;

  tabCount := 0;

  with FMain do begin
    if fromFrame <> '' then
      faFrom.Parent := from;

    faGo.Parent := go;

    if fromFrame <> '' then
      from.Visible := True;
    go.Visible := True;

    if prs = pBack then begin
      from.BringToFront;

      faGo.StartValue := - 0.3 * ClientWidth;
      faGo.StopValue := 0;

      faFrom.StartValue := 0;
      faFrom.StopValue := ClientWidth;
    end else if prs = pGo then begin
      go.BringToFront;

      faFrom.StartValue := 0;
      faFrom.StopValue := - 0.3 * ClientWidth;

      faGo.StartValue := ClientWidth;
      faGo.StopValue := 0;
    end;

    faFrom.Interpolation := TInterpolationType.Quadratic;
    faGo.Interpolation := TInterpolationType.Quadratic;

    fnChangeFrame(goFrame, True);

    Sleep(150);

    faGo.Enabled := True;
    if fromFrame <> '' then
      faFrom.Enabled := True;
  end;
end;

procedure fnGetFromFrame(from : String);
begin
  if from = '' then begin
    Exit;
  end;

  if from = Loading then
    frFrom := FLoading
  else if from = Home then
    frFrom := FHome;
end;

procedure fnChangeFrame(go : String; stat : Boolean = False);
begin
  if go = Loading then begin
    if stat = True then begin
      FLoading.FirstShow;
      Exit;
    end;

    frGo := FLoading;
  end else if go = Home then begin
    if stat = True then begin
      FHome.FirstShow;
      Exit;
    end;

    frGo := FHome;
  end;
end;

procedure fnGoFrame(from, go : String; stat : Boolean = False);
var
  proses : String;
begin
  if stat = False then
    proses := pGo
  else
    proses := pBack;

  fromFrame := from;
  goFrame := go;

  fnGetFromFrame(fromFrame);
  fnChangeFrame(goFrame);

  fnTransitionFrame(frFrom, frGo, FMain.faFromX, FMain.faGoX, proses);
end;

procedure fnHideFrame(from : String);
begin
  if fromFrame <> '' then
    frFrom.Visible := False;

  frFrom := nil;
  frGo := nil;
end;

procedure fnBack;
begin

end;

procedure setNone;
begin

end;


procedure fnLoadLoading(lo : TLayout; ani : TFMXLoadingIndicator; stat : Boolean); overload;  //ganti ini
begin
  TThread.Synchronize(nil, procedure
  begin
    if stat = True then
      lo.BringToFront;
    lo.Visible := stat;
    //ani.Kind := TLoadingIndicatorKind.Wave;
    ani.Enabled := stat;
  end);
end;

procedure fnLoadLoading(stat : Boolean); overload;
begin
  with FMain do begin
    fnLoadLoading(loLoad, aniLoad, stat);
  end;
end;

procedure fnGetE(Msg, Cls : String); overload;
begin
  TThread.Synchronize(nil, procedure
  begin
    FMain.memLog.Lines.Add('Message : ' + Msg);
    FMain.memLog.Lines.Add('Class E : ' + Cls);
  end);
end;

procedure fnGetE(mem : TMemo; str : String); overload;
begin
  TThread.Synchronize(nil, procedure
  begin
    mem.BeginUpdate;
    try
      mem.Lines.Add(str);
    finally
      mem.EndUpdate;
    end;
  end);
end;

procedure fnShowE(str : String);
begin
  with FMain do begin
    TThread.Synchronize(nil, procedure
    begin
      TM.Toast(UpperCase(str));
    end);
  end;
end;

procedure fnThreadSyncGoFrame(from, go : String);
begin
  TThread.Synchronize(nil, procedure begin
    fnGoFrame(from, go);
  end);
end;

end.
