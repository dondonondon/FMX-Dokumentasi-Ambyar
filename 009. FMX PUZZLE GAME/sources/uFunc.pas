unit uFunc;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.IniFiles,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, System.Json, System.NetEncoding, Data.DBXJsonCommon,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FMX.ListView.Types,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects, FMX.StdCtrls, FMX.ListBox,
  FMX.DialogService, System.DateUtils, System.IOUtils, FMX.Layouts, FMX.WebBrowser,
  System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    ;
  {$ELSEIF Defined(MSWINDOWS)}
    ,IWSystem;
  {$ELSE}
  ;
  {$ENDIF}

function fnReplaceStr(strSource, strReplaceFrom, strReplaceWith: string;
         goTrim: Boolean = true): string;

procedure fnSQLAdd(Query: TFDQuery; SQL: string; ClearPrior: Boolean = False); overload;
procedure fnSQLOpen(Query: TFDQuery); overload;
procedure fnExecSQL(Query: TFDQuery); overload;
procedure fnSQLParamByName(Query: TFDQuery; ParamStr: string; Value: Variant); overload;
procedure prExplodeStr(SourceStr: string; Delimiter: char; var List: TStringList);

procedure fnLoadImage(img : TImage; nmFile : String); overload
procedure fnLoadImage(img : TListItemImage; nmFile : String); overload
function fnLoadImage(nmFile : String): String; overload
procedure addHeaderLB(str : String; lb : TListBox);
procedure addItemLB(str, detail : String; lb : TListBox; stl : String);
procedure fnLoadImgFromUrl(url: String; bmps: TImage);
procedure fnSaveImg(img : TImage; nmFile : String); overload
procedure fnSaveImg(img : TImage; nmFile : String; min : Integer); overload
function fnGetDate():String;
function fnEncodeImg(loc : String):String;
procedure fnDecodeImg(img : TImage; str : String);

procedure SaveSettingString(Section, Name, Value: string);
function LoadSettingString(Section, Name, Value: string): string;

procedure fnCreateBrowser(ly : TLayout; url : String);
procedure fnReleaseWB;
procedure fnGetCenter(fromParent, AParent : TControl);
procedure fnGetTop(fromParent, AParent : TControl);
procedure fnGetBottom(fromParent, AParent : TControl);
procedure fnGetClient(fromParent, AParent : TControl);

var
  statBW : Boolean;
  WB : TWebBrowser;

implementation

uses uHelper;


function fnReplaceStr(strSource, strReplaceFrom, strReplaceWith: string; goTrim: Boolean = true): string;
begin
  if goTrim then strSource := Trim(strSource);
  Result := StringReplace(strSource, StrReplaceFrom, StrReplaceWith, [rfReplaceAll, rfIgnoreCase])
end;

procedure prExplodeStr(SourceStr: string; Delimiter: char; var List: TStringList);
var
  i: integer;
begin
  List.Clear;
  while Length(SourceStr) > 0 do
  begin
    i := Pos(Delimiter, SourceStr);
    if (i > 0) then
    begin
      List.Add(Copy(SourceStr, 1, i - 1));
      SourceStr := Copy(SourceStr, i + 1, Length(SourceStr) - i);
    end // if (i > 0) then
    else if Length(SourceStr) > 0 then
    begin
      List.Add(SourceStr);
      SourceStr := '';
    end // if Length(SourceStr) > 0 then
  end; //while Length(SourceStr) > 0 do
end;

procedure fnSQLAdd(Query: TFDQuery; SQL: string; ClearPrior: Boolean = False); overload;
var s: string;
begin
  if ClearPrior then
    Query.SQL.Clear;

  s := fnReplaceStr(SQL, 'GETDATE', 'CURRENT_DATE');
  s := fnReplaceStr(s, 'ISNULL', 'IFNULL');

  Query.SQL.Add(S);
end;

