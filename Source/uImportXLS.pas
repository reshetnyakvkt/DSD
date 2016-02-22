unit uImportXLS;

interface

uses
  Classes,
  SysUtils;

  const
  C_EXCEL_APPLICATION = 'Excel.Application';

type
  TImportDriverXLS = class
  private
    FExcel: OleVariant;
    FWorkBook: OleVariant;
    FSheet: Variant;
    FDataRange: OLEVariant;
    FColMax : integer;
    FRowMax : integer;
    FRowIdx : integer;
    FNumSheet : integer;
    FExcelExecuting : boolean;
    FSourceName: string;
  public
    property SourceName: string read FSourceName write FSourceName;
    property ColMax: integer read FColMax;
  public
    function Open: boolean;
    function Close: boolean;
    function Eof: boolean;
    function Bof: boolean;
    function Count: integer;
    procedure Next;
    procedure Prev;
    function ValueByName(Name: string): variant;
    constructor Create(AName: string);
  end;

implementation

uses
  Variants,
  ACtiveX,
  ComObj;

{ TImportDriverXLS }

function TImportDriverXLS.Bof: boolean;
begin
  Result := False;
end;

function TImportDriverXLS.Close: boolean;
begin
  FExcel.DisplayAlerts := True;
  FExcel.Quit;
end;

function TImportDriverXLS.Count: integer;
begin
  Result := FRowMax;
end;

constructor TImportDriverXLS.Create(AName: string);
begin
  FSourceName := AName;
  FNumSheet := 1;
end;

function TImportDriverXLS.Eof: boolean;
begin
  Result := FRowIdx > FRowMax;
end;

procedure TImportDriverXLS.Next;
begin
  inc(FRowIdx);
end;

function TImportDriverXLS.Open: boolean;
begin
  if FNumSheet < 1 then
    FNumSheet := 1;
  try
    // Ищем запущеный экземплят Excel, если он не найден, вызывается исключение
    FExcel := GetActiveOleObject(C_EXCEL_APPLICATION);
    FExcelExecuting := True;
  except
    FExcelExecuting := False;
  end;

  FExcel := CreateOleObject(C_EXCEL_APPLICATION);

  if FileExists(SourceName) then
    FWorkBook := FExcel.Workbooks.Open(SourceName);

  // Прячем на время импорта
  FExcel.Visible := False;
  FExcel.DisplayAlerts := false;

  FExcel.ActiveWorkBook.WorkSheets[FNumSheet].Activate;
  FSheet := FExcel.ActiveWorkBook.WorkSheets[FNumSheet];

  //Вариант 2. Считывание данных всего диапазона
  FRowMax := FSheet.UsedRange.Rows.Count;
  FColMax := FSheet.UsedRange.Columns.Count;
  FDataRange := FSheet.UsedRange.Value;
  FRowIdx := 1;
end;

procedure TImportDriverXLS.Prev;
begin
  dec(FRowIdx);
end;

function TImportDriverXLS.ValueByName(Name: string): variant;
begin
  Result := FDataRange[FRowIdx, StrToIntDef(Name, 1)];
end;

end.
