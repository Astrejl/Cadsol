unit CadTrace;

interface

uses WinTypes, Winprocs, SysUtils, Graphics,
  Trigo, cadvar, uCouleurs;

function JourAn(var nj, nm: integer): integer;
function HautSol(H, decl, Phi: real): real;
function LStyleMs(Hauteur: integer; Lati: real): integer;
function DemiJour(decl, Phi: real): real;
procedure TraceCadran(var cadran: TCadran; Canvas: TCanvas; ox, oy: integer);

implementation

uses forms, resume, cadtrace3d, GLScene, GLObjects, main, GLSpaceText;

const
  NbJour: array [1 .. 12] of integer = (31, 28, 31, 30, 31, 30, 31, 31, 30,
    31, 30, 31);
  StMois: array [1 .. 12] of array [0 .. 10] of char = ('Janv', 'Fev', 'Mars',
    'Avr', 'Mai', 'Juin', 'Juil', 'Aout', 'Sept', 'Oct', 'Nov', 'Dec');
  MaxInt = 32000;
  DeltaDeg: array [-1 .. 1] of real = (-23.43915, 0, 23.43915); (* pour 2001 *)

var
  nbp: integer;
  lg: string;
  crayon_hsol, crayon_ax, crayon_hbab, crayon_hit, crayon_axe, crayon_dhe,
    crayon_arcd, crayon_meri, old_crayon, new_crayon, crayon_contour: typeTrait;
  GLLineAJL: TGLLines;

procedure CreerCrayon;
begin
  crayon_dhe := dhe;
  crayon_ax := ax;
  crayon_meri := meri;
  crayon_hsol := hsol;
  crayon_hbab := hbab;
  crayon_hit := hit;
  crayon_arcd := arcd;
  crayon_axe := ax;
  old_crayon := hsol;
  new_crayon := ax;
  crayon_contour := cont;
  // New_Crayon :=createpen(PS_DOT,1,RGB(0,0,0));
end;

function HautSol;
begin
  HautSol := ArcSin(cos(H) * cos(decl) * cos(Phi) + sin(decl) * sin(Phi));
end;

function LStyleMs;
begin
  LStyleMs := round(0.9 * Hauteur / tan(HautSol(0, DegToRad(DeltaDeg[1]),
    DegToRad(abs(Lati)))));
end;

function DemiJour;
begin
  DemiJour := ArcCos(-tan(Phi) * tan(decl));
end;

function JourAn(var nj, nm: integer): integer;

var
  s, m: integer;
begin
  s := 0;
  if (nm = 2) and (nj = 29) then
    nj := 28;
  if (nj > 0) and (nm > 0) and (nm <= 12) then
    if nj <= NbJour[nm] then
    begin
      for m := 1 to nm - 1 do
        s := s + NbJour[m];
      s := s + nj;
    end;
  JourAn := s;
end;

procedure TraceCadran;

