program prjDragDrop;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {mainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
