unit CadTrace3D;

interface

uses
Winapi.Windows,
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Messages, Variants, Graphics,uFormAJL,
  Dialogs, GLWin32Viewer, GLCadencer,
  GLObjects, GLGeomObjects, GLScene, GLSpaceText, GLTexture,
  GLzBuffer, GLMaterial, GLCoordinates, GLCrossPlatform,
  GLBaseClasses, GLApplicationFileIO, GLFPSMovement, GLTerrainRenderer, GLSkyBox,
  GLSimpleNavigation, Vcl.Menus, GLBitmapFont,
  GLVectorGeometry,
  GLVectorTypes,
  GLColor, FnpNumericEdit, GLSkydome, GLFireFX;


type
  TFormCadsol3D = class(TFormAJL)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLDummyCube: TGLDummyCube;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    GLSpaceText_Ouest: TGLSpaceText;
    GLSpaceText_Est: TGLSpaceText;
    GLSpaceText_Sud: TGLSpaceText;
    GLSpaceText_Nord: TGLSpaceText;
    GLSpaceTextZenith: TGLSpaceText;
    GLSpaceTextNadir: TGLSpaceText;
    GLDummyCube2: TGLDummyCube;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCylinder1: TGLCylinder;
    GLCube1: TGLCube;
    GLSimpleNavigation1: TGLSimpleNavigation;
    MainMenu1: TMainMenu;
    Axes3DItemMenu: TMenuItem;
    VoirItemMenu: TMenuItem;
    EONSZNitem: TMenuItem;
    ItemLecadranmultiple: TMenuItem;
    ItemLecadrancubique: TMenuItem;
    ItemLecadranactif: TMenuItem;
    Panel1: TPanel;
    DecliEdit: TFnpNumericEdit;
    DecliTrackBar: TTrackBar;
    LbDecli: TStaticText;
    RadBtnEst: TRadioButton;
    RadBtnOuest: TRadioButton;
    BitBtnAppliquer: TBitBtn;
    BitBtn90: TBitBtn;
    BitBtn0: TBitBtn;
    BitBtn180: TBitBtn;
    RadioGroupDecli: TRadioGroup;
    GLArrowLineAxeTerre: TGLArrowLine;
    ItemAxederotationterrestre: TMenuItem;
    StaticTextFaceSud: TStaticText;
    EquatorialBtn: TButton;
    BitBtnIncli180: TBitBtn;
    BitBtnIncli90: TBitBtn;
    BitBtnIncli0: TBitBtn;
    IncliTrackBar: TTrackBar;
    IncliEdit: TFnpNumericEdit;
    LbIncli: TStaticText;
    ButtonMoinsIncli: TButton;
    BitBtnRot180: TBitBtn;
    BitBtnRot90: TBitBtn;
    BitBtnRot0: TBitBtn;
    RotTrackBar: TTrackBar;
    RotEdit: TFnpNumericEdit;
    ButtonMoinsRot: TButton;
    RotLabel: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Axes3DItemMenuClick(Sender: TObject);
    procedure EONSZNitemClick(Sender: TObject);
   // procedure CadranMultiple1Click(Sender: TObject);
    procedure Cadransimple1Click(Sender: TObject);
    procedure ItemLecadranmultipleClick(Sender: TObject);
    procedure ItemLecadrancubiqueClick(Sender: TObject);
    procedure DecliTrackBarChange(Sender: TObject);
    procedure BitBtnAppliquerClick(Sender: TObject);
    procedure IncliTrackBarChange(Sender: TObject);
    procedure BitBtn180Click(Sender: TObject);
    procedure BitBtn0Click(Sender: TObject);
    procedure BitBtn90Click(Sender: TObject);
    procedure BitBtnIncli0Click(Sender: TObject);
    procedure BitBtnIncli90Click(Sender: TObject);
    procedure BitBtnIncli180Click(Sender: TObject);
    procedure EquatorialBtnClick(Sender: TObject);
    procedure ItemAxederotationterrestreClick(Sender: TObject);
    procedure ButtonMoinsIncliClick(Sender: TObject);
    procedure ButtonMoinsRotClick(Sender: TObject);
    procedure RotTrackBarChange(Sender: TObject);
    procedure BitBtnRot0Click(Sender: TObject);
    procedure BitBtnRot90Click(Sender: TObject);
    procedure BitBtnRot180Click(Sender: TObject);
  private
    { Déclarations privées }
    Procedure ColorierCube(ClCadran:Integer);
    Procedure EcrireEONSZN;
  public

    { Déclarations publiques }
  end;