var
  H, Phi, d, z, a, b, yr, mu, ro, h0, hcs, hls, ch, dist, incl, decl, cosPhi,
    sinPhi, cosd, sind, cosi, sini, x0, y0, x1, y1, l, alpha, R: real;
  i, j, k, m, mm, x, y, dh, hl, hlm, chi, ga, pa, la, ha, xe, ye, hsize, vsize,
    xd, yd, xf, yf, ept, xmin, xmax, ymin, ymax: integer;
  xrr, yrr, zrr: extended;
  hr: string[20];
  visible, debut: boolean;

  OldCur: Hcursor;
  dc: HDC;
  oldHFont: hfont;

  ZP: integer; (* 3D elevation au dessus du plan du cadran *)

  {
    Procedure Erreur(s:string);
    var sz:array[0..80]of char;
    begin
    strPcopy(@sz,s);
    Application.MessageBox(@sz,
    'CADRAN ILLISIBLE',MB_IconExclamation+MB_SYSTEMModal)
    end;
  }
  procedure SelectCrayon(cr: typeTrait);
  begin
    Canvas.pen.color := cadran.clTrait[cr];
    Canvas.pen.width := cadran.epTrait[cr];
    Canvas.pen.style := pssolid;
  end;

  function round(x: real): integer;
  var
    R: integer;
  begin
    if abs(x) < MaxInt then
      R := system.round(x)
    else if x > MaxInt then
      R := MaxInt
    else if x < -MaxInt then
      R := -MaxInt;
    round := R;
  end;

  function Voir(x, y: integer): boolean;
  begin
    with cadran do
    begin
      Voir := (x > -largeur div 2 + marge) and (x < largeur div 2 - marge) and
        (y > -Hauteur div 2 + marge) and (y < Hauteur div 2 - marge);
    end;
  end;

  function Ombre(decl, t: real): integer;
  var
    x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, R: real;

  begin
    case cadran.typ of
      vertical:
        begin
          R := cos(decl);
          x0 := sin(t) * R; (* translation decl, t into x0, y0, z0 *)
          y0 := cos(t) * R;
          z0 := sin(decl);

          (* R := Pi/2 - phi; translation x0, y0, z0, into x1, y1, z1 *)
          x1 := x0; (* by rotation around x-axis through angle 90 - phi *)
          y1 := y0 * sinPhi - z0 * cosPhi;
          z1 := y0 * cosPhi + z0 * sinPhi;
          if z1 <= -1E-6 then
          begin
            Ombre := 1;
            exit
          end;
          (* point isn't real: sun is beneath the horizon* *)

          (* R := d ;                        translation x1, y1, z1, into x2, y2, z2 *)
          x2 := x1 * cosd - y1 * sind;
          (* by rotation around z-axis through angle d *)
          y2 := x1 * sind + y1 * cosd;
          z2 := z1;

          (* R := i   ;    translation x2, y2, z2, into x3, y3, z3 *)
          x3 := x2; (* by rotation around x-axis through angle i *)
          y3 := y2 * cosi - z2 * sini;
          z3 := y2 * sini + z2 * cosi;
          if z3 <= 1E-6 then
          begin
            Ombre := 2;
            exit
          end;
          (* point isn't real: sun isn't above the dial* *)
          with cadran do
          begin
            x3 := x3 * hstyle / z3;
            y3 := y3 * hstyle / z3;
            if (abs(x3) > MaxInt) or (abs(y3) > MaxInt) then
            begin
              Ombre := 3;
              exit
            end;
            x := -system.round(x3); (* translation x3, y3, z3, into x, y *)
            y := system.round(y3);
            (* these are the wanted coordinates of the shadow point *)
            x := x + gx;
            y := y + gy;
            (* if (x > -largeur div 2) and (x < largeur div 2) and
              (y > -Hauteur div 2) and (y < Hauteur div 2) then *)
            if Voir(x, y) then
              Ombre := 0
            else
              Ombre := -1;
          end;
        end;

      bifilaire:
        with cadran do
        begin
          if HautSol(t, decl, Phi) < 0 then
          begin
            Ombre := 3;
            exit
          end;
          b := hstyle;
          a := distance;
          d := cosd * (sinPhi * cos(t) - cosPhi * tan(decl)) + sind * sin(t);
          if d = 0 then
          begin
            Ombre := 1;
            exit
          end;
          x3 := -a * (cosd * sin(t) - sind * (sinPhi * cos(t) - cosPhi *
            tan(decl))) / d;
          y3 := b * (cosPhi * cos(t) + sinPhi * tan(decl)) / d;
          if y3 < 1E-6 then
          begin
            Ombre := 2;
            exit
          end;
          if (abs(x3) > MaxInt) or (abs(y3) > MaxInt) then
          begin
            Ombre := 3;
            exit
          end;
          x := system.round(x3);
          y := -system.round(y3);
          x := x + gx;
          y := y + gy;
          (* if (x > -largeur div 2) and (x < largeur div 2) and
            (y > -Hauteur div 2) and (y < Hauteur div 2) then *)
          if Voir(x, y) then
            Ombre := 0
          else
            Ombre := -1;
        end;

    end; (* case *)
  end;

  function fSousStyle: integer;
  var
    x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, v: real;
    x, y: integer;

  begin
    y1 := -cosPhi;
    z1 := sinPhi;
    (* R := d ;                        translation x1, y1, z1, into x2, y2, z2 *)
    x2 := -y1 * sind; (* by rotation around z-axis through angle d *)
    y2 := y1 * cosd;
    z2 := z1;
    (* R := i   ;    translation x2, y2, z2, into x3, y3, z3 *)
    x3 := x2; (* by rotation around x-axis through angle i *)
    y3 := y2 * cosi - z2 * sini;
    z3 := y2 * sini + z2 * cosi;
    v := ArcSin(z3);
    if abs(z3) < 1E-4 then
    begin
      fSousStyle := 1;
      cadran.px := MaxInt;
      exit
    end;
    with cadran do
    begin
      x := -round(x3 * hstyle / z3); (* translation x3, y3, z3, into x, y *)
      y := round(y3 * hstyle / z3);
      (* these are the wanted coordinates of the shadow point *)
      x := x + gx;
      px := x;
      y := y + gy;
      py := y;
      fSousStyle := 0;
    end;
  end;

  procedure EcrireA(x, y: integer; s: string);
  var
    Spacetext: TGLSpaceText;
  begin
    if not FichierCoord then
    begin
      if gettextalign(dc) = 0 then
      begin
        if (x = 0) and (y < 0) then
          setTextAlign(dc, TA_BOTTOM + TA_CENTER);
        if (x = 0) and (y > 0) then
          setTextAlign(dc, TA_TOP + TA_CENTER);
        if (x < 0) and (y < 0) then
          setTextAlign(dc, TA_BOTTOM + TA_LEFT);
        if (x < 0) and (y > 0) then
          setTextAlign(dc, TA_TOP + TA_LEFT);
        if (x > 0) and (y < 0) then
          setTextAlign(dc, TA_BOTTOM + TA_RIGHT);
        if (x > 0) and (y > 0) then
          setTextAlign(dc, TA_TOP + TA_RIGHT);
        if (x > 0) and (y = 0) then
          setTextAlign(dc, TA_BASELINE + TA_RIGHT);
        if (x > 0) and (y = 0) then
          setTextAlign(dc, TA_BASELINE + TA_RIGHT);
      end;
      x := x + ox;
      y := y + oy;
      Canvas.Textout(x, y, s);
      setTextAlign(dc, 0);
      Canvas.MoveTo(x, y);
    end;
    (* if FormCadsol3D.Active then begin
      Spacetext:=TGLSpaceText.CreateAsChild(FormCadsol3D.GLCube1);
      Spacetext.Position.X:=y/FormCadsol3D.GrDim;
      Spacetext.Position.Y:=-x/FormCadsol3D.GrDim;
      Spacetext.Position.Z:=Cadran.Profondeur/FormCadsol3D.GrDim/2;
      Spacetext.Roll(90);
      // Spacetext.TextHeight:=Cadran.pol.lfHeight;
      SpaceText.Text:=s;
      end; *)
  end;

  procedure Ecrirexy(x, y: integer);
  var
    s, sx, sy: string[20];
    oldHFont: hfont;
    ep: integer;
  begin
    str(round(x / 10), sx);
    str(round(y / 10), sy);
    s := '(' + sx + ';' + sy + ')';
    oldHFont := selectObject(dc, hCoordPol);
    EcrireA(x, y, s);
    selectObject(dc, oldHFont);
    ep := CoordPol.LfHeight div 2;
    x := x + ox;
    y := y + oy;
    Canvas.MoveTo(x - ep, y);
    lineto(dc, x + ep, y);
    Canvas.MoveTo(x, y - ep);
    lineto(dc, x, y + ep);
    Canvas.MoveTo(x, y)
  end;

  procedure EcrireCoord(x, y: integer);
  var
    s1, s2: shortstring;
  begin
    // inc(nbp);
    str(x / 10: 10: 1, s1);
    str(y / 10: 10: 1, s2);
    (* Lg:=Lg+'('+s1+';'+s2+') ';
      if nbp=5 then begin
      writeln(f,Lg);
      nbp:=0;Lg:='' end; *)
    writeln(f, s1 + s2);
  end;

  procedure EcrireLigne(s: string);
  var
    i: word;
  begin
    if FichierCoord then
      writeln(f, '// ' + s);
    (* begin
      if Lg<>'' then writeln(f,Lg);
      nbp:=0;Lg:='';
      if s<>'' then begin
      for i:=1 to length(s)+4 do write(f,'-');writeln(f);
      writeln(f,'  '+s);
      end else writeln(f);
      end; *)
  end;

  procedure EcrireAngle(x, y: integer);
  var
    a: real;
    s: string;
  begin
    with cadran do
      if (x <> 0) or (y <> 0) then
      begin
        if y = 0 then
          a := pi / 2
        else
          a := ArcTan(-x / y);
        a := RadToDeg(a);
        str(a: 7: 1, s);
        EcrireLigne('   Angle:' + s + '°');
      end;
  end;

  procedure Noeud(xp, yp: integer);
  var
    xr, yr, zr: extended;
  begin
    with cadran do
    begin
      if typ = Montresol then
      begin
        xr := sin(xp / (largeur / 2) * pi) *
          FormCadsol3D.GLCylinder1.TopRadius * 1.02;
        yr := yp / Hauteur * FormCadsol3D.GLCylinder1.Height;
        zr := cos(xp / (largeur / 2) * pi) *
          FormCadsol3D.GLCylinder1.TopRadius * 1.02;
        GLLineAJL.AddNode(-xr, -yr, zr);
      end
      else
      begin
        xr := xp / Largeur * FormCadsol3D.GLCube1.CubeWidth;
        yr := yp / Hauteur * FormCadsol3D.GLCube1.CubeHeight;
        zr := FormCadsol3D.GLCube1.CubeDepth / 2 + ZP / Profondeur *
          FormCadsol3D.GLCube1.CubeDepth;
        GLLineAJL.AddNode(xr,yr, zr);
      end;;
    end;
  end;

  procedure AllerA(x, y: integer);
  var
    xp, yp: integer;
    xr, yr: extended;
  begin
    if FichierCoord then
      EcrireCoord(x, y)
    else
    begin
      xp := x + ox;
      yp := y + oy;
      Canvas.MoveTo(xp, yp);
      if cadran.coord then
        Ecrirexy(x, y);
    end;
    if FormCadsol3D.Active then
    begin
      if cadran.typ = Montresol then
        GLLineAJL := TGLLines(FormCadsol3D.GLCylinder1.AddNewChild(TGLLines))
      else
        GLLineAJL := TGLLines(FormCadsol3D.GLCube1.AddNewChild(TGLLines));
      // GLLineAJL.SplineMode := lsmCubicSpline;
      GLLineAJL.LineColor.Blue := ($00FF0000 and Canvas.pen.color) / 255;
      GLLineAJL.LineColor.Green := ($0000FF00 and Canvas.pen.color) / 255;
      GLLineAJL.LineColor.Red := ($000000FF and Canvas.pen.color) / 255;
      GLLineAJL.LineWidth := Canvas.pen.width / 20;
      GLLineAJL.LineColor.alpha := 1;
      // GLLineAJL.LineWidth := Canvas.pen.width;
      GLLineAJL.AntiAliased := true;
      GLLineAJL.NodesAspect := lnaInvisible;
      Noeud(xp, yp);
      // FormCadsol3D.GLDummyCube2.AddNewChild(TGLCube);
    end;
  end;

  procedure LigneA(x, y: integer);
  var
    xp, yp: integer;
  begin
    if FichierCoord then
      EcrireCoord(x, y)
    else
    begin
      xp := x + ox;
      yp := y + oy;
      Canvas.lineto(xp, yp);
      if cadran.coord then
        Ecrirexy(x, y);
    end;
    if FormCadsol3D.Active then
      Noeud(xp, yp);
  end;

  procedure EllipseA(x1, y1, x2, y2: integer);
  begin
    x1 := x1 + ox;
    x2 := x2 + ox;
    y1 := y1 + oy;
    y2 := y2 + oy;
    Canvas.ellipse(x1, y1, x2, y2);
  end;

  procedure RectangleA(x1, y1, x2, y2: integer);
    var Cube:TGLCube;
  begin
    x1 := x1 + ox;
    x2 := x2 + ox;
    y1 := y1 + oy;
    y2 := y2 + oy;
    Canvas.Rectangle(x1, y1, x2, y2);
   (* if formCadsol3D.Active then
      with formCadsol3D,Cadran do begin
        cube := TGLCube(GLCube1.AddNewChild(TGLCube));
        cube.Up:=GlCube1.Up;
        cube.Position.X:= (x1+x2)/2/GrDim;
        cube.Position.Y:=  0;
        cube.Position.Z:= (y1+y2)/2/GrDim;
        cube.CubeWidth :=Hauteur/GRdim;
        cube.CubeHeight := Largeur/Grdim;
        cube.CubeDepth := Profondeur/GRDim;
        with cube.Material.FrontProperties do
        begin
          //Diffuse.Color :=;

          // uncomment following lines to stress OpenGL with more color changes calls

          // Ambient.Color:=VectorLerp(clrYellow, clrRed, (x*x+y*y+z*z)/(cSize*cSize*3));
           Emission.AsWinColor:=Cadran.couleur;
           //Specular.Color:=VectorLerp(clrYellow, clrRed, (x*x+y*y+z*z)/(cSize*cSize*3));
        end;
      end;
       //case CadranMultiple.Typ of
       //    Vertical:
           begin
           GLCube:=TGLCube.Create(FormCadsol3D.GLDummyCube2);
           GLCube.CubeWidth := FormCadsol3D.GLCube1.CubeWidth;
           GLCube.CubeHeight := FormCadsol3D.GLCube1.CubeHeight;
           GLCube.CubeDepth := FormCadsol3D.GLCube1.CubeDepth;
           GLCube.Position.X:=(x1+x2)/2/FormCadsol3D.GRDim;
           GLCube.Position.Y:=(y1+y2)/2/FormCadsol3D.GRDim;
           GLCube.Position.Z:=0;
           end;
         end;
     // end    *)
    end;

  procedure TraceArcDiurne(Phi, decl: real; s: string);
  var
    oldFont: hfont;
  begin
    hls := DemiJour(Phi, decl);
    H := ch;
    visible := false;
    debut := true;
    EcrireLigne('Arc diurne ' + s);
    with cadran do
      repeat
        if (Ombre(decl, H) = 0) then
        begin
          if visible then
            LigneA(x, y)
          else
            AllerA(x, y);
          visible := true;
          if debut then
          begin
            if AfficheDate then
            begin
              oldHFont := selectObject(dc, hCoordPol);
              EcrireA(x, y, s);
              selectObject(dc, oldFont)
            end;
            debut := false
          end;
        end
        else
          visible := false;
        H := H - precision / 60 * pi / 12;
      until H < -hls;
    EcrireLigne('');
    H := ch;
    visible := false;
    debut := true;
    with cadran do
      repeat
        if (Ombre(decl, H) = 0) then
        begin
          if visible then
            LigneA(x, y)
          else
            AllerA(x, y);
          visible := true;
          if debut then
          begin
            if AfficheDate then
            begin
              oldHFont := selectObject(dc, hCoordPol);
              EcrireA(x, y, s);
              selectObject(dc, oldFont)
            end;
            debut := false
          end;
        end
        else
          visible := false;
        H := H + precision / 60 * pi / 12;
      until H > hls;
  end;

  function TexteArc(i, j, m: integer): string;
  var
    s: string;
  begin
    if j * m <> 0 then
      s := IntToStr(j) + '/' + IntToStr(m)
    else
      s := '';
    TexteArc := s;
  end;

  function RayonHS(j: integer): real;
  begin
    with cadran do
      RayonHS := j / 365 * distance + distance
  end;

var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: word;

begin (* TraceCadran *)
  // 3D
  ZP := 10; (* elevation 3D standart *)
  //
  CreerCrayon;
  EcrireLigne('');
  EcrireLigne('');
  dc := Canvas.Handle;
  HUserPol := CreateFontIndirect(cadran.Pol);
  // GetObject(HUserPol, sizeOf(TlogFont), @cadran.Pol);
  if HUserPol <> 0 then
    with cadran do
    begin
      hOldFont := selectObject(dc, HUserPol);
      setBkMode(dc, TRANSPARENT);
      OldCur := SetCursor(LoadCursor(0, IDC_WAIT));

      ha := Canvas.TextHeight('N'); (* Hiword(GetTextExtent(dc,'N',1)); *)
      la := Canvas.TextWidth('W'); (* Loword(GetTextExtent(dc,'W',1)); *)
      hsize := GetDeviceCaps(dc, HORZSIZE) * 10;
      vsize := GetDeviceCaps(dc, VERTSIZE) * 10;

      setTextAlign(dc, 0);
      setTextColor(dc, cadran.Couleur);
      SelectCrayon(crayon_hsol);
      if Heure_legale then
        ch := DegToRad(Longi) + (decalage + decalmin / 60) / 12 * pi
      else
        ch := 0;
      if Heure_legale then
        chi := round(ch / pi * 12)
      else
        chi := 0;
      Phi := DegToRad(abs(Lati));
      cosPhi := cos(Phi);
      sinPhi := sin(Phi);
      d := DegToRad(Decli);
      cosd := cos(d);
      sind := sin(d);
      hl := round((ArcCos(-tan(Phi) * tan(DegToRad(DeltaDeg[-1]))) - pi)
        / pi * 12);

      if (Ord(cadran.typ) <> Ord(Multiple)) or (main.CadranMultiple.Contour)
      then
      begin
        SelectCrayon(crayon_contour);
        ept := cadran.epTrait[cont];
        EcrireLigne('Contours du cadran');
        if not FichierCoord then
        begin
          AllerA(-largeur div 2 + ept, -Hauteur div 2 + ept);
          LigneA(largeur div 2 - ept, -Hauteur div 2 + ept);
          LigneA(largeur div 2 - ept, Hauteur div 2 - ept);
          LigneA(-largeur div 2 + ept, Hauteur div 2 - ept);
          LigneA(-largeur div 2 + ept, -Hauteur div 2 + ept);
        end;
      end;

      if cadran.NFBitmap = '' then
      begin
        Canvas.Brush.color := cadran.clCadran;
        RectangleA(-largeur div 2, -Hauteur div 2, largeur div 2,
          Hauteur div 2);
      end
      else
        PapierPeint(cadran, Canvas, ox, oy);

      // selectObject(dc, GetStockObject(NULL_BRUSH));

      if (Axes and (not FichierCoord)) then
      begin
        SelectCrayon(crayon_hsol);
        Canvas.pen.width := 1;
        Canvas.pen.style := psDot;
        AllerA(0, -Hauteur div 2);
        LigneA(0, Hauteur div 2);
        AllerA(-largeur div 2, 0);
        LigneA(largeur div 2, 0);
        SelectCrayon(old_crayon);
      end;

      case cadran.typ of

        vide:
          if cadran.NFBitmap = '' then
          begin
            Devise:='';
            Canvas.Brush.color := cadran.clCadran;
            RectangleA(-largeur div 2, -Hauteur div 2, largeur div 2,
              Hauteur div 2);
          end;

        analemmatique:
          begin
            if Heure_legale then
              ch := DegToRad(Longi) + (decalage + decalmin / 60) / 12 * pi
            else
              ch := 0;
            if Lati > 0 then
              ch := -ch;
            if Heure_legale then
              chi := round(ch / pi * 12)
            else
              chi := 0;
            Grand_axe := round((largeur div 2) * 0.9);
            Petit_axe := round(Grand_axe * sinPhi);
            if Petit_axe > Hauteur div 2 then
            begin
              Petit_axe := round((Hauteur div 2) * 0.9);
              Grand_axe := round(Petit_axe / sinPhi);
            end;
            EcrireLigne('Grand axe');
            AllerA(-Grand_axe, 0);
            LigneA(Grand_axe, 0);
            EcrireLigne('Petit axe');
            AllerA(0, -Petit_axe);
            LigneA(0, Petit_axe);
            EllipseA(-Grand_axe, -Petit_axe, Grand_axe, Petit_axe);
            if Lati >= 0 then
            begin
              setTextAlign(dc, TA_TOP + TA_CENTER);
              EcrireA(0, Hauteur div 2, 'N');
              setTextAlign(dc, TA_BOTTOM + TA_RIGHT);
              EcrireA(largeur div 2, 0, 'E');
              setTextAlign(dc, TA_BOTTOM + TA_CENTER);
              EcrireA(0, -Hauteur div 2, 'S');
              setTextAlign(dc, TA_BOTTOM + TA_LEFT);
              EcrireA(-largeur div 2, 0, 'W');
            end
            else
            begin
              setTextAlign(dc, TA_TOP + TA_CENTER);
              EcrireA(0, Hauteur div 2, 'S');
              setTextAlign(dc, TA_BOTTOM + TA_RIGHT);
              EcrireA(largeur div 2, 0, 'W');
              setTextAlign(dc, TA_BOTTOM + TA_CENTER);
              EcrireA(0, -Hauteur div 2, 'N');
              setTextAlign(dc, TA_BOTTOM + TA_LEFT);
              EcrireA(-largeur div 2, 0, 'E');
            end;

            setTextAlign(dc, TA_TOP + TA_LEFT);
            k := Grand_axe div 50;
            if heure_sol then
              if Heure_legale then
                EcrireLigne('Heures légales')
              else
                EcrireLigne('Heures solaires');
            if heure_sol then
              for i := hl - chi to -hl - chi do
              begin
                H := pi / 12 * i + ch;
                if (H < -1E-4) or (H > 1E-4) then
                begin
                  a := sinPhi / tan(H);
                  z := Grand_axe / Sqrt(1 + 1 / sqr(tan(H)));
                  if H > 0 then
                    x := round(z)
                  else
                    x := -round(z);
                  y := round(a * x)
                end
                else
                begin
                  x := 0;
                  y := Petit_axe
                end;
                if Lati > 0 then
                  str(i + 12: 2, hr)
                else
                  str(-i + 12: 2, hr);
                if H * Lati > 0 then
                  setTextAlign(dc, TA_TOP + TA_RIGHT)
                else
                  setTextAlign(dc, TA_TOP + TA_LEFT);
                if (x <> 0) or (y <> 0) then
                begin
                  EcrireA(x, y, hr);
                  EcrireLigne(hr + ' Heure');
                  if coord or FichierCoord then
                    AllerA(x, y)
                  else
                  begin
                    AllerA(x - k, y);
                    LigneA(x + k, y);
                    AllerA(x, y - k);
                    LigneA(x, y + k);
                  end;
                end;
                if Demi_heure then
                begin
                  SelectCrayon(crayon_dhe);
                  H := H + pi / 24;
                  if i < -hl - chi then
                  begin
                    if (H < -1E-4) or (H > 1E-4) then
                    begin
                      a := sinPhi / tan(H);
                      z := Grand_axe / Sqrt(1 + 1 / sqr(tan(H)));
                      if H > 0 then
                        x := round(z)
                      else
                        x := -round(z);
                      y := round(a * x)
                    end
                    else
                    begin
                      x := 0;
                      y := Petit_axe
                    end;
                    EcrireLigne(hr + 'H. 1/2');
                    if coord or FichierCoord then
                      AllerA(x, y)
                    else
                    begin
                      AllerA(x - k, y);
                      LigneA(x + k, y);
                      AllerA(x, y - k);
                      LigneA(x, y + k);
                    end;
                  end;
                  SelectCrayon(old_crayon);
                end;
              end; (* for *)

            if cadran.Arcs_Diurnes then
            begin
              EcrireLigne('Solstices et equinoxes');
              for j := -1 to 1 do
              begin
                y := round(Grand_axe * tan(DegToRad(DeltaDeg[j])) * cosPhi);
                if coord or FichierCoord then
                  AllerA(0, y)
                else
                begin
                  AllerA(-Grand_axe div 100, y);
                  LigneA(Grand_axe div 100, y)
                end;
                if Lati > 0 then
                  setTextAlign(dc, TA_BOTTOM + TA_LEFT)
                else
                  setTextAlign(dc, TA_BOTTOM + TA_RIGHT);
                if j <> 0 then
                  EcrireA(Grand_axe div 50, y - ha div 2, 's');
              end;
            end;
            for i := 1 to NbDates do
            begin
              j := DateArc[i].jour;
              m := DateArc[i].mois;
              k := JourAn(j, m);
              if j <> 0 then
              begin
                y := round(Grand_axe * tan(Declisol(k)) * cosPhi);
                if Lati < 0 then
                  y := -y;
                EcrireLigne(TexteArc(i, j, m));
                if coord or FichierCoord then
                  AllerA(0, y)
                else
                begin
                  AllerA(-Grand_axe div 100, y);
                  LigneA(Grand_axe div 100, y)
                end;
                setTextAlign(dc, TA_BOTTOM + TA_LEFT);
                if AfficheDate then
                  EcrireA(Grand_axe div 50, y - ha div 2, TexteArc(i, j, m));
              end;
            end;
            setTextAlign(dc, 0);

            if OMBREStyle and not FichierCoord then
            begin
              Present := Heurecadran;
              DecodeDate(Present, Year, Month, Day);
              DecodeTime(Present, Hour, Min, Sec, MSec);
              if Heure_legale then
                ch := DegToRad(Longi) + (decalage + decalmin / 60) / 12 * pi
              else
                ch := 0;
              j := Day;
              m := Month;
              H := (Hour + Min / 60 + Sec / 3600 - 12) / 12 * pi - ch +
                EqTemps[JourAn(j, m)].Eqt;
              if Lati < 0 then
                H := -H;
              j := JourAn(j, m);
              if (H < -1E-4) or (H > 1E-4) then
              begin
                a := sinPhi / tan(H);
                z := Grand_axe / Sqrt(1 + 1 / sqr(tan(H)));
                if H > 0 then
                  x := round(z)
                else
                  x := -round(z);
                y := round(a * x)
              end
              else
              begin
                x := 0;
                y := Petit_axe
              end;
              hl := round
                ((ArcCos(-tan(Phi) * tan(DegToRad(DeltaDeg[-1]))) - pi));
              if abs(H) < abs(hl) then
              begin
                Canvas.Brush.color := cldkgray;
                Canvas.Brush.style := bssolid;
                EllipseA(x - Hauteur div 200, y - Hauteur div 200,
                  x + Hauteur div 200, y + Hauteur div 200);
                Canvas.Brush.color := clblack;
                Canvas.Brush.style := bsclear;
                AllerA(x, y);
                x := 0;
                y := round(Grand_axe * tan(EqTemps[j].decsol) * cosPhi);
                if Lati < 0 then
                  y := -y;
                LigneA(x, y);
              end;
            end;

          end;

        Montresol:
          begin
            Phi := DegToRad(Lati);
            EcrireLigne('Graduations');
            k := 0;
            for m := 1 to 12 do
            begin
              EcrireLigne(StMois[m]);
              SelectCrayon(ax);
              Canvas.pen.width := 1;
              Canvas.pen.style := psDash;
              Canvas.pen.color := ClGray;
              for xe := 1 to 2 do
              begin
                x := round((xe * 10 + k - 1) / 364 * largeur) - largeur div 2;
                AllerA(x, -Hauteur div 2);
                LigneA(x, Hauteur div 2);
                EcrireLigne('')
              end;
              SelectCrayon(ax);
              Canvas.pen.style := pssolid;
              k := k + NbJour[m];
              x := round((k - 1) / 364 * largeur) - largeur div 2;
              AllerA(x, -Hauteur div 2);
              LigneA(x, Hauteur div 2);
              setTextAlign(dc, TA_BOTTOM + TA_CENTER);
              x := round((k - 15) / 364 * largeur) - largeur div 2;
              setBkMode(dc, TRANSPARENT);
              EcrireA(x, -Hauteur div 2, StMois[m]);
            end;
            setTextAlign(dc, 0);
            (* hStyle:=round(Hauteur/tan(HautSol(0,DegToRad(DelTaDeg[1]),DegToRad(abs(Lati))))); *)
            LStyle := LStyleMs(Hauteur, Lati);

            if heure_sol then
              if Heure_legale then
                EcrireLigne('Heures légales')
              else
                EcrireLigne('Heures solaires');
            SelectCrayon(hsol);
            if heure_sol then
              for i := hl - chi to -hl - chi do
              begin
                H := pi / 12 * i + ch;
                str(-i + 12: 2, hr);
                EcrireLigne(hr + ' heures');
                if Heure_legale or Eq_Temps_hiver then
                begin
                  if H > 0 then
                  begin
                    SelectCrayon(crayon_hit);
                    setTextColor(dc, clTrait[hit]);
                  end
                  else
                  begin;
                    SelectCrayon(crayon_hbab);
                    setTextColor(dc, clTrait[hbab])
                  end;
                end;
                j := 1 - increment;
                repeat
                  repeat
                    j := j + increment;
                    if j > 365 then
                      j := 365;
                    if Eq_Temps_hiver then
                      h0 := HautSol(H - EqTemps[j].Eqt, EqTemps[j].decsol, Phi)
                    else
                      h0 := HautSol(H, EqTemps[j].decsol, Phi);
                  until (h0 >= 0) or (j >= 365);
                  if j <= 365 then
                  begin
                    y := -round(LStyle * tan(h0)) + Hauteur div 2;
                    x := round((j - 1) / 364 * largeur) - largeur div 2;
                    if (H <= 0) and (h0 > 0) then
                      EcrireA(x, y, hr);
                    AllerA(x, y);
                  end;
                  while (h0 >= 0) and (j < 365) do
                  begin
                    j := j + increment;
                    if j > 365 then
                      j := 365;
                    if Eq_Temps_hiver then
                      h0 := HautSol(H - EqTemps[j].Eqt, EqTemps[j].decsol, Phi)
                    else
                      h0 := HautSol(H, EqTemps[j].decsol, Phi);
                    y := -round(LStyle * tan(h0)) + Hauteur div 2;
                    x := round((j - 1) / 364 * largeur) - largeur div 2;
                    if (h0 > 0) then
                      if Voir(x, y) then
                        LigneA(x, y)
                      else
                        AllerA(x, y);
                    if (H > 0) and (h0 < 0) and (j < 365) then
                      EcrireA(x, y, hr);
                  end;
                  if (H > 0) and (h0 > 0) then
                    EcrireA(x, y, hr);
                until (j >= 365);
              end (* for *);

            // 3D Tracé du style
            if FormCadsol3D.Active then
            begin
              AllerA(0, cadran.Hauteur div 2);
              zrr := FormCadsol3D.GLCylinder1.BottomRadius + LStyle / 1000;
              yrr := -(Hauteur div 2) / 1000;
              xrr := 0;
              // GlCylinder1.TopRadius := Largeur / 2/pi / GrDim ;
              GLLineAJL.AddNode(xrr, yrr, zrr);
            end;
            //

            if OMBREStyle and not FichierCoord then
            begin
              Present := Heurecadran;
              DecodeDate(Present, Year, Month, Day);
              DecodeTime(Present, Hour, Min, Sec, MSec);
              if Heure_legale then
                ch := DegToRad(Longi) + (decalage + decalmin / 60) / 12 * pi
              else
                ch := 0;
              j := Day;
              m := Month;
              H := (Hour + Min / 60 + Sec / 3600 - 12) / 12 * pi - ch +
                EqTemps[JourAn(j, m)].Eqt;
              j := JourAn(j, m);
              h0 := HautSol(H, EqTemps[j].decsol, Phi);
              y := -round(LStyle * tan(h0)) + Hauteur div 2;
              x := round((j - 1) / 364 * largeur) - largeur div 2;
              if (h0 > 0) then
                if Voir(x, y) then
                begin
                  Canvas.Brush.color := cldkgray;
                  Canvas.Brush.style := bssolid;
                  EllipseA(x - Hauteur div 200, y - Hauteur div 200,
                    x + Hauteur div 200, y + Hauteur div 200);
                  Canvas.Brush.color := clblack;
                  Canvas.Brush.style := bsclear;
                end;
            end;

          end;

        vertical, bifilaire: (* généralisé *)
          begin

            Phi := DegToRad(Lati);
            d := DegToRad(Decli);
            incl := DegToRad(Incli);
            cosPhi := cos(Phi);
            sinPhi := sin(Phi);
            cosd := cos(d);
            sind := sin(d);
            cosi := cos(incl);
            sini := sin(incl);
            hl := round(DemiJour(abs(Phi), DegToRad(DeltaDeg[1])) / pi * 12);
            if Heure_legale then
              ch := DegToRad(Longi) + (decalage + decalmin / 60) / 12 * pi
            else
              ch := 0;

            if OMBREStyle and not FichierCoord then
            begin
              Present := Heurecadran;
              DecodeDate(Present, Year, Month, Day);
              DecodeTime(Present, Hour, Min, Sec, MSec);
              j := Day;
              m := Month;
              H := (Hour + Min / 60 + Sec / 3600 - 12) / 12 * pi - ch +
                EqTemps[JourAn(j, m)].Eqt;
              if (Ombre(EqTemps[JourAn(j, m)].decsol, -H) <= 0) then
              begin
                // SelectCrayon(crayon_dhe);
                Canvas.pen.mode := pmnot;
                Canvas.Brush.color := cldkgray;
                // Canvas.Brush.Style := bssolid;
                EllipseA(x - Hauteur div 200, y - Hauteur div 200,
                  x + Hauteur div 200, y + Hauteur div 200);
                // Canvas.Brush.Color := clblack;
                Canvas.Brush.style := bsclear;
                if (typ <> bifilaire) and cadran.sousstyle and (fSousStyle = 0)
                then
                begin
                  AllerA(px, py);
                  if (not hsin) then
                    LigneA(x, y);
                  if hsin and (abs(y - py) > 1E-6) then
                  begin
                    alpha := ArcTan((x - px) / (y - py)) - pi / 2;
                    if (y > py) then
                      alpha := alpha + pi;
                    R := RayonHS(JourAn(j, m));
                    x := round(px - R * cos(alpha));
                    y := round(py + R * sin(alpha));
                    LigneA(x, y);
                  end;
                end;
              end;
              Canvas.pen.mode := pmcopy;
            end;

            (* Heures solaires *)
            if (heure_sol or Eq_Temps_ete or Eq_Temps_hiver) then
            begin

              if Heure_legale then
                EcrireLigne('Heures légales')
              else
                EcrireLigne('Heures solaires');
              SelectCrayon(crayon_hsol);
              setTextColor(dc, cadran.Couleur);
              for i := -hl to hl do
              begin
                H := pi / 12 * i + ch;
                j := 171;
                visible := false;
                debut := true;
                str(-i + 12: 2, hr);
                EcrireLigne(hr + ' heures');
                xd := 0;
                yd := 0;
                xf := 0;
                yf := 0;
                repeat
                  if (Ombre(EqTemps[j].decsol, H) = 0) then
                  begin
                    if debut then
                    begin
                      if (-i + 12) <> 0 then
                        EcrireA(x, y, hr);
                      xd := x;
                      yd := y;
                      xf := x;
                      yf := y;
                      debut := false
                    end;
                    if heure_sol then
                      if visible then
                        LigneA(x, y)
                      else
                        AllerA(x, y);
                    visible := true;
                    xf := x;
                    yf := y
                  end
                  else
                    visible := false;
                  j := j + increment;
                until j >= 356;
                if FichierCoord then
                  EcrireAngle(xd - xf, yd - yf);

                if Demi_heure then
                begin (* demi-heures *)
                  str(-i + 11: 2, hr);
                  EcrireLigne(hr + ' heures 1/2');
                  SelectCrayon(crayon_dhe);
                  H := H + pi / 24;
                  j := 171;
                  visible := false;
                  debut := true;
                  xd := 0;
                  yd := 0;
                  xf := 0;
                  yf := 0;
                  repeat
                    if (Ombre(EqTemps[j].decsol, H) = 0) then
                    begin
                      if debut then
                      begin
                        xd := x;
                        yd := y;
                        xf := x;
                        yf := y;
                        debut := false
                      end;
                      if visible then
                        LigneA(x, y)
                      else
                        AllerA(x, y);
                      visible := true;
                      xf := x;
                      yf := y
                    end
                    else
                      visible := false;
                    j := j + increment;
                  until j > 356;
                  if FichierCoord then
                    EcrireAngle(xd - xf, yd - yf);
                  SelectCrayon(old_crayon);
                end;
              end; (* for *)
            end;

            if Eq_Temps_ete then
            begin
              EcrireLigne('Heures avec équation du temps, du 21/6 au 21/12');
              SelectCrayon(crayon_meri);
              hlm := round(DemiJour(abs(Phi), DegToRad(DeltaDeg[1])) / pi
                * 12 * 60);
              hlm := (hlm div intervalle) * intervalle;
              i := -hlm;
              while i <= hlm do
              begin
                if FichierCoord then
                  EcrireLigne(IntToStr((-i + 12 * 60) div 60) + 'h. ' +
                    IntToStr((-i + 12 * 60) mod 60) + 'min.');
                if (i mod 60) = 0 then
                  SelectCrayon(crayon_meri)
                else
                  SelectCrayon(crayon_dhe);
                H := i / 60 / 12 * pi + ch;
                j := 172;
                visible := false;
                repeat
                  if (Ombre(EqTemps[j].decsol, H - EqTemps[j].Eqt) = 0) then
                  begin
                    if visible then
                      LigneA(x, y)
                    else
                      AllerA(x, y);
                    visible := true;
                  end
                  else
                    visible := false;
                  j := j + increment;
                until j > 355 + increment;
                i := i + intervalle;
              end;
              SelectCrayon(old_crayon);
            end;

            if Eq_Temps_hiver then
            begin
              EcrireLigne('Heures avec équation du temps, du 21/12 au 21/6');
              SelectCrayon(crayon_meri);
              hlm := round(DemiJour(abs(Phi), DegToRad(DeltaDeg[1])) / pi
                * 12 * 60);
              hlm := (hlm div intervalle) * intervalle;
              i := -hlm;
              while i <= hlm do
              begin
                if FichierCoord then
                  EcrireLigne(IntToStr((-i + 12 * 60) div 60) + 'h. ' +
                    IntToStr((-i + 12 * 60) mod 60) + 'min.');
                if (i mod 60) = 0 then
                  SelectCrayon(crayon_meri)
                else
                  SelectCrayon(crayon_dhe);
                H := i / 60 / 12 * pi + ch;
                j := 354;
                visible := false;
                repeat
                  if j > 365 then
                    k := j - 365
                  else
                    k := j;
                  if (Ombre(EqTemps[k].decsol, H - EqTemps[k].Eqt) = 0) then
                  begin
                    if visible then
                      LigneA(x, y)
                    else
                      AllerA(x, y);
                    visible := true;
                  end
                  else
                    visible := false;
                  j := j + increment;
                until j > 537 + increment;
                i := i + intervalle;
              end;
              SelectCrayon(old_crayon);
            end;

            (* arcs diurnes *)
            SelectCrayon(crayon_arcd);
            if cadran.Arcs_Diurnes then
            begin
              EcrireLigne('Solstices(s) et équinoxe(e)');
              TraceArcDiurne(Phi, DegToRad(DeltaDeg[-1]), 's');
              TraceArcDiurne(Phi, DegToRad(DeltaDeg[0]), 'e');
              TraceArcDiurne(Phi, DegToRad(DeltaDeg[1]), 's');
            end;
            for i := 1 to NbDates do
            begin
              j := DateArc[i].jour;
              m := DateArc[i].mois;
              k := JourAn(j, m);
              if j <> 0 then
                TraceArcDiurne(Phi, EqTemps[k].decsol, TexteArc(i, j, m));
            end;
            SelectCrayon(old_crayon);

            (* heures italiques *)
            if heure_ita and (abs(Lati) < 66.56) then
            begin
              selectObject(dc, HUserPol);
              SelectCrayon(crayon_hit);
              setTextColor(dc, cadran.clTrait[hit]);
              EcrireLigne('Heure italiques');
              for i := 0 to 2 * hl - 1 do
              begin
                j := 172;
                visible := false;
                debut := true;
                str(i: 2, hr);
                EcrireLigne(' Heure ' + hr);
                repeat
                  H := -DemiJour(Phi, EqTemps[j].decsol) + i * pi / 12;
                  if (Ombre(EqTemps[j].decsol, H) = 0) then
                  begin
                    if visible then
                      LigneA(x, y)
                    else
                      AllerA(x, y);
                    visible := true;
                  end
                  else
                    visible := false;
                  if visible and debut and (j > 200) then
                  begin
                    EcrireA(x, y, hr);
                    debut := false
                  end;
                  j := j + increment;
                until j > 355;
              end;
              SelectCrayon(old_crayon);
            end;

            (* heures babyloniques *)
            if heure_bab and (abs(Lati) < 66.56) then
            begin
              selectObject(dc, HUserPol);
              SelectCrayon(crayon_hbab);
              setTextColor(dc, cadran.clTrait[hbab]);
              EcrireLigne('Heure babyloniques');
              for i := 0 to 2 * hl - 1 do
              begin
                j := 172;
                visible := false;
                debut := true;
                str(i: 2, hr);
                EcrireLigne(' Heure ' + hr);
                repeat
                  H := DemiJour(Phi, EqTemps[j].decsol) - i * pi / 12;
                  if (Ombre(EqTemps[j].decsol, H) = 0) then
                  begin
                    if visible then
                      LigneA(x, y)
                    else
                      AllerA(x, y);
                    visible := true;
                  end
                  else
                    visible := false;
                  if visible and debut and (j > 300) then
                  begin
                    EcrireA(x, y, hr);
                    debut := false
                  end;
                  j := j + increment;
                until j > 355;
              end;
              SelectCrayon(old_crayon);
            end;

            (* heures antiques *)
            if heure_temp and (abs(Lati) < 66.56) then
            begin
              SelectCrayon(crayon_meri);
              setTextColor(dc, cadran.clTrait[meri]);
              EcrireLigne('Heure antiques');
              for i := -6 to 6 do
              begin
                j := 172;
                visible := false;
                debut := true;
                str((-i + 6): 2, hr);
                EcrireLigne(' Heure ' + hr);
                repeat
                  H := i * DemiJour(Phi, EqTemps[j].decsol) / 6;
                  if (Ombre(EqTemps[j].decsol, H) = 0) then
                  begin
                    if visible then
                      LigneA(x, y)
                    else
                      AllerA(x, y);
                    visible := true;
                  end
                  else
                    visible := false;
                  if visible and debut and (j > 250) then
                  begin
                    EcrireA(x, y, hr);
                    debut := false
                  end;
                  j := j + increment;
                until j > 355;
              end;
              SelectCrayon(old_crayon);
            end;

            if (typ = vertical) and (fSousStyle = 0) then
            begin
              l := Sqrt((px - gx) * (px - gx) + (py - gy) * (py - gy) + hstyle
                * hstyle);
              if sousstyle and (l < 32000) then
              begin
                EcrireLigne('Sous-stylaire (Gnomon->pole)');
                SelectCrayon(crayon_ax);
                AllerA(gx, gy);
                LigneA(px, py);
                SelectCrayon(old_crayon);
                // 3D
                ZP := hstyle;
                AllerA(gx, gy);
                ZP := 10;
                LigneA(px, py);
                //
              end;
            end;

            (* gnomon *)
            if (not cadran.coord) and (not FichierCoord) then
            begin
              SelectCrayon(crayon_ax);
              AllerA(gx - largeur div 100, gy);
              LigneA(gx + largeur div 100, gy);
              AllerA(gx, gy - Hauteur div 100);
              LigneA(gx, gy + Hauteur div 100);
              SelectCrayon(old_crayon);
              // 3D
              if typ = vertical then
              begin
                ZP := hstyle;
                AllerA(gx, gy);
                ZP := 10;
                LigneA(gx, gy)
              end;
              //
            end
            else
            begin
              if typ = vertical then
                EcrireLigne('Position du style droit');
              if typ = bifilaire then
              begin
                EcrireLigne('Croisement des fils');
                AllerA(gx, gy)
              end;
            end;
            // 3D
            if typ = bifilaire then
            begin
              ZP := hstyle;
              AllerA(-largeur div 2, gy);
              LigneA(largeur div 2, gy);
              ZP := distance;
              AllerA(gx, -Hauteur div 2);
              LigneA(gx, Hauteur div 2);
              ZP := 10
            end;
            //

            if (typ = vertical) and hsin and (fSousStyle = 0) then
            begin
              EcrireLigne('Lignes sinueuses');
              SelectCrayon(crayon_meri);
              setTextColor(dc, cadran.clTrait[meri]);
              hlm := round(DemiJour(abs(Phi), DegToRad(DeltaDeg[1])) / pi
                * 12 * 60);
              hlm := (hlm div intervalle) * intervalle;
              i := -hlm;
              while i <= hlm do
              begin
                if FichierCoord then
                  EcrireLigne(IntToStr((-i + 12 * 60) div 60) + 'h. ' +
                    IntToStr((-i + 12 * 60) mod 60) + 'min.');
                if (i mod 60) = 0 then
                  SelectCrayon(crayon_meri)
                else
                  SelectCrayon(crayon_dhe);
                H := i / 60 / 12 * pi;
                if Heure_legale then
                  H := H + DegToRad(Longi) + (decalage + decalmin / 60)
                    / 12 * pi;
                j := 1;
                debut := true;
                visible := false;
                repeat
                  hcs := H - EqTemps[j].Eqt;
                  if (Ombre(EqTemps[j].decsol, hcs) <= 0) and
                    (abs(y - py) > 1E-6) then
                  begin
                    alpha := ArcTan((x - px) / (y - py)) - pi / 2;
                    if (y > py) then
                      alpha := alpha + pi;
                    R := RayonHS(j);
                    x := round(px - R * cos(alpha));
                    y := round(py + R * sin(alpha));
                    if Voir(x, y) then
                    begin
                      if debut then
                        AllerA(x, y)
                      else
                      begin
                        LigneA(x, y);
                        visible := true
                      end;
                      debut := false;
                    end
                    else
                      debut := true;
                  end
                  else
                    debut := true;
                  j := j + increment;
                until j > 365;
                if (not heure_sol) and ((i mod 60) = 0) and visible and
                  Voir(x, y) then
                  EcrireA(x, y, IntToStr((-i + 12 * 60) div 60));
                i := i + intervalle;
              end;
              SelectCrayon(crayon_hsol);
              for m := 1 to 12 do
              begin
                k := 1;
                j := JourAn(k, m);
                i := -hlm;
                debut := true;
                R := RayonHS(j);
                debut := true;
                while i <= hlm do
                begin
                  H := i / 60 / 12 * pi;
                  if Heure_legale then
                    H := H + DegToRad(Longi) + (decalage + decalmin / 60)
                      / 12 * pi;
                  hcs := H - EqTemps[j].Eqt;
                  if (Ombre(EqTemps[j].decsol, hcs) <= 0) and
                    (abs(y - py) > 1E-6) then
                  begin
                    alpha := ArcTan((x - px) / (y - py)) - pi / 2;
                    if (y > py) then
                      alpha := alpha + pi;
                    x := round(px - R * cos(alpha));
                    y := round(py + R * sin(alpha));
                    if (y > py) then
                      alpha := alpha + pi;
                    if Voir(x, y) then
                    begin
                      if debut then
                      begin
                        oldHFont := selectObject(dc, hCoordPol);
                        EcrireA(x, y, ' 1er ' + StMois[m]);
                        selectObject(dc, oldHFont);
                        AllerA(x, y)
                      end
                      else
                        LigneA(x, y);
                      debut := false;
                    end
                    else
                      debut := true;
                  end
                  else
                    debut := true;
                  i := i + precision;
                end;
              end;
            end;

          end; (* vertical *)

        courbeEqT:
          begin
            // axes
            SelectCrayon(crayon_Ax);
            xmin := -largeur div 2 + marge;
            ymin := -Hauteur div 2 + marge;
            xmax := largeur div 2 - marge;
            ymax := Hauteur div 2 - marge;
            AllerA(xmin, ymin);
            LigneA(xmin, ymax);
            AllerA(xmin, (ymin + ymax) div 2);
            LigneA(xmax, (ymin + ymax) div 2);

            // Graduation jours
             k := 0;
             Canvas.pen.width := 1;
             Canvas.pen.style := pssolid;
            for m := 1 to 12 do
            begin
              Canvas.pen.color := ClSilver;
              for xe := 1 to 2 do
              begin
                x := round((xe * 10 + k - 1) / 364 * (xmax - xmin)) + xmin;
                y := ymax;
                AllerA(x, -y);
                LigneA(x, y);
              end;
              k := k + NbJour[m];
              x := round((k - 1) / 364 * (xmax - xmin)) + xmin;
              AllerA(x, ymin);
              LigneA(x, ymax);
              setTextAlign(dc, TA_BOTTOM + TA_CENTER);
              x := round((k - 15) / 364 * (xmax - xmin)) + xmin;
              setBkMode(dc, TRANSPARENT);
              EcrireA(x, ymin - marge div 2, StMois[m]);
            end;
            for i := -20 to 20 do
            begin
              y := round((i / 40) * (ymax - ymin));
              Canvas.pen.color := ClSilver;
              if (i mod 5) = 0 then
              begin
                Canvas.pen.color := ClGray;
                EcrireA(xmin - marge div 2, y, IntToStr(i));
              end;
              x := xmin;
              AllerA(x, y);
              x := xmax;
              LigneA(x, y);
            end;

            EcrireA(xmin - marge, ymax + marge, 'Temps(min.)');
            EcrireA(xmax + marge, ymin, 'Date');
            setTextAlign(dc, 0);
            cadran.Devise := 'EQUATION DU TEMPS';
            cadran.Devx := (xmin + xmax) div 4;
            cadran.Devy := ymax + marge * 3 div 4;

             // Courbe
            SelectCrayon(crayon_hsol);
            j := 1;
            y := trunc(-EqduTemps(j) / 60 / 40 * (ymax - ymin));
            x := trunc((j - 1) / 365 * (xmax - xmin) + xmin);
            AllerA(x, y);
            repeat
            begin
              inc(j);
              y := trunc(-EqduTemps(j) / 60 / 40 * (ymax - ymin));
              x := trunc((j - 1) / 365 * (xmax - xmin) + xmin);
              LigneA(x, y);
            end
            until j = 365;
          end;

        courbeAna:
          begin
            // axes
            SelectCrayon(crayon_ax);
            xmin := -largeur div 2 + marge;
            ymin := -Hauteur div 2 + marge;
            xmax := largeur div 2 - marge;
            ymax := Hauteur div 2 - marge;
            AllerA((xmin + xmax) div 2, ymin);
            LigneA((xmin + xmax) div 2, ymax);
            AllerA(xmin, (ymin + ymax) div 2);
            LigneA(xmax, (ymin + ymax) div 2);
             // Graduations
            Canvas.pen.width := 1;
            for i := -25 to 25 do
            begin
              y := round((i / 50) * (ymax - ymin));
              Canvas.pen.color := ClSilver;
              if (i mod 5) = 0 then
              begin
                Canvas.pen.color := clgray;
                EcrireA(xmin - marge div 2, y, IntToStr(i) + '°');
              end;
              x := xmin;
              AllerA(x, y);
              x := xmax;
              LigneA(x, y);
            end;
            for i := -20 to 20 do
            begin
              x := round((i / 40) * (xmax - xmin));
              Canvas.pen.color := ClSilver;
              if (i mod 5) = 0 then
              begin
                Canvas.pen.color := clGray;
                EcrireA(x,ymin - marge div 2, IntToStr(i));
              end;
              y := ymin;
              AllerA(x, y);
              y := ymax;
              LigneA(x, y);
            end;
            // Courbe
            SelectCrayon(crayon_hsol);
            j := 1;
            y := trunc((Declisol(j) / pi * 180 / 50) * (ymax - ymin));
            x := trunc(EqduTemps(j) / 60 / 40 * (xmax - xmin));
            AllerA(x, y);
            repeat
            begin
              inc(j);
              y := trunc((Declisol(j) / pi * 180 / 50) * (ymax - ymin));
              x := trunc(EqduTemps(j) / 60 / 40 * (xmax - xmin));
              LigneA(x, y);
            end
            until j = 366;
            j := 1;
            y := trunc((Declisol(j) / pi * 180 / 50) * (ymax - ymin));
            x := trunc(EqduTemps(j) / 60 / 40 * (xmax - xmin));
            LigneA(x, y);
            //
            EcrireA(xmin - marge, ymax + marge, 'Déclinaison du soleil (en °)');
            EcrireA(xmax + marge, ymin, 'Eq. du Temps (min.)');
            setTextAlign(dc, 0);
            cadran.Devise := 'ANALEMNE';
            cadran.Devx := (xmin + xmax) div 4;
            cadran.Devy := ymax + marge * 3 div 4;
          end;
      end; { case }
      selectObject(dc, HUserPol);
      setTextColor(dc, cadran.clTrait[hsol]);
      EcrireLigne('Devise: ' + Devise);
      EcrireA(Devx, Devy, Devise);

      SetCursor(OldCur);
      selectObject(dc, hOldFont);
      SelectCrayon(old_crayon);

    end { with }
  else
  begin
    MessageBox(0,
      'Désactiver l''affichage du contenu des fenêtres'#13'pendant le déplacement',
      'CADSOL: Modifier les propriétés de l''affichage', MB_ICONSTOP);
    halt;
  end;
end;

begin
  nbp := 0;
  lg := '';

end.
