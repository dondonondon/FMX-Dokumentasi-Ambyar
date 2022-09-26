unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Media, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, AndroidTTS, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Net.Mime, REST.Types
  {$IF DEFINED (MSWINDOWS)}
  , ComObj
  {$ENDIF}
  ;

type
  TFMain = class(TForm)
    btnSpeak: TCornerButton;
    mpUI: TMediaPlayer;
    memText: TMemo;
    cbSource: TComboBox;
    TTS: TAndroidTTS;
    btnClear: TCornerButton;
    cbType: TComboBox;
    cbVoiceName: TComboBox;
    tbSpeed: TTrackBar;
    tbPitch: TTrackBar;
    lblSpeed: TLabel;
    lblPitch: TLabel;
    procedure btnSpeakClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cbSourceChange(Sender: TObject);
    procedure tbPitchChange(Sender: TObject);
    procedure tbSpeedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function getVoice(FIndex : Integer; FText : String) : Boolean;
    function getVoiceFromTranslate(FText : String) : Boolean;
    function getVoiceFromCloudGoogle(FText : String) : Boolean;
    function getVoiceFromSAPI(FText : String) : Boolean;
    function getVoiceFromAPIAndroid(FText : String) : Boolean;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

const
  AuthKey = ''; //Cloud API key dapat dari Google Cloud

implementation

{$R *.fmx}

uses BFA.Func, uDM, BFA.Rest;

procedure TFMain.btnClearClick(Sender: TObject);
begin
  memText.Lines.Clear;
end;

procedure TFMain.btnSpeakClick(Sender: TObject);
begin
  if memText.Text = '' then begin
    ShowMessage('Isikan Text');
    Exit;
  end;

  getVoice(cbSource.ItemIndex, memText.Text);
end;

procedure TFMain.cbSourceChange(Sender: TObject);
begin
  if cbSource.ItemIndex = 2 then begin
    cbSource.Width := cbType.Position.X - 16;
    btnSpeak.Width := cbSource.Width;

    cbVoiceName.Visible := True;
    cbType.Visible := True;
    tbSpeed.Visible := True;
    tbPitch.Visible := True;

    lblSpeed.Visible := True;
    lblPitch.Visible := True;

  end else begin
    cbSource.Width := memText.Width;
    btnSpeak.Width := cbSource.Width;

    cbVoiceName.Visible := False;
    cbType.Visible := False;
    tbSpeed.Visible := False;
    tbPitch.Visible := False;

    lblSpeed.Visible := False;
    lblPitch.Visible := False;
  end;

  lblSpeed.Text := Format('Speed %.2f', [tbSpeed.Value]);
  lblPitch.Text := Format('Pitch %.2f', [tbPitch.Value]);

end;

procedure TFMain.FormCreate(Sender: TObject);
var
  FormatBr: TFormatSettings;
begin
  //set ubah default separator yang beda beda disamakan

  FormatBr                     := TFormatSettings.Create;
  FormatBr.DecimalSeparator    := '.';
  FormatBr.ThousandSeparator   := ',';
  FormatBr.DateSeparator       := '-';
  FormatBr.ShortDateFormat     := 'yyyy-mm-dd';
  FormatBr.LongDateFormat      := 'yyyy-mm-dd hh:nn:ss';

  System.SysUtils.FormatSettings := FormatBr;
end;

function TFMain.getVoice(FIndex: Integer; FText: String): Boolean;
begin
  case FIndex of
    0 : begin
      ShowMessage('Silahkan pilih sumber TTS');
    end;

    1 : begin
      getVoiceFromTranslate(FText);
    end;

    2 : begin
      getVoiceFromCloudGoogle(FText); //tidak bisa di decode
    end;

    3 : begin
      getVoiceFromAPIAndroid(FText);
    end;

    4 : begin
      getVoiceFromSAPI(FText);
    end;
  end;
end;

function TFMain.getVoiceFromAPIAndroid(FText: String): Boolean;
begin
  {$IF DEFINED (MSWINDOWS)}
    ShowMessage('Hanya untuk Android');
    Exit;
  {$ENDIF}

  if FText = '' then
    Exit;

  TTS.Speak(FText);
