Unit Trigo;

Interface

{$IFOPT N+}

type
  real = Extended;
{$ENDIF}
Function DegToRad(x: real): real;
Function RadToDeg(x: real): real;
Function Tan(x: real): real;
Function Arcsin(x: real): real;
Function ArcCos(x: real): real;

Implementation

Const
  Eps = 1E-6;

Function DegToRad(x: real): real;
begin
  DegToRad := x / 180 * pi;
end;

Function RadToDeg(x: real): real;
begin
  RadToDeg := x / pi * 180;
end;

Function Tan(x: real): real;
var
  s, c: real;
begin
  s := sin(x);
  c := cos(x);
  if abs(c) > Eps then
    Tan := s / c
  else
    Tan := sin(x) / Eps;
end;

Function Arcsin(x: real): real;
var
  x2, y: real;
begin
  if x > 1 - Eps then
    y := pi / 2
  else if x < -1 + Eps then
    y := -pi / 2
  else
  begin
    x2 := x * x;
    y := ArcTan(sqrt(x2 / (1 - x2)));
    if x < 0 then
      y := -y;
  end;
  Arcsin := y;
end;

Function ArcCos(x: real): real;
var
  x2, y: real;

begin
  if x > 1 - Eps then
    y := 0
  else if x < -1 + Eps then
    y := pi
  else if abs(x) < Eps then
    y := pi / 2
  else
  begin
    x2 := x * x;
    y := ArcTan(sqrt((1 - x2) / x2));
    if x < 0 then
      y := pi - y;
  end;
  ArcCos := y;
end;

end.
