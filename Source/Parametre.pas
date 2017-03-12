unit Parametre;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls, Spin, Grids, Calendar, Buttons, uFormAJL;

type
  TParam = class(TFormAJL)
    Dimensions: TTabSheet;
    Style: TTabSheet;
    ArcsDIurnes: TTabSheet;
    Lignes: TTabSheet;
    PageControl: TPageControl;
    LargeurLb: TLabel;
    Label2: TLabel;
    LargeurEdit: TSpinEdit;
    HauteurEdit: TSpinEdit;
    Bevel1: TBevel;
    SolsticesCBox: TCheckBox;
    ArcList: TListBox;
    SupprimerBtn: TBitBtn;
    Bevel99: TBevel;
    AjouterBtn: TBitBtn;
    PrecisLb1: TLabel;
    PrecisionEdit: TSpinEdit;
    PrecisLb2: TLabel;
    Label5: TLabel;
    IncLb1: TLabel;
    IncrementEdit: TSpinEdit;
    IncLbl2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Orientation: TTabSheet;
    Bevel4: TBevel;
    Declinaison: TLabel;
    DecliEdit: TSpinEdit;
    DecliOuestRB: TRadioButton;
    Label11: TLabel;
    IncliEdit: TSpinEdit;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    gEdit: TSpinEdit;
    GroupBox2: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    gxEdit: TSpinEdit;
    Label19: TLabel;
    gyEdit: TSpinEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    PleinSudBtn: TButton;
    PleinNordBtn: TButton;
    Horizontal0Btn: TButton;
    VerticalBtn: TButton;
    Horizontal180Btn: TButton;
    Declinant90Btn: TButton;
    PoleLb: TLabel;
    StyleLb: TLabel;
    AutoBtn: TButton;
    CarreBtn: TButton;
    PremierCB: TCheckBox;
    Panel1: TPanel;
    DiametreLb: TLabel;
    DiametreEdit: TSpinEdit;
    LongStyleLb: TLabel;
    Bevel3: TBevel;
    Bevel5: TBevel;
    ZodiaqueCB: TCheckBox;
    TabSheet1: TTabSheet;
    Bevel8: TBevel;
    Deviselb: TLabel;
    DeviseBox: TComboBox;
    Label1: TLabel;
    DevxEdit: TSpinEdit;
    Label3: TLabel;
    DevyEdit: TSpinEdit;
    Label4: TLabel;
    Label6: TLabel;
    DecliMinEdit: TSpinEdit;
    IncliMinEdit: TSpinEdit;
    Label7: TLabel;
    Label13: TLabel;
    Label10: TLabel;
    PaintBoxDecli: TPaintBox;
    PaintBoxIncli: TPaintBox;
    AppliquerBtn: TBitBtn;
    SousStyleLb: TLabel;
    Image1: TImage;
    Label24: TLabel;
    jourEdit: TSpinEdit;
    Label25: TLabel;
    AnglessLbl: TLabel;
    AngleSaLbl: TLabel;
    Fils: TTabSheet;
    bevelFils: TBevel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    GroupBox3: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    FilHorEdit: TSpinEdit;
    FilVerEdit: TSpinEdit;
    Label31: TLabel;
    Label32: TLabel;
    AutoFilsButton: TButton;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    xfilEdit: TSpinEdit;
    yFilEdit: TSpinEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    CBAfficheDate: TCheckBox;
    LabelProfondeur: TLabel;
    ProfEdit: TSpinEdit;
    LabelProfondeurmm: TLabel;
    SpinEditMarge: TSpinEdit;
    Label42: TLabel;
    Label43: TLabel;
    LabelLimiteDiametre: TLabel;
    ChBoxMargePourTous: TCheckBox;
    DecliEstRB: TRadioButton;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    IntervalleLbl1: TLabel;
    IntervalleLbl2: TLabel;
    HsinmmLb: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    HLegaleCB: TCheckBox;
    EqTempsHiverCB: TCheckBox;
    DemiHeureCB: TCheckBox;
    EqTempsEteCB: TCheckBox;
    HeureSolCB: TCheckBox;
    HBabCB: TCheckBox;
    HItaCB: TCheckBox;
    HAntiqCB: TCheckBox;
    IntervalleEdit: TSpinEdit;
    HSinCB: TCheckBox;
    RHsinEdit: TSpinEdit;
    GMTEdit: TSpinEdit;
    GMTMinEdit: TSpinEdit;
    procedure OKButtonClick(Sender: TObject);
    procedure AjouterBtnClick(Sender: TObject);
    procedure SupprimerBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnAnnulClick(Sender: TObject);
    procedure PleinSudBtnClick(Sender: TObject);
    procedure PleinNordBtnClick(Sender: TObject);
    procedure Horizontal0BtnClick(Sender: TObject);
    procedure VerticalBtnClick(Sender: TObject);
    procedure Horizontal180BtnClick(Sender: TObject);
    procedure Declinant90BtnClick(Sender: TObject);
    procedure AutoBtnClick(Sender: TObject);
    procedure CarreBtnClick(Sender: TObject);
    procedure PremierCBClick(Sender: TObject);
    procedure LargeurEditChange(Sender: TObject);
    procedure HauteurEditChange(Sender: TObject);
    procedure DiametreEditChange(Sender: TObject);
    procedure IntervalleEditExit(Sender: TObject);
    procedure HeureSolCBClick(Sender: TObject);
    procedure ZodiaqueCBClick(Sender: TObject);
    procedure DecliEditChange(Sender: TObject);
    procedure IncliEditChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure AppliquerBtnClick(Sender: TObject);
    procedure AutoFilsButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ListeArc(n, j, m: integer);
  end;

