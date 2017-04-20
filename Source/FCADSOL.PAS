unit Fcadsol;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, ClipBrd,
  Forms, Dialogs, Menus, ExtCtrls, Buttons, StdCtrls,
  CadVar, Parametre, ExtDlgs, GLCadencer, GLWin32Viewer, GLScene,
  (*AsyncTimer,*) GLObjects, GLGeomObjects, GLSpaceText, GLTexture, GLGui,
  GLWindows, ComCtrls, System.IniFiles, uFormAJL;

type
  TFormCadSol = class(TForm)
    MenuGeneral: TMainMenu;
    Axes1: TMenuItem;
    SousStylaire1: TMenuItem;
    Coordonnes1: TMenuItem;
    Pages1: TMenuItem;
    Outils1: TMenuItem;
    Fichetechnique1: TMenuItem;
    ItemEdition1: TMenuItem;
    Policedecaractres1: TMenuItem;
    N1: TMenuItem;
    Commemtaires1: TMenuItem;
    Type1: TMenuItem;
    Papierpeint1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Effacement1: TMenuItem;
    Lecture1: TMenuItem;
    Dclinaisondusupport1: TMenuItem;
    Coordonnes2: TMenuItem;
    Zoom1: TMenuItem;
    Style1: TMenuItem;
    Devise1: TMenuItem;
    Photo1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Paramtrer1: TMenuItem;
    Commentaire1: TMenuItem;
    Photog1: TMenuItem;
    Vue1: TMenuItem;
    LecturePhoto: TMenuItem;
    Effacement: TMenuItem;
    N2: TMenuItem;
    ItemAfficherPhoto: TMenuItem;
    N3: TMenuItem;
    ItemEmplacement1: TMenuItem;
    ItemParam: TMenuItem;
    ItemCourleurs: TMenuItem;
    FileOpenDialog1: TFileOpenDialog;
    ItemOrientation: TMenuItem;
    OpenPictureDialog2: TOpenPictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure Commemtaires1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Police1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Copier1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Resume1Click(Sender: TObject);
    procedure Type1Click(Sender: TObject);
    procedure Papierpeint1Click(Sender: TObject);
    procedure Pages1Click(Sender: TObject);
    procedure Coordonnes1Click(Sender: TObject);
    procedure Axes1Click(Sender: TObject);
    procedure SousStylaire1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Zoom1Click(Sender: TObject);
    procedure Style1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Dclinaisondusupport1Click(Sender: TObject);
    procedure Effacement1Click(Sender: TObject);
    procedure Coordonnes2Click(Sender: TObject);
    procedure Devise1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Photo1Click(Sender: TObject);
    procedure EffacementClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AfficherPhotoClick(Sender: TObject);
    procedure Parametrage(Sender: TObject);
    procedure ItemEmplacement1Click(Sender: TObject);
    procedure ItemParamClick(Sender: TObject);
    procedure ItemCourleursClick(Sender: TObject);
    procedure ItemEdition1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure ItemOrientationClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    // procedure ItemAfficherPhotoClick(Sender: TObject);

  private
    dc: hdc;
    p: Tpoint;
    r: trect;
    mx, my: Integer;
    Pressed: Boolean;
    { Private-déclarations }
  public
    { Public-déclarations }
    MyMetafile: TMetaFile;
    Cadran: Tcadran;
    appel: TMenuItem;
  end;

var
  FormCadsol: TFormCadSol;

implementation

uses Main, Position, Resume, TypeCad, uCouleurs, Commentaire (*,Apercu*) , zoom,
  Support, Cadtrace, uViewWin, Heurecad,uvisucadMultiple,
  CadTrace3D;
{$R *.DFM}

procedure TFormCadSol.FormCreate(Sender: TObject);

begin
  InitCadran(Cadran);
  Cadran.Pol := UserPol;
  MyMetafile := TMetaFile.Create;
  OpenPictureDialog1.Title := 'Papier peint';

end;

