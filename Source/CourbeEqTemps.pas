unit CourbeEqTemps;

interface

uses

  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, ExtCtrls,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series,
  Buttons, ExtDlgs, VclTee.TeeGDIPlus,VclTee.teePrevi, VCLTee.TeeEdiGrad,
  VCLTee.TeePenDlg, VCLTee.TeCanvas;

type
  TFormCourbeEqTemps = class(TForm)
    Chart1: TChart;
    Series1: TLineSeries;
    Panel1: TPanel;
    PrintButton: TButton;
    OKBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    // procedure Chart1Click(Sender: TObject);
    // procedure EditButnClick(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure Chart1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormCourbeEqTemps: TFormCourbeEqTemps;

implementation

{$R *.DFM}

uses Cadvar, Main, FCadsol, cadtrace;

procedure TFormCourbeEqTemps.Chart1Click(Sender: TObject);
begin

   Chart1.View3D:= Not Chart1.View3D;

end;

procedure TFormCourbeEqTemps.FormCreate(Sender: TObject);
var
  j: integer;
  x, y: double;
begin
   for j := 1 to 365 do
  begin
    y := -EqduTemps(j) / 60;
    x := encodedate(2000, 1, 1) + j - 1;
    Series1.AddXY(x, y, '', clBlue); (* radians *)
  end;
end;

procedure TFormCourbeEqTemps.PrintButtonClick(Sender: TObject);
begin
   VclTee.teePrevi.TeePreview(Self,Chart1);
end;

procedure TFormCourbeEqTemps.OKBitBtnClick(Sender: TObject);
begin
  Close;
end;
end.






