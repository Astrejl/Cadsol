unit Splash;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, jpeg;

type
  TSplashForm = class(TForm)
    Image1: TImage;
    // procedure FormCreate(Sender: TObject);
  private
    { Private-d�clarations }
  public
    { Public-d�clarations }
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}
(*
  procedure TSplashForm.FormCreate(Sender: TObject);
  begin
  try
  Image1.Picture.loadfromFile(ExtractFilePath(Application.exeName)+
  'VerticalPhoto.bmp');
  Image1.Height:=Image1.Picture.Bitmap.Height;
  Image1.Width:=Image1.Picture.Bitmap.Width;
  Width:=Image1.Width;
  Height:=Image1.Height;
  finally
  end;
  end; *)

end.
