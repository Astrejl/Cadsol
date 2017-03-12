unit UnitEssaiFormAJL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,uFormAJL, Vcl.Buttons, Vcl.StdCtrls;

type
  TEssaiFormAJL = class(TFormAJL)
    BitBtn1: TBitBtn;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  EssaiFormAJL: TEssaiFormAJL;

implementation

{$R *.dfm}

end.
