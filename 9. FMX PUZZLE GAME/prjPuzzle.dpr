program prjPuzzle;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  uFunc in 'sources\uFunc.pas',
  uHelper in 'sources\uHelper.pas',
  frGame in 'frame\frGame.pas' {FGame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
