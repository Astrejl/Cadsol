unit InfoSys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Gauges, jpeg, Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage;

type
  TFormInfoSys = class(TForm)
    BitBtn1: TBitBtn;
    OS: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    procedure GetOSInfo;

    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormInfoSys: TFormInfoSys;

implementation

{$R *.DFM}

procedure TFormInfoSys.GetOSInfo;
var
  Platform: string;
  BuildNumber: Integer;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        Platform := 'Windows';
        BuildNumber := Win32BuildNumber and $0000FFFF;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        Platform := 'Windows';
        BuildNumber := Win32BuildNumber;
      end;
  else
    begin
      Platform := 'Windows';
      BuildNumber := 0;
    end;
  end;
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or
    (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if Win32CSDVersion = '' then
      OS.Caption := Format('%s   %d.%d (build %d)', [Platform, Win32MajorVersion,
        Win32MinorVersion, BuildNumber])
    else
      OS.Caption := Format('%s   %d.%d ( %d: %s)', [Platform, Win32MajorVersion,
        Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    OS.Caption := Format('%s %d.%d', [Platform, Win32MajorVersion,
      Win32MinorVersion])
end;

procedure TFormInfoSys.FormActivate(Sender: TObject);
begin
  //GetOSInfo;
OS.Caption := Format('%s   %d.%d',['Windows', Win32MajorVersion, Win32MinorVersion])
end;

procedure TFormInfoSys.BitBtn1Click(Sender: TObject);
begin
  close
end;

end.

(*

  procedure TAboutBox.GetOSInfo;
  var
  Platform: string;
  BuildNumber: Integer;
  begin
  case Win32Platform of
  VER_PLATFORM_WIN32_WINDOWS:
  begin
  Platform := 'Windows 95';
  BuildNumber := Win32BuildNumber and $0000FFFF;
  end;
  VER_PLATFORM_WIN32_NT:
  begin
  Platform := 'Windows NT';
  BuildNumber := Win32BuildNumber;
  end;
  else
  begin
  Platform := 'Windows';
  BuildNumber := 0;
  end;
  end;
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or
  (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
  if Win32CSDVersion = '' then
  OS.Caption := Format('%s %d.%d (Build %d)', [Platform, Win32MajorVersion,
  Win32MinorVersion, BuildNumber])
  else
  OS.Caption := Format('%s %d.%d (Build %d: %s)', [Platform, Win32MajorVersion,
  Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
  OS.Caption := Format('%s %d.%d', [Platform, Win32MajorVersion,
  Win32MinorVersion])
  end;

  procedure TAboutBox.InitializeCaptions;
  var
  MS: TMemoryStatus;
  begin
  GetOSInfo;
  MS.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  PhysMem.Caption := FormatFloat('#,###" KB"', MS.dwTotalPhys div 1024);
  AvailPhys.Caption := FormatFloat('#,###" KB"', MS.dwAvailPhys div 1024);
  end;


  typedef struct _MEMORYSTATUS { // mst

  DWORD dwLength;        // sizeof(MEMORYSTATUS)
  DWORD dwMemoryLoad;    // percent of memory in use
  DWORD dwTotalPhys;     // bytes of physical memory
  DWORD dwAvailPhys;     // free physical memory bytes
  DWORD dwTotalPageFile; // bytes of paging file
  DWORD dwAvailPageFile; // free bytes of paging file
  DWORD dwTotalVirtual;  // user bytes of address space
  DWORD dwAvailVirtual;  // free user bytes
  } MEMORYSTATUS, *LPMEMORYSTATUS; *)