var
  Param: TParam;

implementation

uses Main, FCadsol, Cadvar, Udate, CadTrace, Cadtrace3D, uVisuCadMultiple;
{$R *.DFM}

Var
  AChild: TFormCadsol;
  ACadran: Tcadran;

function TexteArc(i, j, m: integer): string;
var
  s, sj, sm: string[10];
  d: real;
begin
  // s:='   ';
  // s[1]:=chr(96+i);
  if j <> 0 then
    str(j: 2, sj)
  else
    sj := '  ';
  if m <> 0 then
    str(m: 2, sm)
  else
    sm := '  ';
  s := '        ';
  if j * m > 0 then
  begin
    d := Eqtemps[JourAn(j, m)].decsol / pi * 180;
    str(d: 8: 3, s);
  end;
  TexteArc := sj + '/' + sm + s + '°';
end;

procedure TParam.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  Mainform.ItemParametrage.Checked := false;
end;

procedure TParam.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to NbDates do
  begin
    ArcList.Items.Add(TexteArc(i, 0, 0));
  end;
  PageControl.ActivePage := Lignes;
end;

procedure TParam.FormActivate(Sender: TObject);
var
  i: integer;
  s: string[2];
  l, a: real;
begin
  Mainform.ItemParametrage.Checked:=True;
  AChild := TFormCadsol(Mainform.ActiveMDIChild);
  ACadran := AChild.cadran;
  Self.Caption := 'Paramètrage du ' + AChild.Caption;
  With AChild.cadran do
  begin
    Lignes.TabVisible := Typ <> vide;
    Orientation.TabVisible := (Typ = vertical) or (Typ = Bifilaire);
    Style.TabVisible := (Typ = vertical);
    Fils.TabVisible := (Typ = Bifilaire);
    ArcsDIurnes.TabVisible := (Typ = vertical) or (Typ = analemmatique) or
      (Typ = Bifilaire);
    DemiHeureCB.Visible := (Typ = vertical) or (Typ = analemmatique) or
      (Typ = Bifilaire);
    IncrementEdit.Visible := (Typ = vertical) or (Typ = montresol) or
      (Typ = Bifilaire);
    IncLb1.Visible := (Typ = vertical) or (Typ = montresol) or
      (Typ = Bifilaire);
    IncLbl2.Visible := (Typ = vertical) or (Typ = montresol) or
      (Typ = Bifilaire);
    PrecisionEdit.Visible := (Typ = vertical) or (Typ = Bifilaire);
    PrecisLb1.Visible := (Typ = vertical) or (Typ = Bifilaire);
    PrecisLb2.Visible := (Typ = vertical) or (Typ = Bifilaire);
    DiametreEdit.Visible := (Typ = montresol);
    DiametreLb.Visible := (Typ = montresol);
    LabelLimiteDiametre.Visible := (Typ = montresol);
    LongStyleLb.Visible := (Typ = montresol);
    EqTempsHiverCB.Visible := (Typ = vertical) or (Typ = montresol) or
      (Typ = Bifilaire);
    EqTempsEteCB.Visible := (Typ = vertical) or (Typ = Bifilaire);
    HBabCB.Visible := (abs(lati) < 66.56) and
      ((Typ = vertical) or (Typ = Bifilaire));
    HItaCB.Visible := (abs(lati) < 66.56) and
      ((Typ = vertical) or (Typ = Bifilaire));
    HAntiqCB.Visible := (abs(lati) < 66.56) and
      ((Typ = vertical) or (Typ = Bifilaire));
    IntervalleLbl1.Visible := (Typ = vertical) or (Typ = Bifilaire);
    IntervalleLbl2.Visible := (Typ = vertical) or (Typ = Bifilaire);
    IntervalleEdit.Visible := (Typ = vertical) or (Typ = Bifilaire);
    AngleSaLbl.Visible := (Typ = vertical);
    AnglessLbl.Visible := (Typ = vertical);
    Label11.Visible := (Typ = vertical);
    Label12.Visible := (Typ = vertical);
    Label13.Visible := (Typ = vertical);
    Horizontal0Btn.Visible := (Typ = vertical);
    VerticalBtn.Visible := (Typ = vertical);
    Horizontal180Btn.Visible := (Typ = vertical);
    PaintBoxIncli.Visible := (Typ = vertical)and(CadranMultiple.Typ<>Cubique);
    IncliEdit.Visible := (Typ = vertical)and(CadranMultiple.Typ<>Cubique);
    IncliMinEdit.Visible := (Typ = vertical)and(CadranMultiple.Typ<>Cubique);
    HSinCB.Visible := (Typ = vertical);
    RHsinEdit.Visible := (Typ = vertical);
    //HsinRLb.Visible := (Typ = vertical);
    HsinmmLb.Visible := (Typ = vertical);
    CBAfficheDate.Checked := AFFicheDate;
    LabelProfondeur.Visible := Not(Typ = montresol);
    LabelProfondeurmm.Visible := Not(Typ = montresol);
    ProfEdit.Visible := Not(Typ = montresol);
    case Typ of
      analemmatique:
        begin
          ArcsDIurnes.Caption := 'Positions du style';
        end;
      vertical, Bifilaire:
        begin
          ArcsDIurnes.Caption := 'Arcs diurnes';
          EqTempsHiverCB.Caption :=
            'Heures avec Equation du temps (du 21/12 au 21/6)'
        end;
      montresol:
        begin
          EqTempsHiverCB.Caption := 'Heures avec Equation du temps'
        end;
    end;
    LargeurEdit.Value := Largeur div 10;
    HauteurEdit.Value := Hauteur div 10;
    ProfEdit.Value := Profondeur div 10;
    DiametreEdit.Value := round((Largeur div 10) / pi);
    SpinEditMarge.Value := Marge div 10;
    LongStyleLb.Caption := 'Longueur du style: ' +
      FloattostrF(LStyleMs(Hauteur, lati) / 10, ffFixed, 7, 1) + ' mm';
    IncrementEdit.Value := Increment;
    HeureSolCB.Checked := Heure_Sol;
    DemiHeureCB.Checked := demi_heure;
    DemiHeureCB.enabled := HeureSolCB.Checked;
    SolsticesCBox.Checked := arcs_diurnes;
    HLegaleCB.Checked := Heure_Legale;
    if Decalage >= 0 then
      s := ' +'
    else
      s := ' -';
    (* HLegaleCB.Caption:='Heure légale   TU'+s+IntToStr(abs(Decalage))+' h. ';
      if DecalMin<>0 then HLegaleCB.Caption:=HLegaleCB.Caption
      +InttoStr(DecalMin)+' min.'; *)
    EqTempsHiverCB.Checked := eq_temps_hiver;
    EqTempsEteCB.Checked := eq_temps_ete;
    HBabCB.Checked := heure_bab;
    HItaCB.Checked := heure_ita;
    HAntiqCB.Checked := heure_temp;
    IntervalleEdit.Value := Intervalle;
    // IntervalleEdit.Enabled:=EqTempsHiverCB.Checked or EqTempsEteCB.Checked;
    // IntervalleLbl1.enabled:=IntervalleEdit.Enabled;
    // IntervalleLbl2.enabled:=IntervalleEdit.Enabled;

    DecliEdit.Value := round(Int(abs(decli)));
    DecliMinEdit.Value := round(frac(abs(decli)) * 60);
    if decli >= 0 then
      DecliEstRB.Checked := true
    else
      DecliOuestRB.Checked := true;
    IncliEdit.Value := round(Int(Incli));
    IncliMinEdit.Value := round(frac(Incli) * 60);

    for i := 1 to NbDates do
      ArcList.Items.Strings[i - 1] := TexteArc(i, DateArc[i].jour,
        DateArc[i].mois);
    ArcList.Itemindex := 0;
    gEdit.Value := hStyle div 10;
    gxEdit.Value := gx div 10;
    gyEdit.Value := gy div 10;

    l := sqrt((Px - gx) * (Px - gx) + (Py - gy) * (Py - gy) + hStyle * hStyle);
    if l < 30000 then
    begin
      PoleLb.Caption := 'Pole du style:   X= ' + FloattostrF(Px / 10, ffFixed,
        7, 1) + '  Y= ' + FloattostrF(Py / 10, ffFixed, 7, 1) +
        ' (Coordonnées de P)';
      StyleLb.Caption := 'Style  PS: ' + FloattostrF(l / 10, ffFixed, 7,
        1) + ' mm ';
      l := sqrt((Px - gx) * (Px - gx) + (Py - gy) * (Py - gy));
      SousStyleLb.Caption := 'Sous-stylaire  GP: ' +
        FloattostrF(l / 10, ffFixed, 7, 1) + ' mm ';
      if gy <> Py then
        a := arctan((gx - Px) / (gy - Py)) / pi * 180
      else
        a := 90;
      if l <> 0 then
        AngleSaLbl.Caption := 'Sous-stylaire,axe vertical: ' +
          FloattostrF(a, ffFixed, 7, 1) + '°'
      else
        AngleSaLbl.Caption := '';
      if l <> 0 then
      begin
        a := arctan(hStyle / l) / pi * 180;
        AnglessLbl.Caption := 'Style,sous-stylaire: ' + FloattostrF(a, ffFixed,
          7, 1) + '°';
      end
      else
        AnglessLbl.Caption := '';
    end
    else
    begin
      PoleLb.Caption :=
        'Style paralléle aux lignes horaires et au plan du cadran.';
      StyleLb.Caption := '';
      SousStyleLb.Caption := '';
      AngleSaLbl.Caption := '';
      AnglessLbl.Caption := '';
    end;
    DevxEdit.Value := Devx div 10;
    DevyEdit.Value := Devy div 10;
    DeviseBox.text := devise;

    FilHorEdit.Value := hStyle div 10;
    FilVerEdit.Value := Distance div 10;
    xfilEdit.Value := gx div 10;
    yFilEdit.Value := gy div 10;
    HSinCB.Checked := Hsin;
    RHsinEdit.Value := Distance div 10;
    GMTEdit.Value := Decalage;
    GMTMinEdit.Value := DecalMin;
  end;
  PageControlChange(Sender);
