unit Assist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TAssistForm = class(TForm)
    Image1: TImage;
    PrecedentBtn: TBitBtn;
    SuivantBtn: TBitBtn;
    OKBtn: TBitBtn;
    AbortBtn: TBitBtn;
    Texte: TLabel;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  AssistForm: TAssistForm;

implementation

{$R *.DFM}

end.
