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
  GLColor;


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
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Axes3DItemMenuClick(Sender: TObject);
    procedure EONSZNitemClick(Sender: TObject);
   // procedure CadranMultiple1Click(Sender: TObject);
    procedure Cadransimple1Click(Sender: TObject);
    procedure ItemLecadranmultipleClick(Sender: TObject);
    procedure ItemLecadrancubiqueClick(Sender: TObject);
  private
    { Déclarations privées }
    Procedure ColorierCube(ClCadran:Integer);
    Procedure EcrireEONSZN;
  public
    GrDim: Single;
    { Déclarations publiques }
  end;

var
  FormCadsol3D: TFormCadsol3D;


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

procedure TFormCadsol3D.Axes3DItemMenuClick(Sender: TObject);
begin
  GLCube1.ShowAxes:= self.Axes3DItemMenu.Checked;
  Repaint;
end;

procedure TFormCadsol3D.Cadransimple1Click(Sender: TObject);
begin

  AChild :=Main.ActiveCad;(* TFormCadsol(MainForm.ActiveMDIChild); *)
  Self.GLSimpleNavigation1.FormCaption:='Vue 3D '  + Achild.Caption +'  (%FPS) ';
  GLCylinder1.Visible := false;
  //GLCube1.Visible := false;
 // GLCube1.DeleteChildren;
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
      GLCube1.Visible := true;
      GLCube1.DeleteChildren;
      GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli-90);
      GLCube1.CubeWidth := Largeur / GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
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

procedure TFormCadsol3D.FormActivate(Sender: TObject);

begin
  GLCylinder1.Visible := false;
  GLCube1.Visible := false;
  GLCube1.DeleteChildren;
  GLCylinder1.DeleteChildren;
  GLSceneViewer1.Visible := True;
  ItemLecadranmultiple.Enabled:= (CadranMultiple.Typ=multiple);
  ItemLecadrancubique.Enabled := (CadranMultiple.Typ=Cubique);
  if ItemLecadranactif.Checked then  Cadransimple1Click(sender);
  if ItemLecadranmultiple.Checked then ItemLecadranmultipleClick(Sender);
  if ItemLecadranCubique.Checked then ItemLecadrancubiqueClick(Sender);
end;

procedure TFormCadsol3D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GLCube1.DeleteChildren;
  GLSceneViewer1.Visible := false;
  MainForm.itemVueen3dimentions.Checked:=False;
end;

procedure TFormCadsol3D.FormResize(Sender: TObject);
begin
 Self.Refresh;
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
    GrDim := Profondeur;
    if GrDim<Hauteur then GrDim:=Hauteur;
    if GrDim<Largeur then Grdim:=Largeur;
    GrDim:= GrDim/1000*1.3;
    EcrireEONSZN;
    GrDim:=1000;
      GLSceneViewer1.Buffer.BackgroundColor := clFond;
      ColorierCube(ClCadran);
      GLCube1.CubeWidth := Largeur / GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli-90);
      FCadSud.Refresh;
      With FCadSup.Cadran do GLDummyCube2.ResetAndPitchTurnRoll(0,Decli, -Incli+90);
  end;
   With FCadSup.Cadran do
   begin
     // GLCube1.ResetAndPitchTurnRoll(0,Decli, -Incli+90);
      GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli,  Incli-90);
      GLCube1.CubeWidth := Largeur/ GrDim;
      GLCube1.CubeHeight := Hauteur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      FCadSup.Refresh;
      GLDummyCube2.ResetAndPitchTurnRoll(0,-Decli, Incli-90);
    //  GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli);

   end;


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
  Cadransimple1Click(Sender);
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

end.
