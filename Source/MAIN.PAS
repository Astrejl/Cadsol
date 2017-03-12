unit Main;

interface

uses WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ToolWin, ComCtrls,
  ImgList, System.ImageList, FCadsol, CadVar, uFormAJL, System.IniFiles;

type
  TMainForm = class(TFormAJL)
    MainMenu1: TMainMenu;
    CommentLine: TPanel;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    ItemAfficher: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    Timer1: TTimer;
    StatusLine: TPanel;
    FontDialog: TFontDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    N2: TMenuItem;
    Configurerlimprimante1: TMenuItem;
    PrintDialog: TPrintDialog;
    ImprimerCadranTtem: TMenuItem;
    N3: TMenuItem;
    BarredOutils1: TMenuItem;
    LatiPanel: TPanel;
    CommentPanel: TPanel;
    LongiPanel: TPanel;
    WindowArrangeItem: TMenuItem;
    Toutrtablir1: TMenuItem;
    Barredetat1: TMenuItem;
    Enregistrertouslescadrans1: TMenuItem;
    Lisezmoi1: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    Assistantdecration1: TMenuItem;
    ImageList1: TImageList;
    ToutFermer2: TMenuItem;
    SiteinternetCadSol1: TMenuItem;
    CoolBar1: TCoolBar;
    SpeedPanel: TToolBar;
    ExitBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SaveBtn: TSpeedButton;
    PrintButton: TSpeedButton;
    CopyBtn: TSpeedButton;
    FontBtn: TSpeedButton;
    Cadransimple1: TMenuItem;
    ItemNouveauCadranmultiple: TMenuItem;
    ItemStyle: TMenuItem;
    ItemParametrage: TMenuItem;
    itemPositionGeographique: TMenuItem;
    itemCouleursetEpaisseurs: TMenuItem;
    itemVueen3dimentions: TMenuItem;
    itemOmbredustyle: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N4: TMenuItem;
    SaveDialog: TFileSaveDialog;
    ItemToutFermer: TMenuItem;
    OpenDialog1: TFileOpenDialog;
    ItemCubique1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure OuvrirCadranSimpleClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure WindowMinimizeItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpAboutItemClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure Configurerlimprimante1Click(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);

    procedure CommentPanelDblClick(Sender: TObject);
    procedure Toutrtablir1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BarredOutils1Click(Sender: TObject);
    procedure Barredetat1Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Index1Click(Sender: TObject);
    procedure Toutfermer1Click(Sender: TObject);
    procedure Lisezmoi1Click(Sender: TObject);
    procedure Assistant1Click(Sender: TObject);

    procedure SiteinternetCadSol1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NouveauCadranmultipleClick(Sender: TObject);
    procedure ItemStyleClick(Sender: TObject);
    procedure ItemParametrageClick(Sender: TObject);
    procedure itemPositionGeographiqueClick(Sender: TObject);
    procedure itemCouleursetEpaisseursClick(Sender: TObject);
    procedure itemVueen3dimentionsClick(Sender: TObject);
    procedure itemOmbredustyleClick(Sender: TObject);
    procedure NouveauCadransimpleClick(Sender: TObject);
    procedure ItemToutFermerClick(Sender: TObject);
    procedure OuvrirCadranMultipleClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ItemCubique1Click(Sender: TObject);

  private
    { Private declarations }
    procedure CreateMDIChild(const Name: string);
    procedure ShowHint(Sender: TObject);
    procedure WMDropFiles(var Msg: TWMDropFiles);
    procedure PerformFileOpen(const AFileName: string);

  public
    procedure AfficheComment;
    procedure AfficheHeure;
    Procedure AfficheFenetres;
    Procedure DimEtOrientationCadranCubique;
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Debut: Boolean;
  ActiveCad: TFormCadsol;
  CadranMultiple: TCadran;
  FCadSud,FCadEst,FCadNord,FCadOuest,FcadSup,FCadInf: TFormCadsol;
  Style: String;
  // USVer: Boolean;

implementation

{$R *.DFM}

uses Apropos2, ShellAPI, uCouleurs, Assist, Zoom,
  cadtrace3D, ustyle, Vcl.Themes,
  Parametre, Heurecad, Position, uViewWin, uCadranMultiple, uVisuCadMultiple;

Procedure TMainForm.AfficheFenetres;
begin
  Self.ItemAfficher.Visible := True;

  if MainForm.ItemParametrage.Checked then
    Param.Show;
  if MainForm.itemPositionGeographique.Checked then
    PositionForm.Show;
  if MainForm.itemCouleursetEpaisseurs.Checked then
    CouleursDlg.Show;
  if MainForm.itemVueen3dimentions.Checked then
    FormCadsol3D.Show;
  if MainForm.itemOmbredustyle.Checked then
    HeureDlg.Show;
end;

procedure TMainForm.AfficheComment;
var
  Buf: Tampon;
  i: integer;
  s: string;
