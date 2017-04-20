program ProjectFormAJL;

uses
  Vcl.Forms,
  uFormAJL in 'uFormAJL.pas' {FormAJL},
  UnitEssaiFormAJL in 'UnitEssaiFormAJL.pas' {EssaiFormAJL};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'EssaiFormAJL';
  Application.CreateForm(TEssaiFormAJL, EssaiFormAJL);
  Application.Run;
end.
