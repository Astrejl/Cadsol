unit uVisuCadMultiple;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cadvar,Vcl.Menus,uFormAJL,CadTrace3D;

type
  TVisuCadMultipleForm = class(TFormAJL)
    MainMenu1: TMainMenu;
    Imprimer1: TMenuItem;
    Enregister1: TMenuItem;
    Enregistrersous1: TMenuItem;
    Imprimer2: TMenuItem;
    Affichage1: TMenuItem;
    Pages1: TMenuItem;
    N1: TMenuItem;
    ItemProprietes: TMenuItem;
    Vue3D1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Imprimer2Click(Sender: TObject);
    procedure Pages1Click(Sender: TObject);
    procedure ItemProprietesClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Vue3D1Click(Sender: TObject);
  //  procedure ItemVue3D1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  VisuCadMultipleForm: TVisuCadMultipleForm;

implementation

{$R *.dfm}

uses main, Fcadsol;


procedure TVisuCadMultipleForm.FormActivate(Sender: TObject);
begin
  Refresh;
  FormCadSol3D.Refresh;
end;

procedure TVisuCadMultipleForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaMinimize;
end;

procedure TVisuCadMultipleForm.FormHide(Sender: TObject);
var s1,s2:String;
begin
  if CadranMultiple.Modif then
  begin
    S1 := 'Enregistrer les modifications dans le fichier:'#13#10 + '   ' +
      CadranMultiple.Nomfichier;
    S2 := self.Caption;
    if application.MessageBox(PChar(S1), PChar(S2), mb_yesno + mb_iconquestion)
      = idyes then
      EcrireCadranSolMultiple(CadranMultiple, CadranMultiple.Nomfichier);

    Mainform.CommentPanel.Caption := '';
    Mainform.LatiPanel.Caption := '';
    Mainform.LongiPanel.Caption := '';
    // Zoomform.Close;
  end;
end;

procedure TVisuCadMultipleForm.FormPaint(Sender: TObject);
var
  i, j, l, h: integer;
  C: Trect;
begin
  C := VisuCadMultipleForm.ClientRect;
  PaintChild(CadranMultiple, Canvas, C);
  //FormCadsol3D.Refresh;

end;

procedure TVisuCadMultipleForm.FormResize(Sender: TObject);
begin
  Refresh;
  //FormCadsol3D.Refresh;
end;

procedure TVisuCadMultipleForm.Imprimer2Click(Sender: TObject);
begin
  SortieImprimante(CadranMultiple, VisuCadMultipleForm.Canvas);
end;

procedure TVisuCadMultipleForm.ItemProprietesClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Dimensions: '+ IntToStr(CadranMultiple.LargeurTot div 10)+' x '+ IntToStr(CadranMultiple.HauteurTot div 10)+ 'mm')
end;


procedure TVisuCadMultipleForm.Pages1Click(Sender: TObject);
begin
  CadranMultiple.NumPage := Self.Pages1.Checked;
  Refresh;
end;

procedure TVisuCadMultipleForm.Vue3D1Click(Sender: TObject);
begin
inherited;
FormCadsol3D.Show;
FormCadsol3D.ItemLecadranmultipleClick(sender);
end;

end.
