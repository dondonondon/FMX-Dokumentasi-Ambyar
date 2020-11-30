unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Platform
  {$IFDEF Android}
    ,Androidapi.JNI.Os  //TJBuild
    ,Androidapi.Helpers, FMX.Edit // StringToJString
  {$ENDIF}
  {$IFDEF IOS}
    ,iOSapi.UIKit
    ,Posix.SysSysctl
    ,Posix.StdDef
  {$ENDIF}
    ;

type
  TForm1 = class(TForm)
    CornerButton1: TCornerButton;
    Memo1: TMemo;
    Edit1: TEdit;
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.CornerButton1Click(Sender: TObject);
var
  OSVersion: TOSVersion;
  OSLang: String;
  LocaleService: IFMXLocaleService;

  ModelName: String;
begin
  ModelName := 'unknown';
  {$IFDEF Android}
  ModelName := JStringToString(TJBuild.JavaClass.MODEL);
  {$ENDIF}
  {$IFDEF IOS}
  ModelName := GetDeviceModelString;
  {$ENDIF}

  Memo1.Lines.Add(Format('ModelName=%s', [ ModelName ] ));
  Memo1.Lines.Add(Format('OSName=%s', [OSVersion.Name]));
  Memo1.Lines.Add(Format('Platform=%d', [Ord(OSVersion.Platform)]));
  Memo1.Lines.Add(Format('Version=%d.%d', [OSVersion.Major,OSVersion.Minor]));

  OSLang := '';
  if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, IInterface(LocaleService)) then
  begin
    OSLang := LocaleService.GetCurrentLangID();

    // if set Japanese on Android, LocaleService returns "jp", but other platform returns "ja"
    // so I think it is better to change "jp" to "ja"
    if (OSLang = 'jp') then OSLang := 'ja';
  end;
  Memo1.Lines.Add(Format('Lang=%s', [ OSLang ] ));

end;

end.
