unit Typecad;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, jpeg;

type
  TTypeCadDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
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

    Procedure BtnRadClick(Sender:TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TypeCadDlg: TTypeCadDlg;

implementation

{$R *.DFM}

uses sysutils,fcadsol,uvisucadMultiple;

Procedure TTypeCadDlg.BtnRadClick(Sender:TObject);
 begin
   Image1.Visible := VertBtn.Checked;
   Image2.Visible := AnalemBtn.Checked;
   Image3.Visible := HauteurBtn.Checked;
   Image4.Visible := BifilBtn.Checked;
 end;

procedure TTypeCadDlg.FormActivate(Sender: TObject);
begin
      // BifilBtn.Visible  :=Not VisuCadMultipleForm.Visible ;
       HauteurBtn.Visible:=Not VisuCadMultipleForm.Visible ;
       AnalemBtn.Visible :=Not VisuCadMultipleForm.Visible ;
end;

end.
