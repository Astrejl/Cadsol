unit uCouleurs;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls, Spin,uformAJL;

type
  TCouleursDlg = class(TFormAJL)
    OKBtn: TBitBtn;
    ColorDialog1: TColorDialog;

    LigneHorBtn: TSpeedButton;
    LigneHorShp: TShape;
    LigneHorEdit: TSpinEdit;

    DemiHBtn: TSpeedButton;
    DemiHShp: TShape;
    DemiHEdit: TSpinEdit;

    HItBtn: TSpeedButton;
    HitShp: TShape;
    HItEdit: TSpinEdit;

    HBabBtn: TSpeedButton;
    HBabShp: TShape;
    HBabEdit: TSpinEdit;

    ArcBtn: TSpeedButton;
    ArcShp: TShape;
    ArcEdit: TSpinEdit;

    MeriBtn: TSpeedButton;
    MeriShp: TShape;
    MeriEdit: TSpinEdit;

    AxesBtn: TSpeedButton;
    AxesShp: TShape;
    AxesEdit: TSpinEdit;
    ShapeFond: TShape;
    Image1: TImage;
    CadranButton: TSpeedButton;
    FondButton: TSpeedButton;
    Label1: TLabel;
    ShapeCadran: TShape;
    ContourButton: TSpeedButton;
    ContourEdit: TSpinEdit;
    ContourShape: TShape;
    TousLesCadransChekBox: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure LigneHorBtnClick(Sender: TObject);
    procedure LigneHorEditChange(Sender: TObject);
    procedure DemiHBtnClick(Sender: TObject);
    procedure DemiHEditChange(Sender: TObject);
    procedure HBabEditChange(Sender: TObject);
    procedure HBabBtnClick(Sender: TObject);
    procedure HItBtnClick(Sender: TObject);
    procedure HItEditChange(Sender: TObject);
    procedure ArcBtnClick(Sender: TObject);
    procedure ArcEditChange(Sender: TObject);
    procedure AxesEditChange(Sender: TObject);
    procedure MeriEditChange(Sender: TObject);
    procedure MeriBtnClick(Sender: TObject);
    procedure AxesBtnClick(Sender: TObject);
    procedure CadranButtonClick(Sender: TObject);
    procedure FondButtonClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ShapeFondMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeCadranMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ContourEditChange(Sender: TObject);
    procedure ContourButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CouleursDlg: TCouleursDlg;

implementation

{$R *.DFM}

uses Main, FCadsol, Cadvar, CadTrace3D, uVisuCadMultiple;

var
  AChild: TFormCadsol;

Function Ep(i: Integer): Integer;
begin
  Ep := i + 1;
end;