end;

function TFMain.getVoiceFromCloudGoogle(FText: String): Boolean;
begin
  if AuthKey = '' then begin
    ShowMessage('AuthKey Google belum diisi');
    Exit;
  end;

  var FVType : String;
  var FVName : String;

  if cbType.ItemIndex = 0 then begin
    FVType := 'id-ID-Standard-';
  end else begin
    FVType := 'id-ID-Wavenet-';
  end;

  FVName := FVType + cbVoiceName.Selected.Text;

  var FFormat :=
    '{'#13 +
    '"audioConfig": {'#13 +
    '"audioEncoding": "MP3",'#13 +
    '"pitch": '+ tbPitch.Value.ToString +','#13 +
    '"speakingRate": '+ tbSpeed.Value.ToString +''#13 +
    '},'#13 +
    '"input": {'#13 +
    '"text": "'+ FText +'"'#13 +
    '},'#13 +
    '"voice": {'#13 +
    '"languageCode": "id-ID",'#13 +
    '"name": "'+ FVName +'"'#13 +
    '}'#13 +
    '}';

  var FURL := 'https://texttospeech.googleapis.com/v1beta1/text:synthesize';

  DM.RReq.Params.Clear;
  DM.RReq.AddBody(FFormat, TRESTContentType.ctAPPLICATION_JSON);
  DM.RReq.AddParameter('X-Goog-Api-Key', AuthKey, TRESTRequestParameterKind.pkHTTPHEADER);

  if not fnParseJSON(DM.RClient, DM.RReq, DM.RResp, DM.rRespAdapter, FURL, DM.memData, TRESTRequestMethod.rmPOST) then begin
    ShowMessage('Tidak dapat melakukan request');
    Exit;
  end;

  if mpUI.State = TMediaState.Playing then
    mpUI.Stop;

  mpUI.Clear;

  fnDecodeBase64(DM.memData.FieldByName('audioContent').AsString, fnLoadFile('temp.mp3'));
  {memText.Lines.Clear;
  memText.Lines.Add(DM.memData.FieldByName('audioContent').AsString);
  fnDecodeBase64(memText.Text, fnLoadFile('temp.mp3'));}

  if FileExists(fnLoadFile('temp.mp3')) then begin
    mpUI.FileName := fnLoadFile('temp.mp3');
    mpUI.Play;
  end;
end;

function TFMain.getVoiceFromSAPI(FText: String): Boolean;
begin
  {$IF DEFINED (ANDROID)}
    ShowMessage('Hanya untuk Windows');
    Exit;

  {$ELSEIF DEFINED (MSWINDOWS)}
    var FVoice : OleVariant;
    FVoice := CreateOLEObject('SAPI.SpVoice');


    FVoice.speak(FText, 0);

    {var Voices : OLEVariant;
    var i : Integer;

    Voices := FVoice.GetVoices;
    for i := 0 to Voices.Count - 1 do begin
      memText.Lines.Add(Voices.Item(i).GetDescription);
    end;}
  {$ENDIF}
end;

function TFMain.getVoiceFromTranslate(FText: String): Boolean;
begin
  if mpUI.State = TMediaState.Playing then
    mpUI.Stop;

  mpUI.Clear;

  var FURL := 'https://translate.google.com/translate_tts?ie=UTF-8&client=gtx&q='+ FText +'&tl=id-Id';
  fnDownloadFile(FURL, 'temp.mp3');

  if FileExists(fnLoadFile('temp.mp3')) then begin
    mpUI.FileName := fnLoadFile('temp.mp3');
    mpUI.Play;
  end;
end;

procedure TFMain.tbPitchChange(Sender: TObject);
begin
  lblPitch.Text := Format('Pitch %.2f', [tbPitch.Value]);
end;

procedure TFMain.tbSpeedChange(Sender: TObject);
begin
  lblSpeed.Text := Format('Speed %.2f', [tbSpeed.Value]);
end;

end.
