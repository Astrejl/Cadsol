unit Analemna;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, StdCtrls, Buttons, ExtCtrls,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series,
  VclTee.TeeGDIPlus,  VclTee.teeprevi ;

type
  TFormAnalemna = class(TForm)
    Chart1: TChart;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    ImprimerBtn: TBitBtn;
    Series1: TPointSeries;
    procedure FormCreate(Sender: TObject);
    procedure ImprimerBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormAnalemna: TFormAnalemna;

implementation

uses Cadvar, Main, cadtrace;
{$R *.DFM}

procedure TFormAnalemna.FormCreate(Sender: TObject);
var
  j: integer;
  x, y: double;
begin
  for j := 1 to 365 do
  begin
    y := Declisol(j) / pi * 180;
    x := EqduTemps(j) / 60;
    Series1.AddXY(x, y, '', clBlue); (* radians *)
    // EqTemps[j].decsol:=Declisol(j);            (*radians*)
  end;
end;

procedure TFormAnalemna.ImprimerBtnClick(Sender: TObject);
begin
  
  VclTee.teePrevi.TeePreview(Self,Chart1);



  //Chart1.PreviousPage;
  //VclTee.TeeGDIPlus.(Self, Chart1);
end;

procedure TFormAnalemna.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.
