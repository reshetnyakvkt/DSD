unit uImportManager;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB, Datasnap.DBClient,
  IniFiles,
  uSettingsImport,
  Variants;

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
  FSettingsImport := TSettingsImport.Create(FSettingsFile);
  DataSet := TClientDataSet.Create(FOwner);
end;

destructor TImportManager.Destroy;
begin
  FSettingsImport.Free;
end;

procedure TImportManager.Import;
const
  StepRow = 2;
var
  FImportDriverXLS: TImportDriverXLS;
  NumRow: Integer;

  function ImportRow : boolean;
  var
    I: integer;
    FieldImport : TFiledImport;
    FieldValue: Variant;
    RowCancel : boolean;
  begin
    Result := True;
    RowCancel := false;
    DataSet.Append;
    for I := 0 to Pred(Length(FSettingsImport.FieldImport)) do
    begin
      FieldImport := FSettingsImport.FieldImport[I];
      FieldValue := FImportDriverXLS.ValueByName(FieldImport.Column);
      if not VarIsNull(FieldValue) and not VarIsEmpty(FieldValue) then
        try
          DataSet.FieldByName(FieldImport.Name).Value :=
            FieldImport.GetValue(FieldValue);
        except
          Result := False;
        end
      else
        if FieldImport.Code then
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
          case FieldImport.FieldType of
            ftString:
              DataSet.FieldDefs.Add(FieldValue, FieldImport.FieldType, 256, False);
          else
            DataSet.FieldDefs.Add(FieldValue, FieldImport.FieldType, 0, False);
          end;
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
        InitField
      else
        ImportRow;

      inc(NumRow);
      FImportDriverXLS.Next;
      if (NumRow mod StepRow = 0) then
        StepProgress('', StepRow);
    end;
  finally
    HideProgress;
    FImportDriverXLS.Close;
    FImportDriverXLS.Free;
  end;
end;

procedure TImportManager.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

end.
