unit Cadvar;

interface

uses WinTypes, SysUtils, WinProcs, windows, Forms, Messages, StdCtrls,
  ExtCtrls, Graphics, ComCtrls, Xml.xmldom, Xml.XMLIntf, Xml.omnixmldom,
  Xml.XMLDoc, system.Classes, Soap.EncdDecd;

const
  nbDates = 18;
  ControleV8=666;
type
  TNomFichier = ShortString;
  Tampon = Array [0 .. 2000] of char;
  TCad = (vide, vertical, horizontal, declinantEst, declinantOuest,
    analemmatique, montresol, bifilaire, multiple,courbeEqT,courbeAna,cubique,
    TCadSud,TCadEst,TCadNord,TCadOuest,TcadSup,TCadInf);

  TDateArc = record
    jour, mois: SmallInt;
  end;

  TypeTrait = (hsol, ax, hBab, hit, dhe, arcd, meri,cont);

  TCadran = record
    Controle:Integer;
    Lati, Longi, Decli: Real;
    Largeur, Hauteur, LargeurTot, HauteurTot, NbCadLargeur, NbCadHauteur,
      hStyle, distance, decalage, precision, increment: Integer;
    arcs_diurnes, demi_heure, heure_legale, eq_temps_hiver, eq_temps_ete: bool;
    Commentaire: Tampon;
    DateArc: Array [1 .. nbDates] of TDateArc;
    heure_bab, heure_ita: bool;
    precishbi: Integer;
    couleur: LongInt;
    axes, coord, SousStyle: wordbool;
    EpTraitV4: array [TypeTrait] of word;
    ClTraitV4: array [TypeTrait] of TColor;
    NumPage: wordbool;
    NomFichier: TNomFichier;
    Modif, HSin: wordbool;
    clCadran, clFond: TColor;
    NFBitmap: TNomFichier;
    Incli: Real;
    gx, gy: Integer;
    heure_sol, heure_temp: wordbool;
    px, py, LStyle, intervalle: Integer;
    Devx, Devy: Integer;
    Devise: TNomFichier;
    Typ: TCad;
    pol: TlogFont;
    EpTrait: array [TypeTrait] of word;
    ClTrait: array [TypeTrait] of TColor;
    DecalMin: Integer;
    NFPhoto: TNomFichier;
    AfficheDate: wordbool;
    Profondeur: Integer;
    Ligne,Colonne:integer;
    contour:Boolean;
    Marge:Integer;
    Rotation,real2,real3,real4,real5,real6real7:real;
    ChiffresRomains,Int2,int3,int4,int5,int6,int7:integer;
    String1,String2,String3,String4,String5,String6,String7:TnomFichier;
  end;


Const
  chTcad: array [TCad] of string = (' ', 'Cadran à style fixe', 'Horizontal',
    'Oriental', 'Occidental', 'Cadran analemmatique', 'Cadran de hauteur',
    'Cadran vertical bifilaire', 'Cadran multiple','Courbe de l''équation du temps', 'Courbe de l''analemne',
    'Cubique','Face Sud','Face Est','Face Nord','Face Ouest','Face supérieure','Face inférieure');

var
  Buf, Buff: array [0 .. 255] of char;
  HelpPath, EquaPath, NomFtxt: TNomFichier;
  EqTemps: array [1 .. 365] of record eqt, decsol: Real; end;
Retrace:Boolean;
OldCur:HCursor;
Grand_Axe, Petit_Axe: Integer;
UserPol, CoordPol: TlogFont;
hOldFont, HUserPol, HCoordPol: HFont;
ColorRef:LongInt;
f:textFile;
FichierCoord:Boolean;
VLim:Boolean;
OmbreStyle:Boolean;
HeureCadran:TdateTime;
//VoirCadranMultiple:Boolean;