end;

procedure TParam.OKButtonClick(Sender: TObject);
var
  i: integer;
  ActiveCad: TFormCadsol;
begin
  AChild := TFormCadsol(Mainform.ActiveMDIChild);
  AChild.cadran.Marge := SpinEditMarge.Value * 10;


  for i := 1 to Mainform.MDIChildCount do
    with TFormCadsol(Mainform.MDIChildren[i - 1]) do
    begin
      cadran.Largeur := LargeurEdit.Value * 10;
      cadran.Hauteur := HauteurEdit.Value * 10;
      cadran.Profondeur := ProfEdit.Value * 10;
      if self.ChBoxMargePourTous.Checked then  cadran.Marge := SpinEditMarge.Value * 10;
    end;
  CadranMultiple.Marge:=SpinEditMarge.Value * 10;
  CadranMultiple.LargeurTot := LargeurEdit.Value * 10 *
    CadranMultiple.NbCadLargeur;
  CadranMultiple.HauteurTot := HauteurEdit.Value * 10 *
    CadranMultiple.NbCadHauteur;
  CadranMultiple.Profondeur := ProfEdit.Value * 10;
  CadranMultiple.Largeur := CadranMultiple.LargeurTot div CadranMultiple.
    NbCadLargeur;
  CadranMultiple.Hauteur := CadranMultiple.HauteurTot div CadranMultiple.
    NbCadHauteur;

  with AChild.cadran do
  begin
    arcs_diurnes := SolsticesCBox.Checked;
    Heure_Sol := HeureSolCB.Checked;
    Heure_Legale := HLegaleCB.Checked;
    demi_heure := DemiHeureCB.Checked;
    eq_temps_hiver := EqTempsHiverCB.Checked;
    eq_temps_ete := EqTempsEteCB.Checked;
    heure_bab := HBabCB.Checked;
    heure_ita := HItaCB.Checked;
    heure_temp := HAntiqCB.Checked;
    Precision := PrecisionEdit.Value;
    Increment := IncrementEdit.Value;
    decli := DecliEdit.Value + DecliMinEdit.Value / 60;
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
        end;


    with IntervalleEdit do
    begin
      while (60 mod Value <> 0) do
        Value := Value + 1;
      Intervalle := Value;
    end;
    Devx := DevxEdit.Value * 10;
    Devy := DevyEdit.Value * 10;
    devise := DeviseBox.text;
    Modif := true;
    case Typ of
      Bifilaire:
        begin
          hStyle := FilHorEdit.Value * 10;
          Distance := FilVerEdit.Value * 10;
          gx := xfilEdit.Value * 10;
          gy := yFilEdit.Value * 10;
        end;
      vertical:
        begin
          hStyle := gEdit.Value * 10;
          gx := gxEdit.Value * 10;
          gy := gyEdit.Value * 10;
          Hsin := HSinCB.Checked;
          if Hsin then
            Distance := RHsinEdit.Value * 10;
        end;
    end;
    Decalage := GMTEdit.Value;
    DecalMin := GMTMinEdit.Value;
    AFFicheDate := CBAfficheDate.Checked;

  end;