begin
  ActiveCad := TFormCadsol(MDIChildren[0]);
  if ActiveCad <> Nil then
    with ActiveCad.cadran do
    begin
      strLCopy(Buf, Commentaire, sizeOf(Buf));
      for i := 0 to StrLen(Buf) do
        if Buf[i] in [#13, #10] then
          Buf[i] := ' ';
      MainForm.CommentPanel.Caption := strPas(Buf);
      s := FloattostrF(abs(Lati), ffGeneral, 3, 0) + '°';
      if Lati >= 0 then
        s := s + 'N'
      else
        s := s + 'S';
      MainForm.LatiPanel.Caption := s;
      s := FloattostrF(abs(Longi), ffGeneral, 3, 0) + '°';
      if Longi >= 0 then
        s := s + 'W'
      else
        s := s + 'E';
      MainForm.LongiPanel.Caption := s;
    end
  else
  begin
    MainForm.CommentPanel.Caption := '';
    MainForm.LatiPanel.Caption := '';
    MainForm.LongiPanel.Caption := '';
    // MainForm.TimeText.Caption := '';

  end;
  //FormCadsol3D.Refresh;
  Param.Refresh;
  PositionForm.Refresh;
  CouleursDlg.Refresh;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  Name: String;
begin
  application.OnHint := ShowHint;
  application.ShowHint := True;
  application.HintColor := clAqua;
  application.HintPause := 100;
  Screen.OnActiveFormChange := UpdateMenuItems;

  Caption := application.title;
  FillChar(UserPol, sizeOf(UserPol), #0);
  GetObject(MainForm.Font.handle, sizeOf(TlogFont), @UserPol);
  UserPol.LfHeight := UserPol.LfHeight * 10;
  HUserPol := CreateFontIndirect(UserPol);
  GetObject(HUserPol, sizeOf(TlogFont), @CoordPol);
  CoordPol.LfHeight := 30;
  HCoordPol := CreateFontIndirect(CoordPol);
  Debut := True;
  Chdir(extractFileDir(paramStr(0)));

  Name := 'Menu';
  Ini := TIniFile.Create(ChangeFileExt(application.ExeName, '.INI'));
  try
    Self.ItemParametrage.Checked :=
      Ini.ReadBool(Name, 'Parametrage_Checked', False);
    Self.itemPositionGeographique.Checked :=
      Ini.ReadBool(Name, 'POsitionGeo_Checked', False);
    Self.itemCouleursetEpaisseurs.Checked :=
      Ini.ReadBool(Name, 'Couleursetpaisseurs_Checked', False);
    Self.itemOmbredustyle.Checked :=
      Ini.ReadBool(Name, 'HeureduCadran_Checked', False);
    Self.itemVueen3dimentions.Checked :=
      Ini.ReadBool(Name, 'Vue3D_Checked', False);
    Style := Ini.ReadString(Name, 'Style', 'Windows');
    TStyleManager.TrySetStyle(Style);
  finally
    Ini.Free;
  end;

end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusLine.Caption := application.Hint;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
begin
  { create a new MDI child window }

  ActiveCad := TFormCadsol.Create(application);
  ActiveCad.Caption := Name;
  ActiveCad.cadran.Nomfichier := Name;
end;

procedure TMainForm.FileNewItemClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].Close;
  ActiveCad := TFormCadsol.Create(application);
  InitCadran(ActiveCad.cadran);
  //VoirCadranMultiple := False;
  // Mainform.Tile;
  // Mainform.Tile;
  ActiveCad.Caption := 'Nouveau Cadran';
  VisuCadMultipleForm.Visible := False;
end;

procedure TMainForm.FileCloseItemClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].WindowState := wsnormal;
  if ActiveMDIChild <> nil then
  begin
    ActiveMDIChild.WindowState := wsnormal;
    ActiveMDIChild.Close;
  end;
  AfficheComment;
end;

procedure TMainForm.FileSaveAsItemClick(Sender: TObject);
var
  Ext, FirstLine: String;
begin
  FirstLine := 'Ecrasement du fichier existant?';
  if VisuCadMultipleForm.Visible then
  begin
    SaveDialog.FileName := ExtractFileName(VisuCadMultipleForm.Caption);
    SaveDialog.FileName:=ChangeFileExt(SaveDialog.FileName, '.cadm');
    SaveDialog.FileTypes.Clear;
    with SaveDialog.FileTypes.Add do
    begin
      DisplayName := 'cadran multiple';
      FileMask := '*.cadm';
    end;
    if SaveDialog.Execute then
    begin
      if FileExists(SaveDialog.FileName) then
        if application.messagebox(strPcopy(Buff, FirstLine),
          strPcopy(Buf, SaveDialog.FileName), mb_yesno or mb_iconquestion) = Id_NO
        then
          exit;
      SaveDialog.FileName:=ChangeFileExt(SaveDialog.FileName, '.cadm');
      CadranMultiple.NomFichier:=SaveDialog.FileName;
      EcrireCadranSolMultiple(cadranMultiple, SaveDialog.FileName);
      VisuCadMultipleForm.Caption := SaveDialog.FileName;
    end;
  end
  else
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    SaveDialog.FileName := ExtractFileName(ActiveCad.Caption);
    ChangeFileExt(SaveDialog.FileName, '.cads');
    SaveDialog.FileTypes.Clear;
    with SaveDialog.FileTypes.Add do
    begin
      DisplayName := 'cadran simple';
      FileMask := '*.cads';
    end;
    if SaveDialog.Execute then
    begin
      if FileExists(SaveDialog.FileName) then
        if application.messagebox(strPcopy(Buff, FirstLine),
          strPcopy(Buf, SaveDialog.FileName), mb_yesno or mb_iconquestion) = Id_NO
        then
          exit;

      SaveDialog.FileName:=ChangeFileExt(SaveDialog.FileName, '.cads');
      EcrireCadranSol(ActiveCad.cadran, SaveDialog.FileName);
      ActiveCad.Cadran.NomFichier:=SaveDialog.FileName;
      ActiveCad.Caption := SaveDialog.FileName;
    end;
  end;
