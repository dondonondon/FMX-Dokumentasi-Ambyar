unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.TabControl, System.Threading, System.Diagnostics;

type
  TForm1 = class(TForm)
    lbAnchor: TListBox;
    btnAnchor: TCornerButton;
    tcMain: TTabControl;
    tiAlign: TTabItem;
    tiAnchor: TTabItem;
    btnAlign: TCornerButton;
    lbAlign: TListBox;
    vsAlign: TVertScrollBox;
    vsAnchor: TVertScrollBox;
    tiAlignAPM: TTabItem;
    tiAnchorAPM: TTabItem;
    btnAlignAPM: TCornerButton;
    vsAlignAPM: TVertScrollBox;
    btnAnchorAPM: TCornerButton;
    vsAnchorAPM: TVertScrollBox;
    btnClear: TCornerButton;
    lblSw: TLabel;
    btnDown: TCornerButton;
    procedure btnAnchorClick(Sender: TObject);
    procedure lbAnchorItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnAlignClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAlignAPMClick(Sender: TObject);
    procedure btnAnchorAPMClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
  private
    { Private declarations }
  public
    YYA, YYAPM : Single;
    iAlign, iAnchor, iAlignAPM, iAnchorAPM : Integer;
    procedure addItem(listB : TListBox); overload;
    procedure addItem(vs : TVertScrollBox); overload;
    procedure fnPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure fnSetControl(st : Boolean);
    procedure fnSetLabel(str : String);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.addItem(listB : TListBox);
var
  lb : TListBoxItem;
  R : TRectangle;
begin
  lb := TListBoxItem.Create(listB);
  lb.Selectable := False;
  lb.Height := 100;
  lb.Width := listB.Width / listB.Columns;

    R := TRectangle.Create(lb);
    R.Parent := lb;
    if listB.Tag = 1 then begin
      R.Width := lb.Width - 16;
      R.Height := lb.Height - 16;
      R.Position.X := 8;
      R.Position.Y := 8;
    end else begin
      R.Align := TAlignLayout.Client;
      R.Margins := TBounds.Create(TRectF.Create(8, 8, 8, 8));
    end;

    R.HitTest := False;

  listB.AddObject(lb);
end;

procedure TForm1.addItem(vs: TVertScrollBox);
var
  R, RR : TRectangle;
begin
  R := TRectangle.Create(vs);
  R.Parent := vs;
  if vs.Tag = 1 then begin
    R.Width := vs.Width - 16;
    R.Height := 50;
    if vs.Name = 'vsAnchor' then
      R.Position := TPosition.Create(TPointF.Create(8, YYA))
    else
      R.Position := TPosition.Create(TPointF.Create(8, YYAPM));
      RR := TRectangle.Create(R);
      RR.Parent := R;
      RR.Width := R.Width - 16;
      RR.Height := R.Height - 16;
      RR.Position := TPosition.Create(TPointF.Create(8, 8));


    if vs.Name = 'vsAnchor' then begin
      RR.Tag := iAnchor;
      YYA := YYA + R.Height + 16;
      Inc(iAnchor);
    end else begin
      RR.Tag := iAnchorAPM;
      YYAPM := YYAPM + R.Height + 16;
      Inc(iAnchorAPM);
    end;

  end else begin
    R.Align := TAlignLayout.Top;
    R.Margins := TBounds.Create(TRectF.Create(8, 8, 8, 8));
      RR := TRectangle.Create(R);
      RR.Parent := R;
      RR.Align := TAlignLayout.Client;
      RR.Margins := TBounds.Create(TRectF.Create(8, 8, 8, 8));

    R.Position.Y := 9999999;
    if vs.Name = 'vsAlign' then begin
      RR.Tag := iAlign;
      Inc(iAlign);
    end else begin
      RR.Tag := iAlignAPM;
      Inc(iAlignAPM);
    end;
  end;
  RR.OnPaint := fnPaint;

  RR.HitTest := False;
  R.HitTest := False;
end;

