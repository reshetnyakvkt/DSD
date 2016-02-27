object wndMain: TwndMain
  Left = 0
  Top = 0
  Caption = 'wndMain'
  ClientHeight = 349
  ClientWidth = 610
  Color = clBtnFace
  Constraints.MinHeight = 139
  Constraints.MinWidth = 302
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    610
    349)
  PixelsPerInch = 96
  TextHeight = 13
  object edPathFile: TEdit
    Left = 7
    Top = 8
    Width = 445
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
  end
  object btnOpen: TButton
    Left = 459
    Top = 7
    Width = 69
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object gMain: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 37
    Width = 604
    Height = 268
    Margins.Top = 37
    Align = alClient
    DataSource = dsMain
    DrawingStyle = gdsGradient
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnImport: TButton
    Left = 534
    Top = 7
    Width = 69
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Import'
    TabOrder = 3
    OnClick = btnImportClick
  end
  object Panel: TPanel
    Left = 0
    Top = 308
    Width = 610
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Label1: TLabel
      Left = 12
      Top = 10
      Width = 62
      Height = 16
      Caption = 'TotalCount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 186
      Top = 10
      Width = 41
      Height = 16
      Caption = 'Loaded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 336
      Top = 10
      Width = 45
      Height = 16
      Caption = 'Skipped'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTotalCount: TLabel
      Left = 77
      Top = 10
      Width = 60
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbLoaded: TLabel
      Left = 232
      Top = 10
      Width = 42
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbSkipped: TLabel
      Left = 388
      Top = 10
      Width = 42
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object dsMain: TDataSource
    Left = 40
    Top = 80
  end
end
