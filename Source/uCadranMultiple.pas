unit uCadranMultiple;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

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
    HauteurTotEdit: TSpinEdit;
    HauteurTotLabl: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    SpinEditMarge: TSpinEdit;
    Image1: TImage;
    procedure OKBtnClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  CadranMultipleForm: TCadranMultipleForm;

implementation

{$R *.dfm}


procedure TCadranMultipleForm.OKBtnClick(Sender: TObject);
begin
 if NbCadHauteurEdit.Value * NbCadLargeurEdit.Value=1 then begin
  Application.MessageBox('Un cadran multiple doit contenir au moins deux cadrans!', Pchar(Caption),MB_OK);
  ModalResult:=MRNone;
 end;

end;

End.