end;

procedure TMainForm.FileSaveItemClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    EcrireCadranSol(ActiveCad.cadran, ActiveCad.cadran.Nomfichier);
    ActiveCad.cadran.Modif := False;
  end;
end;

procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.WindowMinimizeItemClick(Sender: TObject);
var
  i: integer;
begin
  { Must be done backwards through the MDIChildren array }
  for i := MDIChildCount - 1 downto 0 do
    MDIChildren[i].WindowState := wsMinimized;
end;

procedure TMainForm.Toutrtablir1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].WindowState := wsnormal;
end;

procedure TMainForm.UpdateMenuItems(Sender: TObject);
begin
  // FileCloseItem.Enabled := MDIChildCount > 0;
  FileSaveItem.Enabled := MDIChildCount > 0;
  FileSaveAsItem.Enabled := MDIChildCount > 0;
  SaveBtn.Enabled := MDIChildCount > 0;
  CopyBtn.Enabled := MDIChildCount > 0;
  FontBtn.Enabled := MDIChildCount > 0;
  PrintButton.Enabled := MDIChildCount > 0;
  WindowCascadeItem.Enabled := MDIChildCount > 0;
  WindowTileItem.Enabled := MDIChildCount > 0;
  WindowArrangeItem.Enabled := MDIChildCount > 0;
  WindowMinimizeItem.Enabled := MDIChildCount > 0;
  Toutrtablir1.Enabled := MDIChildCount > 0;
  ImprimerCadranTtem.Enabled := MDIChildCount > 0;
  CommentPanel.Enabled := MDIChildCount > 0;
  LatiPanel.Enabled := MDIChildCount > 0;
  LongiPanel.Enabled := MDIChildCount > 0;
  Enregistrertouslescadrans1.Enabled := MDIChildCount > 1;
  // Toutfermer1.Enabled := MDIChildCount > 0;
  // ToutFermer2.Enabled := MDIChildCount > 0;

  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    ActiveCad.FormActivate(Sender);
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainForm.HelpAboutItemClick(Sender: TObject);
begin
  FormApropos.ShowModal;
end;

procedure TMainForm.AfficheHeure;

begin
  If (ActiveMDIChild <> nil) and MainForm.itemOmbredustyle.Checked then
  begin
    TFormCadsol(ActiveMDIChild).Refresh;
    // FormCadsol3D.Refresh;
    if TFormCadsol(ActiveMDIChild).Zoom1.Checked then
      ZoomForm.Refresh;
  end;

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  HeureCadran := HeureCadran + Timer1.Interval / 1000 / 3600 / 24;
  AfficheHeure;

end;

procedure TMainForm.FontBtnClick(Sender: TObject);
begin
  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    UserPol := ActiveCad.cadran.Pol;
    HUserPol := CreateFontIndirect(UserPol);
    FontDialog.Font.handle := HUserPol;
    FontDialog.Font.Color := ActiveCad.cadran.couleur;
    FontDialog.Font.Name := TFontName(ActiveCad.cadran.Pol.lfFaceName);
    FontDialog.Font.size := FontDialog.Font.size div 10;
    FontDialog.Execute;
    FontDialog.Font.size := FontDialog.Font.size * 10;
    HUserPol := FontDialog.Font.handle;
    GetObject(HUserPol, sizeOf(TlogFont), @ActiveCad.cadran.Pol);
    ActiveCad.cadran.couleur := FontDialog.Font.Color;
    ActiveCad.cadran.Modif := True;
    UserPol := ActiveCad.cadran.Pol;
    ActiveCad.Refresh;
  end;
end;

procedure TMainForm.Configurerlimprimante1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    if ActiveCad.cadran.Numpage then
      ActiveCad.Refresh;
  end;
end;

procedure TMainForm.PrintButtonClick(Sender: TObject);

begin

  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    with ActiveCad do
      SortieImprimante(cadran, ActiveCad.canvas);
  end;
end;

procedure TMainForm.BarredOutils1Click(Sender: TObject);
begin
  with BarredOutils1 do
  begin
    Checked := Not Checked;
    SpeedPanel.Visible := Checked;
  end;
end;

procedure TMainForm.Barredetat1Click(Sender: TObject);
begin
  with Barredetat1 do
  begin
    Checked := Not Checked;
    CommentLine.Visible := Checked;
  end;
end;

Procedure TMainForm.DimEtOrientationCadranCubique;
var    l,h,p:integer;
      icl,dcl:Real;