procedure InitCadran(var Cadran: TCadran);
  Function LireCadran(var Cadran: TCadran; NF: TNomFichier): Boolean;
  // Function EcrireCadran(var Cadran: TCadran; NF: TNomFichier): Boolean;
    //Function EcrireCadranXml(var Cadran: TCadran; NF: TNomFichier): Boolean;
      Function EcrireCadranSol(var Cadran: TCadran; NF: TNomFichier): Boolean;
        Function EcrirePPetPhoto(var Cadran: TCadran; NF: TNomFichier): Boolean;
          //Function LireCadranXml(var Cadran: TCadran; NF: TNomFichier): Boolean;
                Procedure PaintChild(var Cadran: TCadran; Canvas: Tcanvas;
                  R: TRect);
                  Procedure LireEqTemps;
                    Procedure Compacter(var S: string);
                      Procedure SortieImprimante(var Cadran: TCadran; EcranCanvas: Tcanvas);
                        Function Executer(LCom: String; cmdShow: Integer): word;
                          Function EqDuTemps(DayNr: Real): Real;
                          (* Equation du temps,    en secondes à 12h TU pour 1998 *)
                            Function DecliSol(DayNr: Real): Real;
                            (* Déclinaison du soleil, en radians à 12h TU pour 1998 *)
                            procedure PapierPeint(Cadran: TCadran; Canvas: Tcanvas;ox,oy:integer);
                            Procedure EcrireCadranSolMultiple(cadran:TCadran; NF: TNomFichier);

implementation

(* {$R CADVAR.RES} *)
uses math, CadTrace, Printers, Main, Dialogs, uVisuCadMultiple, FCadsol;

Function Executer;
var
  R: word;
begin
  strPcopy(Buf, LCom);
  R := WinExec(@Buf, cmdShow);
  (* if r<32 then begin
    if r=0 then messageBox(0,'Mémoire insuffisante'
    ,Buf,mb_iconExclamation);
    if r>0 then messageBox(0,'Edition impossible'
    ,Buf,mb_iconExclamation);
    end; *)
  Executer := R; (* execution reussie ssi r>=32 *)
end;

Procedure Compacter(var S: string);
var
  T: string;
  i: Integer;
begin
  T := '';
  for i := 1 to Length(S) do
    if S[i] <> ' ' then
      T := T + S[i];
  S := T;
end;

procedure InitCadran;
var
  i: Integer;
  T: TypeTrait;
