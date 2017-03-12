unit Zoom;

interface

uses
  Windows, WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Vcl.StdCtrls,uFormAJL;

type
  TZoomForm = class(TFormAJL)
    LabelCoord: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    P: Tpoint;
    dc: hdc;
    { Déclarations privées }
  public
    Zx, Zy: integer;
    { Déclarations publiques }
  end;

var
  ZoomForm: TZoomForm;

implementation

{$R *.DFM}

uses Main, Cadvar, Cadtrace, FCadsol,cadtrace3D;

Var
  AChild: TFormCadsol;

procedure TZoomForm.FormPaint(Sender: TObject);
begin

  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if AChild <> nil then
  begin
    Self.Caption := 'Loupe: ( ' + inttostr(Zx div 10) + ' ; ' + inttostr(Zy div 10) + ' )';
    Canvas.Brush.color := AChild.Cadran.ClFond;
    Canvas.pen.width := 0;
    Canvas.pen.style := psSolid;
    Canvas.pen.color := AChild.Cadran.ClFond;
    Canvas.Brush.color := AChild.Cadran.clCadran;
    Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
    dc := Canvas.handle;
    setMapMode(dc, MM_LOMETRIC);
    SetViewPortOrgEx(dc, ClientWidth div 2, ClientHeight div 2, nil);
    TraceCadran(AChild.Cadran, Canvas, -Zx, -Zy);
    FormCadsol3D.Refresh;
  end
  else
  begin
    Caption := '';
    Canvas.pen.style := psSolid;
    Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  end;
end;

procedure TZoomForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if AChild <> nil then
  begin
    AChild.Zoom1.Checked := false;
    AChild.Cursor := crDefault;
    Action := cahide;
  end;
end;

procedure TZoomForm.FormActivate(Sender: TObject);
begin
  AChild := TFormCadsol(MainForm.ActiveMDIChild);
  if AChild <> nil then
  begin
    dc := Canvas.handle;
    setMapMode(dc, MM_LOMETRIC);
    SetViewPortOrgEx(dc, ClientWidth div 2, ClientHeight div 2, nil);
    P.x := AChild.Cadran.Largeur;
    P.y := AChild.Cadran.Hauteur;
    (* LptoDp(dc,P,1);
      VertScrollBar.Range:=P.Y;
      P.x:=achild.Cadran.Largeur; P.y:=achild.Cadran.Hauteur;
      LptoDp(dc,P,1);
      VertScrollBar.Range:=P.Y;
      P.x:=zx; P.y:=zy;
      LptoDp(dc,P,1);
      VertScrollBar.position:=P.Y; *)
  end;
end;

end.
