unit Typecad;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, jpeg,uFormAJL;

type
  TTypeCadDlg = class(TFormAJL)
    OKBtn: TBitBtn;
    Bevel1: TBevel;
    VertBtn: TRadioButton;
    AnalemBtn: TRadioButton;
    HauteurBtn: TRadioButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    SansTypeBtn: TRadioButton;
    BifilBtn: TRadioButton;
    Image4: TImage;
    EqTempsBtn: TRadioButton;
    AnalemneBtn: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TypeCadDlg: TTypeCadDlg;

implementation

{$R *.DFM}

uses sysutils,fcadsol,uvisucadMultiple, MAIN,CadVar,CadTrace3D;
Var  i, j: Integer;
     ActiveCad: TFormCadSol;


procedure TTypeCadDlg.FormActivate(Sender: TObject);
begin
if Mainform.MDIChildCount=0 then begin
   Mainform.ItemTypedecadran1.Checked:=false;
   close;
   end;
      // BifilBtn.Visible  :=Not VisuCadMultipleForm.Visible ;
  HauteurBtn.Visible:= CadranMultiple.typ=vide;
  AnalemBtn.Visible := CadranMultiple.typ=vide;
  BifilBtn.Visible := CadranMultiple.typ in [vide,multiple];
  ActiveCad:= TFormCadsol(MainForm.ActiveMDIChild);
  MainForm.ItemTypedecadran1.Checked:=True;
  Self.Caption:='Type du cadran '+activeCad.Caption;
  with ActiveCad.Cadran do begin
    case Typ of
      Vertical:
        TypeCadDlg.VertBtn.Checked := true;
      Analemmatique:
        TypeCadDlg.AnalemBtn.Checked := true;
      bifilaire:
        TypeCadDlg.BifilBtn.Checked := true;
      Montresol:
        TypeCadDlg.HauteurBtn.Checked := true;
      Vide:
        TypeCadDlg.SansTypeBtn.Checked := true;
      courbeEqT: TypeCadDlg. EqTempsBtn.Checked := true;
      courbeAna: begin
         TypeCadDlg.AnalemneBtn.Checked := true;
         //PaintChild(ActiveCad.Cadran,Image1.Canvas,Image1.ClientRect);
      end;
    end;
  end;
   Image1.Visible := VertBtn.Checked;
   Image2.Visible := AnalemBtn.Checked;
   Image3.Visible := HauteurBtn.Checked;
   Image4.Visible := BifilBtn.Checked;

end;

procedure TTypeCadDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
Mainform.ItemTypedecadran1.Checked:=False;
end;

procedure TTypeCadDlg.OKBtnClick(Sender: TObject);
begin
  With ActiveCad.Cadran do
     begin
      if TypeCadDlg.VertBtn.Checked then Typ := Vertical;
      if TypeCadDlg.BifilBtn.Checked then Typ := bifilaire;
      if TypeCadDlg.AnalemBtn.Checked then Typ := Analemmatique;
      if TypeCadDlg.HauteurBtn.Checked then Typ := Montresol;
      if TypeCadDlg.SansTypeBtn.Checked then Typ := Vide;
      if TypeCadDlg.EqTempsBtn.Checked then Typ := CourbeEqT;
      if TypeCadDlg.AnalemneBtn.Checked then Typ := CourbeAna;
      FormActivate(Sender);

      ActiveCad.SousStylaire1.Visible :=(Typ = Vertical);
      case typ of
        Analemmatique: begin
                       Incli := 0;
                       Decli := 0;
                       Devise:='Devise...';
                       end;
        bifilaire:
                       begin
                       Incli := 90;
                       Devise:='Devise...';
                       for i:=1 to Mainform.MDIChildCount do begin
                         ActiveCad:=TFormCadsol(MainForm.MDIChildren[i-1]);
                         ActiveCad.Cadran.Incli:=90;
                         end;
                       end;
        else begin
             Devise:='';
             ChiffresRomains:=0;
             end;  (*Case*)

      end;
      Modif := true;
      ActiveCad.refresh;
      FormCadsol3D.Refresh;
    end;
  end;  (*OK*)

end.
