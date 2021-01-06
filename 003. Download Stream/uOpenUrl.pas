unit uOpenUrl;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
{$IF Defined(IOS)}
  macapi.helpers, iOSapi.Foundation, FMX.helpers.iOS;
{$ELSEIF Defined(ANDROID)}
  Androidapi.JNI.GraphicsContentViewText,
  FMX.Helpers.Android, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  Androidapi.JNI.Webkit, System.IOUtils,
  FMX.Platform.Android, Androidapi.JNI.Net, Androidapi.JNI.Os;
{$ELSEIF Defined(MACOS)}
  Posix.Stdlib;
{$ELSEIF Defined(MSWINDOWS)}
  Winapi.ShellAPI, Winapi.Windows;
{$ENDIF}

type
  tUrlOpen = class
    //class procedure OpenUrl(URL: string);
  end;
  procedure OpenUrl(URL: string);
  procedure OpenFile(str : String);
implementation

procedure OpenUrl(URL: string);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  tandroidhelper.Activity.startActivity(Intent);
  // SharedActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar(URL), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl(URL));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString(URL)));
{$ENDIF}
end;

procedure OpenFile(str : String);
{$IF Defined(ANDROID)}
const
  setVideo  = 'video/*';
  setImage  = 'image/*';
  setPDF    = 'application/pdf';
  setXLS    = 'application/vnd.ms-excel';
  setDOC    = 'application/msword';
  setDOCX   = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  setAudio  = 'audio/*';
  setText   = 'text/*';
var
  Intent: JIntent;
  Data: Jnet_Uri;
  exFile : String;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  exFile := AnsiLowerCase(StringReplace(TPath.GetExtension(str), '.', '',[]));

  if (exFile = 'jpg') or (exFile = 'jpeg') then
    exFile := setImage
  else if (exFile = 'mp4') or (exFile = 'mkv') or (exFile = 'avi') or (exFile = 'ts') or (exFile = '3gp') then
    exFile := setVideo
  else if (exFile = 'xls') or (exFile = 'xlsx') then
    exFile := setXLS
  else if (exFile = 'doc') then
    exFile := setDOC
  else if (exFile = 'docx') then
    exFile := setDOCX
  else if (exFile = 'pdf') then
    exFile := setPDF;


  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Data := TJnet_Uri.JavaClass.parse(StringToJString(str));
  Intent.setDataAndType(Data, StringToJString(exFile));
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY);
  MainActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar(str), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl(str));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString(str)));
{$ENDIF}
end;

end.
