unit uImportManager;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB, Datasnap.DBClient,
  IniFiles,
  Variants,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  uImportSettings;

type
  TImportManager = class
  private
    FOwner: TComponent;
    FXML: IXMLSettingsImportType;
    FAppPath : string;
    FAppName : string;
    FSettingsFile : string;
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
    constructor Create(AOwner : TComponent; AppPath : String); overload;
  end;

implementation

uses
  uImportDriverXLS,
  _wndProgress;

{ TImportManager }

constructor TImportManager.Create(AOwner: TComponent; AppPath: String);
begin
  FOwner := AOwner;
  FAppPath := ExtractFilePath(AppPath);
  FAppName := ExtractFileName(AppPath);
  FAppName := copy(FAppName, 1, length(FAppName) - Length(ExtractFileExt(FAppName)));
  DataSet := TClientDataSet.Create(FOwner);
  FXML := DefaultSettingsImport;
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
    FieldValue: Variant;
    RowCancel : boolean;
  begin
    Result := True;
    RowCancel := false;
    DataSet.Append;

    for I := 0 to Pred(FXML.ChildNodes.Count) do
    begin
      if FXML.FieldImport[I].Column = '' then
        Continue;

      FieldValue := FImportDriverXLS.ValueByName(FXML.FieldImport[I].Column);
      if not VarIsNull(FieldValue) and not VarIsEmpty(FieldValue) then
        try
          DataSet.FieldByName(FXML.FieldImport[I].Name).Value :=
            FXML.FieldImport[I].GetValue(FieldValue);
        except
          Result := False;
        end
      else
        if FXML.FieldImport[I].Code then
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
    FieldValue: Variant;
  begin
    DataSet.FieldDefs.Clear;
    for J := 1 to FImportDriverXLS.ColMax do
      for I := 0 to Pred(FXML.Count) do
      begin
        FieldValue := FImportDriverXLS.ValueByName(IntToStr(J));
        if (not VarIsNull(FieldValue))
          and (AnsiUpperCase(FieldValue) = AnsiUpperCase(FXML.FieldImport[I].Name))
        then
        begin
          FXML.FieldImport[I].Column := IntToStr(J);
          case FXML.FieldImport[I].GetFieldType of
            ftString:
              DataSet.FieldDefs.Add(FieldValue, FXML.FieldImport[I].GetFieldType,
                256, False);
          else
            DataSet.FieldDefs.Add(FieldValue, FXML.FieldImport[I].GetFieldType,
              0, False)
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