begin
 //Dimensions et Inclinaisons
  With CadranMultiple do begin
     L:=Largeur;H:=Hauteur;P:=Profondeur;
     icl:=Incli;dcl:=Decli;
  end;
  With FCadSud.Cadran do begin
     Largeur:=L;Hauteur:=H;Profondeur:=P;
     Incli:=90;
     Decli:=dcl;
     end;
  With FCadNord.Cadran do begin
     Largeur:=L;Hauteur:=H;Profondeur:=P;
     Incli:=90;
     Decli:=-dcl+180;
     if Decli>180 then Decli:=Decli-360
     end;
  With FCadEst.Cadran do begin
     Largeur:=P;Hauteur:=H;Profondeur:=L;
     Incli:=90;
     Decli:=dcl+90;
     if Decli>180 then Decli:=Decli-360
     end;
  With FCadOuest.Cadran do begin
     Largeur:=P;Hauteur:=H;Profondeur:=L;
     Incli:=90;
     Decli:=dcl-90;
     if Decli<-180 then Decli:=Decli+360
     end;
  With FCadInf.Cadran do begin
     Largeur:=L;Hauteur:=P;Profondeur:=H;
     Incli:=180;
     Decli:=dcl;
     end;
  With FCadSup.Cadran do begin
     Largeur:=L;Hauteur:=P;Profondeur:=H;
     Incli:=0;
     Decli:=dcl;
     end;
end;

procedure TMainForm.ItemCubique1Click(Sender: TObject);
 var i:integer;

begin
  for i := 0 to MDIChildCount - 1 do
    TformCadsol(MDIChildren[i]).Close;
  VisuCadMultipleForm.Hide;
  InitCadran(CadranMultiple);
  With CadranMultiple do begin
     Typ:=Cubique;
     Largeur:=6000;Hauteur:=4000;Profondeur:=7000;
     Incli:=90;Decli:=0;
  end;

  //Creation Faces
  FCadSud := TFormCadsol.Create(application);
  FCadSud.Caption:= ChTcad[TCadSud];
  FCadEst := TFormCadsol.Create(application);
  FCadEst.Caption:= ChTcad[TCadEst];
  FCadNord := TFormCadsol.Create(application);
  FCadNord.Caption:= ChTcad[TCadNord];
  FCadOuest := TFormCadsol.Create(application);
  FCadOuest.Caption:= ChTcad[TCadOuest];
  FCadSup := TFormCadsol.Create(application);
  FCadSup.Caption:= ChTcad[TCadSup];
  FCadInf := TFormCadsol.Create(application);
  FCadInf.Caption:= ChTCad[TCadInf];

  DimEtOrientationCadranCubique;
  //Init Style
  for i := 0 to MDIChildCount - 1 do
    with TformCadsol(MDIChildren[i]).Cadran do begin
      Hstyle := Hauteur div 10;gx:=0;gy:=Hauteur div 5;
    end;

  Tile;
  AfficheFenetres;




end;


procedure TMainForm.NouveauCadranmultipleClick(Sender: TObject);
Var
  i, j: integer;
  R, C: Trect;
  l, h: integer;
begin

  for i := 0 to MDIChildCount - 1 do
    TformCadsol(MDIChildren[i]).Close;
  VisuCadMultipleForm.Hide;
  InitCadran(CadranMultiple);
  CadranMultiple.Typ:=Multiple;
  if CadranMultipleForm.ShowModal = mrCancel then
    exit;
  With CadranMultiple, CadranMultipleForm do
  begin
    Marge := SpinEditMarge.Value * 10;
    nbCadLargeur := nbCadLargeurEdit.Value;
    nbCadHauteur := nbCadHauteurEdit.Value;
    LargeurTot := LargeurTotEdit.Value * 10;
    HauteurTot := HauteurTotEdit.Value * 10;
    Largeur := LargeurTot div nbCadLargeur; // div nbCadlargeur;
    Hauteur := HauteurTot div nbCadHauteur; // div nbCadHauteur;
    Typ := multiple;
  end;

  for i := 1 to CadranMultiple.nbCadLargeur do
    for j := 1 to CadranMultiple.nbCadHauteur do
    begin
      ActiveCad := TFormCadsol.Create(application);
      InitCadran(ActiveCad.cadran);
      ActiveCad.Caption := 'Cadran L' + IntToStr(j) + ' - C' + IntToStr(i);
      ActiveCad.cadran.Largeur := CadranMultiple.Largeur;
      ActiveCad.cadran.Hauteur := CadranMultiple.Hauteur;
      ActiveCad.cadran.Marge := CadranMultiple.Marge;
      ActiveCad.cadran.Ligne := j;
      ActiveCad.cadran.Colonne := i;
      ActiveCad.cadran.hStyle := CadranMultiple.Hauteur * 10 div 100;
      ActiveCad.cadran.gx := 0;
      ActiveCad.cadran.gy := CadranMultiple.Hauteur * 10 div 50;
      ActiveCad.cadran.Nomfichier := ActiveCad.Caption;
    end;
  //VisuCadMultipleForm.cadran := CadranMultiple;
  Cascade;
  VisuCadMultipleForm.WindowState := wsnormal;
  VisuCadMultipleForm.Show;
  VisuCadMultipleForm.Repaint;

  AfficheFenetres;

