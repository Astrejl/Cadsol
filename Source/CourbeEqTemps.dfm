object FormCourbeEqTemps: TFormCourbeEqTemps
  Left = 804
  Top = 301
  Caption = 'Courbe de l'#39#233'quation du temps'
  ClientHeight = 419
  ClientWidth = 612
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
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 612
    Height = 27
    Align = alBottom
    TabOrder = 1
    object PrintButton: TButton
      Left = 64
      Top = 0
      Width = 72
      Height = 21
      Caption = 'Imprimer...'
      TabOrder = 0
      OnClick = PrintButtonClick
    end
    object OKBitBtn: TBitBtn
      Left = 0
      Top = 0
      Width = 61
      Height = 20
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = OKBitBtnClick
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 612
    Height = 392
    BackWall.Brush.Style = bsClear
    Gradient.EndColor = clAqua
    Gradient.StartColor = 8421631
    Legend.Visible = False
    PrintProportional = False
    Title.Color = clRed
    Title.Font.Height = -25
    Title.Frame.Width = 2
    Title.Text.Strings = (
      'Equation du temps')
    BottomAxis.DateTimeFormat = 'dd/MM'
    BottomAxis.Grid.Color = 16744448
    BottomAxis.Grid.DrawAlways = True
    BottomAxis.Grid.ZPosition = 1.000000000000000000
    BottomAxis.Increment = 7.000000000000000000
    BottomAxis.LabelsFormat.Font.Height = -16
    BottomAxis.MinorTickCount = 0
    BottomAxis.MinorTickLength = 0
    BottomAxis.TickInnerLength = 2
    BottomAxis.Title.Caption = 'Date'
    BottomAxis.Title.Font.Height = -28
    Chart3DPercent = 35
    LeftAxis.AxisValuesFormat = '#,##0.##'
    LeftAxis.DateTimeFormat = 'nn:ss'
    LeftAxis.ExactDateTime = False
    LeftAxis.Grid.Color = 16744448
    LeftAxis.Increment = 1.000000000000000000
    LeftAxis.LabelsFormat.Font.Height = -16
    LeftAxis.LabelsFormat.Shadow.Visible = False
    LeftAxis.MinorGrid.Color = clSilver
    LeftAxis.MinorGrid.Visible = True
    LeftAxis.MinorTickCount = 5
    LeftAxis.MinorTickLength = 4
    LeftAxis.TickLength = 2
    LeftAxis.Ticks.Color = 4194368
    LeftAxis.Ticks.Width = 2
    LeftAxis.Title.Caption = 'Minutes'
    LeftAxis.Title.Font.Color = clRed
    LeftAxis.Title.Font.Height = -19
    LeftAxis.Title.Color = -1
    LeftAxis.Title.Pen.Color = 1476395008
    LeftAxis.Title.Pen.Width = 0
    LeftAxis.TitleSize = 40
    SeriesGroups = <
      item
        Name = 'Group1'
      end
      item
        Name = 'Group2'
      end>
    View3D = False
    Align = alClient
    BevelInner = bvLowered
    BevelWidth = 2
    BorderWidth = 2
    Color = clWhite
    TabOrder = 0
    OnClick = Chart1Click
    DefaultCanvas = 'TTeeCanvas3D'
    PrintMargins = (
      4
      14
      14
      14)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Marks.Style = smsValue
      SeriesColor = clRed
      Title = 'Valeurs'
      Brush.BackColor = clDefault
      Dark3D = False
      LinePen.Color = clRed
      Pointer.Brush.Color = clRed
      Pointer.HorizSize = 1
      Pointer.InflateMargins = True
      Pointer.Style = psDiamond
      Pointer.VertSize = 1
      Pointer.Visible = True
      XValues.DateTime = True
      XValues.Name = 'X '
      XValues.Order = loAscending
      YValues.Name = 'Y '
      YValues.Order = loNone
    end
  end
end