procedure fnSQLOpen(Query: TFDQuery); overload;
var L: TStringList;
  s: string;
  s1: string;
  TempS: string;
  x1: integer;
  x2: integer;
begin
  L := TStringList.Create;

  s := Query.SQL.Text;
  x1 := Pos('SELECT TOP', UpperCase(s));
  if x1 > 0 then
  begin
    if s[x1 - 1] = '(' then // --> berarti ada Sub Query di dalam Query, perlu diparse lagi
    begin
      x2 := Pos(')', s); // ambil akhir dari sub query
      s1 := UpperCase(Copy(s, x1, x2 - x1));
      prExplodeStr(s1, ' ', L);

      TempS := L[1] + ' ' + L[2];

      Insert(' LIMIT ' + L[2], s, x2);
      s := fnReplaceStr(s, TempS, '');
      Query.SQL.Text := s;
    end
    else
    begin
      // ambil jumlahnya
      prExplodeStr(UpperCase(s), ' ', L);

      TempS := L[1] + ' ' + L[2];

      s := fnReplaceStr(s, TempS, '');
      s := s + ' LIMIT ' + L[2];
      Query.SQL.Text := s;
    end
  end;

  FreeAndNil(L);

  Query.Prepared;
//  fnWriteQueryLog(Format('DATE: %s | QUERY: %s', [fnFormatDateTimeDB(Now), Query.SQL.Text]));
  Query.Open;
end;

procedure fnExecSQL(Query: TFDQuery); overload;
var L: TStringList;
  s: string;
  s1: string;
  TempS: string;
  x1: integer;
  x2: integer;
begin
  L := TStringList.Create;

  s := Query.SQL.Text;
  x1 := Pos('SELECT TOP', UpperCase(s));
  if x1 > 0 then
  begin
    if s[x1 - 1] = '(' then // --> berarti ada Sub Query di dalam Query, perlu diparse lagi
    begin
      x2 := Pos(')', s); // ambil akhir dari sub query
      s1 := UpperCase(Copy(s, x1, x2 - x1));
      prExplodeStr(s1, ' ', L);

      TempS := L[1] + ' ' + L[2];

      Insert(' LIMIT ' + L[2], s, x2);
      s := fnReplaceStr(s, TempS, '');
      Query.SQL.Text := s;
    end
    else
    begin
      // ambil jumlahnya
      prExplodeStr(UpperCase(s), ' ', L);

      TempS := L[1] + ' ' + L[2];

      s := fnReplaceStr(s, TempS, '');
      s := s + ' LIMIT ' + L[2];
      Query.SQL.Text := s;
    end
  end;

  FreeAndNil(L);

  Query.Prepared;

  Query.ExecSQL;
end;

procedure fnSQLParamByName(Query: TFDQuery; ParamStr: string; Value: Variant); overload;
begin
  Query.Params.ParamByName(ParamStr).Value := Value
end;

procedure fnCreateBrowser(ly : TLayout; url : String);
begin
  statBW := True;

  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        WB := TWebBrowser.Create(ly);
        WB.Parent := ly;
        WB.Align := TAlignLayout.Client;
        WB.Visible := False;
        WB.URL := URL;
        WB.OnDidFinishLoad := Helper.WBDidLoad;
      end
      );
    end
  ) .Start;
end;

procedure fnReleaseWB;
begin
  if statBW = True then
  begin
    {$IF DEFINED(IOS) or DEFINED(ANDROID)}
      WB.DisposeOf;
    {$ELSE}
      WB.Free;
    {$ENDIF}
    statBW := False;
  end;
end;

procedure fnLoadImage(img : TImage; nmFile : String);
var
  xx, loc, locTemp : String;
