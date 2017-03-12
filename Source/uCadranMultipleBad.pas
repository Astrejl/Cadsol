unit uCadranMultipleBad;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Samples.Spin, OKCANCL1;

type
  TCadranMultipleDlg = class(TForm)
    HelpBtn: TButton;
    nbCadLargeurEdit: TSpinEdit;
    NbCadHauteurEdit: TSpinEdit;
    NbCadHauteurLbl: TLabel;
    NbCadLargeurLbl: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    procedure HelpBtnClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  CadranMultipleDlg: TCadranMultipleDlg;

implementation

{$R *.dfm}

procedure TCadranMultipleDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

end.
 