end;

procedure TMainForm.NouveauCadransimpleClick(Sender: TObject);
Var
  i: integer;

begin

  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].Close;

  ActiveCad := TFormCadsol.Create(application);
  InitCadran(ActiveCad.cadran);
  ActiveCad.Caption := 'Cadran simple';
  VisuCadMultipleForm.Hide;
  CadranMultiple.Typ:=vide;
  //VoirCadranMultiple := False;

  AfficheFenetres;

  // if Sender = Cadranmultiple1 then
  // begin
  // if CadranMultipleForm.ShowModal=mrCancel then Exit;
  // VoirCadranMultiple := True;
  // With CadranMultiple, CadranMultipleForm do
  // begin
  // Marge := SpinEditMarge.Value * 10;
  // nbCadLargeur := nbCadLargeurEdit.Value;
  // nbCadHauteur := nbCadHauteurEdit.Value;
  // LargeurTot := LargeurTotEdit.Value * 10;
  // HauteurTot := HauteurTotEdit.Value * 10;
  // Largeur := LargeurTot div nbCadLargeur; // div nbCadlargeur;
  // Hauteur := HauteurTot div nbCadHauteur; // div nbCadHauteur;
  // Typ := Multiple;
  // end;
  // end
  // else
  // With CadranMultiple do
  // begin
  // nbCadLargeur := 1;
  // nbCadHauteur := 1;
  // LargeurTot := Largeur;
  // HauteurTot := Hauteur;
  // Typ := Vertical;
  // end;
  // for i := 1 to CadranMultiple.nbCadLargeur do
  // for j := 1 to CadranMultiple.nbCadHauteur do
  // begin
  // ActiveCad := TFormCadsol.Create(application);
  // InitCadran(ActiveCad.cadran);
  // ActiveCad.Caption := 'Cadran L' + IntToStr(j) + ' - C' + IntToStr(i);
  // ActiveCad.cadran.Largeur := CadranMultiple.Largeur;
  // ActiveCad.cadran.Hauteur := CadranMultiple.Hauteur;
  // ActiveCad.cadran.Marge := CadranMultiple.Marge;
  // ActiveCad.cadran.Ligne := j;
  // ActiveCad.cadran.Colonne := i;
  // ActiveCad.cadran.hStyle := CadranMultiple.Hauteur * 10 div 100;
  // ActiveCad.cadran.gx := 0;
  // ActiveCad.cadran.gy := CadranMultiple.Hauteur * 10 div 50;
  // end;
  //
  // if Sender = Cadranmultiple1 then
  // begin
  // Cascade;
  // VisuCadMultipleForm.WindowState:=WSNormal;
  // VisuCadMultipleForm.Show;
  // VisuCadMultipleForm.Repaint;
  // end
  // else begin
  // ActiveCad.Caption := 'nouveau Cadran';
  // VisuCadMultipleForm.Hide;
  // VoirCadranMultiple := False;
  // end;
  // ItemAfficher.Visible := True;
  // if MainForm.ItemParametrage.Checked then
  // Param.Show;
  // if MainForm.itemPositionGeographique.Checked then
  // PositionForm.Show;
  // if MainForm.itemCouleursetEpaisseurs.Checked then
  // CouleursDlg.Show;
  // if MainForm.itemVueen3dimentions.Checked then
  // FormCadsol3D.Show;
  // if MainForm.itemOmbredustyle.Checked then
  // HeureDlg.Show;

end;

procedure TMainForm.CommentPanelDblClick(Sender: TObject);
begin
  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    with ActiveCad do
      Commemtaires1Click(Sender);;
  end;
end;

procedure TMainForm.CopyBtnClick(Sender: TObject);
begin
  if ActiveMDIChild <> Nil then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    with ActiveCad do
      Copier1Click(Sender);
  end;
end;

procedure TMainForm.PerformFileOpen(const AFileName: string);
begin
  CreateMDIChild(AFileName);
  ActiveCad := TFormCadsol(ActiveMDIChild);
  if not LireCadran(ActiveCad.cadran, AFileName) then
    ActiveCad.Caption := 'SansNom' + IntToStr(MDIChildCount);
  AfficheComment;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // FileNewItemClick(Sender);

  DragAcceptFiles(handle, True);
  { Check if we should load a file from the command line }
  if (ParamCount > 0) and FileExists(paramStr(1)) then
    PerformFileOpen(paramStr(1));
end;

