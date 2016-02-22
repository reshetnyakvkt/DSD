unit uImportManager;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB, Datasnap.DBClient,
  IniFiles,
  uSettingsImport,
  Variants;

const
  C_SC_MAIN = 'MAIN';
  C_PAR_FILE = 'FILE';

type
  TImportManager = class
  private
    FOwner: TComponent;
    FAppPath : string;
    FAppName : string;
    FSettingsFile : string;
    FSettingsImport : TSettingsImport;
  private
    FFileName : string;
    procedure SetFileName(const Value: string);
  private
    FIniFile : TIniFile;
    FIniFileName : string;
  public
    DataSet : TClientDataSet;
    property FileName : string read FFileName write SetFileName;
  public
    procedure Import;
    constructor Create(AOwner : TComponent; AppPath : String);
    destructor Destroy; override;
  end;

implementation

uses
  uImportXLS,
  _wndProgress;

{ TImportManager }

constructor TImportManager.Create(AOwner: TComponent; AppPath: String);
begin
  FOwner := AOwner;
  FAppPath := ExtractFilePath(AppPath);
  FAppName := ExtractFileName(AppPath);
  FAppName := copy(FAppName, 1, length(FAppName) - Length(ExtractFileExt(FAppName)));
  FIniFileName := Format('%s.%s', [FAppPath + FAppName, 'ini']);
  FIniFile := TIniFile.Create(FIniFileName);

  FileName := FIniFile.ReadString(C_SC_MAIN, C_PAR_FILE, '');
  FSettingsFile := FAppPath + FAppName + '.xml';
  FSettingsImport := TSettingsImport.Create(FSettingsFile);
  DataSet := TClientDataSet.Create(FOwner);
end;

destructor TImportManager.Destroy;
begin
  FIniFile.Free;
  FSettingsImport.Save(FSettingsFile);
end;

procedure TImportManager.Import;
const
  StepRow = 2;
var
  FImportDriverXLS: TImportDriverXLS;
  NumRow: Integer;

  procedure ImportRow;
  var
    I: integer;
    FieldImport : TFiledImport;
    FieldValue: Variant;
    RowCancel : boolean;
  begin
    RowCancel := false;
    DataSet.Insert;
    for I := 0 to Pred(Length(FSettingsImport.FieldImport)) do
    begin
      FieldImport := FSettingsImport.FieldImport[I];
      FieldValue := FImportDriverXLS.ValueByName(FieldImport.Column);
      DataSet.FieldByName(FieldImport.Name).Value := FieldValue;
      if True then

      RowCancel := true;
    end;
    if not RowCancel then
      DataSet.Post
    else
      DataSet.Cancel;
  end;

  procedure InitField;
  var
    I: integer;
    J: integer;
    FieldImport : TFiledImport;
    FieldValue: Variant;
  begin
    DataSet.FieldDefs.Clear;
    for J := 1 to FImportDriverXLS.ColMax do
      for I := 0 to Pred(Length(FSettingsImport.FieldImport)) do
      begin
        FieldImport := FSettingsImport.FieldImport[I];
        FieldValue := FImportDriverXLS.ValueByName(IntToStr(J));
        if (not VarIsNull(FieldValue))
          and (AnsiUpperCase(FieldValue) = AnsiUpperCase(FieldImport.Name))
        then
        begin
          FieldImport.Column := IntToStr(J);
          DataSet.FieldDefs.Add(FieldValue, FieldImport.FieldType);
          break;
        end;
      end;
    DataSet.CreateDataSet;
  end;

begin
  DataSet.Close;

  FImportDriverXLS := TImportDriverXLS.Create(FFileName);
  try
    NumRow := 1;
    FImportDriverXLS.Open;
    ShowProgress('Загрузка файла ' + FFileName, FImportDriverXLS.Count);
    while not FImportDriverXLS.Eof do
    begin
      if NeedStop then
        Break;
      if NumRow = 1 then
        InitField;

      ImportRow;
      FImportDriverXLS.Next;
      inc(NumRow);
      if (NumRow mod StepRow = 0) then
        StepProgress('', StepRow);
    end;
  finally
    HideProgress;
    FImportDriverXLS.Free;
  end;
end;

procedure TImportManager.SetFileName(const Value: string);
begin
  FFileName := Value;
  FIniFile.WriteString(C_SC_MAIN, C_PAR_FILE, FFileName);
  FIniFile.UpdateFile;
end;

end.