var
  FormCadsol3D: TFormCadsol3D;
  GrDim: Single;

implementation

{$R *.dfm}

uses Cadvar, Main, FCadsol, uVisuCadMultiple;

var
  AChild: TFormCadsol;

Procedure TFormCadsol3D.ColorierCube(ClCadran:Integer);
begin
      GLCube1.Material.FrontProperties.Emission.Blue := ($00FF0000 and ClCadran)
        / ($00FF0000);
      GLCube1.Material.FrontProperties.Emission.Green :=
        ($0000FF00 and ClCadran) / ($0000FF00);
      GLCube1.Material.FrontProperties.Emission.Red := ($000000FF and ClCadran)
        / ($000000FF);
end;

procedure TFormCadsol3D.DecliTrackBarChange(Sender: TObject);
begin
  inherited;
  DecliEdit.Value:=DecliTrackBar.Position;
end;

procedure TFormCadsol3D.Axes3DItemMenuClick(Sender: TObject);
begin
  GLCube1.ShowAxes:= self.Axes3DItemMenu.Checked;
  Repaint;
end;

procedure TFormCadsol3D.BitBtn0Click(Sender: TObject);
begin
  inherited;
  DecliTrackBar.Position:=0;
end;

procedure TFormCadsol3D.BitBtn180Click(Sender: TObject);
begin
  inherited;
  DecliTrackBar.Position:=180;
end;

procedure TFormCadsol3D.BitBtn90Click(Sender: TObject);
begin
  inherited;
  DecliTrackBar.Position:=90;
end;


procedure TFormCadsol3D.BitBtnAppliquerClick(Sender: TObject);
var i:integer;  aCad:Tcadran;
begin
  inherited;
  GLCube1.DeleteChildren;
  AChild :=TFormCadsol(MainForm.ActiveMDIChild);
  if CadranMultiple.typ=Cubique then ACad:=FCadSud.Cadran else Acad:=Achild.Cadran;
  With ACad do begin
    decli := DecliEdit.Value;
    Incli := IncliEdit.Value;
    Rotation:=RotEdit.Value;
    if RadBtnOuest.Checked then decli := -decli;

    if CadranMultiple.Typ in [vide,Multiple] then for i := 1 to Mainform.MDIChildCount do
      begin
        ActiveCad := TFormCadsol(Mainform.MDIChildren[i - 1]);
        ActiveCad.cadran.decli := decli;
        ActiveCad.cadran.Incli := Incli;
        ActiveCad.cadran.Rotation:=Rotation;
      end;

    if CadranMultiple.Typ=Cubique then begin
      CadranMultiple.Incli:=Incli;
      CadranMultiple.Decli:=Decli;
      CadranMultiple.Rotation:=Rotation;
      Mainform.DimEtOrientationCadranCubique;
    end;
  end;

  for i:=1 to MainForm.MDIChildCount do MainForm.MDIChildren[i-1].Refresh;
  if ItemLecadranactif.Checked then  Cadransimple1Click(sender);




  //if ItemLecadranmultiple.Checked then ItemLecadranmultipleClick(Sender);
  //if ItemLecadranCubique.Checked then ItemLecadrancubiqueClick(Sender);
  //VisuCadMultipleForm.refresh;

   (* if CadranMultiple.typ=Cubique then  begin
        CadranMultiple.Decli:= decli;
        MainForm.DimEtOrientationCadranCubique;
        end;      *)


 (*  decli := DecliEdit.Value + DecliMinEdit.Value / 60;
    Incli := IncliEdit.Value + IncliMinEdit.Value / 60;
    if Decli>180 then Decli:=180;
    if Incli>180 then Incli:=180;
    if DecliOuestRB.Checked then decli := -decli;
    if CadranMultiple.Typ=Multiple then for i := 1 to Mainform.MDIChildCount do
      begin
        ActiveCad := TFormCadsol(Mainform.MDIChildren[i - 1]);
        ActiveCad.cadran.decli := decli;
        ActiveCad.cadran.Incli := Incli;
      end;
    if CadranMultiple.typ=Cubique then  begin
        CadranMultiple.Decli:= decli;
        MainForm.DimEtOrientationCadranCubique;
        end;      *)