procedure TMainForm.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array [0 .. MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      PerformFileOpen(strPas(CFileName));
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  inherited;
//If self.MDIChildCount=0 then self.FileNewItemClick(Sender);
//AfficheFenetres;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
  Name: String;
begin
  // Toutfermer1Click(Sender);
  Name := 'Menu';
  Ini := TIniFile.Create(ChangeFileExt(application.ExeName, '.INI'));
  try
    Ini.WriteBool(Name, 'Parametrage_Checked', Self.ItemParametrage.Checked);
    Ini.WriteBool(Name, 'POsitionGeo_Checked',
      Self.itemPositionGeographique.Checked);
    Ini.WriteBool(Name, 'Couleursetpaisseurs_Checked',
      Self.itemCouleursetEpaisseurs.Checked);
    Ini.WriteBool(Name, 'HeureduCadran_Checked', Self.itemOmbredustyle.Checked);
    Ini.WriteBool(Name, 'Vue3D_Checked', Self.itemVueen3dimentions.Checked);
    Ini.WriteString(Name, 'Style', TStyleManager.ActiveStyle.Name);
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
  s: string;
begin
  // for i := 0 to MDIChildCount - 1 do
  // TFormCadsol(MDIChildren[i]).Close;
  s := 'Abandon de l''application?';
  if application.messagebox(strPcopy(Buff, s), strPcopy(Buf, application.title),
    mb_yesno + mb_iconquestion) = IDYES then
  begin
    Toutfermer1Click(Sender);
    CanClose := True;
  end
  else
    CanClose := False;
end;

procedure TMainForm.Toutfermer1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    TFormCadsol(MDIChildren[i]).Close;
  if VisuCadMultipleForm <> nil then
    VisuCadMultipleForm.Close;
  // FileNewItemClick(Sender);
  AfficheComment;
end;

procedure TMainForm.Index1Click(Sender: TObject);
var
  s, nf: string;
begin
  // if pos('*',Application.title)<>0 then begin Mainform.stop;exit end;
  // Application.HelpCommand(HELP_INDEX, 0);(*winhelp*)
  // s:='explorer.exe '+extractFileDir(paramStr(0))+'.\aide\index.html';
  // MessageDlg(s, mtInformation,[mbOk], 0);
  // MessageBox(0,strPcopy(buf,s),'',0);
  setcurrentdir(extractFileDir(paramStr(0)));
  nf := 'documentationV5.htm';
  s := 'explorer.exe ' + nf;
  // if Executer(s,SW_SHOWMAXIMIZED)<32 then
  // MessageDlg('Fichier '+nf+' non visualisable!' , mtWarning,[mbOk], 0);
  ShellExecute(GetDesktopWindow(), 'open', PChar(nf), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.itemCouleursetEpaisseursClick(Sender: TObject);
begin
  inherited;
  if itemCouleursetEpaisseurs.Checked then
    CouleursDlg.Show
  else
    CouleursDlg.Close;
end;



procedure TMainForm.itemOmbredustyleClick(Sender: TObject);
begin
  inherited;
  if itemOmbredustyle.Checked then
    HeureDlg.Show
  else
    HeureDlg.Close;
end;

procedure TMainForm.OuvrirCadranSimpleClick(Sender: TObject);
begin
  if ActiveMDIChild = nil then
    NouveauCadransimpleClick(Sender);
 // OpenDialog1.FileTypes.Clear;
  // OpenDialog1.InitialDir := GetCurrentDir;
 (* with OpenDialog1.FileTypes.Add do

  begin
    DisplayName := 'cadran simple';
    FileMask := '*.cads';
  end;   *)

  if OpenDialog1.Execute then
  begin
    ActiveCad := TFormCadsol(ActiveMDIChild);
    If LireCadran(ActiveCad.cadran, OpenDialog1.FileName) then
    begin
      ActiveCad.Caption := 'Cadran: ' + OpenDialog1.FileName;
      ActiveCad.cadran.Nomfichier := OpenDialog1.FileName;
      ActiveCad.Refresh;
      AfficheComment;
    end;
  end;
  if ActiveMDIChild <> nil then
    ActiveMDIChild.Refresh;
  AfficheFenetres;
end;

procedure TMainForm.OuvrirCadranMultipleClick(Sender: TObject);
Var
  i, j, l, C: integer;
  f_Cad: File of TCadran;
  ActiveCad: TFormCadsol;
begin

  ItemToutFermerClick(Sender) ;
  OpenDialog1.FileName:='';
  OpenDialog1.Execute;

  if ExtractFileExt(OpenDialog1.FileName) = '.cadm' then
  begin
    InitCadran(CadranMultiple);
    VisuCadMultipleForm.WindowState := wsnormal;
    FileMode := fmOpenRead;
    assignFile(f_Cad, OpenDialog1.FileName);
    Reset(f_Cad);
    Read(f_Cad, CadranMultiple);
    CadranMultiple.Modif:=False;
    CadranMultiple.NomFichier:=ExtractFileName(OpenDialog1.FileName);
    for i := 1 to CadranMultiple.nbCadHauteur do
      for j := 1 to CadranMultiple.nbCadLargeur do
      begin
        ActiveCad := TFormCadsol.Create(application);
        Read(f_Cad, ActiveCad.cadran);
        l := ActiveCad.cadran.Ligne;
        C := ActiveCad.cadran.Colonne;
        ActiveCad.Caption := 'Cadran L' + IntToStr(l) + ' - C' + IntToStr(C)+'.cads';
        ActiveCad.cadran.Nomfichier := ActiveCad.Caption;
      end;
    CloseFile(f_Cad);
    Cascade;
    VisuCadMultipleForm.Caption := OpenDialog1.FileName;
    VisuCadMultipleForm.Show;
   // VisuCadMultipleForm.Repaint;
  end;

  if ExtractFileExt(OpenDialog1.FileName) = '.cads' then
  begin
    ActiveCad := TFormCadsol.Create(application);
    If LireCadran(ActiveCad.cadran, OpenDialog1.FileName) then
    begin
      ActiveCad.Caption := 'Cadran: ' + OpenDialog1.FileName;
      ActiveCad.cadran.Nomfichier := ExtractFileName(OpenDialog1.FileName);
      ActiveCad.Repaint;
    end;
  end;

  ItemAfficher.Visible := True;
  AfficheFenetres;
  AfficheComment;

end;

procedure TMainForm.ItemParametrageClick(Sender: TObject);
begin
  inherited;
  if ItemParametrage.Checked then
    Param.Show
  else
    Param.Close;
end;

procedure TMainForm.itemPositionGeographiqueClick(Sender: TObject);
begin
  inherited;
  if itemPositionGeographique.Checked then
    PositionForm.Show
  else
    PositionForm.Close;
end;

procedure TMainForm.ItemStyleClick(Sender: TObject);
var
  Ini: TIniFile;
  Name: String;
begin
  Name := 'Menu';
  Ini := TIniFile.Create(ChangeFileExt(application.ExeName, '.INI'));

  Ini.WriteBool(Name, 'Parametrage_Checked', Self.ItemParametrage.Checked);
  Ini.WriteBool(Name, 'POsitionGeo_Checked',
    Self.itemPositionGeographique.Checked);
  Ini.WriteBool(Name, 'Couleursetpaisseurs_Checked',
    Self.itemCouleursetEpaisseurs.Checked);
  Ini.WriteBool(Name, 'HeureduCadran_Checked', Self.itemOmbredustyle.Checked);
  Ini.WriteBool(Name, 'Vue3D_Checked', Self.itemVueen3dimentions.Checked);

  FStyle.ShowModal;

  Self.ItemParametrage.Checked :=
    Ini.ReadBool(Name, 'Parametrage_Checked', False);
  Self.itemPositionGeographique.Checked :=
    Ini.ReadBool(Name, 'POsitionGeo_Checked', False);
  Self.itemCouleursetEpaisseurs.Checked :=
    Ini.ReadBool(Name, 'Couleursetpaisseurs_Checked', False);
  Self.itemOmbredustyle.Checked :=
    Ini.ReadBool(Name, 'HeureduCadran_Checked', False);
  Self.itemVueen3dimentions.Checked :=
    Ini.ReadBool(Name, 'Vue3D_Checked', False);
  Style := Ini.ReadString(Name, 'Style', 'Windows');

end;

procedure TMainForm.ItemToutFermerClick(Sender: TObject);
var
  i: integer;
begin
  ItemAfficher.Visible := False;
  for i := 0 to MainForm.MDIChildCount - 1 do
    TFormCadsol(MainForm.MDIChildren[i]).close;
  
  CouleursDlg.Close;
  if VisuCadMultipleForm <> nil then
    VisuCadMultipleForm.Hide;
  HeureDlg.Close;
  ZoomForm.Close;
  Param.Close;
  FormCadsol3D.Close;
  PositionForm.Close;
end;

procedure TMainForm.itemVueen3dimentionsClick(Sender: TObject);
begin
  inherited;
  if itemVueen3dimentions.Checked then
    FormCadsol3D.show else FormCadsol3D.Close;
end;

procedure TMainForm.Lisezmoi1Click(Sender: TObject);
var
  s, nf: string;
begin
  setcurrentdir(extractFileDir(paramStr(0)));
  nf := 'lisezmoi.txt';
  if not FileExists(nf) then
  begin
    MessageDlg('Fichier ' + nf + ' absent!', mtWarning, [mbOk], 0);
    exit;
  end;
  s := 'notepad.exe ' + nf;
  if Executer(s, SW_SHOW) < 32 then
  begin
    s := 'explorer.exe ' + nf;
    if Executer(s, SW_SHOW) < 32 then
      MessageDlg('Fichier ' + nf + ' non visualisable!', mtWarning, [mbOk], 0);
  end;
end;

procedure TMainForm.Assistant1Click(Sender: TObject);
var
  i: integer;
  s1, s2: PChar;
label Debut, fin, typecad, Param, geo, comment, photo, couleur, pp,
  fichiercoord, police, imprime, ficherecap, sauver;

begin
  s1 := 'Voulez vous être assisté dans la création d''un Cadran Solaire?';
  s2 := 'Assistant de Création';
Debut:
  with application do
    if messagebox(s1, s2, mb_iconquestion + mb_yesno) = IDYES then
    begin
      (* for i := MDIChildCount - 1 downto 0 do
        MDIChildren[i].Close;
        FileNewItemClick(Sender); *)

    typecad:
      AssistForm.texte.Caption :=
        'Vous devez commencer par préciser le type de Cadran';
      case AssistForm.ShowModal of
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Type1Click(Sender);
        100:
          goto geo;
        -100:
          goto Debut;
      end;

    geo:
      AssistForm.texte.Caption :=
        'Il faut ensuite fixer la position géographique du cadran:'#13#10 +
        ' Latitude et, de plus, si le cadran doit donner l''heure légale:'#13#10
        + ' Longitude, et decalage horaire par rapport à l''heure du méridien de Greenwitch';
      case AssistForm.ShowModal of
        mrAbort:
          exit;
        mrOk:
          begin
            PositionForm.Close;
            PositionForm.BorderStyle := bsDialog;
            PositionForm.ShowModal; // (ActiveMDIChild).Latitude1Click(Sender);
            PositionForm.BorderStyle := bssizeable;
            PositionForm.Show;
          end;
        100:
          goto Param;
        -100:
          goto typecad;
      end;

    Param:
      AssistForm.texte.Caption := 'Vous devez paramètrer le cadran: ' +
        'Choix des dimensions, des lignes horaires, de la devise...'#13#10 +
        'Et suivant le type du cadran:' +
        ' position et longueur du style, orientation, arcs diurnes...';
      case AssistForm.ShowModal of
        - 100:
          goto geo;
        100:
          goto comment;
        mrAbort:
          exit;
        mrOk:
          Parametre.Param.Show;
        // TFormCadsol(ActiveMDIChild).Paramtrage1Click(Sender);
      end;

    comment:
      AssistForm.texte.Caption :=
        'Vous pouvez ensuite noter quelques commentaires ' +
        'personnels sur votre cadran.';
      case AssistForm.ShowModal of
        - 100:
          goto Param;
        100:
          goto photo;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Commemtaires1Click(Sender);
      end;

    photo:
      AssistForm.texte.Caption :=
        'Si vous avez une photo numériseé (format  bmp ou jpg)'#13#10 +
        'Vous pouvez la joindre au cadran.';
      case AssistForm.ShowModal of
        - 100:
          goto comment;
        100:
          goto couleur;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Photo1Click(Sender);
      end;

    couleur:
      AssistForm.texte.Caption :=
        'La couleur et l''épaisseur des traits (au 1/10 de mm)' +
        ' peuvent être choisis par l''utilisateur.';
      case AssistForm.ShowModal of
        - 100:
          goto photo;
        100:
          goto police;
        mrAbort:
          exit;
        mrOk:
          CouleursDlg.Show;
        // TFormCadsol(ActiveMDIChild).Couleurs1Click(Sender);
      end;

    police:
      AssistForm.texte.Caption := 'Vous pouvez choisir la police' +
        ' de caractères utilisée pour tracer le cadran.';
      case AssistForm.ShowModal of
        - 100:
          goto couleur;
        100:
          goto pp;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Police1Click(Sender);
      end;

    pp:
      AssistForm.texte.Caption := 'Il est possible de choisir un papier peint '
        + 'comme fond de cadran (fichier au format bmp ou jpg)';
      case AssistForm.ShowModal of
        - 100:
          goto police;
        100:
          goto sauver;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Papierpeint1Click(Sender);
      end;

    sauver:
      AssistForm.texte.Caption :=
        'Votre cadran est terminé, il est recommandé de l''enregistrer ' +
        'dans un fichier, sous un nom de votre choix.';
      case AssistForm.ShowModal of
        - 100:
          goto pp;
        100:
          goto imprime;
        mrAbort:
          exit;
        mrOk:
          FileSaveAsItemClick(Sender);
      end;

    imprime:
      AssistForm.texte.Caption :=
        'Vous pouvez imprimer tout ou partie de votre cadran, ' +
        'à l''echelle 1:1';
      case AssistForm.ShowModal of
        - 100:
          goto sauver;
        100:
          goto ficherecap;
        mrAbort:
          exit;
        mrOk:
          PrintButtonClick(Sender);
      end;

    ficherecap:
      AssistForm.texte.Caption := 'Vous pouvez également afficher et imprimer '
        + 'un fiche récapitulative de votre cadran, ' +
        'avec un dessin en réduction.';
      case AssistForm.ShowModal of
        - 100:
          goto imprime;
        100:
          goto fichiercoord;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Resume1Click(Sender);
      end;

    fichiercoord:
      AssistForm.texte.Caption := 'Au lieu d''imprimer le cadran, vous pouvez '
        + 'écrire les coordonnées des points de tracé ' +
        'dans un fichier texte.';
      case AssistForm.ShowModal of
        - 100:
          goto ficherecap;
        100:
          goto fin;
        mrAbort:
          exit;
        mrOk:
          TFormCadsol(ActiveMDIChild).Coordonnes2Click(Sender);
      end;

    fin:
      if messagebox
        ('Nous espèrons que ce logiciel vous donne satisfaction'#13#10 +
        'si vous avez des remarques diverses, n''hésitez pas '#13#10 +
        'à nous en faire part.', 'Assistant de Création',
        mb_iconinformation + mb_OKCancel) = idcancel then
        exit;
      HelpAboutItemClick(Sender);
    end;
end;

procedure TMainForm.SiteinternetCadSol1Click(Sender: TObject);
begin
  WinExec('explorer.exe HTTP://Cadsol.fr',1);
end;

{ s:='explorer.exe http://www.cadsol.fr';
  if Executer(s,SW_SHOWMAXIMIZED)<32 then
  MessageDlg('Connection impossible' , mtWarning,[mbOk], 0);
  end; }
begin
  InitCadran(CadranMultiple);

end.
