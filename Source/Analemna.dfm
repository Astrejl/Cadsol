object FormAnalemna: TFormAnalemna
  Left = 207
  Top = 148
  Caption = 'Analemne'
  ClientHeight = 433
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 308
    Height = 413
    BackWall.Brush.Style = bsClear
    Legend.Visible = False
    PrintProportional = False
    Title.Text.Strings = (
      'Analemne')
    BottomAxis.Axis.Width = 1
    BottomAxis.Grid.Color = clBlue
    BottomAxis.MinorGrid.Color = clSilver
    BottomAxis.MinorGrid.Visible = True
    BottomAxis.MinorTickCount = 5
    BottomAxis.MinorTicks.Color = 16744448
    BottomAxis.Ticks.Color = 16744448
    BottomAxis.TicksInner.Color = clBlue
    BottomAxis.Title.Caption = 'Equation du temps (mn)'
    LeftAxis.Axis.Width = 1
    LeftAxis.Grid.Color = 16744448
    LeftAxis.MinorGrid.Color = 16744448
    LeftAxis.MinorTickCount = 5
    LeftAxis.MinorTicks.Color = 16744448
    LeftAxis.TicksInner.Color = clBlue
    LeftAxis.Title.Caption = 'Declinaison du soleil  ('#176')'
    View3D = False
    Align = alClient
    BevelInner = bvLowered
    BevelWidth = 2
    BorderWidth = 2
    Color = clWhite
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TPointSeries
      SeriesColor = clRed
      ClickableLine = False
      Pointer.Brush.Color = clRed
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Style = psDiamond
      Pointer.VertSize = 2
      XValues.Name = 'X '
      XValues.Order = loAscending
      YValues.Name = 'Y '
      YValues.Order = loNone
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 413
    Width = 308
    Height = 20
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 0
      Top = 0
      Width = 61
      Height = 20
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object ImprimerBtn: TBitBtn
      Left = 65
      Top = 0
      Width = 61
      Height = 20
      Caption = 'Imprimer...'
      TabOrder = 1
      OnClick = ImprimerBtnClick
    end
  end
end
