unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects,
  FMX.ListBox, FMX.TabControl, FMX.DialogService, System.Permissions, System.Generics.Collections, Generics.Defaults,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.Edit, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    btnDownload: TCornerButton;
    memLog: TMemo;
    aniLoad: TAniIndicator;
    Edit1: TEdit;
    ClearEditButton1: TClearEditButton;
    CornerButton1: TCornerButton;
    cbAuto: TCheckBox;
    pbDownload: TProgressBar;
    procedure btnDownloadClick(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FPermissionReadExternalStorage : String;
    FPermissionWriteExternalStorage : String;
    path : String;
    procedure fnDownload;
    function fnSetLocation(nmFile : String) : String;
    procedure DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure RequestPermissionsResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses

  {$IF DEFINED (ANDROID)}
    FMX.Helpers.Android, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
    Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Webkit,
    FMX.Platform.Android, Androidapi.JNI.Net, Androidapi.JNI.Os,
  {$ELSE IF DEFINED (MSWINDOWS)}
    IWSystem,
  {$ENDIF}
  uOpenUrl;

procedure TForm1.btnDownloadClick(Sender: TObject);
begin
  if Edit1.Text = '' then begin
    ShowMessage('TIDAK ADA LINK');
    Exit;
  end;

  btnDownload.Enabled := False;
  aniLoad.Enabled := True;
  memLog.Lines.Clear;

  {$IF DEFINED (ANDROID)}
  PermissionsService.RequestPermissions(
    [FPermissionReadExternalStorage, FPermissionWriteExternalStorage],
    RequestPermissionsResult,
    DisplayRationale);
  {$ELSEIF DEFINED (MSWINDOWS)}
    TTask.Run(procedure begin
      try
        fnDownload;
      finally
        TThread.Synchronize(nil, procedure begin
          btnDownload.Enabled := True;
          aniLoad.Enabled := False;

          if cbAuto.IsChecked then
            openFile(fnSetLocation('tes.pdf'));
        end);
      end;
    end).Start;
  {$ENDIF}
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
begin
  if FileExists(fnSetLocation('tes.pdf')) then
    OpenFile(fnSetLocation('tes.pdf'))
  else
    ShowMessage('TIDAK ADA FILE TERKAIT');
end;

procedure TForm1.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
 for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg + 'Aplikasi meminta ijin untuk membaca storage' + SLineBreak + SLineBreak
    else if APermissions[I] = FPermissionWriteExternalStorage then
      RationaleMsg := RationaleMsg + 'Aplikasi meminta ijin untuk menulis storage';
  end;
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure TForm1.fnDownload;
var
  nHTTP : TNetHTTPClient;
  Stream : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    nHTTP := TNetHTTPClient.Create(nil);
    try
      try
        nHTTP.Get(Edit1.Text, Stream);
        Stream.SaveToFile(fnSetLocation('tes.pdf'));
        TThread.Synchronize(nil, procedure begin
          memLog.Lines.Add('Download Selesai');
        end);
      except
        on E : Exception do begin
          TThread.Synchronize(nil, procedure begin
            memLog.Lines.Add(E.Message);
            memLog.Lines.Add(E.ClassName);
          end);
        end;
      end;
    finally
      nHTTP.DisposeOf;
    end;
  finally
    Stream.DisposeOf;
  end;
end;

function TForm1.fnSetLocation(nmFile: String) : String;
{var
  pth : String;}
begin
  {$IF DEFINED (ANDROID)}
    //pth := TPath.GetDocumentsPath + PathDelim + nmFile;
  {$ELSE IF DEFINED (MSWINDOWS)}
    //pth := gsAppPath + PathDelim + nmFile;
  {$ENDIF}

  //pth := StringReplace(pth, '//', '/', [rfReplaceAll, rfIgnoreCase]);
  //pth := StringReplace(pth, '\\', '\', [rfReplaceAll, rfIgnoreCase]);
  {GANTI}

  {$IF DEFINED (ANDROID)}
    Result := path + PathDelim + nmFile;
  {$ELSE IF DEFINED (MSWINDOWS)}
    Result := gsAppPath + PathDelim + nmFile;
  {$ENDIF}
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IF DEFINED(ANDROID)}
    FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);      //permission
    FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);     //permission
  {$ELSE}


  {$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  {$IF DEFINED (ANDROID)}

  {$ENDIF}
end;

procedure TForm1.RequestPermissionsResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 2) and (AGrantResults[0] = TPermissionStatus.Granted) and (AGrantResults[1] = TPermissionStatus.Granted) then
  begin
    path := '/storage/emulated/0/CreateDownloadPDF';

    if not DirectoryExists(path) then begin
      CreateDir(path);
    end;

    TTask.Run(procedure begin
      try
        fnDownload;
      finally
        TThread.Synchronize(nil, procedure begin
          btnDownload.Enabled := True;
          aniLoad.Enabled := False;

          if cbAuto.IsChecked then
            openFile(fnSetLocation('tes.pdf'));
        end);
      end;
    end).Start;
  end
  else
  begin
    TDialogService.ShowMessage('Gagal mendapatkan akses storage');
  end;
end;

end.