end;

procedure TFormCadsol3D.BitBtnIncli0Click(Sender: TObject);
begin
  inherited;
  IncliTrackBar.Position:=0;
end;

procedure TFormCadsol3D.BitBtnIncli180Click(Sender: TObject);
begin
  inherited;
  IncliTrackBar.Position:=180;
end;

procedure TFormCadsol3D.BitBtnIncli90Click(Sender: TObject);
begin
  inherited;
  IncliTrackBar.Position:=90;
end;

procedure TFormCadsol3D.BitBtnRot0Click(Sender: TObject);
begin
  inherited;
  RotTrackBar.Position:=0;
end;

procedure TFormCadsol3D.BitBtnRot180Click(Sender: TObject);
begin
  inherited;
  RotTrackBar.Position:=180;
end;

procedure TFormCadsol3D.BitBtnRot90Click(Sender: TObject);
begin
  inherited;
  RotTrackBar.Position:=90;
end;

procedure TFormCadsol3D.ButtonMoinsIncliClick(Sender: TObject);
begin
  inherited;
  IncliEdit.Value:=-IncliEdit.Value;
  if IncliEdit.Value>=0 then ButtonMoinsIncli.Caption:='-' else   ButtonMoinsIncli.Caption:='+';
end;

procedure TFormCadsol3D.ButtonMoinsRotClick(Sender: TObject);
begin
  inherited;
  RotEdit.Value:=-RotEdit.Value;
  if RotEdit.Value>=0 then ButtonMoinsRot.Caption:='-' else   ButtonMoinsRot.Caption:='+';
end;

procedure TFormCadsol3D.Cadransimple1Click(Sender: TObject);
begin

  AChild :=TFormCadsol(MainForm.ActiveMDIChild);
  Self.GLSimpleNavigation1.FormCaption:='Orientation: '  + Achild.Caption +'  (%FPS) ';
  GLCylinder1.Visible := false;
  GLCube1.Visible :=False;
  GLCube1.DeleteChildren;
  GLCylinder1.DeleteChildren;
  with AChild.Cadran do
  begin
    GLSceneViewer1.Visible := True;
    GLSceneViewer1.Buffer.BackgroundColor := clFond;
    GrDim := Profondeur;
    if GrDim<Hauteur then GrDim:=Hauteur;
    if GrDim<Largeur then Grdim:=Largeur;
    GrDim:= GrDim/1000*1.3;
    EcrireEONSZN;
    GrDim:=1000;
    if AChild.Cadran.Typ = Montresol then
    begin
      GLCube1.Visible := false;
      GLCylinder1.Visible := True;
      GLCylinder1.DeleteChildren;
      GLCylinder1.Visible := true;
      GLCylinder1.Height := Hauteur / GrDim;
      GLCylinder1.TopRadius := Largeur / 2 / pi / GrDim;
      GLCylinder1.BottomRadius := Largeur / 2 / pi / GrDim;
      GLCylinder1.Material.FrontProperties.Emission.Blue :=
        ($00FF0000 and ClCadran) / ($00FF0000);
      GLCylinder1.Material.FrontProperties.Emission.Green :=
        ($0000FF00 and ClCadran) / ($0000FF00);
      GLCylinder1.Material.FrontProperties.Emission.Red :=
        ($000000FF and ClCadran) / ($000000FF);
      GLDummyCube2.ResetAndPitchTurnRoll(0, 0, 0);
    end
    else
    begin
      GLCylinder1.Visible := false;
      GLCube1.Visible :=True;
//
//      With GLDummyCube2 do begin
//        Direction.X:=0;
//        Direction.Y:=1;
//        Direction.Z:=0;
//        Up.X:=0;
//        Up.Y:=0;
//        Up.Z:=1;
//      end;
//
      GLCube1.CubeWidth := Largeur / GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli-90);
      GLCube1.RollAngle:=Achild.Cadran.Rotation;

      ColorierCube(ClCadran);
    end;
    AChild.Refresh;

  end;
end;

