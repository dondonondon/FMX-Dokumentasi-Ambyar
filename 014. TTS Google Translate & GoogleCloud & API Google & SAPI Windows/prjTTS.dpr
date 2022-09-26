program prjTTS;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {FMain},
  BFA.Func in 'sources\BFA.Func.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  BFA.Rest in 'sources\BFA.Rest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
