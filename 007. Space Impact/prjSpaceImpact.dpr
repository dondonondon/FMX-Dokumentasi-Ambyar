program prjSpaceImpact;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
