unit Heurecad;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls,uFormAJL;

type
  THeureDlg = class(TFormAJL)
    DatePicker: TDateTimePicker;
    TimePicker: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    HDButton: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HDButtonClick(Sender: TObject);
    procedure TimePickerChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeureDlg: THeureDlg;

implementation

uses cadvar, main,FCadsol,cadtrace3D;
{$R *.DFM}

procedure THeureDlg.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure THeureDlg.FormActivate(Sender: TObject);
begin
  OmbreStyle := True;
  DatePicker.Date := Int(HeureCadran);
  TimePicker.time := Frac(HeureCadran);
  Mainform.itemOmbredustyle.Checked:=True;
  Mainform.AfficheHeure;
end;

procedure THeureDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var achild:TFormCadsol; i:integer;
begin
 OmbreStyle:=False;
 MainForm.itemOmbredustyle.Checked:=False;
 For i:=1 to MainForm.MDIChildCount do MainForm.MDIChildren[i-1].Refresh;
end;

procedure THeureDlg.HDButtonClick(Sender: TObject);
begin
  HeureCadran := Now;
  OmbreStyle := True;
  DatePicker.Date := Int(HeureCadran);
  TimePicker.time := Frac(HeureCadran);
  Mainform.AfficheHeure;
end;

procedure THeureDlg.TimePickerChange(Sender: TObject);
begin
  HeureCadran := Frac(TimePicker.time) + Int(DatePicker.Date);
  OmbreStyle := True;
  Mainform.AfficheHeure;


end;

end.




