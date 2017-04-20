unit uFenetres;


interface
 uses VCl.Forms;
   Procedure GererFenetres(ItemIndex:Integer);

implementation
   uses  cadvar,main,cadtrace3D, Parametre, Heurecad, Position, uCadranMultiple,ucouleurs,typeCad,uVisuCadMultiple;


 Procedure FenetresFlottantes(BS:TBorderStyle;ep:integer);

 begin
   with CouleursDlg do begin
     BorderStyle:=BS;
     Top:=ep;Left:=ep;
     Height:=400; Width:=350;
     Show;
   end;

   With PositionForm do begin
     BorderStyle:=BS;
     Top:=ep;Width:=350;
     Left:=Screen.Width-350-ep;
     Height:=screen.Height div 2;
     Show;
   end;

    With Mainform do begin
      BorderStyle:=BS;
     Top:=ep; Left:=2*ep+CouleursDlg.Width;
     Height:=screen.Height div 2;
     Width:=Screen.Width-CouleursDlg.Width- PositionForm.Width-4*ep;
     Show;
   end;

   With Param do begin
     BorderStyle:=BS;
     Top:=CouleursDlg.Top+CouleursDlg.Height+ep; left:=ep;
     Width:=350; Height:=400;
     Show
   end;

   With TypeCadDlg do begin
     BorderStyle:=BS;
     Top:=PositionForm.Height +2*ep; Left:= PositionForm.Left;
     Width:=PositionForm.Width; Height:=450;
     Show
   end;

   With HeureDlg do begin
     BorderStyle:=BS;
     Left:=ep;Top:=CouleursDlg.Height+ Param.Height+3*ep;
     Width:=350; Height:=70;
     show
   end;

    With VisuCadMultipleForm do begin
     BorderStyle:=BS;
     Top:= MainForm.Height+2*ep;
     Left:= MainForm.Left;
     Width:=MainForm.Width div 2-ep;
     Height:=screen.Height div 2 - 2*ep;
     If CadranMultiple.Typ=Multiple then show;
   end;

   With FormCadsol3D do begin
     BorderStyle:=BS;
     Top:= MainForm.Height+2*ep;
     If CadranMultiple.Typ<>Vide then Width:= MainForm.Width div 2 else Width:=MainForm.Width;
     Left:=TypeCadDlg.Left-ep-Width;
     Height:=VisuCadMultipleForm.Height;
     show
   end;


   end;


  Procedure GererFenetres;
   begin
    Case ItemIndex of
      1:FenetresFlottantes(TBorderStyle(bsSizeable),5);
      2:FenetresFlottantes(TBorderStyle(bsNone),5);
    End;
   end;
end.
