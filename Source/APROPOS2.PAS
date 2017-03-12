unit APROPOS2;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg, Vcl.Imaging.pngimage, Vcl.Dialogs;

type
  TFormAPropos = class(TForm)
    Panel1: TPanel;
    Copyright: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    Log: TLabel;
    Label6: TLabel;
    n: TStaticText;
    Image3: TImage;
    DateCreationLb: TLabel;
    FileVersion: TLabel;
    DateLicenceLb: TLabel;
    VersionLb: TLabel;
    Image1: TImage;

    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAPropos: TFormAPropos;

implementation

{$R *.DFM}

uses sysutils, Cadvar, Infosys;

type
  TEXEVersionData = record
    CompanyName, FileDescription, FileVersion, InternalName, LegalCopyright,
      LegalTrademarks, OriginalFileName, ProductName, ProductVersion, Comments,
      PrivateBuild, SpecialBuild: string;
  end;
var lang: string;
function GetEXEVersionData(const FileName: string): TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;

  TLandCodepage = record
    wLanguage, wCodePage: word;
  end;
var
  dummy, len: cardinal;
  buf, pntr: pointer;
 // lang: string;
begin
  len := GetFileVersionInfoSize(PChar(FileName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage,
      PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'),
      pntr, len) { and (@len <> nil) } then
      result.CompanyName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'),
      pntr, len) { and (@len <> nil) } then
      result.FileDescription := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'),
      pntr, len) { and (@len <> nil) } then
      result.FileVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'),
      pntr, len) { and (@len <> nil) } then
      result.InternalName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'),
      pntr, len) { and (@len <> nil) } then
      result.LegalCopyright := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'),
      pntr, len) { and (@len <> nil) } then
      result.LegalTrademarks := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang +
      '\OriginalFileName'), pntr, len) { and (@len <> nil) } then
      result.OriginalFileName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'),
      pntr, len) { and (@len <> nil) } then
      result.ProductName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'),
      pntr, len) { and (@len <> nil) } then
      result.ProductVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr,
      len) { and (@len <> nil) } then
      result.Comments := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'),
      pntr, len) { and (@len <> nil) } then
      result.PrivateBuild := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'),
      pntr, len) { and (@len <> nil) } then
      result.SpecialBuild := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

procedure TFormAPropos.FormActivate(Sender: TObject);
var
  Year, Month, Day: word;
  TV: TEXEVersionData;
begin
  Caption := 'A propos de ' + Application.Title;
  DecodeDate(FileDateToDateTime(fileage(paramStr(0))), Year, Month, Day);
  DateCreationLb.Caption := IntToStr(Day) + ' / ' + IntToStr(Month) + ' / ' +IntToStr(Year);
  // FileVersionInfo;
  DateLicenceLb.Caption:= IntToStr(CurrentYear);
  TV := GetEXEVersionData(paramStr(0));
  VersionLb.Caption := TV.FileVersion;
 (* With TV,Memo.Lines do begin
    Add(CompanyName);
    Add(FileDescription);
    Add(FileVersion);
    Add(InternalName);
    Add(LegalCopyright);
    add(LegalTrademarks);
    add(OriginalFileName);
    add(ProductName);
    add(ProductVersion);
    add(Comments);
    add(PrivateBuild);
    add(SpecialBuild);
    end;       *)

  //OSLb.Caption := Format('%s   %d.%d',['Windows', Win32MajorVersion, Win32MinorVersion]);
end;


procedure TFormAPropos.SpeedButton1Click(Sender: TObject);
begin
  FormInfoSys.ShowModal;
end;

end.
