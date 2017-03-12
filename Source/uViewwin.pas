unit uViewwin;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Jpeg, Menus;

type
  TViewForm = class(TForm)
    Image1: TImage;
    PopupMenu: TPopupMenu;
    ItemFermer: TMenuItem;
    Ajuster1: TMenuItem;
    Imprimer1: TMenuItem;

    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewFormPhoto: TViewForm;

implementation

uses Main, FCadsol;

Var
  AChild: TFormCadsol;

{$R *.DFM}

procedure TViewForm.FormActivate(Sender: TObject);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if AChild.Cadran.NFPhoto <> '' then
  begin
    Image1.Picture.loadfromFile(AChild.Cadran.NFPhoto);
    ClientHeight := Image1.Picture.Height;
    ClientWidth := Image1.Picture.Width;
    Caption := ExtractFileName(AChild.Cadran.NFPhoto) + '  (' +
      IntToStr(Image1.Width) + 'x' + IntToStr(Image1.Height) + ')';
  end;
end;

end.