end;

procedure TParam.AutoBtnClick(Sender: TObject);
begin
  with AChild.cadran do
  begin
    gEdit.Value := Hauteur div 100;
    gxEdit.Value := 0;
    gyEdit.Value := Hauteur div 50;
  end;
end;

procedure TParam.BtnAnnulClick(Sender: TObject);
begin
  AChild.cadran := ACadran;
end;

procedure TParam.AjouterBtnClick(Sender: TObject);
var
  i, j, m, y: word;
begin
  if ArcList.Itemindex >= 0 then
  begin
    i := ArcList.Itemindex + 1;
    with Fdate, AChild.cadran do
    begin
      if DateArc[i].jour <> 0 then
      begin
        j := DateArc[i].jour;
        m := DateArc[i].mois
      end
      else
        decodedate(now, y, m, j);
      MoisEdit.Value := m;
      jourEdit.Value := j;
      if Showmodal = MROK then
      begin
        m := MoisEdit.Value;
        j := jourEdit.Value;
        ArcList.Items.Strings[ArcList.Itemindex] := TexteArc(i, j, m);
        DateArc[i].jour := jourEdit.Value;
        DateArc[i].mois := MoisEdit.Value;
      end;
    end;
    if i < NbDates then
      ArcList.Itemindex := i;
  end;
