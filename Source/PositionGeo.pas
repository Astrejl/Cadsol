unit PositionGeo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Spin, FnpNumericEdit, jpeg, GLWin32Viewer,
  GLScene, GLObjects, GLCadencer, GLGeomObjects, ComCtrls, shellapi,
  GLCoordinates, GLCrossPlatform, GLBaseClasses (*, GLMisc
    GLCoordinates, GLCrossPlatform, BaseClasses, GLMisc*);

type
  TPositionForm = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LatiDegreEdit: TFnpNumericEdit;
    LatiMinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    RadioNord: TRadioButton;
    RadioSud: TRadioButton;
    Label8: TLabel;
    Label7: TLabel;
    LatiSecEdit: TSpinEdit;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Secondes: TLabel;
    Label5: TLabel;
    LongiDegreEdit: TFnpNumericEdit;
    LongiMinEdit: TSpinEdit;
    RadioGroup2: TRadioGroup;
    RadOuest: TRadioButton;
    LongiSecEdit: TSpinEdit;
    GMTEdit: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    h: TLabel;
    GMTMinEdit: TSpinEdit;
    min: TLabel;
    LabelLoc: TLabel;
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
    RadioGroup3: TRadioGroup;
    RadioButton2D: TRadioButton;
    Label6: TLabel;
    TrackBar1: TTrackBar;
    RadioButton3D: TRadioButton;
    Button1: TButton;
    RadEst: TRadioButton;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure RadioButton3DClick(Sender: TObject);
    procedure RadioButton2DClick(Sender: TObject);
    procedure LatiDegreEditChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure LongiDegreEditExit(Sender: TObject);
    procedure LatiDegreEditExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
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

uses Main, CadVar, FCadsol, Trigo, Math, Registry;
{$R *.DFM}

var
  Lat, Longi: real;
  pressed: boolean;
  AChild: TFormCadsol;
  mx, my: Integer;
  CamScale: single;

procedure TPositionForm.Affiche;
var
  l: real;
begin
  with Image1 do
  begin
    l := round((height / 2 - Y) / (height / 2) * 90);
    if l < 0 then
      RadioSud.Checked := True
    else
      RadioNord.Checked := True;
    l := abs(l);
    if l > 90 then
      l := 90;
    LatiDegreEdit.Value := l;
    l := round((Width / 2 - X) / (Width / 2) * 180);
    GMTEdit.Value := -round(l / 15);
    if l < 0 then
      RadEst.Checked := True
    else
      RadOuest.Checked := True;
    l := abs(l);
    if l > 180 then
      l := 180;
    LongiDegreEdit.Value := l;
  end;
end;

procedure TPositionForm.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pressed then
  begin
    // Image1.Cursor:=crSize;
    Affiche(X, Y);
  end;
end;

procedure TPositionForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pressed := True;
  // Image1.Cursor:=crSize;
  Affiche(X, Y);
end;

procedure TPositionForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pressed := false;
  // Image1.Cursor:=crsize;
  Affiche(X, Y);
end;

procedure TPositionForm.FormActivate(Sender: TObject);
var
  X, Y: Integer;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with AChild do
  begin
    self.GLCadencer1.Enabled := True;
    if Cadran.Lati < 0 then
      RadioSud.Checked := True
    else
      RadioNord.Checked := True;
    LatiDegreEdit.Value := abs(Cadran.Lati);
    self.GLDummyCube1.pitchAngle := Cadran.Lati;
    LatiMinEdit.Value := 0;
    LatiSecEdit.Value := 0;
    if Cadran.Longi < 0 then
      RadOuest.Checked := True
    else
      RadEst.Checked := True;
    LongiDegreEdit.Value := abs(Cadran.Longi);
    self.GLSphere1.TurnAngle := Cadran.Longi;
    LongiMinEdit.Value := 0;
    LongiSecEdit.Value := 0;
    GMTEdit.Value := Cadran.decalage;
    GMTMinEdit.Value := Cadran.DecalMin;
    Y := round(Image1.height / 2 * (1 - Cadran.Lati / 90));
    X := round(Image1.Width / 2 * (1 - Cadran.Longi / 180));
    // p:=Clienttoscreen(point(x,y));*)
    // setcursorpos(p.x,p.y);
    // Image1.Picture.create;
    // image1.Picture.Bitmap.Canvas.Ellipse(x-5,y-5,x+5,y+5);
    // Canvas.Ellipse(0,0,x,y);
    RadioButton3D.Checked := True;
    // shellExecute
  end;

  FormResize(Sender);
  // GlCamera1.SceneScale := CamScale * Math.Min(GLSceneViewer1.Width / 450, GLSceneViewer1.Height / 300);
end;

procedure TPositionForm.BitBtn1Click(Sender: TObject);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  Lat := LatiDegreEdit.Value + LatiMinEdit.Value / 60 +
    LatiSecEdit.Value / 3600;
  if Lat > 90 then
    Lat := 90;
  if Lat < 0 then
    Lat := 0;
  if RadioSud.Checked then
    Lat := -Lat;
  AChild.Cadran.Lati := Lat;
  Longi := LongiDegreEdit.Value + LongiMinEdit.Value / 60 +
    LongiSecEdit.Value / 3600;
  if Longi > 180 then
    Longi := 180;
  if Longi < 0 then
    Longi := 0;
  if RadEst.Checked then
    Longi := -Longi;
  AChild.Cadran.Longi := Longi;
  AChild.Cadran.decalage := GMTEdit.Value;
  AChild.Cadran.DecalMin := GMTMinEdit.Value