procedure TForm1.btnAlignAPMClick(Sender: TObject);
begin
  TTask.Run(procedure var i : Integer; sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      for i := 0 to 50 do begin
        TThread.Synchronize(nil, procedure begin
          addItem(vsAlignAPM);
        end);

        Sleep(3);
      end;
      sw.Stop;
      fnSetLabel('(in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;
end;

procedure TForm1.btnAlignClick(Sender: TObject);
var
  i: Integer;
  sw : TStopwatch;
begin
  fnSetControl(False);
  try
    sw := TStopwatch.StartNew;
    for i := 0 to 50 do begin
      addItem(vsAlign);
    end;
    sw.Stop;
    lblSw.Text := '(in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms';
  finally
    fnSetControl(True);
  end;
end;

procedure TForm1.btnAnchorAPMClick(Sender: TObject);
begin
  TTask.Run(procedure var i : Integer; sw : TStopwatch; begin
    fnSetControl(False);
    try
      sw := TStopwatch.StartNew;
      for i := 0 to 50 do begin
        TThread.Synchronize(nil, procedure begin
          addItem(vsAnchorAPM);
        end);

        Sleep(3);
      end;
      sw.Stop;
      fnSetLabel('(in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms');
    finally
      fnSetControl(True);
    end;
  end).Start;
end;

procedure TForm1.btnAnchorClick(Sender: TObject);
var
  i: Integer;
  sw : TStopwatch;
begin
  fnSetControl(False);
  try
    sw := TStopwatch.StartNew;
    for i := 0 to 50 do begin
      addItem(vsAnchor);
    end;
    sw.Stop;
    lblSw.Text := '(in milliseconds): ' + sw.Elapsed.TotalMilliseconds.ToString + 'ms';
  finally
    fnSetControl(True);
  end;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  YYA := 8;
  YYAPM := 8;
  iAlign := 0;
  iAnchor := 0;
  iAlignAPM := 0;
  iAnchorAPM := 0;

  vsAlign.Content.DeleteChildren;
  vsAlignAPM.Content.DeleteChildren;
  vsAnchor.Content.DeleteChildren;
  vsAnchorAPM.Content.DeleteChildren;

  vsAlign.Repaint;
  vsAlignAPM.Repaint;
  vsAnchor.Repaint;
  vsAnchorAPM.Repaint;
end;

procedure TForm1.btnDownClick(Sender: TObject);
begin
  if tcMain.TabIndex = 0 then
    vsAlign.ViewportPosition := TPointF.Create(0, 999999)
  else if tcMain.TabIndex = 1 then
    vsAnchor.ViewportPosition := TPointF.Create(0, 999999)
  else if tcMain.TabIndex = 2 then
    vsAlignAPM.ViewportPosition := TPointF.Create(0, 999999)
  else if tcMain.TabIndex = 3 then
    vsAnchorAPM.ViewportPosition := TPointF.Create(0, 999999)
end;

procedure TForm1.fnPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  with Canvas do begin
    BeginScene();
    Font.Style := [];
    Font.Size := 12;
    Fill.Color := TAlphaColors.Red;
    FillText(TRectF.Create(0, 0, TRectangle(Sender).Width, TRectangle(Sender).Height), TRectangle(Sender).Tag.ToString, False, 1, [], TTextAlign.Center, TTextAlign.Center); //TFillTextFlag.RightToLeft
    EndScene;
  end;
  Application.ProcessMessages;
end;

procedure TForm1.fnSetControl(st: Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    btnAnchor.Enabled := st;
    btnAnchorAPM.Enabled := st;
    btnAlign.Enabled := st;
    btnAlignAPM.Enabled := st;
  end);
end;

procedure TForm1.fnSetLabel(str: String);
begin
  TThread.Synchronize(nil, procedure begin
    lblSw.Text := str;
  end);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  YYA := 8;
  YYAPM := 8;
  iAlign := 0;
  iAnchor := 0;
  iAlignAPM := 0;
  iAnchorAPM := 0;
end;

procedure TForm1.lbAnchorItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  ShowMessage(Item.Index.ToString);
end;

end.
