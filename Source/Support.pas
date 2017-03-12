unit Support;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Buttons, ComCtrls;

type
  TDecliSupport = class(TForm)
    BitBtn1: TBitBtn;
    DatePicker: TDateTimePicker;
    Label2: TLabel;
    TimePicker: TDateTimePicker;
    Panel1: TPanel;
    EqTempsLbl: TStaticText;
    DecSolLbl: TStaticText;
    AzLbl: TLabel;
    HmeriLocLb: TStaticText;
    ImpressionBtn: TBitBtn;
    Bevel1: TBevel;
    LongiText: TStaticText;
    LatiText: TStaticText;
    LatiBtn: TBitBtn;
    HLeverLbl: TLabel;
    HCoucherLbl: TLabel;
    HauteurSolLb: TLabel;
    procedure LongiBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DatePickerChange(Sender: TObject);
    procedure LatiBtnClick(Sender: TObject);
    procedure ImpressionBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    procedure AfficheLbl;
  end;

var
  DecliSupport: TDecliSupport;

implementation

uses Main, FCadsol, cadvar, cadtrace, trigo, position;
{$R *.DFM}

Var
  AChild: TFormCadsol;

procedure AfficheLongi;
Var
  s: String;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with AChild.Cadran do
  begin
    s := FloattostrF(abs(Longi), ffGeneral, 3, 0) + '°';
    s := 'Longitude: ' + s;
    if Longi > 0 then
      s := s + 'Ouest';
    if Longi < 0 then
      s := s + 'Est';
    s := s + '  Heure: GMT  ';
    if Decalage >= 0 then
      s := s + '+'
    else
      s := s + '-';
    s := s + IntToStr(abs(Decalage)) + ' h.';
    if DecalMin <> 0 then
      s := s + '  ' + IntToStr(DecalMin) + ' Min.';
  end;
  DecliSupport.LongiText.Caption := s;
end;

procedure AfficheLati;
Var
  s: String;
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  with AChild.Cadran do
  begin
    s := FloattostrF(abs(Lati), ffGeneral, 3, 0) + '°';
    s := 'Latitude: ' + s;
    if Lati > 0 then
      s := s + 'Nord';
    if Lati < 0 then
      s := s + 'Sud';
  end;
  DecliSupport.LatiText.Caption := s;
end;

(* Function TMLocalDiag.DecMur;
  var hv,dm,ds,phi,deno:real;
  ja:integer;

  begin
  ja:=JourAn(nj,nm);
  if ja<>0 then with cadran do begin
  hv:=hPlan+MPlan/60-EqTemps[JourAn(nj,nm)].Eqt*12/pi+Longi/15-decalage;
  hv:=(hv-12)/12*pi;
  ds:=EqTemps[JourAn(nj,nm)].DecSol;
  Phi:=abs(DegToRad(lati));
  deno:=sin(Phi)*cos(hv)-tan(ds)*cos(Phi);
  if deno<>0 then dm:=arcTan(sin(hv)/deno) else dm:=Pi;
  DecMur:=90-dm/pi*180;
  end;
  end; *)

procedure TDecliSupport.AfficheLbl;
var
  Year, Month, Day, Hour, Min, Sec, MSec: word;
  mm, dd, eq, decmur, ds, Mins, secs: integer;
  hv, phi, deno, dm, az, hl, hc, dj, ha: real;
  s: string;
