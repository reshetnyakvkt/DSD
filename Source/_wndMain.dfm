object wndMain: TwndMain
  Left = 0
  Top = 0
  Caption = 'wndMain'
  ClientHeight = 348
  ClientWidth = 734
  Color = clBtnFace
  Constraints.MinHeight = 150
  Constraints.MinWidth = 325
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    734
    348)
  PixelsPerInch = 105
  TextHeight = 14
  object edPathFile: TEdit
    Left = 8
    Top = 8
    Width = 556
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
  end
  object btnOpen: TButton
    Left = 570
    Top = 7
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object gMain: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 40
    Width = 728
    Height = 305
    Margins.Top = 40
    Align = alClient
    DataSource = dsMain
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnImport: TButton
    Left = 651
    Top = 7
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Import'
    TabOrder = 3
    OnClick = btnImportClick
  end
  object dsMain: TDataSource
    Left = 40
    Top = 80
  end
end
