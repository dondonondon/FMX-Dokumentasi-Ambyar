program prjTemplate;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  {$IF DEFINED (ANDROID)}
  FMX.FontGlyphs.Android in 'sources\FMX.FontGlyphs.Android.pas',
  {$ENDIF }
  uFontSetting in 'sources\uFontSetting.pas',
  frMain in 'frMain.pas' {FMain},
  uFunc in 'sources\uFunc.pas',
  uGoFrame in 'sources\uGoFrame.pas',
  uMain in 'sources\uMain.pas',
  uOpenUrl in 'sources\uOpenUrl.pas',
  uRest in 'sources\uRest.pas',
  frHome in 'frames\frHome.pas' {FHome: TFrame},
  frLoading in 'frames\frLoading.pas' {FLoading: TFrame},
  frLogin in 'frames\frLogin.pas' {FLogin: TFrame},
  frTemp in 'frames\frTemp.pas' {FTemp: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
