unit Position;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Spin, jpeg, GLWin32Viewer,
  GLScene, GLObjects, GLCadencer, GLGeomObjects, ComCtrls, shellapi,
  GLCoordinates, GLCrossPlatform, GLBaseClasses, Vcl.Mask, FnpNumericEdit,uFormAJL;
   (*, GLMisc  GLCoordinates, GLCrossPlatform, BaseClasses, GLMisc*)

type
  TPositionForm = class(TFormAJL)
    Image1: TImage;
    PanelLati: TPanel;
    Label2: TLabel;
    LatiMinEdit: TSpinEdit;
    RadioGroupNordSud: TRadioGroup;
    RadioNord: TRadioButton;
    RadioSud: TRadioButton;
    Label8: TLabel;
    Label7: TLabel;
    LatiSecEdit: TSpinEdit;
    PanelLongi: TPanel;
    Label5: TLabel;
    LongiMinEdit: TSpinEdit;
    LongiSecEdit: TSpinEdit;
    GMTEdit: TSpinEdit;
    h: TLabel;
    GMTMinEdit: TSpinEdit;
    min: TLabel;
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLDummyCube1: TGLDummyCube;
    GLCamera1: TGLCamera;
    GLSphere1: TGLSphere;
    GLCadencer1: TGLCadencer;
    GLLines1: TGLLines;
    GLLines2: TGLLines;
    GLLines3: TGLLines;
    GLLightSource1: TGLLightSource;
    Label6: TLabel;
    RadEst: TRadioButton;
    RadOuest: TRadioButton;
    Panel3: TPanel;
    RadioGroup2D3D: TRadioGroup;
    RadioButton3D: TRadioButton;
    RadioButton2D: TRadioButton;
    BitBtn1: TBitBtn;
    TrackBar1: TTrackBar;
    LabelLoc: TLabel;
    RadioGroupOuestEst: TRadioGroup;
    LatiDegreEdit: TFnpNumericEdit;
    LongiDegreEdit: TFnpNumericEdit;
    Label1: TLabel;
    Label3: TLabel;
    //LatiDegreEdit: TFnpNumericEdit;
   // LOngiDegreEdit: TFnpNumericEdit;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure RadioButton3DClick(Sender: TObject);
    procedure RadioButton2DClick(Sender: TObject);
    procedure LatiDegreEditChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure LongiDegreEditExit(Sender: TObject);
    procedure LatiDegreEditExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadOuestClick(Sender: TObject);
    procedure RadEstClick(Sender: TObject);
    procedure LongiDegreEditChange(Sender: TObject);
    procedure LongiMinEditExit(Sender: TObject);
    procedure LongiSecEditExit(Sender: TObject);
    procedure LatiMinEditExit(Sender: TObject);
    procedure LatiSecEditExit(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  private
    procedure Affiche(X, Y: Integer);
    procedure Globe;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  PositionForm: TPositionForm;

implementation

uses Main, CadVar, FCadsol, Trigo, Math, CadTrace3D, uVisuCadMultiple;
{$R *.DFM}

var
  Lat, Longi: real;
  pressed: boolean;
  AChild: TFormCadsol;
  mx, my: Integer;
  CamScale: single;


procedure TPositionForm.Affiche;
var l: real;
begin
  with image1 do begin
    l := round((height / 2 - y) / (height / 2) * 90);
    if l < 0 then RadioSud.Checked := True else RadioNord.Checked := True;
    l := abs(l);
    if l > 90 then l := 90;
    LatiDegreEdit.Value := Integer(Round(l));
    l := round((Width / 2 - x) / (Width / 2) * 180);
    GMTEdit.Value := -Integer(round(l / 15));
    if l < 0 then RadEst.Checked := True else RadOuest.Checked := True;
    l := abs(l);
    if l > 180 then l := 180;
    LongiDegreEdit.Value := Trunc(l);
  end;
end;


procedure TPositionForm.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if pressed then begin
   // Image1.Cursor:=crSize;
    affiche(x, y);
  end;
end;

procedure TPositionForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pressed := True;
 //Image1.Cursor:=crSize;
  affiche(x, y);
end;

procedure TPositionForm.Image1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pressed := false;
 //Image1.Cursor:=crsize;
  affiche(x, y);
end;

procedure TPositionForm.FormActivate(Sender: TObject);
var x, y: integer;
begin
  MainForm.itemPositionGeographique.Checked:=True;
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with Achild do begin
    self.GLCadencer1.Enabled:=True;

    latiDegreEdit.Value := abs(Cadran.Lati);
    self.GLDummyCube1.pitchAngle := Cadran.Lati;
    LatiMinEdit.value := 0;
    LatiSecEdit.Value := 0;

    longiDegreEdit.Value := abs(Cadran.Longi);
    self.GLSphere1.TurnAngle := Cadran.Longi;
    longiMinEdit.value := 0;
    longiSecEdit.Value := 0;
    GMTEdit.Value := Cadran.decalage;
    GMTMinEdit.Value := Cadran.DecalMin;
    y := round(Image1.height / 2 * (1 - Cadran.Lati / 90));
    x := round(Image1.Width / 2 * (1 - Cadran.Longi / 180));
    Image1.Visible:=false;
    GlSceneviewer1.Visible:=True;
    TrackBar1.Visible:=True;

     if Cadran.Lati < 0 then RadioSud.Checked := True else RadioNord.Checked := True;
     if Cadran.Longi > 0 then RadOuest.Checked := True else RadEst.Checked := True;
    RadioButton3D.Checked:=True;
    RadioButton2D.Checked:=False;
  end;

  //FormResize(sender);
  //GlCamera1.SceneScale := CamScale * Math.Min(GLSceneViewer1.Width / 450, GLSceneViewer1.Height / 300);
end;

procedure TPositionForm.BitBtn1Click(Sender: TObject);
 var i:integer;
begin
for i:= 1 to MainForm.MDIChildCount do begin
  AChild := TFormCadsol(MainForm.MDIChildren[i-1]);
  Lat := LatiDegreEdit.Value + LatiMinEdit.Value / 60 + LatiSecEdit.value / 3600;
  if Lat > 90 then Lat := 90;
  if Lat < 0 then Lat := 0;
  if RadioSud.Checked then Lat := -Lat;
  AChild.Cadran.Lati := Lat;
  Longi := LongiDegreEdit.Value + LongiMinEdit.Value / 60 + LongiSecEdit.value / 3600;
  if Longi > 180 then Longi := 180;
  if Longi < 0 then Longi := 0;
  if RadEst.Checked then Longi := -Longi;
  AChild.Cadran.Longi := Longi;
  AChild.Cadran.Decalage := GMTEdit.Value;
  AChild.Cadran.DecalMin := GMTMinEdit.Value;
  Achild.Refresh;
  end;

  if FormCadsol3d.Visible then begin
    FormCadsol3d.SetFocus;
    FormCadsol3D.Refresh;
    Self.SetFocus;
  end;

  VisuCadMultipleForm.Refresh;
end;

procedure TpositionForm.Globe;
 Var la,lo:single;
begin
AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with Achild do begin
   la:=latiDegreEdit.Value;
   if self.RadioSud.Checked then la:=-la;
   lo:=LongiDegreEdit.Value;
   if self.RadEst.Checked then lo:=-lo;
   self.GLDummyCube1.pitchAngle := la;
   self.GLSphere1.TurnAngle := lo;
  end;
end;



procedure TPositionForm.FormResize(Sender: TObject);
begin
  GlCamera1.SceneScale := CamScale * Math.Min(GLSceneViewer1.Width / 450, GLSceneViewer1.Height / 300);
end;

procedure TPositionForm.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Mx := x; My := y;
end;

procedure TPositionForm.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var p, t: single;
    NewLati,NewLongi:Real;
begin
  if (ssLeft in Shift) then begin
    p := (My - y) / TrackBar1.Position;
    t := (Mx - x) / TrackBar1.Position;
    if abs(GLSphere1.TurnAngle - t) <= 180 then
      GLSphere1.turnAngle := GLSphere1.TurnAngle - t;
    if abs(GLDummyCube1.pitchAngle - p)<= 90 then
      GLDummyCube1.pitchAngle := GLDummyCube1.pitchAngle - p;
    NewLati:= round(GLDummyCube1.pitchAngle);
    latiDegreEdit.Value := abs(NewLati);
    if NewLati < 0 then
      RadioSud.Checked := True else RadioNord.Checked := true;
    NewLongi:=round(GLSphere1.turnAngle);
    longiDegreEdit.Value := abs(NewLongi);
    if NewLongi<0 then
      RadEst.Checked:=true else RadOuest.Checked:=True;
    Mx := x;
    My := y;
    GMTEdit.Value:=round(-GLSphere1.turnAngle/15);
  end;
end;

procedure TPositionForm.TrackBar1Change(Sender: TObject);
begin
  CamScale:=TrackBar1.Position;
  FormResize(Sender);
end;


procedure TPositionForm.RadioButton3DClick(Sender: TObject);
begin
if RadioButton3D.Checked then begin
   Image1.Visible:=false;
   GlSceneviewer1.Visible:=True;
   TrackBar1.Visible:=True;
 end
end;


procedure TPositionForm.RadOuestClick(Sender: TObject);
begin
  Globe;
end;

procedure TPositionForm.RadEstClick(Sender: TObject);
begin
  Globe;
end;

procedure TPositionForm.RadioButton2DClick(Sender: TObject);
begin
 if RadioButton2D.Checked then begin
   Image1.Visible:=True;
   GlSceneviewer1.Visible:=False;
   TrackBar1.Visible:=False;
 end
end;

procedure TPositionForm.LatiDegreEditChange(Sender: TObject);
begin
   Globe;
end;


procedure TPositionForm.LongiDegreEditChange(Sender: TObject);
begin
   Globe
end;

procedure TPositionForm.LongiDegreEditExit(Sender: TObject);
begin
 if RadEst.Checked then GLSphere1.turnAngle:= -LongiDegreEdit.Value
                   else GLSphere1.turnAngle:= LongiDegreEdit.Value;
end;

procedure TPositionForm.LongiMinEditExit(Sender: TObject);
begin
  LongiDegreEdit.Value:= LongiDegreEdit.Value +  LongiMinEdit.Value/60 ;
  LongiMinEdit.Value:=0;
end;

procedure TPositionForm.LongiSecEditExit(Sender: TObject);
begin
  LongiDegreEdit.Value:= LongiDegreEdit.Value +  LongiSecEdit.Value/3600 ;
  LongiSecEdit.Value:=0;
end;

procedure TPositionForm.LatiDegreEditExit(Sender: TObject);
begin
if RadioSud.Checked then GLDummyCube1.pitchAngle:= -LatiDegreEdit.Value
                   else GLDummyCube1.pitchAngle:= LatiDegreEdit.Value;
end;

procedure TPositionForm.LatiMinEditExit(Sender: TObject);
begin
      LatiDegreEdit.Value:= LatiDegreEdit.Value +  LatiMinEdit.Value/60 ;
      LatiMinEdit.Value:=0;

end;

procedure TPositionForm.LatiSecEditExit(Sender: TObject);
begin
  LatiDegreEdit.Value:= LatiDegreEdit.Value +  LatiSecEdit.Value/3600 ;
  LatiSecEdit.Value:=0;
end;

procedure TPositionForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 GlCadencer1.Enabled:=False;
 MainForm.itemPositionGeographique.Checked:=False;
end;


procedure TPositionForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
 TrackBar1.Position := TrackBar1.Position + wheelDelta div 100;
end;

begin
CamScale:=7;
end.