procedure TCouleursDlg.FormActivate(Sender: TObject);
begin
  Mainform.itemCouleursetEpaisseurs.Checked:=True;
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  Self.Caption:='Couleurs et épaisseurs du '+Achild.Caption;
  if MainForm.MDIChildCount > 1 then
    TousLesCadransChekBox.Visible := true
  else
    TousLesCadransChekBox.Visible := False;

  ShapeCadran.Brush.Color := AChild.Cadran.clCadran;
  ShapeFond.Brush.Color := AChild.Cadran.ClFond;

  LigneHorShp.Brush.Color := AChild.Cadran.ClTrait[hsol];
  LigneHorShp.Pen.Color := AChild.Cadran.ClTrait[hsol];
  LigneHorEdit.Value := AChild.Cadran.EpTrait[hsol];
  LigneHorShp.Width := Ep(LigneHorEdit.Value);

  DemiHShp.Brush.Color := AChild.Cadran.ClTrait[dhe];
  DemiHShp.Pen.Color := AChild.Cadran.ClTrait[dhe];
  DemiHEdit.Value := AChild.Cadran.EpTrait[dhe];
  DemiHShp.Width := Ep(DemiHEdit.Value);

  HitShp.Brush.Color := AChild.Cadran.ClTrait[hit];
  HitShp.Pen.Color := AChild.Cadran.ClTrait[hit];
  HItEdit.Value := AChild.Cadran.EpTrait[hit];
  HitShp.Width := Ep(HItEdit.Value);

  HBabShp.Brush.Color := AChild.Cadran.ClTrait[hBab];
  HBabShp.Pen.Color := AChild.Cadran.ClTrait[hBab];
  HBabEdit.Value := AChild.Cadran.EpTrait[hBab];
  HBabShp.Width := Ep(HBabEdit.Value);

  ArcShp.Brush.Color := AChild.Cadran.ClTrait[Arcd];
  ArcShp.Pen.Color := AChild.Cadran.ClTrait[Arcd];
  ArcEdit.Value := AChild.Cadran.EpTrait[Arcd];
  ArcShp.Width := Ep(ArcEdit.Value);

  ContourShape.Brush.Color := AChild.Cadran.ClTrait[Cont];
  ContourShape.Pen.Color := AChild.Cadran.ClTrait[Cont];
  ContourEdit.Value := AChild.Cadran.EpTrait[Cont];
  ContourShape.Width := Ep(ContourEdit.Value);

  MeriShp.Brush.Color := AChild.Cadran.ClTrait[Meri];
  MeriShp.Pen.Color := AChild.Cadran.ClTrait[Meri];
  MeriEdit.Value := AChild.Cadran.EpTrait[Meri];
  MeriShp.Width := Ep(MeriEdit.Value);

  AxesShp.Brush.Color := AChild.Cadran.ClTrait[Ax];
  AxesShp.Pen.Color := AChild.Cadran.ClTrait[Ax];
  AxesEdit.Value := AChild.Cadran.EpTrait[Ax];
  AxesShp.Width := Ep(AxesEdit.Value);

end;

procedure TCouleursDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.itemCouleursetEpaisseurs.Checked := False;
end;

procedure TCouleursDlg.LigneHorBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[hsol];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[hsol] := LigneHorShp.Brush.Color;
    LigneHorShp.Brush.Color := ColorDialog1.Color;
    LigneHorShp.Pen.Color := ColorDialog1.Color;
  end;
end;

procedure TCouleursDlg.DemiHBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[dhe];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[dhe] := DemiHShp.Brush.Color ;
    DemiHShp.Brush.Color := ColorDialog1.Color;
    DemiHShp.Pen.Color := ColorDialog1.Color;
  end;

end;

procedure TCouleursDlg.HItBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[hit];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[hit] := HitShp.Brush.Color ;
    HitShp.Brush.Color := ColorDialog1.Color;
    HitShp.Pen.Color := ColorDialog1.Color;
  end;
end;

procedure TCouleursDlg.HBabBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[hBab];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[hBab] := HBabShp.Brush.Color ;
    HBabShp.Brush.Color := ColorDialog1.Color;
    HBabShp.Pen.Color := ColorDialog1.Color;
  end;

end;

procedure TCouleursDlg.ArcBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[Arcd];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[Arcd] := ArcShp.Brush.Color ;
    ArcShp.Brush.Color := ColorDialog1.Color;
    ArcShp.Pen.Color := ColorDialog1.Color;
  end;

end;

procedure TCouleursDlg.MeriBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[Meri];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[Meri] := MeriShp.Brush.Color;
    MeriShp.Brush.Color := ColorDialog1.Color;
    MeriShp.Pen.Color := ColorDialog1.Color;
  end;

end;

procedure TCouleursDlg.AxesBtnClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[Ax];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[Ax] := AxesShp.Brush.Color;
    AxesShp.Brush.Color := ColorDialog1.Color;
    AxesShp.Pen.Color := ColorDialog1.Color;
  end;
end;

procedure TCouleursDlg.ContourButtonClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClTrait[Cont];
  if ColorDialog1.Execute then
  begin
    // AChild.Cadran.ClTrait[Cont] := ContourShape.Brush.Color;
    ContourShape.Brush.Color := ColorDialog1.Color;;
    ContourShape.Pen.Color := ColorDialog1.Color;;
  end;
end;

procedure TCouleursDlg.LigneHorEditChange(Sender: TObject);
begin
  LigneHorShp.Width := Ep(LigneHorEdit.Value);