procedure TFormCadSol.Commemtaires1Click(Sender: TObject);
begin
  with CommentDlg do
  begin
    Memo1.SetTextBuf(Cadran.Commentaire);
    ShowModal;
    if (ModalResult = MrOK) and (Memo1.Modified) then
    begin
      Memo1.GetTextBuf(Cadran.Commentaire, 2000);
      Mainform.AfficheComment;
      Cadran.Modif := true;
      (* MainForm.CommentLine.Refresh; *)
    end;
  end;
end;

procedure TFormCadSol.FormPaint(Sender: TObject);
var
  bm: tpicture;
  rbm, rcl, k: real;
  r: trect;

  procedure Effacer;
  begin
    Canvas.Brush.color := ClAppWorkSpace;
    Canvas.Pen.color := ClWhite;
    Canvas.Pen.width := 1;
    Canvas.Pen.style := psSolid;
    Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  end;

begin
  Effacement.Enabled := Cadran.NFPhoto <> '';
  Style1.Enabled := (Cadran.Typ = Vertical) or (Cadran.Typ = bifilaire);
  SousStylaire1.Visible := Cadran.Typ = Vertical;
  SousStylaire1.Checked := Cadran.SousStyle;
  Coordonnes1.Checked := Cadran.Coord;
  Axes1.Checked := Cadran.axes;
  Pages1.Checked := Cadran.NumPage;

  r := getClientRect;
  Canvas.Brush.color := Cadran.ClFond;
  Canvas.Pen.width := 0;
  Canvas.Pen.style := psSolid;
  Canvas.Pen.color := Cadran.ClFond;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  Canvas.Brush.color := Cadran.clCadran;
  Hint := '';
  try
    PaintChild(Cadran, Canvas, r);
  finally
  end;

end;

procedure TFormCadSol.Police1Click(Sender: TObject);
begin
  Mainform.FontBtnClick(Sender);
end;

procedure TFormCadSol.Copier1Click(Sender: TObject);
var
  cv: Tcanvas;
  r: trect;
begin
  // MyMetafile.height:=height;
  // MyMetafile.Width:=Width;

  cv := TMetafileCanvas.Create(MyMetafile, Canvas.Handle);
  r := rect(0, 0, width, Height);

  try
    cv.Brush.color := Cadran.clCadran;
    PaintChild(Cadran, cv, r);
  finally
    cv.free;
  end;
  ClipBoard.assign(MyMetafile);
end;

procedure TFormCadSol.FormActivate(Sender: TObject);
var
  Ini: TIniFile;
  Name: String;
begin
  SousStylaire1.Checked := Cadran.SousStyle;
  Coordonnes1.Checked := Cadran.Coord;
  Axes1.Checked := Cadran.axes;
  Pages1.Checked := Cadran.NumPage;
  Mainform.AfficheComment;
  Effacement1.Enabled := Cadran.NFBitmap <> '';
  UserPol := Cadran.Pol;
  HUserPol := CreateFontIndirect(Cadran.Pol);

(*  if MainForm.ItemParametrage.Checked then  with Param do begin
    SetFocus; Repaint end;
  if MainForm.itemPositionGeographique.Checked then
    PositionForm.Invalidate;
  if MainForm.itemCouleursetEpaisseurs.Checked then
    CouleursDlg.Invalidate;
  if MainForm.itemVueen3dimentions.Checked then
    FormCadsol3D.Invalidate;
  if MainForm.itemOmbredustyle.Checked then
    HeureDlg.Invalidate;
  if MainForm.ItemTypedecadran1.Checked then
    TypeCadDlg.Invalidate;      *)

end;

procedure TFormCadSol.Resume1Click(Sender: TObject);
begin
  ResumeDlg.ShowModal;
end;

procedure TFormCadSol.Type1Click(Sender: TObject);

begin
  TypeCadDlg.Show;
end;


procedure TFormCadSol.Papierpeint1Click(Sender: TObject);
begin
  OpenPictureDialog2.Filename := Cadran.NFBitmap;
  OpenPictureDialog2.Title := 'Papier peint';
  if OpenPictureDialog1.Execute then
  begin
    Cadran.NFBitmap := OpenPictureDialog1.Filename;
    Cadran.Modif := true;
    refresh
  end;
  Effacement1.Enabled := Cadran.NFBitmap <> '';
