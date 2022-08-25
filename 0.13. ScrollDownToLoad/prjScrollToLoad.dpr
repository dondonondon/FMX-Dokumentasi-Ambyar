program prjScrollToLoad;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  BFA.Func in 'sources\BFA.Func.pas',
  BFA.Helper.MemTable in 'sources\BFA.Helper.MemTable.pas',
  BFA.Helper.Main in 'sources\BFA.Helper.Main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