begin
  TThread.Synchronize(nil, procedure begin
    img.Visible := False;
  end);

  try
    {$IF DEFINED(IOS) or DEFINED(ANDROID)}
      xx := TPath.GetDocumentsPath + PathDelim;
    {$ELSEIF Defined(MSWINDOWS)}
      xx := gsAppPath + 'img' + PathDelim;
    {$ENDIF}

    loc := xx + nmFile;
    locTemp := xx + 'kosong.png';

    if FileExists(loc) then
      img.Bitmap.LoadFromFile(loc)
    else
      img.Bitmap.LoadFromFile(locTemp);
  finally
    TThread.Synchronize(nil, procedure begin
      img.Visible := True;
    end);
  end;
end;

procedure fnLoadImage(img : TListItemImage; nmFile : String);
var
  xx, loc, locTemp : String;
  temp : TImage;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    xx := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF Defined(MSWINDOWS)}
    xx := gsAppPath + 'img' + PathDelim;
  {$ENDIF}

  loc := xx + nmFile;
  locTemp := xx + 'kosong.png';

  temp := TImage.Create(nil);
  try
    if FileExists(loc) then
      temp.Bitmap.LoadFromFile(loc)
    else
      temp.Bitmap.LoadFromFile(locTemp);

    img.Bitmap := temp.Bitmap;
  except
  end;
end;

function fnLoadImage(nmFile : String): String;
var
  xx, loc, locTemp : String;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    xx := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF Defined(MSWINDOWS)}
    xx := gsAppPath + 'img' + PathDelim;
  {$ENDIF}

  loc := xx + nmFile;
  locTemp := xx + 'kosong.png';

  if FileExists(loc) then
    Result := loc
  else
    Result := locTemp;
end;

procedure fnLoadImgFromUrl(url: String; bmps: TImage);
var
  Stream : TMemoryStream;
  HTTP : TNetHTTPClient;
begin
  TThread.Synchronize(nil, procedure begin
    bmps.Visible := False;
  end);
  HTTP := TNetHTTPClient.Create(nil);
  Stream := TMemoryStream.Create;
  try
    HTTP.Get(url, Stream);
    Stream.Position := 0;
    bmps.Bitmap.LoadFromStream(Stream);
  finally
    begin
      HTTP.Free;
      Stream.Free;

      TThread.Synchronize(nil, procedure begin
        bmps.Visible := True;
      end);
    end;
  end;
end;

procedure addHeaderLB(str : String; lb : TListBox);
var
  head : TListBoxGroupHeader;
begin
  //lb.BeginUpdate;
  try
    head := TListBoxGroupHeader.Create(lb);
    head.Text := uppercase(str);
    head.TextSettings.Font.Style := [TFontStyle.fsBold];
    head.FontColor := $FFE38E05;
    head.StyledSettings := [];
    lb.AddObject(head);
  finally
    //lb.EndUpdate;
  end;
end;

procedure addItemLB(str, detail : String; lb : TListBox; stl : String);
var
  txt : TListBoxItem;
begin
  //lb.BeginUpdate;
  try
    txt := TListBoxItem.Create(lb);
    txt.StyleLookup := stl;
    txt.Text := str;
    txt.ItemData.Detail := detail;
    txt.TextSettings.Font.Style := [TFontStyle.fsBold];
    txt.Selectable := False;
    txt.StyledSettings := [];
    lb.AddObject(txt);
  finally
    //lb.EndUpdate;
  end;
end;


