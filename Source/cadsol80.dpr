// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
program cadsol80;

uses
  WINPROCS,
  sysutils,
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  CADTRACE in 'CADTRACE.PAS',
  TRIGO in 'TRIGO.PAS',
  typeCad in 'typeCad.PAS' {TypeCadDlg},
  uCouleurs in 'uCouleurs.pas' {CouleursDlg},
  SPLASH in 'SPLASH.PAS' {SplashForm},
  Parametre in 'Parametre.pas' {Param},
  UDate in 'UDate.pas' {FDate},
  Commentaire in 'Commentaire.pas' {CommentDlg},
  Resume in 'Resume.pas' {ResumeDlg},
  cadvar in 'cadvar.pas',
  InfoSys in 'InfoSys.pas' {FormInfoSys},
  Support in 'Support.pas' {DecliSupport},
  Position in 'Position.pas' {PositionForm},
  Zoom in 'Zoom.pas' {ZoomForm},
  uViewwin in 'uViewwin.pas' {ViewForm},
  Assist in 'Assist.pas' {AssistForm},
  Heurecad in 'Heurecad.pas' {HeureDlg},
  CadTrace3D in 'CadTrace3D.pas' {FormCadsol3D},
  Vcl.Themes,
  Vcl.Styles,
  APROPOS2 in 'APROPOS2.PAS' {FormAPropos},
  FCADSOL in 'FCADSOL.PAS' {MDIChild},
  uCadranMultiple in 'uCadranMultiple.pas' {CadranMultipleForm},
  uVisuCadMultiple in 'uVisuCadMultiple.pas' {VisuCadMultipleForm},
  uFormAJL in 'uFormAJL.pas' {FormAJL},
  uStyle in 'uStyle.pas' {FormStyle},
  uFenetres in 'uFenetres.pas';

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Tablet Light');
  Application.Title := 'Cadsol 8.0';
  Application.HelpFile := '';
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTypeCadDlg, TypeCadDlg);
  Application.CreateForm(TCouleursDlg, CouleursDlg);
  Application.CreateForm(TParam, Param);
  Application.CreateForm(TFDate, FDate);
  Application.CreateForm(TCommentDlg, CommentDlg);
  Application.CreateForm(TResumeDlg, ResumeDlg);
  Application.CreateForm(TFormInfoSys, FormInfoSys);
  Application.CreateForm(TDecliSupport, DecliSupport);
  Application.CreateForm(TPositionForm, PositionForm);
  Application.CreateForm(TZoomForm, ZoomForm);
  Application.CreateForm(TAssistForm, AssistForm);
  Application.CreateForm(THeureDlg, HeureDlg);
  Application.CreateForm(TFormCadsol3D, FormCadsol3D);
  Application.CreateForm(TFormAPropos, FormAPropos);
  Application.CreateForm(TCadranMultipleForm, CadranMultipleForm);
  Application.CreateForm(TVisuCadMultipleForm, VisuCadMultipleForm);
  Application.CreateForm(TViewForm, ViewFormPhoto);
  Application.CreateForm(TAssistForm, AssistForm);
  Application.CreateForm(THeureDlg, HeureDlg);
  Application.CreateForm(TFormCadsol3D, FormCadsol3D);
  Application.CreateForm(TFormAPropos, FormAPropos);
  Application.CreateForm(TCadranMultipleForm, CadranMultipleForm);
  Application.CreateForm(TVisuCadMultipleForm, VisuCadMultipleForm);
  Application.CreateForm(TFormStyle, FStyle);
  SplashForm.Hide;
  SplashForm.Free;

  Application.Run;

end.