begin
  FillChar(Cadran, sizeof(TCadran), #0);
  with Cadran do
  begin
    Controle:=ControleV8;
    arcs_diurnes := false;
    demi_heure := false;
    heure_legale := false;
    eq_temps_hiver := false;
    eq_temps_ete := false;
    heure_bab := false;
    heure_ita := false;
    heure_temp := false;
    heure_sol := true;
    Lati := 43;
    Longi := -3;
    Decli := 0;
    Largeur := 7500;
    Hauteur := 5000;
    Profondeur := 150;
    hStyle := 500;
    distance := 800;
    decalage := 0;
    precision := 15;
    increment := 5;
    Typ := vertical;

    for i := 1 to nbDates do
    begin
      DateArc[i].jour := 0;
      DateArc[i].mois := 0;
    end;
    precishbi := 1;
    FillChar(pol, sizeof(TlogFont), #0);
    Pol.lfFaceName:='Arial' ;
    Pol.lfOrientation:=0;
    Pol.lfWeight:=400;
    Pol.lfHeight:=-133;
    Pol.lfOrientation:=0;
    couleur := RGB(0, 0, 0);
    axes := false;
    coord := false;
    SousStyle := true;
    (*
      clBlack	Noir
      clMaroon	Marron
      clGreen	Vert
      clOlive	Vert olive
      clNavy	Bleu marine
      clPurple	Violet
      clTeal	Teal
      clGray	Gris
      clSilver	Argent
      clRed	Rouge
      clLime	Vert clair
      clBlue	Bleu
      clFuchsia	Fuchsia
      clAqua	Aqua
      clWhite	Blanc *)

    for T := hsol to cont do
      EpTrait[T] := 0;
    ClTrait[hsol] := clBlack;
    ClTrait[ax] := clBlack;
    ClTrait[hBab] := clOlive;
    ClTrait[hit] := clMaroon;
    ClTrait[dhe] := clBlue;
    ClTrait[arcd] := clNavy;
    ClTrait[meri] := clRed;
    ClTrait[cont] := clwhite;
    NumPage := false;
    NomFichier := 'SansNom';
    Modif := false;
    clFond := clSilver;
    clCadran := clWhite;
    NFBitmap := '';
    Incli := 90;
    gx := 0;
    gy := 1750;
    heure_sol := true;
    px := 0;
    py := 0;
    LStyle := 0;
    intervalle := 60;
    Devx :=0;
    Devy := -2000;
    Devise := 'Devise...';
    DecalMin := 0;
    NFPhoto := '';
    HSin := false;
    AfficheDate := true;
    LargeurTot := 15000;
    HauteurTot := 5000;
    NbCadLargeur := 1;
    NbCadHauteur := 1;
    Ligne:=1;Colonne:=1;
    Contour:=False;
    Marge:=300;
    Rotation:=0;
    ChiffresRomains:=0;
  end;
end;

Function LireCadran;
var
  f: file;
  R, Ior: Integer;
  aCadran: TCadran;
  nTyp: TCad;


begin
  result := false;
  if FileExists(NF) then
  begin
    InitCadran(aCadran);
    assignFile(f, NF);
{$I-}
    filemode := fmopenread;
    reset(f, 1);
    blockRead(f, aCadran, sizeof(aCadran), R);
    Ior := IoResult;
    if Ior > 0 then
    begin
      Application.MessageBox(pchar('Fichier ' + NF),
        pchar('Erreur de lecture ' + IntToStr(Ior)), mb_SYSTEMMODAL);
      close(f);
      exit;
    end;
    close(f);
{$I+}
    if R = 0 then
    begin
      Application.MessageBox(strPcopy(Buf, NF), 'FichierVide',
        mb_iconExclamation);
      exit;
    end;
    if (aCadran.Controle <> ControleV8)
    then
      Application.MessageBox('Ce fichier ne contient PAS un cadran solaire.',
        strPcopy(Buf, NF), mb_iconStop)
    else
    begin
      Cadran := aCadran;
      Cadran.NomFichier := NF;
      if Cadran.NFBitmap <> '' then
        Cadran.NFBitmap := ExtractFilepath(Cadran.NomFichier) +
          ExtractFileName(Cadran.NFBitmap);
      if Cadran.NFPhoto <> '' then
        Cadran.NFPhoto := ExtractFilepath(Cadran.NomFichier) +
          ExtractFileName(Cadran.NFPhoto);
      ChDir(ExtractFilepath(NF));
      with Cadran do
      begin
        if NFBitmap <> '' then
          NFBitmap := ExpandFileName(NFBitmap);
        if NFPhoto <> '' then
          NFPhoto := ExpandFileName(NFPhoto);
      end;
    end;
    Result:=True;
  end
  else
    Application.MessageBox(strPcopy(Buf, NF), 'FICHIER INEXISTANT',
      mb_iconExclamation)
end;


(*
Function LireCadranXml;
var
  tb: Tbytes;
Begin
  with MainForm, Cadran do
  begin
    XMLDocument1.LoadFromFile(NF);

    With XMLDocument1.ChildNodes.Nodes[ExtractFileName(NF)] do
    begin
      Longi := StrToFloat(ChildNodes.Nodes['Longitude'].Text);
      Lati := StrToFloat(ChildNodes.Nodes['Latitude'].Text);
      NFBitmap := ChildNodes.Nodes['PapierPeint'].Text;
      getmem(Pointer(tb), sizeof(pol));
      tb := DecodeBase64(ChildNodes.Nodes['Police'].Text);
      // assign(tb,pol);
    end;

  end;
end;     *)

{ TODO 5 -oJL : Finir EcrireCadranXML }

(*Function EcrireCadranXml;
begin
  EcrirePPetPhoto(Cadran, NF);
  with MainForm, Cadran do
  begin
    XMLDocument1.Free;
    XMLDocument1 := TXMLDocument.Create(MainForm);
    XMLDocument1.Active := true;
    XMLDocument1.Options := [doNodeAutoCreate, doNodeAutoIndent, doAttrNull,
      doAutoPrefix, doNamespaceDecl];
    XMLDocument1.Version := '1.0';
    XMLDocument1.Encoding := 'ISO-8859-1';
    with XMLDocument1.AddChild(ExtractFileName(NF)) do
    begin
      AddChild('Longitude').Text := FloatToStr(Longi);
      AddChild('Latitude').Text := FloatToStr(Lati);
      AddChild('PapierPeint').Text := NFBitmap;
      AddChild('Police').Text := EncodeBase64(@pol, sizeof(pol));
    end;
    XMLDocument1.SaveToFile(NF);
  end;
end;   *)



Function EcrireCadranSol;
Var
  f_Cad: File of TCadran;
  aNF: TNomFichier;
  aModif: Boolean;
begin
  result := true;
  aNF := Cadran.NomFichier;
  aModif := Cadran.Modif;
  EcrirePPetPhoto(Cadran, NF);
  assign(f_Cad, NF);
{$I-}
  rewrite(f_Cad);
  if IoResult = 0 then
  begin
    write(f_Cad, Cadran);
    close(f_Cad);
  end;
{$I+}
  if IoResult <> 0 then
  begin
    messageBeep(mb_iconExclamation);
    Application.MessageBox('ENREGISTREMENT IMPOSSIBLE', strPcopy(Buf, NF),
      mb_iconExclamation);
    result := false;
    Cadran.NomFichier := aNF;
    Cadran.Modif := false;
  end;
end;

Procedure EcrireCadranSolMultiple;
Var
  f_Cad: File of TCadran;
  i:integer;
begin
  EcrirePPetPhoto(Cadran, NF);
  assignFile(f_Cad, NF);
{$I-}
  rewrite(f_Cad);
  if IoResult = 0 then
  begin
    write(f_Cad, CadranMultiple);
    if CadranMultiple.Typ=Multiple then
      for i := 1 to MainForm.MDIChildCount do write(f_cad,TFormCadsol(MainForm.MDIChildren[i-1]).Cadran);
    if CadranMultiple.Typ=Cubique then begin
      write(f_cad,FcadInf.Cadran);
      write(f_cad,FcadSup.Cadran);
      write(f_cad,FcadNord.Cadran);
      write(f_cad,FcadEst.Cadran);
      write(f_cad,FcadOuest.Cadran);
      write(f_cad,FcadSud.Cadran);
    end;
    closeFile(f_Cad);
  end;
{$I+}
  if IoResult <> 0 then
  begin
    messageBeep(mb_iconExclamation);
    Application.MessageBox('ENREGISTREMENT IMPOSSIBLE', strPcopy(Buf, NF),
      mb_iconExclamation);
    Cadran.Modif := false;
  end;

end;

Function EcrirePPetPhoto;
var
  bm: TPicture;
begin

  Cadran.NomFichier := NF;

  if Cadran.NFBitmap <> '' then
    if FileExists(Cadran.NFBitmap) then
    begin
      bm := TPicture.Create;
      try
        bm.LoadFromFile(Cadran.NFBitmap);
        Cadran.NFBitmap := ExtractFilepath(Cadran.NomFichier) +
          ExtractFileName(Cadran.NFBitmap);
        bm.SaveToFile(Cadran.NFBitmap);
        Cadran.NFBitmap := ExtractFileName(Cadran.NFBitmap);
      finally
        bm.Free
      end
    end
    else
      Cadran.NFBitmap := '';

  if Cadran.NFPhoto <> '' then
    if FileExists(Cadran.NFPhoto) then
    begin
      bm := TPicture.Create;
      try
        bm.LoadFromFile(Cadran.NFPhoto);
        Cadran.NFPhoto := ExtractFilepath(Cadran.NomFichier) +
          ExtractFileName(Cadran.NFPhoto);
        bm.SaveToFile(Cadran.NFPhoto);
        Cadran.NFPhoto := ExtractFileName(Cadran.NFPhoto);
      finally
        bm.Free
      end
    end
    else
      Cadran.NFPhoto := '';

  Cadran.Modif := false;
  Cadran.Controle := controleV8;

end;


procedure PapierPeint;
var
  bp: TPicture;
  bm: TBitmap;
  rbm: TRect;
  ext: String;
begin
  if Cadran.NFBitmap <> '' then
    if FileExists(Cadran.NFBitmap) then
    begin
      ext := ExtractFileExt(AnsiLowerCaseFileName(Cadran.NFBitmap));
      if (ext = '.bmp') or (ext = '.jpg') or (ext = '.jpeg') or (ext = '.wmf')
        or (ext = '.emf') then
      begin
        bp := TPicture.Create;
        bp.LoadFromFile(Cadran.NFBitmap);
        // bp.Bitmap.Transparent:=true;
        setrect(rbm, -Cadran.Largeur div 2+ox, Cadran.Hauteur div 2+oy,
          Cadran.Largeur div 2+ox, -Cadran.Hauteur div 2+oy);
        Canvas.StretchDraw(rbm, bp.Graphic);
        bp.Free;
      end;
    end
    else
    begin
      Application.MessageBox(strPcopy(Buf, Cadran.NFBitmap),
        'Papier peint introuvable', mb_iconExclamation);
      Cadran.NFBitmap := ''
    end;
end;

Procedure PaintChild;
var
  dc: hdc;
  rc, c: TRect;
  l, h, i, j: Integer;

  procedure cadre(Larg,Haut:Integer);
  var
    h, S: THandle;
    ombre: Integer;

  begin
      h:=selectObject(dc, getstockObject(BLACK_PEN));
      s:=selectObject(dc, getstockObject(NULL_BRUSH));
      canvas.Pen.Style:= psSolid;
      Canvas.Pen.Width:=10;
      canvas.Pen.Color:=ClBlack ;
      canvas.Brush.Color:=ClWhite;
      rectangle(dc, -Larg div 2, -Haut div 2, Larg div 2,Haut div 2);
      ombre := round(Haut / 140 + Larg / 140);
      selectObject(dc, getstockObject(BLACK_BRUSH));
    //  canvas.Brush.Color:=ClBlack;
     // canvas.Brush.Style:=bsSolid;
      rectangle(dc, -Larg div 2 + ombre, -Haut div 2,
        Larg div 2 + ombre, -Haut div 2 - ombre);
      rectangle(dc, Larg div 2, Haut div 2 - ombre, Larg div 2 + ombre,
        -Haut div 2 - ombre);
  //    selectObject(dc, getstockObject(NULL_BRUSH));
   //    selectobject (dc,h);
       selectobject (dc,s);

  end;

  procedure Echelle(Larg,Haut:integer);
  var
    extX, extY: Integer;
  begin
    setMapMode(dc, MM_ISOTROPIC);
    extX := round((Larg div 2) * 1.1);
    extY := round((Haut div 2) * 1.1);
    with R do
    begin
      setWindowOrgex(dc, 0, 0, nil);
      SetWindowExtEx(dc, extX, -extY, nil);
      SetViewPortOrgEx(dc, (left + right) div 2, (top + bottom) div 2, nil);
      SetViewPortExtEx(dc, (right - left) div 2, (bottom - top) div 2, nil);
    end;
  end;

  Procedure TracerPages(Larg,Haut:integer);
  var
    dcPrt: hdc;
    Page: Array [0 .. 80] of char;
    VSize, Hsize, np, nph, npv, ih, iv: Integer;
    s1: string;
    OldCur: HCursor;
    Oldpen, Newpen: HPen;

  begin
    OldCur := SetCursor(LoadCursor(0, IDC_WAIT));
    dcPrt := Printer.Handle;
    Hsize := GetDeviceCaps(dcPrt, HORZSIZE) * 10;
    VSize := GetDeviceCaps(dcPrt, VERTSIZE) * 10;
    SetCursor(OldCur);
    with Cadran do
    begin
      nph := (Larg - 1) div Hsize;
      npv := (Haut - 1) div VSize;
    end;
    selectObject(dc, getstockObject(NULL_BRUSH));
    selectObject(dc, getstockObject(ANSI_VAR_FONT));
    SetTextColor(dc, RGB(127, 127, 127));
    setBkMode(dc, TRANSPARENT);
    Newpen := createpen(PS_DOT, 1, 0);
    Oldpen := selectObject(dc, Newpen);
    np := 1;
    for iv := 0 to npv do
      for ih := nph downto 0 do
        with Cadran do
        begin
          rectangle(dc, (-ih - 1) * Hsize + ((nph + 1) * Hsize) div 2,
            (-iv - 1) * VSize + ((npv + 1) * VSize) div 2,
            (-ih) * Hsize + ((nph + 1) * Hsize) div 2,
            (-iv) * VSize + ((npv + 1) * VSize) div 2);
          strcopy(Page, 'P');
          str(np: 3, s1);
          Compacter(s1);
          StrCat(Page, strPcopy(Buf, s1));
          Textout(dc, (-ih - 1) * Hsize + ((nph + 2) * Hsize) div 2,
            (-iv) * VSize + (npv * VSize) div 2, Page, strLen(Page));
          np := np + 1;
        end; (* for for *)
    selectObject(dc, Oldpen);
    DeleteObject(Newpen);
  end;

begin
  dc := Canvas.Handle;

  with Cadran do
  begin

    if Typ in[Multiple,Cubique] then
       begin
       Echelle(LargeurTot,HauteurTot);
       cadre(LargeurTot,HauteurTot);
       //PapierPeint(Cadran, Canvas,0,0);

       for i := 0 to MainForm.MDIChildCount-1 do begin
        ActiveCad := TFormCadsol(MainForm.MDIChildren[i]);
        l:=ActiveCad.Cadran.Ligne;h:=ActiveCad.Cadran.Colonne;
        TraceCadran(ActiveCad.Cadran, Canvas,
              (-NbCadLargeur+h-1)*largeur+LargeurTot div 2+largeur div 2,
              (-l)*hauteur+HauteurTot div 2+hauteur div 2)
        end;
        if NumPage then TracerPages(LargeurTot,HauteurTot);
       end
    else begin
        Echelle(Largeur,Hauteur);   Cadre(Largeur,Hauteur);
      //  PapierPeint(Cadran, Canvas,0,0);
        TraceCadran(Cadran, Canvas, 0, 0);
        if NumPage then TracerPages(Largeur,Hauteur);
    end;
   end;
  end;


Function EqDuTemps; (* Equation du temps, en secondes à 12h TU pour 2001 *)
var
  l: Real;
begin
  l := (DayNr + 0.5) * 360 / 365.2422 - 80.265634; (* DEGREES *)
  l := DegToRad(l);
  EqDuTemps := -107.4731 * SIN(l) - 428.5494 * COS(l) + 596.0762 * SIN(2 * l) -
    2.0973 * COS(2 * l) + 4.4342 * SIN(3 * l) + 19.2715 * COS(3 * l) - 12.7329 *
    SIN(4 * l); (* SECONDS of time *)
end;

{ Formules pour 2001
  L                = DAGNR*360/365.2422 - 80.265634         GRADEN

  TIJDSVEREFFENING = - 107.4731*SIN( L) - 428.5494*COS( L)
  + 596.0762*SIN(2L) -   2.0973*COS(2L)
  +   4.4342*SIN(3L) +  19.2715*COS(3L)
  -  12.7329*SIN(4L)                   SECONDEN

  LAMBDA           = L
  +   0.4293*SIN( L) +   1.8659*COS( L)
  -   0.0180*SIN(2L) +   0.0087*COS(2L)  GRADEN

  EPSILON          =   23.43915                             GRADEN

  DECLINATIE       = ARCSIN(SIN LAMBDA * SIN EPSILON)       GRADEN
}

Function DecliSol; (* Déclinaison du soleil, en radians à 12h TU pour 2001 *)
var
  l, LAMBDA, EPSILON: Real;
begin
  l := (DayNr + 0.5) * 360 / 365.2422 - 80.265634; (* DEGREES *)
  l := DegToRad(l);
  LAMBDA := RadToDeg(l) + 0.4293 * SIN(l) + 1.8659 * COS(l) - 0.0180 *
    SIN(2 * l) + 0.0087 * COS(2 * l); (* DEGREES *)
  EPSILON := 23.43915; (* DEGREES *)
  DecliSol := ARCSIN(SIN(DegToRad(LAMBDA)) * SIN(DegToRad(EPSILON)));
  (* Radians *)
end;

Procedure LireEqTemps;
var
  j: Integer;
begin
  for j := 1 to 365 do
  begin
    EqTemps[j].eqt := EqDuTemps(j) / 3600 * pi / 12; (* radians *)
    EqTemps[j].decsol := DecliSol(j); (* radians *)
  end;
end;

Procedure SortieImprimante;
var
  dcPrt: hdc;
  Page: array [0 .. 10] of char;
  Hsize, VSize, hres, vres, np, nph, npv, ih, iv, debut, fin, nc, dx,
    dy,i,j,l,h,ll,hh: Integer;
  s1: string;
  OldCur: HCursor;
  bp: TPicture;
  rbm: TRect;

  procedure LirePapierPeint;
  var
    ext: String;
  begin
    if FileExists(Cadran.NFBitmap) then
    begin
      ext := ExtractFileExt(AnsiLowerCaseFileName(Cadran.NFBitmap));
      if (ext = '.bmp') or (ext = '.jpg') or (ext = '.jpeg') or (ext = '.wmf')
        or (ext = '.emf') then
      begin
        bp := TPicture.Create;
        bp.LoadFromFile(Cadran.NFBitmap);
      end
      else
      begin
        Application.MessageBox(strPcopy(Buf, Cadran.NFBitmap),
          'Papier peint introuvable', mb_iconExclamation);
        Cadran.NFBitmap := ''
      end;
    end;
  end;

begin
  OldCur := SetCursor(LoadCursor(0, IDC_WAIT));
  dcPrt := Printer.Handle;
  Hsize := GetDeviceCaps(dcPrt, HORZSIZE) * 10; (* en mm *)
  VSize := GetDeviceCaps(dcPrt, VERTSIZE) * 10;
  hres := GetDeviceCaps(dcPrt, HORZRES); (* en pixels *)
  vres := GetDeviceCaps(dcPrt, VERTRES);
  setBkMode(dcPrt, TRANSPARENT);
  SetCursor(OldCur);

  with Cadran, MainForm do
  begin
    if Typ=Multiple then  begin ll:=LargeurTot; hh:=HauteurTot end
                    else  begin ll:=Largeur   ; hh:=Hauteur    end ;

    nph := ll div Hsize;
    npv := hh div VSize;
    debut := 1;
    fin := (nph + 1) * (npv + 1);
    // PrintDialog.Options := [poPageNums,powarning];
    PrintDialog.Minpage := 1;
    PrintDialog.MaxPage := fin;
    PrintDialog.FromPage := 1;
    PrintDialog.ToPage := fin;

    if PrintDialog.Execute then
      for nc := 1 to PrintDialog.Copies do
      begin
        if Cadran.NFBitmap <> '' then
          LirePapierPeint;
        np := 1;
        debut := PrintDialog.FromPage;
        fin := PrintDialog.ToPage;
        Printer.Title := 'Cadran solaire:' + Cadran.NomFichier;
        if PrintDialog.Copies > 1 then
          Printer.Title := Printer.Title + ' (Copie ' + IntToStr(nc) + ')';
        Printer.beginDOC;
        dcPrt := Printer.Handle;
        Hsize := GetDeviceCaps(dcPrt, HORZSIZE) * 10; (* en mm *)
        VSize := GetDeviceCaps(dcPrt, VERTSIZE) * 10;
        hres := GetDeviceCaps(dcPrt, HORZRES); (* en pixels *)
        vres := GetDeviceCaps(dcPrt, VERTRES);
        setBkMode(dcPrt, TRANSPARENT);
        selectObject(dcPrt, getstockObject(NULL_BRUSH));

        for iv := npv downto 0 do
          for ih := 0 to nph do
          begin
            if (np >= debut) and (np <= fin) then
            begin

              setMapMode(dcPrt, MM_TEXT);
              SetViewPortOrgEx(dcPrt, 0, 0, nil);
              selectObject(dcPrt, getstockObject(NULL_BRUSH));
              rectangle(dcPrt, 1, 1, hres - 1, vres - 1);

              setMapMode(dcPrt, MM_LOMETRIC); (* 10 u.logiques-> 1mm *)
              SetViewPortOrgEx(dcPrt, hres div 2, vres div 2, nil);
              dx := (nph * (Hsize div 2) - ih * Hsize);
              dy := (npv * (VSize div 2) - iv * VSize);
              setrect(rbm, -ll div 2 + dx,
                hh div 2 + dy, ll div 2 + dx,
                -hh div 2 + dy);
              Printer.Canvas.Brush.color := Cadran.clCadran;
              Printer.Canvas.rectangle(rbm);
              if Cadran.NFBitmap <> '' then
                Printer.Canvas.StretchDraw(rbm, bp.Graphic);
   //
   if Typ=Multiple then
       begin
       for i := 0 to MainForm.MDIChildCount-1 do begin
        ActiveCad := TFormCadsol(MainForm.MDIChildren[i]);
        l:=ActiveCad.Cadran.Ligne;h:=ActiveCad.Cadran.Colonne;
        TraceCadran(ActiveCad.Cadran, Printer.Canvas,
              (-NbCadLargeur+h-1)*largeur+LargeurTot div 2+largeur div 2 + dx,
              (-l)*hauteur+HauteurTot div 2+hauteur div 2 + dy)
        end;
       end
    else begin
        TraceCadran(Cadran, Printer.Canvas, dx, dy);
    end;
   //

              if NumPage then
              begin
                SetViewPortOrgEx(dcPrt, hres div 2, vres div 2, nil);
                selectObject(dcPrt, getstockObject(device_default_font));
                strcopy(Page, 'Page:');
                str(np: 3, s1);
                Compacter(s1);
                StrCat(Page, strPcopy(Buf, s1));
                SetTextColor(dcPrt, RGB(127, 127, 127));
                Textout(dcPrt, -Hsize div 2 + 20, VSize div 2 - 20, Page,
                  strLen(Page));
              end;

              if Printer.Aborted then
                np := fin;
              if np < fin then
                Printer.NewPage;
            end;
            np := np + 1;
          end; (* for for *)
        Printer.EndDoc;
        if Cadran.NFBitmap <> '' then
          bp.Free;
      end; (* if *)
  end; (* with *)
end;

begin
  ColorRef := RGB(0, 0, 0);
  LireEqTemps;
  FichierCoord := false;
  ChDir(extractFileDir(paramStr(0)));
  OmbreStyle := false;
  HeureCadran := now;
  //VoirCadranMultiple:=False;
end.
