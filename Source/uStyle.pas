unit uStyle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,Vcl.Themes;


type
  TFormStyle = class(TForm)
    cbxVclStyles: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FStyle: TFormStyle;

implementation
       uses  FCadsol,Main,Parametre,CadTrace3D,Position,uCouleurs,uVisuCadMultiple,HeureCad,Zoom,
  typeCad;
{$R *.dfm}

procedure TFormStyle.BitBtn1Click(Sender: TObject);
 Var i:Integer;
begin
  for i := 0 to MainForm.MDIChildCount - 1 do TFormCadsol(MainForm.MDIChildren[i]).Close;
  Param.Close;
  FormCadsol3D.Close;
  PositionForm.Close;
  CouleursDlg.Close;
  if VisuCadMultipleForm<>nil then VisuCadMultipleForm.Hide;
  HeureDlg.Close;
  ZoomForm.Close;
  TypeCadDlg.Close;

  try
   TStyleManager.TrySetStyle(cbxVclStyles.Text,True);
  finally
    close;
  end;
end;

procedure TFormStyle.FormActivate(Sender: TObject);
var
  StyleName: string;
begin
  cbxVclStyles.Clear;
  for StyleName in TStyleManager.StyleNames do
    if StyleName<>'Windows' then cbxVclStyles.Items.Add(StyleName);
  cbxVclStyles.ItemIndex := cbxVclStyles.Items.IndexOf(TStyleManager.ActiveStyle.Name);
end;

end.