end;

procedure TParam.SupprimerBtnClick(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to NbDates do
    if ArcList.Selected[i - 1] then
      with AChild.cadran do
      begin
        ArcList.Items.Strings[i - 1] := TexteArc(i, 0, 0);
        DateArc[i].jour := 0;
        DateArc[i].mois := 0;
      end;
end;

procedure TParam.ListeArc;
begin
  With AChild.cadran do
  begin
    ArcList.Items.Strings[n - 1] := TexteArc(n, j, m);
    DateArc[n].jour := j;
    DateArc[n].mois := m;
  end;
end;

procedure TParam.PremierCBClick(Sender: TObject);
var
  i: integer;
begin
  if PremierCB.Checked then
    for i := 1 to 12 do
      ListeArc(i, jourEdit.Value, i);
  if Not PremierCB.Checked then
    for i := 1 to 12 do
      ListeArc(i, 0, 0);
end;

procedure TParam.ZodiaqueCBClick(Sender: TObject);
begin
  if ZodiaqueCB.Checked then
  begin
    ListeArc(13, 21, 1);
    ListeArc(14, 21, 2);
    ListeArc(15, 21, 4);
    ListeArc(16, 21, 5);
    SolsticesCBox.Checked := true;
  end;
  if Not ZodiaqueCB.Checked then
  begin
    ListeArc(13, 0, 0);
    ListeArc(14, 0, 0);
    ListeArc(15, 0, 0);
    ListeArc(16, 0, 0);
    SolsticesCBox.Checked := false;
  end;

end;

procedure TParam.PleinSudBtnClick(Sender: TObject);
begin
  DecliEdit.Value := 0;
  DecliMinEdit.Value := 0;
end;

procedure TParam.PleinNordBtnClick(Sender: TObject);
begin
  DecliEdit.Value := 180;
  DecliMinEdit.Value := 0;
end;

procedure TParam.Declinant90BtnClick(Sender: TObject);
begin
  DecliEdit.Value := 90;
  DecliMinEdit.Value := 0;
end;

procedure TParam.Horizontal0BtnClick(Sender: TObject);
begin
  IncliEdit.Value := 0;
  IncliMinEdit.Value := 0;
end;

procedure TParam.VerticalBtnClick(Sender: TObject);
begin
  IncliEdit.Value := 90;
  IncliMinEdit.Value := 0;
end;

procedure TParam.Horizontal180BtnClick(Sender: TObject);
begin
  IncliEdit.Value := 180;
  IncliMinEdit.Value := 0;
end;

procedure TParam.CarreBtnClick(Sender: TObject);
begin
  with AChild.cadran do
    LargeurEdit.Value := (HauteurEdit.Value + LargeurEdit.Value) div 2;
  HauteurEdit.Value := LargeurEdit.Value;
  ProfEdit.Value := LargeurEdit.Value div 20;
end;

procedure TParam.LargeurEditChange(Sender: TObject);
begin
  DiametreEdit.Value := round(LargeurEdit.Value / pi);
end;

procedure TParam.HauteurEditChange(Sender: TObject);
begin
  LongStyleLb.Caption := 'Longueur du style: ' +
    FloattostrF(LStyleMs(HauteurEdit.Value * 10, AChild.cadran.lati) / 10,
    ffFixed, 7, 1) + ' mm';
end;

procedure TParam.DiametreEditChange(Sender: TObject);
begin
  LargeurEdit.Value := round(DiametreEdit.Value * pi);
end;

procedure TParam.IntervalleEditExit(Sender: TObject);
begin
  with IntervalleEdit do
    while (60 mod Value <> 0) do
      Value := Value + 1;
end;

procedure TParam.HeureSolCBClick(Sender: TObject);
begin
  DemiHeureCB.enabled := HeureSolCB.Checked;
end;

procedure TParam.DecliEditChange(Sender: TObject);
var
  r, a: real;
begin
  AChild := TFormCadsol(Mainform.ActiveMDIChild);
  ACadran := AChild.cadran;
  With AChild.cadran, PaintBoxDecli, PaintBoxDecli.Canvas do
  begin
    r := width div 2;
    a := DecliEdit.Value;
    Pen.Color := ClBlack;
    Brush.Color := ClWhite;
    Ellipse(0, 0, width, height);
    If DecliEdit.Value < 180 then
      a := a + DecliMinEdit.Value / 60;
    if DecliEstRB.Checked then  a := -abs(a);
    a := a / 180 * pi;
    Pen.Color := ClBlue;
    moveto(round(r - r * cos(a)), round(r - r * sin(a)));
    lineto(round(r + r * cos(a)), round(r + r * sin(a)));
    a := a - pi / 2;
    Pen.Color := ClRed;
    moveto(round(r), round(r));
    lineto(round(r - r * cos(a) / 4), round(r - r * sin(a) / 4));
  end;
end;

procedure TParam.IncliEditChange(Sender: TObject);
var
  r, a, w, h: real;
begin
  AChild := TFormCadsol(Mainform.ActiveMDIChild);
  ACadran := AChild.cadran;
  With AChild.cadran, PaintBoxIncli, PaintBoxIncli.Canvas do
  begin
    if Typ = Bifilaire then
      IncliEdit.Value := 90;
    r := width div 2;
    w := width;
    h := height;
    a := IncliEdit.Value;
    If IncliEdit.Value < 180 then
      a := a + IncliMinEdit.Value / 60;
    a := a / 180 * pi;
    Pen.Color := ClBlack;
    Brush.Color := ClWhite;
    rectangle(0, 0, width, height);
    Pen.Color := ClBlue;
    moveto(round(r - r * cos(a)), round(r - r * sin(a)));
    lineto(round(r + r * cos(a)), round(r + r * sin(a)));
    a := a + pi / 2;
    Pen.Color := ClRed;
    moveto(round(r), round(r));
    lineto(round(r - r * cos(a) / 4), round(r - r * sin(a) / 4));
  end;

end;

procedure TParam.PageControlChange(Sender: TObject);
begin
  DecliEditChange(Sender);
  IncliEditChange(Sender);
end;

procedure TParam.AppliquerBtnClick(Sender: TObject);
begin
  AChild := TFormCadsol(Mainform.ActiveMDIChild);
  OKButtonClick(Sender);

  AChild.refresh;
  if formCadsol3d.Visible then
  begin
    formCadsol3d.Setfocus;
    formCadsol3d.Formactivate(Sender);
    Self.Setfocus;
  end;
  VisuCadMultipleForm.refresh;
end;

procedure TParam.AutoFilsButtonClick(Sender: TObject);
begin
  with AChild.cadran do
  begin
    FilHorEdit.Value := Hauteur div 100;
    FilVerEdit.Value := (Hauteur div 100) * 6 div 5;
    xfilEdit.Value := 0;
    yFilEdit.Value := Hauteur div 50;
  end;
end;

end.