end;

procedure TFormCadSol.Parametrage(Sender: TObject);
begin
  Mainform.ItemParametrageClick(Sender);
end;

procedure TFormCadSol.Effacement1Click(Sender: TObject);
begin
  if Cadran.NFBitmap <> '' then
  begin
    Cadran.NFBitmap := '';
    Cadran.Modif := true;
    refresh
  end;
  Effacement1.Enabled := Cadran.NFBitmap <> '';
end;

procedure TFormCadSol.EffacementClick(Sender: TObject);
begin
  Cadran.NFPhoto := '';
  Cadran.Modif := true;
  Effacement.Enabled := false;
end;

procedure TFormCadSol.Pages1Click(Sender: TObject);
begin
  Cadran.NumPage := not Cadran.NumPage;
  Pages1.Checked := Cadran.NumPage;
  Cadran.Modif := true;
  refresh
end;

procedure TFormCadSol.Coordonnes1Click(Sender: TObject);
begin
  Cadran.Coord := not Cadran.Coord;
  Coordonnes1.Checked := Cadran.Coord;
  Cadran.Modif := true;
  refresh
end;

procedure TFormCadSol.Axes1Click(Sender: TObject);
begin
  Cadran.axes := not Cadran.axes;
  Axes1.Checked := Cadran.axes;
  Cadran.Modif := true;
  refresh
end;

procedure TFormCadSol.SousStylaire1Click(Sender: TObject);
begin
  Cadran.SousStyle := not Cadran.SousStyle;
  SousStylaire1.Checked := Cadran.SousStyle;
  Cadran.Modif := true;
  refresh
end;

procedure TFormCadSol.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Pressed := true;
  with r, Cadran do
  begin
    dc := getdc(Handle);
    // dc:=canvas.handle;
    r := getClientRect;
    setMapMode(dc, MM_ISOTROPIC);
    setWindowOrgex(dc, 0, 0, nil);
    SetWindowExtEx(dc, round((Cadran.largeur div 2) * 1.1),
      -round((Cadran.hauteur div 2) * 1.1), nil);
    SetViewPortOrgEx(dc, (left + right) div 2, (top + bottom) div 2, nil);
    SetViewPortExtEx(dc, (right - left) div 2, (bottom - top) div 2, nil);
  end;
  case Button of
    mbLeft:
      begin
        if Style1.Checked and (Cadran.Typ in [Vertical, bifilaire]) then
          with Cadran do
          begin

            p.X := X;
            p.Y := Y;
            DPToLP(dc, p, 1);
            gx := p.X;
            gy := p.Y;
            Modif := true;
            refresh;
            if Param.Visible then
            begin
              Param.SetFocus;
              Param.refresh;
            end;
            if formCadsol3d.Visible then
            begin
              formCadsol3d.SetFocus;
              formCadsol3d.refresh;
              self.SetFocus;
            end;
            self.SetFocus;
          end;
        if Zoom1.Checked then
          with ZoomForm do
          begin
            p.X := X;
            p.Y := Y;
            DPToLP(dc, p, 1);
            Zx := p.X;
            Zy := p.Y;
            ZoomForm.Show;
            ZoomForm.refresh
          end;
        if Devise1.Checked then
          with Cadran do
          begin

            p.X := X;
            p.Y := Y;
            DPToLP(dc, p, 1);
            if (abs(p.X) < largeur / 2) and (abs(p.Y) < hauteur / 2) then
            begin
              Devx := p.X;
              Devy := p.Y;
              Modif := true;
              refresh;
              if Param.Visible then
              begin
                Param.SetFocus;
                Param.refresh;
              end;
            end;
          end;
        releasedc(Handle, dc);
      end;
  end;
end;

procedure TFormCadSol.Zoom1Click(Sender: TObject);
var
  i: Integer;
