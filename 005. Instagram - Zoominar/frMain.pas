unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.ImgList, FMX.Objects, System.ImageList, FMX.Effects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Threading, System.IOUtils,
  FMX.Edit, FMX.SearchBox, FMX.ScrollBox, FMX.Memo
  {$IF DEFINED (ANDROID)}
  , Androidapi.Helpers
  {$ELSEIF DEFINED (MSWINDOWS)}
  {$ENDIF}
  ;

type
  TFMain = class(TForm)
    loHeader: TLayout;
    lbFooter: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Glyph4: TGlyph;
    img: TImageList;
    ListBoxItem5: TListBoxItem;
    ciImg: TCircle;
    lbMain: TListBox;
    SB: TStyleBook;
    reFooter: TRectangle;
    seFooter: TShadowEffect;
    btnCamera: TCornerButton;
    Label1: TLabel;
    loTemp: TLayout;
    imgFeedProfile: TCircle;
    Label2: TLabel;
    imgFeed: TRectangle;
    ShadowEffect1: TShadowEffect;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    Label3: TLabel;
    lblCaption: TLabel;
    CornerButton4: TCornerButton;
    imgComment: TCircle;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    aniLoad: TAniIndicator;
    procedure lbFooterItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ciImgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fnClickTemp(Sender : TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure addItem;
    procedure addStory;
    procedure fnClickCi(Sender : TObject);
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}
const
  iFeedProfil = 102;
  iFeed = 101;
  iComment = 100;

procedure TFMain.addItem;
var
  lb : TListBoxItem;
  lo : TLayout;
  i: Integer;
  loc : String;
begin
  lb := TListBoxItem.Create(lbMain);
  lb.Height := loTemp.Height + 16;
  lb.Width := lbMain.Width - 6;
  lb.Selectable := False;

  lo := TLayout(loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Position.X := 5;
  lo.Position.Y := 5;
  lo.Width := lbMain.Width - 16;

  lo.Visible := True;

  lo.Repaint;

  {$IF DEFINED (ANDROID)}
  loc := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF DEFINED (MSWINDOWS)}
  loc := ExpandFileName(GetCurrentDir) + PathDelim;
  {$ENDIF}

  for i := 0 to lo.ControlsCount - 1 do begin
    if lo.Controls[i] is TCornerButton then begin
      if TCornerButton(lo.Controls[i]).Hint = 'temp' then
        TCornerButton(lo.Controls[i]).OnClick := fnClickTemp;
    end else if lo.Controls[i] is TRectangle then begin
      if TRectangle(lo.Controls[i]).Tag = iFeed then
        TRectangle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + 'feed.jpg');
    end else if lo.Controls[i] is TCircle then begin
      if TCircle(lo.Controls[i]).Tag = iFeedProfil then
        TCircle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + '9.png')
      else if TCircle(lo.Controls[i]).Tag = iComment then
        TCircle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + 'profil.jpg');
    end;
  end;

  lbMain.AddObject(lb);

  Application.ProcessMessages;
end;

procedure TFMain.addStory;
var
  listB : TListBox;
  lb, lbSt : TListBoxItem;
  li : TLine;
  L : TLabel;
  ci : TCircle;
  i : Integer;
  loc : String;
