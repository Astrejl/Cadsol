unit uCfaranMultiple;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls;

type
  TCadranMultipleForm = class(TForm)
    Bevel1: TBevel;
    nbCadLargeurEdit: TSpinEdit;
    NbCadHauteurEdit: TSpinEdit;
    NbCadHauteurLbl: TLabel;
    NbCadLargeurLbl: TLabel;
    Label3: TLabel;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    Bevel2: TBevel;
    LargeurtotEdit: TSpinEdit;
    SpinEdit2: TSpinEdit;
    HauteurTot: TLabel;
    Label4: TLabel;
    Label2: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  CadranMultipleForm: TCadranMultipleForm;

implementation

{$R *.dfm}

end.