procedure TFormCadsol3D.EONSZNitemClick(Sender: TObject);
begin
    GLDummyCube.ShowAxes:= EONSZNitem.Checked;
    GLSpaceText_Ouest.Visible:= EONSZNitem.Checked;
    GLSpaceText_Est.Visible:=EONSZNitem.Checked;
    GLSpaceText_Sud.Visible:= EONSZNitem.Checked;
    GLSpaceText_Nord.Visible:=EONSZNitem.Checked;
    GLSpaceTextZenith.Visible:= EONSZNitem.Checked;
    GLSpaceTextNadir.Visible := EONSZNitem.Checked;
  Repaint;
end;

procedure TFormCadsol3D.EquatorialBtnClick(Sender: TObject);
begin
  AChild :=TFormCadsol(MainForm.ActiveMDIChild);
  With Achild.Cadran do  begin
     IncliEdit.Value:=abs(Lati);
     if Lati>=0 then DecliEdit.Value:=0 else DecliEdit.Value:=180;
     //Gx:=0;Gx:=0;
  end;
  IncliTrackBar.Position:= Round(IncliEdit.Value);
  DecliTrackBar.Position:= Round(DecliEdit.Value);
end;

procedure TFormCadsol3D.FormActivate(Sender: TObject);

begin
MainForm.itemVueen3dimentions.Checked:=True;
ItemAxederotationterrestreClick(Sender);
  GLCylinder1.Visible := false;
  GLCube1.Visible := false;
  //GLCube1.DeleteChildren;
  GLCylinder1.DeleteChildren;
  GLSceneViewer1.Visible := True;
  Cadransimple1Click(sender);
 // if ItemLecadranmultiple.Checked then ItemLecadranmultipleClick(Sender);
 // if ItemLecadranCubique.Checked then ItemLecadrancubiqueClick(Sender);
  AChild :=TFormCadsol(MainForm.ActiveMDIChild);
  With Achild.Cadran do begin
     DecliEdit.Value:=abs(Decli);
     if decli < 0 then RadBtnOuest.Checked := true
                   else RadBtnEst.Checked := true;
    // DecliTrackBar.Position:=abs(Round(Decli));
     IncliEdit.Value := Incli;
     if Incli>=0 then ButtonMoinsIncli.Caption:='-' else   ButtonMoinsIncli.Caption:='+';
     if Rotation>=0 then ButtonMoinsRot.Caption:='-' else   ButtonMoinsRot.Caption:='+';
     RotEdit.Value:=Rotation;
     //if Typ in [bifilaire,analemmatique] then Panel2.Visible:=false else Panel2.Visible:=true;
  end;
  DecliTrackBar.Position :=abs(Round(DecliEdit.Value));
  IncliTrackBar.Position :=abs(Round(IncliEdit.Value));
  RotTrackBar.Position :=abs(Round(RotEdit.Value));
  StaticTextFaceSud.Visible:=False;
  if (CadranMultiple.Typ=Cubique) and (Achild.Caption <> ChTcad[TCadSud]) then
  begin
     StaticTextFaceSud.Visible:=True;
     BitBtnAppliquer.Visible:=false;
     Panel1.Enabled:=False;

  end  else begin
       Panel1.Enabled:=True;
       BitBtnAppliquer.Visible:=True;
       StaticTextFaceSud.Visible:=false
       end;
   Refresh
end;


procedure TFormCadsol3D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GLCube1.DeleteChildren;
  GLCylinder1.DeleteChildren;
  GLSceneViewer1.Visible := false;
  MainForm.itemVueen3dimentions.Checked:=False;
end;

procedure TFormCadsol3D.FormResize(Sender: TObject);
begin
 Self.Refresh;
end;

procedure TFormCadsol3D.IncliTrackBarChange(Sender: TObject);
begin
  inherited;
  if IncliEdit.Value>=0 then IncliEdit.Value:= IncliTrackBar.Position
                        else IncliEdit.Value:=-IncliTrackBar.Position;
end;

procedure TFormCadsol3D.ItemAxederotationterrestreClick(Sender: TObject);
begin
  inherited;
  with GLArrowLineAxeTerre do begin
    AChild :=TFormCadsol(MainForm.ActiveMDIChild);
    Visible:=ItemAxederotationterrestre.Checked;
    Height:= Achild.Cadran.Hauteur /GRDim *4;
    TurnAngle:=90+AChild.Cadran.lati;
  end;