begin
for i:=1 to mainForm.MDIChildCount do
    with TformCadsol(MainForm.MDIChildren[i-1]) do
 begin
  Zoom1.Checked := not Zoom1.Checked;
  if Zoom1.Checked then
    begin
    Devise1.Checked := false;
    Style1.Checked := false;
    Cursor := crDrag;
    ZoomForm.Show;
    ZoomForm.refresh
    end
  else
    begin
    Cursor := crDefault;
    ZoomForm.Close;
    end;
 end;
end;

procedure TFormCadSol.Style1Click(Sender: TObject);
var i:integer;
begin
  for i:=1 to mainForm.MDIChildCount do
    with TformCadsol(MainForm.MDIChildren[i-1]) do
  begin
       Style1.Checked := not Style1.Checked;
  if ZoomForm.Visible then
    ZoomForm.Close;
  if Style1.Checked then
    begin
    Zoom1.Checked := false;
    Devise1.Checked := false;
    Cursor := crCross
    end
  else
    Cursor := crDefault;
  end;
end;

procedure TFormCadSol.Devise1Click(Sender: TObject);
var i:integer;
begin
for i:=1 to mainForm.MDIChildCount do
    with TformCadsol(MainForm.MDIChildren[i-1]) do
 begin
  Devise1.Checked := not Devise1.Checked;
  if ZoomForm.Visible then
    ZoomForm.Close;
  if Devise1.Checked then
  begin
    Zoom1.Checked := false;
    Style1.Checked := false;
    Cursor := crHandPoint
  end
  else
    Cursor := crDefault;
 end;
end;

procedure TFormCadSol.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with r, Cadran do
  begin
    // dc:=getdc(handle);
    dc := Canvas.Handle;
    r := getClientRect;
    setMapMode(dc, MM_ISOTROPIC);
    setWindowOrgex(dc, 0, 0, nil);
    SetWindowExtEx(dc, round((Cadran.largeur div 2) * 1.1),
      -round((Cadran.hauteur div 2) * 1.1), nil);
    SetViewPortOrgEx(dc, (left + right) div 2, (top + bottom) div 2, nil);
    SetViewPortExtEx(dc, (right - left) div 2, (bottom - top) div 2, nil);
  end;
  p.X := X;
  p.Y := Y;
  DPToLP(dc, p, 1);
  Mainform.Statusline.Caption := IntToStr(p.X div 10) + ' , ' +
    IntToStr(p.Y div 10);
  // releasedc(handle,dc);
end;

procedure TFormCadSol.Dclinaisondusupport1Click(Sender: TObject);
begin
  DecliSupport.ShowModal;
end;

{ ChangeFileExt changes the extension of a filename. FileName specifies a
  filename with or without an extension, and Extension specifies the new
  extension for the filename. The new extension can be a an empty string or
  a period followed by up to three characters.

  function ChangeFileExt(const FileName, Extension: string): string;
}

procedure TFormCadSol.Coordonnes2Click(Sender: TObject);
var
  Com, NFText: shortstring;

begin
   NFText := ChangeFileExt(Cadran.Nomfichier, '.txt');
  FileOpenDialog1.Filename := NFText;
  if FileOpenDialog1.Execute then
  begin
    NFText := FileOpenDialog1.Filename;
    assignFile(f, NFText);
(*$I-*)
    rewrite(f) (*$I+*)
      ;
    if IOResult = 0 then
    begin
      FichierCoord := true;

      writeln(f, '//  CADRAN : ' + Cadran.Nomfichier);
      writeln(f, '//  ______________________________________________');
      writeln(f, '//  Date d''édition :' + DateTimetostr(Now));
      writeln(f, '//  (C)Copyright ' + application.Title);
      writeln(f, '//  ______________________________________________');
      writeln(f, '//');
      writeln(f, '//  L''origine des axes est au centre du cadran');
      writeln(f, '//  Orientation des abscisses: de gauche à droite');
      writeln(f, '//  Orientation des ordonnées: de bas en haut ');
      writeln(f, '//  (suivant la ligne de plus grande pente)');
      writeln(f, '//  L''unité de mesure est le millimètre');
      writeln(f, '//  (Précision: 1/10 de millimètre)');
      writeln(f, '//');

      TraceCadran(Cadran, Canvas, 0, 0);
      FichierCoord := false;
      closeFile(f);
      Com := 'Notepad.exe ' + NFText;
      WinExec(@Com[0], SW_SHOW);
    end
    else
      MessageDlg('Ecriture impossible dans l''unité: ' +
        ExtractFileDrive(NFText), mtWarning, [mbOK], 0);
  end;
