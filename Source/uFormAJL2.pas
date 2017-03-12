unit uFormAJL2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.IniFiles,Vcl.Themes;

type
  TFormAJL = class(TForm)

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

constructor TFormAJL.Create(AOwner: TComponent);
var
  Ini: TIniFile;
  NameStyle,Name:String;
begin
  inherited Create(AOwner);
  Ini:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Top := Ini.ReadInteger(Name, 'Top', Top);
    Left := Ini.ReadInteger(Name, 'Left', Left);
    Width := Ini.ReadInteger(Name, 'Width', Width);
    Height := Ini.ReadInteger(Name, 'Height', Height);
    windowState := TWindowState(Ini.ReadInteger(Name, 'WindowState',
      Integer(windowState)));
    NameStyle:=Ini.ReadString(Name,'Style','Window') ;
    TStyleManager.TrySetStyle(NameStyle);
  finally
    Ini.Free;
  end;
end;

destructor TFormAJL.Destroy;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Ini.WriteInteger(Name, 'Top', Top);
    Ini.WriteInteger(Name, 'Left', Left);
    Ini.WriteInteger(Name, 'Width', Width);
    Ini.WriteInteger(Name, 'Height', Height);
    Ini.WriteInteger(Name, 'wsState', Integer(windowState));
    Ini.WriteString(Name,'Style',TStyleManager.ActiveStyle.Name);
  finally
    Ini.Free;
  end;
  inherited Destroy;
end;

end.
