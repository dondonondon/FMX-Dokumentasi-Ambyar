unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, System.Threading, FMX.Edit, FMX.SearchBox;

type
  TFMain = class(TForm)
    tcMain: TTabControl;
    tiMain: TTabItem;
    tiSearch: TTabItem;
    btnSearch: TCornerButton;
    lbMain: TListBox;
    QData: TFDMemTable;
    Memo1: TMemo;
    lblValue: TLabel;
    sbSearch: TSearchBox;
    procedure btnSearchClick(Sender: TObject);
    procedure lbMainViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure FormShow(Sender: TObject);
    procedure sbSearchTyping(Sender: TObject);
    procedure sbSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FLastRecordIndexLoad : Integer;
    isLoad : Boolean;
    procedure fnRequestData;
    procedure fnLoadDataBasic(FLoad : Integer);
    procedure fnLoadData(FLoad : Integer);
    procedure addItem(FIndex : Integer; FName : String);
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Func, BFA.Helper.MemTable, BFA.Helper.Main;

procedure TFMain.addItem(FIndex: Integer; FName: String);
begin
  var lb := TListBoxItem.Create(lbMain);
  lb.Height := 40;
  lb.Text := FName;
  lb.Tag := FIndex;

  lb.Font.Size := 12.5;
  lb.StyledSettings := [];

  {$IF DEFINED (ANDROID)}
    lb.Selectable := False;
  {$ENDIF}

  lbMain.AddObject(lb);
end;

procedure TFMain.btnSearchClick(Sender: TObject);
begin
  fnLoadData(6);
end;

procedure TFMain.fnLoadData(FLoad: Integer);
begin
  if isLoad then
    Exit;

  isLoad := True;
  try
    if QData.IsEmpty then
      Exit;

    if lbMain.Items.Count >= QData.RecordCount then
      Exit;

    QData.RecNo := FLastRecordIndexLoad;
    var FStartCount := FLastRecordIndexLoad - 1;
    var FItemsCount := lbMain.Items.Count;

    TThread.Synchronize(nil, procedure begin
      lbMain.BeginUpdate;
      try
        for var i := FStartCount to (FLoad + FLastRecordIndexLoad) - 1 do begin
          addItem(QData.RecNo, QData.FieldByName('radio_name').AsString);

          Inc(FItemsCount);
          if FItemsCount >= QData.RecordCount then
            Break;

          QData.Next;
        end;
      finally
        lbMain.EndUpdate;
      end;
    end);

    FLastRecordIndexLoad := QData.RecNo;
  finally
    isLoad := False;
  end;
end;

procedure TFMain.fnLoadDataBasic(FLoad: Integer);
begin
  QData.RecNo := FLastRecordIndexLoad;
  var FStartCount := FLastRecordIndexLoad - 1;

  lbMain.BeginUpdate;
  for var i := FStartCount to (FLoad + FLastRecordIndexLoad) - 1 do begin
    addItem(QData.RecNo, QData.FieldByName('radio_name').AsString);

    QData.Next;
  end;

  FLastRecordIndexLoad := QData.RecNo;

  lbMain.EndUpdate;
end;

procedure TFMain.fnRequestData;
begin
  heLoading(True);
  isLoad := True;
  try

    if not QData.FillDataFromURL('https://www.blangkon.net/radio.json') then begin
      TThread.Synchronize(nil, procedure begin ShowToastMessage(QData.FieldByName('messages').AsString, C_ERROR); end);
      Exit;
    end;

    FLastRecordIndexLoad := QData.RecNo;
  finally
    heLoading(False);

    isLoad := False;
    fnLoadData(6);
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  TTask.Run(procedure begin
    fnRequestData;
  end).Start;
end;

procedure TFMain.lbMainViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
  lblValue.Text := Format(
    'ListBox Height : %s'#13 + 'ContentBounds.Size.CY : %s'#13 + 'ViewportPosition.Y : %s'#13 +
    'FLastRecordIndexLoad : %s'#13 + 'QData Record Index : %s'#13 +
    'ListBox Items Count : %s'#13 + 'QData Count : %s',
    [
      lbMain.Height.ToString, lbMain.ContentBounds.Size.cy.ToString, lbMain.ViewportPosition.Y.ToString,
      FLastRecordIndexLoad.ToString, QData.RecNo.ToString,
      lbMain.Items.Count.ToString, QData.RecordCount.ToString
    ]
  );

  if lbMain.Items.Count >= QData.RecordCount then
    Exit;

  if Round(lbMain.ViewportPosition.Y + 0.4999) >= (lbMain.ContentBounds.Size.cy - lbMain.Height) then begin
    if lbMain.Items.Count >= QData.RecordCount then
      Exit;

    fnLoadData(6);
  end;
  
end;

procedure TFMain.sbSearchKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if not Assigned(lbMain.Selected) then begin
    if lbMain.Items.Count = 0 then
      Exit
    else
      lbMain.ItemByIndex(0).IsSelected := True;

    Exit;
  end else begin
    if Key = vkUp then begin
      if lbMain.Selected.Index = 0 then
        Exit;

      lbMain.ItemByIndex(lbMain.Selected.Index - 1).IsSelected := True;
      lbMain.ScrollToItem(lbMain.Selected);
    end else if Key = vkDown then begin
      if lbMain.Selected.Index = (QData.RecordCount - 1) then
        Exit;

      lbMain.ItemByIndex(lbMain.Selected.Index + 1).IsSelected := True;
      lbMain.ScrollToItem(lbMain.Selected);
    end else begin
      Exit;
    end;
  end;
end;

procedure TFMain.sbSearchTyping(Sender: TObject);
begin
  isLoad := True;
  try
    lbMain.Items.Clear;

    QData.Filtered := False;
    QData.Filter := 'radio_name LIKE ''%'+sbSearch.Text+'%''';
    QData.Filtered := True;

    QData.First;
    FLastRecordIndexLoad := QData.RecNo;
  finally
    isLoad := False;
    fnLoadData(6);
  end;
end;

end.