begin
  DecodeDate(DatePicker.Date, Year, Month, Day);
  DecodeTime(TimePicker.Time, Hour, Min, Sec, MSec);
  mm := Month;
  dd := Day;
  secs := round(EqDuTemps(jourAn(dd, mm)));
  secs := round(secs / 20) * 20;
  Mins := secs div 60;
  secs := secs mod 60;
  s := 'Equation du temps: ' + IntToStr(Mins) + ' Minutes ' + IntToStr(secs) +
    ' Secondes';
  EqTempsLbl.Caption := s;
  dm := DecliSol(jourAn(dd, mm)) / pi * 180;
  dm := round(dm * 10) / 10;
  s := 'Déclinaison du soleil à midi: ' + FloattostrF(dm, ffGeneral, 4, 0) +
    ' Degrés';
  DecSolLbl.Caption := s;

  with AChild.Cadran do
  begin
    hv := Hour + Min / 60 + Sec / 3600 + EqTemps[jourAn(dd, mm)].Eqt * 12 / pi -
      Longi / 15 - Decalage - DecalMin / 60;
    hv := (hv - 12) / 12 * pi;
    phi := abs(Lati / 180 * pi);
    deno := sin(phi) * cos(hv) - tan(EqTemps[jourAn(dd, mm)].DecSol) * cos(phi);
    if deno <> 0 then
      az := arcTan(sin(hv) / deno)
    else
      az := pi;
    az := round(az / pi * 180 * 10) / 10;
    if (hv > 0) and (az < 0) then
      az := az + 180;
    if (hv < 0) and (az > 0) then
      az := az - 180;
    s := 'Azimuth: ' + FloattostrF(abs(az), ffFixed, 5, 1) + ' Degrés';
    if az > 0 then
      s := s + 'Ouest';
    if az < 0 then
      s := s + 'Est';
    AzLbl.Caption := s;
    ha := HautSol(hv, DecliSol(jourAn(dd, mm)), Lati / 180 * pi) / pi * 180;
    s := 'Hauteur:  ' + FloattostrF(ha, ffFixed, 5, 1) + ' Degrés';
    HauteurSolLb.Caption := s;

    s := 'Passage du soleil au méridien local à ';
    Min := round((12 - EqTemps[jourAn(dd, mm)].Eqt * 12 / pi + Longi / 15 +
      Decalage + DecalMin / 60) * 60);
    Hour := Min div 60;
    Min := Min mod 60;
    s := s + IntToStr(Hour) + 'h ' + IntToStr(Min) + 'm';
    HmeriLocLb.Caption := s;

    dj := DemiJour(DecliSol(jourAn(dd, mm)), Lati / 180 * pi) / pi * 12;
    if (dj < 1 / 60) then
    begin
      HLeverLbl.Caption := 'Nuit permanente';
      HCoucherLbl.Caption := '';
    end;
    if dj > (12 - 1 / 60) then
    begin
      HLeverLbl.Caption := 'Jour permanent';
      HCoucherLbl.Caption := '';
    end;
    if (dj >= 1 / 60) and (dj <= (12 - 1 / 60)) then
    begin
      hl := 12 - dj;
      s := 'Lever du soleil à ';
      Min := round((hl - EqTemps[jourAn(dd, mm)].Eqt * 12 / pi + Longi / 15 +
        Decalage + DecalMin / 60) * 60);
      Hour := Min div 60;
      Min := Min mod 60;
      s := s + IntToStr(Hour) + 'h ' + IntToStr(Min) + 'm';
      HLeverLbl.Caption := s;
      hc := 12 + dj;
      s := 'Coucher du soleil à ';
      Min := round((hc - EqTemps[jourAn(dd, mm)].Eqt * 12 / pi + Longi / 15 +
        Decalage + DecalMin / 60) * 60);
      Hour := Min div 60;
      Min := Min mod 60;
      s := s + IntToStr(Hour) + 'h ' + IntToStr(Min) + 'm';
      HCoucherLbl.Caption := s;
    end;
  end;
end;

procedure TDecliSupport.FormActivate(Sender: TObject);
begin
  AfficheLati;
  AfficheLongi;
  AfficheLbl;
end;

procedure TDecliSupport.FormCreate(Sender: TObject);
begin
  DatePicker.Date := Now;
  TimePicker.Time := Now;
end;

procedure TDecliSupport.DatePickerChange(Sender: TObject);
begin
  AfficheLbl;
end;

procedure TDecliSupport.LongiBtnClick(Sender: TObject);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if PositionForm.ShowModal = MrOk then
  begin
    AfficheLongi;
    AfficheLati;
    AChild.Cadran.Modif := True;
    AChild.Refresh;
    AfficheLbl;
  end;
end;

procedure TDecliSupport.LatiBtnClick(Sender: TObject);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if true (*PositionForm.ShowModal = MrOk*) then
  begin
    AfficheLati;
    AfficheLongi;
    AfficheLbl;
    AChild.Cadran.Modif := True;
    AChild.Refresh;
  end;
end;

procedure TDecliSupport.ImpressionBtnClick(Sender: TObject);
begin
  if messageBox(Handle, 'Impression?', 'Azimuth CADSOL',
    MB_YESNO + MB_ICONQUESTION) = IDYES then
    Print;
end;

procedure TDecliSupport.BitBtn1Click(Sender: TObject);
begin
  close
end;

end.
