unit uImportManager;

interface

uses
//  System.SysUtils, System.Classes,
//  Data.DB, Datasnap.DBClient,
//  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  SysUtils, Classes,
  DB, DBClient,
  xmldom, XMLIntf, XMLDoc,
  IniFiles,
  Variants,
  Forms,
  uImportCondition,
  _utils;

type
  TProgressChange = procedure of object;

  TImportManager = class
  private
    FOwner: TComponent;
    FXML: IXMLConditionType;
    FAppPath: string;
    FAppName: string;
    FFileName: string;
    FProgressChange, FStartChange: TProgressChange;
    procedure SetFileName(const Value: string);
  private
    FTotalRows: integer;
    FImportRows: integer;
    FSkippedRows: integer;
  public
    DataSet: TClientDataSet;
    property FileName: string read FFileName write SetFileName;
    property onStart: TProgressChange read FStartChange write FStartChange;
    property onProgressChange: TProgressChange read FProgressChange write FProgressChange;
    property TotalRows: integer read FTotalRows;
    property ImportRows: integer read FImportRows;
    property SkippedRows: integer read FSkippedRows;
  public
    procedure Import; overload;
    procedure Import(AXMLCondition: IXMLConditionType); overload;
    procedure Import(AXMLConditionFileName: string); overload;
    procedure Import_cond(AXMLCond: string; ACond: string); overload;
  public
    constructor Create(AOwner: TComponent; AppPath: String); overload;
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
  FXML := DefaultCondition;
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
      if FXML.Field[I].Column = '' then
        Continue;

      FieldValue := FImportDriverXLS.ValueByName(FXML.Field[I].Column);
      if not VarIsNull(FieldValue) and not VarIsEmpty(FieldValue) then
        try
          DataSet.FieldByName(FXML.Field[I].Name).Value :=
            FXML.Field[I].GetValue(FieldValue);
        except
          Result := False;
        end
      else
        if FXML.Field[I].SkipRowIfEmpty then
          RowCancel := true;
    end;
    if not RowCancel then
    begin
      DataSet.Post;
      Inc(FImportRows);
    end
    else
    begin
      DataSet.Cancel;
      inc(FSkippedRows);
    end;
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
          and (AnsiUpperCase(FieldValue) = AnsiUpperCase(FXML.Field[I].Name))
        then
        begin
          FXML.Field[I].Column := IntToStr(J);
          case FXML.Field[I].GetFieldType of
            ftString:
              DataSet.FieldDefs.Add(FieldValue, FXML.Field[I].GetFieldType,
                256, False);
          else
            DataSet.FieldDefs.Add(FieldValue, FXML.Field[I].GetFieldType,
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
    DataSet.DisableControls;
    NumRow := 1;
    FImportDriverXLS.Open;
    if Assigned(FStartChange) then
       FStartChange;

    FTotalRows := Pred(FImportDriverXLS.Count);
    FSkippedRows := 0;
    FImportRows := 0;
    ShowProgressExt('File loading ' + FFileName, FImportDriverXLS.Count, true);
    while not FImportDriverXLS.Eof do
    begin
      if NeedStop then
        Break;

      if NumRow = 1 then
        InitField
      else
        ImportRow;

      inc(NumRow);

      if Assigned(FProgressChange) then
         FProgressChange;
      FImportDriverXLS.Next;
      Application.ProcessMessages;
      if (NumRow mod StepRow = 0) then
        StepProgress('', StepRow);
    end;
  finally
    DataSet.EnableControls;
    HideProgress;
    FImportDriverXLS.Close;
    FImportDriverXLS.Free;
  end;
end;

procedure TImportManager.Import(AXMLCondition: IXMLConditionType);
begin
  FXML := AXMLCondition;
  Import;
end;

procedure TImportManager.Import(AXMLConditionFileName: string);
begin
  Import(LoadCondition(AXMLConditionFileName));
end;

procedure TImportManager.Import_cond(AXMLCond: string; ACond: string);
begin
  Import(GetConditionXML(AXMLCond, ACond));
end;

procedure TImportManager.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

end.