end;

procedure TFormCadSol.FormClick(Sender: TObject);
begin
//   FormCadsol3D.Refresh;
//   SetActiveWindow(Handle)
//   if FormCadsol3D.Visible then SetActiveWindow(FormCadsol3D.Handle);
end;

procedure TFormCadSol.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 (* if Mainform.MDIChildCount=1 then begin
  HeureDlg.Close;
  CouleursDlg.Close;
  ZoomForm.Close;
  Param.Close;
  FormCadsol3D.Close;
  PositionForm.Close;
  TypeCadDlg.Close;
  MainForm.ItemAfficher.Visible := False;
  end;  *)
 If CadranMultiple.Typ=Vide then begin
    HeureDlg.Close;
    CouleursDlg.Close;
    ZoomForm.Close;
    Param.Close;
    FormCadsol3D.Close;
    PositionForm.Close;
    TypeCadDlg.Close;
    VisuCadMultipleForm.Close;
    MainForm.ItemAfficher.Visible := False;
    Action := caFree
    end else Action:=caMinimize;
end;

procedure TFormCadSol.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  S1, S2: String;
begin
  (* if Cadran.Modif then
  begin
    if CadranMultiple.Typ<>Vide then begin
       //CadranMultiple.Modif:=True;
       Canclose:=True;
       exit;
    end;
    S1 := 'Enregistrer les modifications dans le fichier:'#13#10 + '   ' +
      self.Cadran.Nomfichier;
    S2 := self.Caption;
    if application.MessageBox(PChar(S1), PChar(S2), mb_yesno + mb_iconquestion)
      = idyes then
      EcrireCadransol(ActiveCad.Cadran, self.Cadran.Nomfichier);

    Mainform.CommentPanel.Caption := '';
    Mainform.LatiPanel.Caption := '';
    Mainform.LongiPanel.Caption := '';
    Cadran.Modif := false;
    // Zoomform.Close;
  end;   *)
  Canclose:= true;
end;

procedure TFormCadSol.FormResize(Sender: TObject);
begin
  refresh;
end;

procedure TFormCadSol.ItemCourleursClick(Sender: TObject);
begin
 CouleursDlg.Show;
end;

procedure TFormCadSol.ItemEdition1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
//  if ActiveMDIChild<>nil then  ItemEdition1.Caption:='Modifier : '+ self.ActiveMDIChild.Caption;
end;

procedure TFormCadSol.ItemEmplacement1Click(Sender: TObject);
begin
 Positionform.show;
end;

procedure TFormCadSol.ItemOrientationClick(Sender: TObject);
begin
  FormCadsol3D.Show
end;

procedure TFormCadSol.ItemParamClick(Sender: TObject);
begin
 Param.Show;
end;

procedure TFormCadSol.AfficherPhotoClick(Sender: TObject);
begin
  ViewFormPhoto.Show
end;

procedure TFormCadSol.Photo1Click(Sender: TObject);
begin
  OpenPictureDialog1.InitialDir := GetCurrentDir;
  OpenPictureDialog1.Title := 'Photographie du cadran';
  OpenPictureDialog1.Filter :=
    'Tout fichier:   *.bmp; *.emf; *.wmf;*.jpg;*.jpeg|*.bmp;*.emf;*.wmf;*.jpg;*.jpeg|Bitmaps (*.bmp)|*.bmp|MétaFichiers améliorés (*.emf)|*.emf|MetaFichiers (*.wmf)|*.wmf|Fichier compressés (*.jpg;*.jpeg)|*.jpg;*.jpeg';

  OpenPictureDialog1.Filename := Cadran.NFPhoto;
  if OpenPictureDialog1.Execute then
  begin
    Cadran.NFPhoto := OpenPictureDialog1.Filename;
    Cadran.Modif := true;
    ViewFormPhoto.Show
  end;
end;

end.
