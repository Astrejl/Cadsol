unit uSiteWebCadsol;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw,uFormAJL;

type
  TSiteWeb = class(TFormAJL)
    WebBrowser1: TWebBrowser;
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  SiteWeb: TSiteWeb;

implementation
  uses Main;
{$R *.dfm}

procedure TSiteWeb.FormActivate(Sender: TObject);
begin
  WebBrowser1.Navigate('http://www.cadsol.fr');
end;

end.