end;

procedure TPositionForm.Globe;
Var
  la, lo: single;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with AChild do
  begin
    la := LatiDegreEdit.Value;
    if self.RadioSud.Checked then
      la := -la;
    lo := LongiDegreEdit.Value;
    if self.RadEst.Checked then
      lo := -lo;
    self.GLDummyCube1.pitchAngle := la;
    self.GLSphere1.TurnAngle := lo;
  end;
end;

procedure TPositionForm.BitBtn3Click(Sender: TObject);

begin
  (* FormBasegeo.Localisation:='';
    FormBaseGeo.ShowModal;
    if FormBasegeo.Localisation<>'' then
    StrPCopy (achild.cadran.Commentaire,Formbasegeo.Localisation);
    LabelLoc.Caption:=Formbasegeo.Localisation; *)
end;

procedure TPositionForm.FormResize(Sender: TObject);
begin
  GLCamera1.SceneScale := CamScale * Math.min(GLSceneViewer1.Width / 450,
    GLSceneViewer1.height / 300);
end;

procedure TPositionForm.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TPositionForm.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  p, t: single;
begin
  if (ssLeft in Shift) then
  begin
    p := (my - Y) / 5;
    t := (mx - X) / 5;
    if abs(GLSphere1.TurnAngle - t) <= 180 then
      GLSphere1.TurnAngle := GLSphere1.TurnAngle - t;
    if abs(GLDummyCube1.pitchAngle - p) <= 90 then
      GLDummyCube1.pitchAngle := GLDummyCube1.pitchAngle - p;
    LatiDegreEdit.Value := round(GLDummyCube1.pitchAngle);
    if LatiDegreEdit.Value < 0 then
    begin
      LatiDegreEdit.Value := abs(LatiDegreEdit.Value);
      RadioSud.Checked := True;
    end
    else
      RadioNord.Checked := True;
    LongiDegreEdit.Value := round(GLSphere1.TurnAngle);
    if LongiDegreEdit.Value < 0 then
    begin
      LongiDegreEdit.Value := abs(LongiDegreEdit.Value);
      RadEst.Checked := True
    end
    else
      RadOuest.Checked := True;
    mx := X;
    my := Y;
    GMTEdit.Value := round(-GLSphere1.TurnAngle / 15);
  end;
end;

procedure TPositionForm.TrackBar1Change(Sender: TObject);
begin
  CamScale := TrackBar1.Position;
  FormResize(Sender);
end;

procedure TPositionForm.RadioButton3DClick(Sender: TObject);
begin
  if RadioButton3D.Checked then
  begin
    Image1.Visible := false;
    GLSceneViewer1.Visible := True;
    TrackBar1.Visible := True;
  end
end;

procedure TPositionForm.RadioButton2DClick(Sender: TObject);
begin
  if RadioButton2D.Checked then
  begin
    Image1.Visible := True;
    GLSceneViewer1.Visible := false;
    TrackBar1.Visible := false;
  end
end;

procedure TPositionForm.LatiDegreEditChange(Sender: TObject);
begin
  Globe;
end;

procedure TPositionForm.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TPositionForm.LongiDegreEditExit(Sender: TObject);
begin
  if RadEst.Checked then
    GLSphere1.TurnAngle := -LongiDegreEdit.Value
  else
    GLSphere1.TurnAngle := LongiDegreEdit.Value;
end;

procedure TPositionForm.LatiDegreEditExit(Sender: TObject);
begin
  if RadioSud.Checked then
    GLDummyCube1.pitchAngle := -LatiDegreEdit.Value
  else
    GLDummyCube1.pitchAngle := LatiDegreEdit.Value;
end;

procedure TPositionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GLCadencer1.Enabled := false;
end;

procedure TPositionForm.Button1Click(Sender: TObject);
var
  s: string;

  function Executer(LCom: string; cmdShow: Integer): bool;
  var
    si: TStartUpInfo;
    pi: TProcessInformation;
    r: bool;
  begin
    fillchar(si, SizeOf(si), 0);
    si.dwFlags := STARTF_USEPOSITION + STARTF_USESIZE;
    si.dwX := self.ClientOrigin.X;
    si.dwY := self.ClientOrigin.Y;
    si.dwXSize := self.ClientWidth;
    si.dwYSize := self.ClientHeight;
    r := CreateProcess(nil, pchar(LCom), nil, nil, false, 0, nil, nil, si, pi);

    if r then // waitForSingleObject(pi.hProcess,INFINITE) (*attendre la fin du nouveau processus*)
    else
      MessageDlg('Commande incorrecte:' + LCom, mtError, [mbOK], 0);
    Executer := r;

  end;

  function GetRegistryValue: string;
  var
    Registry: TRegistry;
    s: string;
  begin
    Registry := TRegistry.Create;

    Registry.RootKey := HKEY_CLASSES_ROOT;
    { False car ne voulons pas le créer s'il n'existe pas }
    Registry.OpenKey('\CLSID\{1796A329-04C1-4C07-B28E-E4A807935C06}', false);
    Result := Registry.ReadString('LocalServer32');

    Registry.Free;
  end;

begin
  s := GetRegistryValue;
  Executer(s, 0);
end;

begin
  CamScale := 7;

end.