procedure fnSaveImg(img : TImage; nmFile : String);
var
  xx: String;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    xx := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF Defined(MSWINDOWS)}
    xx := gsAppPath + 'img' + PathDelim;
  {$ENDIF}
  xx := fnReplaceStr(xx, '\\','\');
  img.Bitmap.SaveToFile(xx + nmFile);
end;

procedure fnSaveImg(img : TImage; nmFile : String; min : Integer);
var
  xx: String;
  w, h : Integer;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    xx := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF Defined(MSWINDOWS)}
    xx := gsAppPath + 'img' + PathDelim;
  {$ENDIF}
  w := img.Bitmap.Width;
  h := img.Bitmap.Height;

  if (w >= min) or (h >= min) then begin
    repeat
      w := Round(w/1.5);
      h := Round(h/1.5);
    until ((w <= min) and (h <= min));
    img.Bitmap.Resize(w , h);
  end;

  xx := fnReplaceStr(xx, '\\','\');
  img.Bitmap.SaveToFile(xx + nmFile);
end;

function fnGetDate():String;    //menamai gambar image
begin
  Result := FormatDateTime('YYYYMMDDHHNNSS', Now) + '.jpg';
end;

function fnEncodeImg(loc : String):String;
var
  HasilToJson : String;
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    stream.LoadFromFile(loc);
    HasilToJson := TDBXJSONTools.StreamToJSON(stream, 0, stream.Size).ToJSON;
    Result := TNetEncoding.Base64.Encode(HasilToJson);
  finally
    stream.Free;
  end;
end;

procedure fnDecodeImg(img : TImage; str : String);
var
  memStream : TMemoryStream;
  jsonArray : TJSONArray;
  decode : String;
begin
  memStream := TMemoryStream.Create;
  decode := TNetEncoding.Base64.Decode(str);
  jsonArray := TJSONObject.ParseJSONValue(decode) as TJSONArray;
  try
    memStream.LoadFromStream(TDBXJSONTools.JSONToStream(jsonArray));
    img.Bitmap.LoadFromStream(memStream);
  finally
    begin
      {$IF DEFINED(IOS) or DEFINED(ANDROID)}
        memStream.DisposeOf;
        jsonArray.DisposeOf;
      {$ELSE}
        memStream.Free;
        jsonArray.Free;
      {$ENDIF}
      memStream := nil;
      jsonArray := nil;
    end;
  end;
end;

function LoadSettingString(Section, Name, Value: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(TPath.GetCachePath + PathDelim + 'config.ini');
  try
    Result := ini.ReadString(Section, Name, Value);
  finally
    ini.Free;
  end;
end;

procedure SaveSettingString(Section, Name, Value: string);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(TPath.GetCachePath + PathDelim + 'config.ini');
  try
    ini.WriteString(Section, Name, Value);
  finally
    ini.Free;
  end;
end;

procedure fnGetCenter(fromParent, AParent : TControl);
var
  wiF, wiP, heF, heP : Integer;
begin
  wiF := Round(fromParent.Width);
  heF := Round(fromParent.Height);
  wiP := Round(AParent.Width);
  heP := Round(AParent.Height);

  AParent.Position.X := Round((wiF / 2) - (wiP / 2));
  AParent.Position.Y := Round((heF / 2) - (heP / 2));
end;

procedure fnGetTop(fromParent, AParent : TControl);
var
  wiF, wiP, heF, heP : Integer;
begin
  wiF := Round(fromParent.Width);
  heF := Round(fromParent.Height);
  wiP := Round(AParent.Width);
  heP := Round(AParent.Height);

  AParent.Position.X := Round((wiF / 2) - (wiP / 2));
  AParent.Position.Y := Round(0);
end;

procedure fnGetBottom(fromParent, AParent : TControl);
var
  wiF, wiP, heF, heP : Integer;
begin
  wiF := Round(fromParent.Width);
  heF := Round(fromParent.Height);
  wiP := Round(AParent.Width);
  heP := Round(AParent.Height);

  AParent.Position.X := Round((wiF / 2) - (wiP / 2));
  AParent.Position.Y := Round(heF - heP);
end;

procedure fnGetClient(fromParent, AParent : TControl);
var
  wiF, wiP, heF, heP : Integer;
begin
  wiF := Round(fromParent.Width);
  heF := Round(fromParent.Height);
  wiP := Round(AParent.Width);
  heP := Round(AParent.Height);

  AParent.Position.X := 0;
  AParent.Position.Y := 0;

  AParent.Width := wiF;
  AParent.Height := heF;
end;

end.
