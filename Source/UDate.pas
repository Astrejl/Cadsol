unit UDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Calendar, Spin, Vcl.Mask, FnpNumericEdit;

type
  TFDate = class(TForm)
    MoisEdit: TSpinEdit;
    Mois: TLabel;
    Jour: TLabel;
    JourEdit: TSpinEdit;
    Calendar: TCalendar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    //DecsolEdit: TJVCalcEdit;
    Label1: TLabel;
    FnpNumericEdit1: TFnpNumericEdit;
    procedure MoisEditChange(Sender: TObject);
    procedure JourEditChange(Sender: TObject);
    procedure CalendarChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FDate: TFDate;

implementation

uses Cadvar, Cadtrace;
{$R *.DFM}

var
  j, m: integer;

procedure TFDate.MoisEditChange(Sender: TObject);
begin
  Calendar.Month := MoisEdit.Value;
end;

procedure TFDate.JourEditChange(Sender: TObject);
begin
  Calendar.Day := JourEdit.Value;
end;

procedure TFDate.CalendarChange(Sender: TObject);

begin
  JourEdit.Value := Calendar.Day;
  MoisEdit.Value := Calendar.Month;
  j := Calendar.Day;
  m := Calendar.Month;
  FnpNumericEdit1.Value := EqTemps[JourAn(j, m)].decsol / pi * 180;
end;

procedure TFDate.FormActivate(Sender: TObject);
begin
  j := Calendar.Day;
  m := Calendar.Month;
  FnpNumericEdit1.Value := EqTemps[JourAn(j, m)].decsol / pi * 180;
end;

procedure TFDate.BitBtn1Click(Sender: TObject);
begin
  j := Calendar.Day;
  m := Calendar.Month;
  if (FnpNumericEdit1.Value >= -23.43915) and (FnpNumericEdit1.Value <= 23.43915) then
    EqTemps[JourAn(j, m)].decsol := FnpNumericEdit1.Value / 180 * pi;
end;

end.
