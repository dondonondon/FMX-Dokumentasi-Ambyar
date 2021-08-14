unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.TabControl, System.Threading, System.Diagnostics, FMX.Edit, FMX.ImgList,
  FMX.Advertising, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    btnClear: TCornerButton;
    Edit1: TEdit;
    tcMain: TTabControl;
    tiAlign: TTabItem;
    btnAlign: TCornerButton;
    lbAlign: TListBox;
    Label1: TLabel;
    tiAnchor: TTabItem;
    btnAnchor: TCornerButton;
    lbAnchor: TListBox;
    Label2: TLabel;
    tiAlignAPM: TTabItem;
    btnAlignAPM: TCornerButton;
    Label3: TLabel;
    tiAnchorAPM: TTabItem;
    btnAnchorAPM: TCornerButton;
    Label4: TLabel;
    lbStyle: TListBox;
    lbClone: TListBox;
    lbStyleAPM: TListBox;
    lbStyleLoopInThread: TListBox;
    SB: TStyleBook;
    loTemp: TLayout;
    bgTemp: TRectangle;
    lblRegion: TLabel;
    lblAlias: TLabel;
    lblPrice: TLabel;
    lblKet: TLabel;
    loPosChart: TLayout;
    reMore: TRectangle;
    glMore: TGlyph;
    glWatchlist: TGlyph;
    imgChart: TImage;
    cbVisible: TCheckBox;
    TabItem1: TTabItem;
    loLoad: TLayout;
    aniLoad: TAniIndicator;
    CornerButton1: TCornerButton;
    Label5: TLabel;
    lbCloneAPM: TListBox;
    TabItem2: TTabItem;
    CornerButton2: TCornerButton;
    Label6: TLabel;
    lbCloneThreadInLoop: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure btnAlignClick(Sender: TObject);
    procedure btnAnchorClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure lbStyleItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnAlignAPMClick(Sender: TObject);
    procedure btnAnchorAPMClick(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
  private
    procedure fnSetControl(st : Boolean);
    procedure addItemStyle(FRegion, FAlias, FPrice, FKet : String);
    procedure addItemStyleAPM(FRegion, FAlias, FPrice, FKet : String);
    procedure addItemStyleLoopInThread(FRegion, FAlias, FPrice, FKet : String);
    procedure addItemClone(FRegion, FAlias, FPrice, FKet : String);
    procedure addItemCloneLoopInThread(FRegion, FAlias, FPrice, FKet : String);
    procedure addItemCloneThreadInLoop(FRegion, FAlias, FPrice, FKet : String);
    procedure addBanner;
    procedure fnSetLabel(L : TLabel; str : String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.addBanner;
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Height := 72;
  lb.Width := lbStyle.Width;
  lb.StyleLookup := 'lbBanner';

  lb.Selectable := False;

  lbStyle.AddObject(lb);

  lb.StylesData['sBanner.AdUnitID'] := 'ca-app-pub-3940256099942544/6300978111';
  lb.StylesData['sBanner.LoadAd'];
end;

procedure TForm1.addItemClone(FRegion, FAlias, FPrice, FKet: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblRegion.Text := FRegion;
  lblAlias.Text := FAlias;
  lblPrice.Text := FPrice;
  lblKet.Text := FKet;

  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbClone.Width;
  lb.Height := loTemp.Height + (12);
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];
  lb.StyleLookup := 'lbNull';

  lo := TLayout(loTemp.Clone(nil));
  lo.Width := lbClone.Width - (8 * 4);
  lo.Position.X := 8 + 8;
  lo.Position.Y := 8;

  lb.AddObject(lo);

  lbClone.AddObject(lb);
  lo.Visible := True;
end;

procedure TForm1.addItemCloneLoopInThread(FRegion, FAlias, FPrice,
  FKet: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblRegion.Text := FRegion;
  lblAlias.Text := FAlias;
  lblPrice.Text := FPrice;
  lblKet.Text := FKet;

  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbCloneAPM.Width;
  lb.Height := loTemp.Height + (12);
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];
  lb.StyleLookup := 'lbNull';

  lo := TLayout(loTemp.Clone(nil));
  lo.Width := lbCloneAPM.Width - (8 * 4);
  lo.Position.X := 8 + 8;
  lo.Position.Y := 8;

  lb.AddObject(lo);

  lbCloneAPM.AddObject(lb);
  lo.Visible := True;
end;

procedure TForm1.addItemCloneThreadInLoop(FRegion, FAlias, FPrice,
  FKet: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblRegion.Text := FRegion;
  lblAlias.Text := FAlias;
  lblPrice.Text := FPrice;
  lblKet.Text := FKet;

  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbCloneThreadInLoop.Width;
  lb.Height := loTemp.Height + (12);
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];
  lb.StyleLookup := 'lbNull';

  lo := TLayout(loTemp.Clone(nil));
  lo.Width := lbCloneThreadInLoop.Width - (8 * 4);
  lo.Position.X := 8 + 8;
  lo.Position.Y := 8;

  lb.AddObject(lo);

  lbCloneThreadInLoop.AddObject(lb);
  lo.Visible := True;
end;

procedure TForm1.addItemStyle(FRegion, FAlias, FPrice, FKet: String);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Height := 72;
  lb.Width := lbStyle.Width;
  lb.StyleLookup := 'lbData';

  lb.Selectable := False;

  lbStyle.AddObject(lb);

  lb.StylesData['lblAlias'] := FAlias;
  lb.StylesData['lblKet'] := FKet;
  lb.StylesData['lblPrice'] := FPrice;
  lb.StylesData['lblRegion'] := FRegion;
end;

procedure TForm1.addItemStyleAPM(FRegion, FAlias, FPrice, FKet: String);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Height := 72;
  lb.Width := lbStyleAPM.Width;
  lb.StyleLookup := 'lbData';

  lb.Selectable := False;

  lbStyleAPM.AddObject(lb);

  lb.StylesData['lblAlias'] := FAlias;
  lb.StylesData['lblKet'] := FKet;
  lb.StylesData['lblPrice'] := FPrice;
  lb.StylesData['lblRegion'] := FRegion;
end;

procedure TForm1.addItemStyleLoopInThread(FRegion, FAlias, FPrice,
  FKet: String);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Height := 72;
  lb.Width := lbStyleLoopInThread.Width;
  lb.StyleLookup := 'lbData';

  lb.Selectable := False;

  lbStyleLoopInThread.AddObject(lb);

  lb.StylesData['lblAlias'] := FAlias;
  lb.StylesData['lblKet'] := FKet;
  lb.StylesData['lblPrice'] := FPrice;
  lb.StylesData['lblRegion'] := FRegion;
end;

procedure TForm1.btnAlignAPMClick(Sender: TObject);
begin
  TTask.Run(procedure var i : Integer; sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
        TThread.Synchronize(nil, procedure begin
          addItemStyleAPM('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
          Application.ProcessMessages;
        end);
      end;
      sw.Stop;
      fnSetLabel(Label3, '['+ lbStyleAPM.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;

  label9.Text := 'TTask.Run'#13 +
    'for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
    '  TThread.Synchronize(nil, procedure begin'#13 +
    '    addItemStyleAPM(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
    '    Application.ProcessMessages;'#13 +
    '  end);'#13 +
    'end;';
end;

procedure TForm1.btnAlignClick(Sender: TObject);
var
  i: Integer;
  sw : TStopwatch;
begin
  fnSetControl(False);
  try
    sw := TStopwatch.StartNew;
    for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
      addItemStyle('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
    end;
    sw.Stop;
    Label1.Text := '['+ lbStyle.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms';
  finally
    fnSetControl(True);
  end;

  label7.Text :=
  'for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
  '  addItemStyle(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
  'end;';
end;

procedure TForm1.btnAnchorAPMClick(Sender: TObject);
begin
  TTask.Run(procedure var sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      TThread.Synchronize(nil, procedure var i : Integer; begin
        for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
          addItemStyleLoopInThread('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
        end;
      end);
      sw.Stop;
      fnSetLabel(Label4, '['+ lbStyleLoopInThread.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;

  label8.Text := 'TTask.Run'#13 +
    'TThread.Synchronize(nil, procedure var i : Integer; begin'#13 +
    '  for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
    '    addItemStyleLoopInThread(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
    '  end;'#13 +
    'end);';
end;

procedure TForm1.btnAnchorClick(Sender: TObject);
var
  i: Integer;
  sw : TStopwatch;
begin
  fnSetControl(False);
  try
    sw := TStopwatch.StartNew;
    for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
      addItemClone('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
    end;
    sw.Stop;
    Label2.Text := '['+ lbClone.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms';
  finally
    fnSetControl(True);
  end;

  label10.Text :=
    'for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
    '  addItemClone(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
    'end;';
end;
procedure TForm1.btnClearClick(Sender: TObject);
begin
  lbStyle.Items.Clear;
  lbClone.Items.Clear;
  lbCloneAPM.Items.Clear;
  lbStyleAPM.Items.Clear;
  lbStyleLoopInThread.Items.Clear;
  lbCloneThreadInLoop.Items.Clear;
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
begin
  TTask.Run(procedure var sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      TThread.Synchronize(nil, procedure var i : Integer; begin
        for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
          addItemCloneLoopInThread('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
        end;
      end);
      sw.Stop;
      fnSetLabel(Label5, '['+ lbCloneAPM.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;

  label11.Text := 'TTask.Run'#13 +
    'TThread.Synchronize(nil, procedure var i : Integer; begin'#13 +
    '  for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
    '    addItemCloneLoopInThread(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
    '  end;'#13 +
    'end);';
end;

procedure TForm1.CornerButton2Click(Sender: TObject);
begin
  TTask.Run(procedure var i : Integer; sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin
        TThread.Synchronize(nil, procedure begin
          addItemCloneThreadInLoop('AALI', 'Astra Agro Lestari Tbk.', '16,375', '+20 (+3.50%)');
          Application.ProcessMessages;
        end);
      end;
      sw.Stop;
      fnSetLabel(Label6, '['+ lbCloneThreadInLoop.Items.Count.ToString +'](in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;

  label12.Text :=  'TTask.Run'#13 +
    'for i := 0 to StrToIntDef(Edit1.Text, 10) - 1 do begin'#13 +
    '  TThread.Synchronize(nil, procedure begin'#13 +
    '    addItemCloneThreadInLoop(''AALI'', ''Astra Agro Lestari Tbk.'', ''16,375'', ''+20 (+3.50%)'');'#13 +
    '    Application.ProcessMessages;'#13 +
    '  end);'#13 +
    'end;';
end;

procedure TForm1.fnSetControl(st: Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    btnAnchor.Enabled := st;
    btnAnchorAPM.Enabled := st;
    btnAlign.Enabled := st;
    btnAlignAPM.Enabled := st;
    CornerButton1.Enabled := st;
    CornerButton2.Enabled := st;

    loLoad.Visible := not st;
    aniLoad.Enabled := not st;

    if cbVisible.IsChecked then begin
      lbStyle.Visible := True;
      lbStyleAPM.Visible := True;
      lbClone.Visible := True;

      lbCloneAPM.Visible := True;
      lbCloneThreadInLoop.Visible := True;
      lbStyleLoopInThread.Visible := True;
    end else begin
      lbStyle.Visible := st;
      lbStyleAPM.Visible := st;
      lbClone.Visible := st;

      lbCloneAPM.Visible := st;
      lbCloneThreadInLoop.Visible := st;
      lbStyleLoopInThread.Visible := st;
    end;
  end);
end;

procedure TForm1.fnSetLabel(L: TLabel; str: String);
begin
  TThread.Synchronize(nil, procedure begin
    L.Text := str;
  end);
end;

procedure TForm1.lbStyleItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  ShowMessage(Item.StylesData['lblRegion'].ToString);
  Item.StylesData['lblRegion.Text'] := 'TeloGoreng';
end;

end.