begin
  lb := TListBoxItem.Create(lbMain);
  lb.Height := 90;
  lb.Width := lbMain.Width;
  lb.Selectable := False;

    li := TLine.Create(lb);
    li.Parent := lb;
    li.Width := lbMain.Width;
    li.Height := lb.Height;
    li.Position := TPosition.Create(TPointF.Create(0, 0));
    li.LineType := TLineType.Bottom;
    li.Stroke.Color := $FFECECEC;
    li.Stroke.Thickness := 1.25;

    listB := TListBox.Create(lb);
    listB.Parent := lb;
    listB.Width := lbMain.Width;
    listB.Height := lb.Height;
    listB.Position := TPosition.Create(TPointF.Create(0, 0));
    listB.ShowScrollBars := False;
    listB.StyleLookup := 'lbMain';
    listB.ListStyle := TListStyle.Horizontal;

    listB.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight];

    {$IF DEFINED (ANDROID)}
    loc := TPath.GetDocumentsPath + PathDelim;
    {$ELSEIF DEFINED (MSWINDOWS)}
    loc := ExpandFileName(GetCurrentDir) + PathDelim;
    {$ENDIF}

      for i := 0 to 8 do begin
        lbSt := TListBoxItem.Create(listB);
        lbSt.Width := 65;
        lbSt.Height := listB.Height;
        lbSt.Selectable := False;
          ci := TCircle.Create(lbSt);
          ci.Parent := lbSt;
          ci.Width := 50;
          ci.Height := 50;
          ci.Position := TPosition.Create(TPointF.Create((lbSt.Width - ci.Width) / 2, 4));
          ci.Stroke.Kind := TBrushKind.None;

          ci.OnClick := fnClickCi;

          ci.Fill.Kind := TBrushKind.Bitmap;
          ci.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;

          ci.Fill.Bitmap.Bitmap.LoadFromFile(loc + 'story.png');

          ci := TCircle.Create(lbSt);
          ci.Parent := lbSt;
          ci.Width := 40;
          ci.Height := 40;
          ci.Stroke.Kind := TBrushKind.None;
          ci.Position := TPosition.Create(TPointF.Create((lbSt.Width - ci.Width) / 2, 9));

          ci.HitTest := False;

          ci.Fill.Kind := TBrushKind.Bitmap;
          ci.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;

          if i = 0 then
            ci.Fill.Bitmap.Bitmap.LoadFromFile(loc + 'profil.jpg')
          else
            ci.Fill.Bitmap.Bitmap.LoadFromFile(loc + (i + 1).ToString + '.png');

          L := TLabel.Create(lbSt);
          L.Parent := lbSt;
          L.Width := lbSt.Width - 4;
          L.Position := TPosition.Create(TPointF.Create((lbSt.Width - L.Width) / 2, ci.Position.Y + ci.Height + 4));
          if i = 0 then
            L.Text := 'Cerita Anda'
          else
            L.Text := 'Other';
          L.TextAlign := TTextAlign.Center;
          L.TextSettings.Font.Size := 11;
          //L.TextSettings.Font.Style := [TFontStyle.fsBold];
          L.StyledSettings := [];

        listB.AddObject(lbSt);
      end;

  lbMain.AddObject(lb);
end;

procedure TFMain.ciImgClick(Sender: TObject);
begin
  addItem;
end;

procedure TFMain.fnClickCi(Sender: TObject);
var
  C : TCircle;
  i : Integer;
  lb : TListBoxItem;
begin
  C := TCircle(Sender);

  C.Fill.Kind := TBrushKind.None;

  C.Stroke.Kind := TBrushKind.Solid;
  C.Stroke.Thickness := 2;

  C.Stroke.Color := $FF9D9D9D;
  lb := TListBoxItem(C.Parent);
  for i := 0 to lb.ControlsCount - 1 do begin
    if lb.Controls[i] is TLabel then begin
      TLabel(lb.Controls[i]).FontColor := $FF9D9D9D;
    end;
  end;

end;

procedure TFMain.fnClickTemp(Sender: TObject);
var
  B : TCornerButton;
begin
  B := TCornerButton(Sender);

  if B.ImageIndex <> B.Tag then
    B.ImageIndex := B.Tag
  else
    B.ImageIndex := B.Tag + 1;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  {$IF DEFINED (ANDROID)}
  TAndroidHelper.Activity.getWindow.setStatusBarColor($FFECECEC);
  TAndroidHelper.Activity.getWindow.setNavigationBarColor($FFECECEC);
  {$ENDIF}
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  loTemp.Visible := False;
  aniLoad.Enabled := True;
  aniLoad.Visible := True;

  addStory;

  TTask.Run(procedure var i : integer; begin
    Sleep(250);
    try
      for i := 0 to 15 do begin
        TThread.Synchronize(nil, procedure begin
          addItem;
        end);
        Sleep(25);
      end;
    finally
      TThread.Synchronize(nil, procedure begin
        aniLoad.Enabled := False;
        aniLoad.Visible := False;
      end);
    end;
  end).Start;
end;

procedure TFMain.lbFooterItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  i, ii: Integer;
  lb : TListBoxItem;
begin

  if Item.Index <> 4 then begin
    for ii := 0 to lbFooter.Content.ControlsCount - 1 do begin
      if lbFooter.Content.Controls[ii] is TListBoxItem then begin
        lb := TListBoxItem(lbFooter.Content.Controls[ii]);
        for i := 0 to lb.ControlsCount - 1 do begin
          if lb.Controls[i] is TGlyph then
            TGlyph(lb.Controls[i]).ImageIndex := TGlyph(lb.Controls[i]).Tag;
        end;
      end;
    end;


    for i := 0 to Item.ControlsCount - 1 do begin
      if Item.Controls[i] is TGlyph then
        TGlyph(Item.Controls[i]).ImageIndex := TGlyph(Item.Controls[i]).Tag + 1;
    end;
  end;
end;

end.
