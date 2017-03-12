unit Resume;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Buttons, Dialogs, ComCtrls;

type

  TResumeDlg = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel: TPanel;
    Memo1: TMemo;
    PoliceButton: TSpeedButton;
    FontDialog1: TFontDialog;
    procedure FormActivate(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ImprimeInfo;
    Procedure AfficheInfo;
    procedure PoliceButtonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  end;

var
  ResumeDlg: TResumeDlg;

implementation

{$R *.DFM}

uses Printers, Main, FCadsol, Cadtrace, Cadvar, math;

var
  AChild: TFormCadsol;
  r: trect;
  Texte: Tampon;

Procedure TResumeDlg.AfficheInfo;
var
  s, s1, s2: string;
  l, a: real;
  narcs, i, j, k, m: integer;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with AChild.Cadran, Memo1.lines do
  begin
    Caption := NomFichier;
    Clear;
    Add('');
    Add('CADRAN:' + NomFichier);
    Add('____________________________________________');
    Add('   Date d''édition :' + DateTimeToStr(Now));
    Add('    (C)Copyright ' + Application.title);
    Add('____________________________________________');

    Add('');
    Add(Commentaire);
    Add('');
    Add('TYPE: ' + chTcad[Typ]);

    Add('DIMENSIONS');

    str(Largeur div 10: 5, s);
    Add('  Largeur : ' + s + 'mm');
    str(Hauteur div 10: 5, s);
    Add('  Hauteur : ' + s + 'mm');
    if Typ = MontreSol then
    begin
      str((Largeur / pi / 10): 7: 1, s);
      Add('  Diamètre:' + s + 'mm');
      l := LStyleMs(Hauteur, Lati) / 10;
      str(l: 7: 1, s);
      Add('  Style:' + s + 'mm');
    end;
    if Typ = Analemmatique then
    begin
      str(Grand_axe div 10: 5, s);
      Add('  Demi grand axe : ' + s + 'mm');
      str(Petit_axe div 10: 5, s);
      Add('  Demi petit axe : ' + s + 'mm');
    end;

    Add('POSITION Géographique');

    str(abs(Lati): 7: 3, s);
    s1 := '';
    if Lati > 0 then
      s1 := 'Nord';
    if Lati < 0 then
      s1 := 'Sud';
    Add('  Latitude  : ' + s + '° ' + s1);
    str(abs(Longi): 7: 3, s);
    s1 := '';
    if Longi < 0 then
      s1 := 'Est';
    if Longi > 0 then
      s1 := 'Ouest';
    Add('  Longitude : ' + s + '° ' + s1);

    if (Typ = Vertical) or (Typ = Bifilaire) then
    begin

      Add('ORIENTATION');

      str(abs(Decli): 10: 3, s);
      s1 := '';
      if Decli > 0 then
        s1 := 'Est';
      if Decli < 0 then
        s1 := 'Ouest';
      Add('  Déclinaison : ' + s + '° ' + s1);
      Add('  (0°:plein Sud, 180°:plein Nord, 90°:occidental ou oriental)');
      str(abs(Incli): 10: 3, s);
    end;
    if Typ = Vertical then
    begin
      Add('  Inclinaison : ' + s + '° ');
      Add('  (0°:horizontal, 90°:vertical)');

      Add('STYLE');

      str(hStyle div 10: 5, s);
      Add('  Longueur du style droit : ' + s + 'mm');
      Add('    (orthogonalement au plan du cadran)');
      str(gx div 10: 5, s1);
      str(gy div 10: 5, s2);
      Add('  Position du style droit :' + s1 + 'mm ' + s2 +
        'mm   (0,0:centre du cadran)');
      l := sqrt((Px - gx) * (Px - gx) + (Py - gy) * (Py - gy) + hStyle
        * hStyle);
      if l < 30000 then
      begin
        str(Px / 10: 7: 1, s1);
        str(Py / 10: 7: 1, s2);
        Add('  Pole du style  :' + s1 + 'mm' + s2 +
          'mm   (0,0:centre du cadran) ');
        str((l / 10): 7: 1, s);
        Add('  Longueur du style:' + s + 'mm');
        l := sqrt((Px - gx) * (Px - gx) + (Py - gy) * (Py - gy));
        str((l / 10): 7: 1, s);
        Add('  Longueur sous-stylaire:' + s + 'mm');
        if gy <> Py then
          a := arctan((gx - Px) / (gy - Py)) / pi * 180
        else
          a := 90;
        if l <> 0 then
          Add('  Angle sous-stylaire,axe vertical: ' + FloattostrF(a, ffFixed,
            7, 1) + '°');
        if l <> 0 then
        begin
          a := arctan(hStyle / l) / pi * 180;
          Add('  Angle style,sous-stylaire: ' + FloattostrF(a, ffFixed, 7,
            1) + '°');
        end;
      end
      else
        Add('  Style parallèle au plan du cadran');
    end;

    if Typ = Bifilaire then
    begin
      Add('FILS');
      str(hStyle div 10: 5, s);
      Add('  Distance Cadran - Fil horizontal: ' + s + 'mm');
      str(distance div 10: 5, s);
      Add('  Distance Cadran - Fil vertical  : ' + s + 'mm');
      str(gx div 10: 5, s1);
      str(gy div 10: 5, s2);
      Add('  Croisement des fils :' + s1 + 'mm ' + s2 +
        'mm   (0,0:centre du cadran)')
    end;

    if Typ in [Vertical, Analemmatique, Bifilaire] then
    begin
      narcs := 0;
      for i := 1 to NbDates do
        if DateArc[i].jour * DateArc[i].mois <> 0 then
          inc(narcs);
      if (narcs > 0) or arcs_diurnes then
      begin

        if Typ in [Vertical, Bifilaire] then
          Add('ARCS DIURNES')
        else
          Add('POSITIONS DU STYLE');

        narcs := 0;
        s := '';
        for i := 1 to NbDates do
          if DateArc[i].jour * DateArc[i].mois <> 0 then
          begin
            inc(narcs);
            j := DateArc[i].jour;
            m := DateArc[i].mois;
            // if (narcs mod 8=0) then strcat(Texte,NL);
            str(j: 2, s1);
            str(m: 2, s2);
            compacter(s1);
            compacter(s2);
            s := s + '  ' + s1 + '/' + s2;
          end;
        if narcs > 0 then
          Add(s);
        if arcs_diurnes then
          Add('  Solstices et équinoxes.');
        str(Precision: 2, s1);
        if Typ = Vertical then
          Add('  Précision du tracé:' + s1 + ' minute(s)');
      end;
    end;

    if Typ <> Vide then
    begin

      Add('HEURES');
      if heure_sol then
        Add('  Heures solaires');
      if demi_heure then
        Add('  Demi-heures');
      if hsin then
        Add('  Heures sinueuses');
      if Decalage >= 0 then
        s := '+'
      else
        s := '-';
      if DecalMin <> 0 then
        s1 := '  ' + IntToStr(DecalMin) + ' Min.'
      else
        s1 := '';
      if heure_legale then
        Add('  Heure légale (avec correction de la longitude) GMT ' + s +
          IntToStr(abs(Decalage)) + 'h. ' + s1);
      if Typ in [Vertical, Bifilaire] then
      begin
        if eq_temps_hiver then
          Add('  Heures avec Equation du temps (du 21/12 au 21/6 )');
        if eq_temps_ete then
          Add('  Heures avec Equation du temps (du 21/6  au 21/12)');
        if eq_temps_hiver or eq_temps_ete or hsin then
        begin
          Add('    Intervalle entre deux tracés:' + IntToStr(Intervalle) +
            ' minutes');
          Add('    Précision des tracés:' + IntToStr(Increment) + ' jours');
        end;
        if heure_bab then
          Add('  Heures babyloniques');
        if heure_ita then
          Add('  Heures italiques');
        if heure_temp then
          Add('  Heures antiques (ou inégales)');
      end;
      if Typ = MontreSol then
      begin
        if eq_temps_hiver then
          Add('  Heures avec Equation du temps');
        if eq_temps_hiver then
          Add('    Précision des tracés:' + IntToStr(Increment) + ' jours');
      end;
      if devise <> '' then
        Add('DEVISE: ' + devise);
    end;
  end; (* with *)
end;

procedure TResumeDlg.FormActivate(Sender: TObject);
begin
  AfficheInfo;
end;

procedure TResumeDlg.ImprimeInfo;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  Printer.title := AChild.Cadran.NomFichier;
  Printer.beginDOC;
  r := Bounds(0, 0, Printer.PageWidth, Printer.PageHeight);
  Memo1.GetTextBuf(Texte, Memo1.GetTextLen);
  Printer.Canvas.font.Assign(Memo1.font);
  Drawtext(Printer.Canvas.Handle, Texte, StrLen(Texte), r, dt_wordbreak or
    dt_calcRect);
  Drawtext(Printer.Canvas.Handle, Texte, StrLen(Texte), r, dt_wordbreak);
  r := Rect(0, r.bottom + 50, Printer.PageWidth, Printer.PageHeight);
  PaintChild(AChild.Cadran, Printer.Canvas, r);
  Printer.EndDOC;
end;

// (0, 3086, 4810, 6903, (0, 3086), (4810, 6903))
procedure TResumeDlg.PrintButtonClick(Sender: TObject);
begin;
  if messageBox(Handle, 'Impression?', 'Fiche CADSOL',
    MB_YESNO + MB_ICONQUESTION) = IDYES then
    ImprimeInfo;
end;

procedure TResumeDlg.PoliceButtonClick(Sender: TObject);

begin
  //FontDialog1.Options := FontDialog1.Options + [fdApplyButton];
  if FontDialog1.Execute then
    Memo1.font.Assign(FontDialog1.font);

end;

procedure TResumeDlg.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.


