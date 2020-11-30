program prjTemplate;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  frLoading in 'frames\frLoading.pas' {FLoading: TFrame},
  frHome in 'frames\frHome.pas' {FHome: TFrame},
  uFontSetting in 'sources\uFontSetting.pas',
  uFunc in 'sources\uFunc.pas',
  uGoFrame in 'sources\uGoFrame.pas',
  uMain in 'sources\uMain.pas',
  uOpenUrl in 'sources\uOpenUrl.pas',
  uRest in 'sources\uRest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