end;

procedure TFormCadsol3D.ItemLecadrancubiqueClick(Sender: TObject);
var i:Integer; CubeF:TGLCube;
begin
  //AChild :=Main.ActiveCad;(* TFormCadsol(MainForm.ActiveMDIChild); *)
  Self.GLSimpleNavigation1.FormCaption:='Vue 3D Cadran cubique  (%FPS) ';
  GLCylinder1.Visible := false;
  GLCube1.Visible := True;
  GLCube1.DeleteChildren;
  GLCylinder1.DeleteChildren;


    GLSceneViewer1.Visible := True;


    with FCadSud.Cadran do
  begin

    GrDim:=1000;
      GLSceneViewer1.Buffer.BackgroundColor := clFond;
      ColorierCube(ClCadran);
      GLCube1.CubeWidth := Largeur / GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli-90);
      FCadSud.refresh;
    //  With FCadSup.Cadran do GLDummyCube2.ResetAndPitchTurnRoll(0,Decli, -Incli+90);
  end;
   With FCadEst .Cadran do
   begin
     // GLCube1.ResetAndPitchTurnRoll(0,Decli, -Incli+90);

    (*  GLCube1.CubeWidth := Largeur/ GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;   *)
      GLCube1.ResetAndPitchTurnRoll(0,Decli,Incli-90);
      GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli,  Incli-90);

      FCadest.Refresh;
    //  GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli, Incli-90);
    //  GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli);

   end;
  { With FCadOuest.Cadran do
   begin
     // GLCube1.ResetAndPitchTurnRoll(0,Decli, -Incli+90);
      GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli,  Incli+90);
      GLCube1.CubeWidth := Largeur/ GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      FCadOuest.Refresh;
    //  GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli, Incli-90);
    //  GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli);

   end;   }


end;

Procedure TFormCadsol3D.EcrireEONSZN;
Begin
    GLSpaceText_Ouest.Position.Z:= GrDim;
    GLSpaceText_Est.Position.Z  :=-GrDim;
    GLSpaceText_Sud.Position.X  := GrDim;
    GLSpaceText_Nord.Position.X :=-GrDim;
    GLSpaceTextZenith.Position.Y:= GrDim;
    GLSpaceTextNadir.Position.Y :=-GrDim;
end;

procedure TFormCadsol3D.ItemLecadranmultipleClick(Sender: TObject);
Var ActiveChild:TFormCadsol;
begin
  //Cadransimple1Click(Sender);
  Self.Caption:='Vue 3D Cadran multiple  ';
  GLCylinder1.Visible := false;
  GLCube1.Visible := false;
  GLCube1.DeleteChildren;

  with CadranMultiple do
  begin
    GLSceneViewer1.Buffer.BackgroundColor := clFond;
    GrDim := Profondeur;
    if GrDim<HauteurTot then GrDim:=HauteurTot;
    if GrDim<LargeurTot then Grdim:=LargeurTot;
    GrDim:= GrDim/1000*1.3;
    EcrireEONSZN;
    GrDim:=1000;
      ActiveChild:=TformCadsol(MainForm.ActiveMDIChild);
      If activeChild<>Nil then ClCadran:=ActiveChild.Cadran.clCadran;

      Self.GLSimpleNavigation1.FormCaption:='Vue 3D '  +'  (%FPS) ';

      GLCube1.CubeWidth := Largeur /GrDim ;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      GLCube1.Visible := True;
      GLCube1.DeleteChildren;
     // ColorierCube(ClCadran);
     //GLDummyCube2.ResetRotations;
      GLDummyCube2.Turn(-Decli); GLDummyCube2.Roll(incli-90);
     // GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli);
      VisuCadMultipleForm.Repaint;
      GLCube1.CubeWidth := LargeurTot /GrDim ;
      GLCube1.CubeHeight := HauteurTot / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      ColorierCube(ClCadran);
  end;
end;

procedure TFormCadsol3D.RotTrackBarChange(Sender: TObject);
begin
  inherited;
  if RotEdit.Value>=0 then RotEdit.Value:= RotTrackBar.Position
                      else RotEdit.Value:=-RotTrackBar.Position;
end;

end.
