unit CadTrace3DMult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,uFormAJL,
  Dialogs, GLWin32Viewer, StdCtrls, Buttons, ExtCtrls, GLCadencer,
  GLObjects, GLGeomObjects, GLScene, GLSpaceText, GLTexture,
  ComCtrls, GLzBuffer, GLMaterial, GLCoordinates, GLCrossPlatform,
  GLBaseClasses, GLApplicationFileIO, GLFPSMovement, GLTerrainRenderer, GLSkydome, GLSkyBox,
  GLSimpleNavigation, Vcl.Menus, GLBitmapFont;

type
  TFormCadsol3DMult = class(TFormAJL)
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
    Image1: TImage;
    GLSkyBox1: TGLSkyBox;
    GLSimpleNavigation1: TGLSimpleNavigation;
    MainMenu1: TMainMenu;
    Axes3DItemMenu: TMenuItem;
    VoirItemMenu: TMenuItem;
    EONSZNitem: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Axes3DItemMenuClick(Sender: TObject);
    procedure EONSZNitemClick(Sender: TObject);
  private
    mx, my: Integer;
    { Déclarations privées }
  public
    GrDim: Single;
    { Déclarations publiques }
  end;

var
  FormCadsol3DMult: TFormCadsol3D;


implementation

{$R *.dfm}

uses Cadvar, Main, FCadsol;

var
  AChild: TFormCadsol;

procedure TFormCadsol3D.Axes3DItemMenuClick(Sender: TObject);
begin
  GLCube1.ShowAxes:= self.Axes3DItemMenu.Checked;
  Repaint;
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
  self.WindowState:=wsNormal;
  AChild :=Main.ActiveCad;(* TFormCadsol(MainForm.ActiveMDIChild); *)
  Self.Caption:='Vue 3D  '  + Achild.Caption ;
  with AChild.Cadran do
  begin
    GLSceneViewer1.Buffer.BackgroundColor := clFond;
    GLSceneViewer1.Visible := true;
    //GLCadencer1.Enabled := true;
    GrDim := Profondeur;
    if GrDim<Hauteur then GrDim:=Hauteur;
    if GrDim<Largeur then Grdim:=Largeur;
    GrDim:= GrDim/1000*2;
    GLSpaceText_Ouest.Position.Z:= GrDim;
    GLSpaceText_Est.Position.Z  :=-GrDim;
    GLSpaceText_Sud.Position.X  := GrDim;
    GLSpaceText_Nord.Position.X :=-GrDim;
    GLSpaceTextZenith.Position.Y:= GrDim;
    GLSpaceTextNadir.Position.Y :=-GrDim;
    GrDim:=1000;
    if AChild.Cadran.Typ = Montresol then
    begin
      GLCube1.Visible := false;
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
      (* if Achild.Cadran.NFBitMap<>'' then begin
        Image1.Picture.LoadFromFile(Achild.Cadran.NFBitMap);
        GLCylinder1.Material.Texture.Image.Assign(Image1.Picture);
        end; *)
    end
    else
    begin
      GLCylinder1.Visible := false;
      GLCube1.DeleteChildren;
      GLCube1.Visible := true;
      GLDummyCube2.ResetAndPitchTurnRoll(0, -Decli, Incli);
      GLCube1.CubeWidth := Hauteur / GrDim;
      GLCube1.CubeHeight := Largeur / GrDim;
      GLCube1.CubeDepth := Profondeur / GrDim;
      GLCube1.Material.FrontProperties.Emission.Blue := ($00FF0000 and ClCadran)
        / ($00FF0000);
      GLCube1.Material.FrontProperties.Emission.Green :=
        ($0000FF00 and ClCadran) / ($0000FF00);
      GLCube1.Material.FrontProperties.Emission.Red := ($000000FF and ClCadran)
        / ($000000FF);
      (* if Achild.Cadran.NFBitMap<>'' then begin
        Image1.Picture.LoadFromFile(Achild.Cadran.NFBitMap);
        GLCube1.Material.Texture.Image.Assign(Image1.Picture);
        end; *)
    end;
    Self.GLSimpleNavigation1.FormCaption:='Vue 3D '  + Achild.Caption +'  (%FPS) ';
    AChild.Refresh;
  end;
  // GLZShadows1.CastShadow;
end;

procedure TFormCadsol3D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GLCube1.DeleteChildren;
  GLSceneViewer1.Visible := false;
 // GLCadencer1.Enabled := false;
  MainForm.itemVueen3dimentions.Checked:=False;
end;

procedure TFormCadsol3D.FormResize(Sender: TObject);
begin
 Self.Refresh;
end;

end.