end;

procedure TCouleursDlg.DemiHEditChange(Sender: TObject);
begin
  DemiHShp.Width := Ep(DemiHEdit.Value);
end;

procedure TCouleursDlg.HBabEditChange(Sender: TObject);
begin
  HBabShp.Width := Ep(HBabEdit.Value);
end;

procedure TCouleursDlg.HItEditChange(Sender: TObject);
begin
  HitShp.Width := Ep(HItEdit.Value);
end;

procedure TCouleursDlg.ArcEditChange(Sender: TObject);
begin
  ArcShp.Width := Ep(ArcEdit.Value);
end;

procedure TCouleursDlg.MeriEditChange(Sender: TObject);
begin
  MeriShp.Width := Ep(MeriEdit.Value);
end;

procedure TCouleursDlg.OKBtnClick(Sender: TObject);
var
  i: Integer;
  Procedure ModifCouleurs;
  begin
    with AChild.Cadran do
    begin
      EpTrait[hsol] := LigneHorEdit.Value;
      EpTrait[dhe] := DemiHEdit.Value;
      EpTrait[hBab] := HBabEdit.Value;
      EpTrait[hit] := HItEdit.Value;
      EpTrait[Arcd] := ArcEdit.Value;
      EpTrait[Meri] := MeriEdit.Value;
      EpTrait[Ax] := AxesEdit.Value;
      EpTrait[Cont] := ContourEdit.Value;
    end;
    AChild.Cadran.ClTrait[hsol] := LigneHorShp.Brush.Color;
    AChild.Cadran.ClTrait[dhe] := DemiHShp.Brush.Color;
    AChild.Cadran.ClTrait[hit] := HitShp.Brush.Color;
    AChild.Cadran.ClTrait[hBab] := HBabShp.Brush.Color;
    AChild.Cadran.ClTrait[Arcd] := ArcShp.Brush.Color;
    AChild.Cadran.ClTrait[Meri] := MeriShp.Brush.Color;
    AChild.Cadran.ClTrait[Ax] := AxesShp.Brush.Color;
    AChild.Cadran.ClTrait[Cont] := ContourShape.Brush.Color;
    AChild.Cadran.clCadran := ShapeCadran.Brush.Color;
    AChild.Cadran.ClFond := ShapeFond.Brush.Color;
    AChild.refresh;
  end;

begin
  if Self.TousLesCadransChekBox.Checked then
    for i := 1 to MainForm.MDIChildCount do
    begin
      AChild := TFormCadsol(MainForm.MDIChildren[i - 1]);
      ModifCouleurs;
      VisuCadMultipleForm.Color:=ShapeFond.Brush.Color;
      CadranMultiple.contour:=true;
    end
  else
  begin
    AChild := TFormCadsol(MainForm.ActiveMDIChild);
    ModifCouleurs
  end;
  if formCadsol3d.Visible then
  begin
    formCadsol3d.Setfocus;
    formCadsol3d.refresh;
    Self.Setfocus;
  end;
  VisuCadMultipleForm.refresh;
end;

procedure TCouleursDlg.ShapeCadranMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CadranButtonClick(Sender);
end;

procedure TCouleursDlg.ShapeFondMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FondButtonClick(Sender);
end;

procedure TCouleursDlg.AxesEditChange(Sender: TObject);
begin
  AxesShp.Width := Ep(AxesEdit.Value);
end;

procedure TCouleursDlg.ContourEditChange(Sender: TObject);
begin
  ContourShape.Width := Ep(ContourEdit.Value);
end;

procedure TCouleursDlg.CadranButtonClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.clCadran;
  if ColorDialog1.Execute then
  begin
    ShapeCadran.Brush.Color := ColorDialog1.Color;
    Self.refresh;
  end;
end;

procedure TCouleursDlg.FondButtonClick(Sender: TObject);
begin
  ColorDialog1.Color := AChild.Cadran.ClFond;
  if ColorDialog1.Execute then
  begin
    ShapeFond.Brush.Color := ColorDialog1.Color;
    Self.refresh;
  end;

end;

end.
