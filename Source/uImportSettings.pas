unit uImportSettings;

interface

uses
  xmldom,
  XMLDoc,
  XMLIntf,
  DB,
  Rtti,
  System.Classes,
  System.SysUtils,
  System.AnsiStrings;

type
  TXMLFieldType = record
    Name: string;
    FType: TFieldType;
  end;

{ Forward Decls }

  IXMLSettingsImportType = interface;
  IXMLFieldImportType = interface;

{ IXMLSettingsImportType }

  IXMLSettingsImportType = interface(IXMLNodeCollection)
    ['{AB91AAAF-10E6-4DD6-8FDF-BABCA61B80D5}']
    { Property Accessors }
    function Get_FieldImport(Index: Integer): IXMLFieldImportType;
    { Methods & Properties }
    function Add: IXMLFieldImportType; overload;
    function Add(AName, AFieldType, AFunctionName : string;
      ACode: boolean): IXMLFieldImportType; overload;
    function Insert(const Index: Integer): IXMLFieldImportType;
    property FieldImport[Index: Integer]: IXMLFieldImportType read Get_FieldImport; default;
  end;

{ IXMLFieldImportType }

  IXMLFieldImportType = interface(IXMLNode)
    ['{FF059132-9118-421F-BEF0-1BB608DD6BBC}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Column: UnicodeString;
    function Get_FieldType: UnicodeString;
    function Get_Code: Boolean;
    function Get_FunctionName: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Column(Value: UnicodeString);
    procedure Set_FieldType(Value: UnicodeString);
    procedure Set_Code(Value: Boolean);
    procedure Set_FunctionName(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Column: UnicodeString read Get_Column write Set_Column;
    property FieldType: UnicodeString read Get_FieldType write Set_FieldType;
    property Code: Boolean read Get_Code write Set_Code;
    property FunctionName: UnicodeString read Get_FunctionName write Set_FunctionName;
    function GetFieldType: TFieldType;
    function GetValue(Value: variant): variant;
  end;

{ Forward Decls }

  TXMLSettingsImportType = class;
  TXMLFieldImportType = class;

{ TXMLSettingsImportType }

  TXMLSettingsImportType = class(TXMLNodeCollection, IXMLSettingsImportType)
  protected
    { IXMLSettingsImportType }
    function Get_FieldImport(Index: Integer): IXMLFieldImportType;
    function Add: IXMLFieldImportType; overload;
    function Add(AName, AFieldType, AFunctionName : string;
      ACode: boolean): IXMLFieldImportType; overload;
    function Insert(const Index: Integer): IXMLFieldImportType;
  public
    procedure AfterConstruction; override;
  end;

  TFunc = function(Value: variant): variant of object;

{ TXMLFieldImportType }
  TXMLFunctions = class(TPersistent)
  public
    class function UpperCase(Value: variant): variant;
    class function LowerCase(Value: variant): variant;
    class function StrToInt(Value: variant): variant;
    class function Func(Value: variant): variant;
    class function FindMethodByName(AName : String) : TFunc;
  end;

  TXMLFieldImportType = class(TXMLNode, IXMLFieldImportType)
  protected
    Func : TFunc;
    { IXMLFieldImportType }
    function Get_Name: UnicodeString;
    function Get_Column: UnicodeString;
    function Get_FieldType: UnicodeString;
    function Get_Code: Boolean;
    function Get_FunctionName: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Column(Value: UnicodeString);
    procedure Set_FieldType(Value: UnicodeString);
    procedure Set_Code(Value: Boolean);
    procedure Set_FunctionName(Value: UnicodeString);
    function GetFieldType: TFieldType;
    function GetValue(Value: variant): variant;
  end;

{ Global Functions }

function GetSettingsImport(Doc: IXMLDocument): IXMLSettingsImportType;
function LoadSettingsImport(const FileName: string): IXMLSettingsImportType;
function NewSettingsImport: IXMLSettingsImportType;
function DefaultSettingsImport: IXMLSettingsImportType;

const
  TargetNamespace = '';
  XMLFieldTypes : array [0..3] of TXMLFieldType = (
    (Name: 'String';  FType: ftString),
    (Name: 'Integer'; FType: ftInteger),
    (Name: 'Date'; FType: ftDate),
    (Name: 'Float'; FType: ftFloat)
  );

implementation

{ Global Functions }

function GetSettingsImport(Doc: IXMLDocument): IXMLSettingsImportType;
begin
  Result := Doc.GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function LoadSettingsImport(const FileName: string): IXMLSettingsImportType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function NewSettingsImport: IXMLSettingsImportType;
begin
  Result := NewXMLDocument.GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function DefaultSettingsImport: IXMLSettingsImportType;
begin
  Result := NewSettingsImport;
  Result.Add('Name',     'String',  'UpperCase', false);
  Result.Add('Birthday', 'Date',    'Age',  false);
  Result.Add('Salary',   'Integer', '', false);
  Result.Add('Surname',  'String',  'LowerCase', true);
  Result.Add('DOB',      '',        '', false);
  Result.Add('AMOUNT',   '',        '', false);
end;

{ TXMLSettingsImportType }

function TXMLSettingsImportType.Add(AName, AFieldType, AFunctionName: string;
  ACode: boolean): IXMLFieldImportType;
begin
  Result := AddItem(-1) as IXMLFieldImportType;
  Result.Name := AName;
  Result.FunctionName := AFunctionName;
  Result.FieldType := AFieldType;
  Result.Code := ACode;
end;

procedure TXMLSettingsImportType.AfterConstruction;
begin
  RegisterChildNode('FieldImport', TXMLFieldImportType);
  ItemTag := 'FieldImport';
  ItemInterface := IXMLFieldImportType;
  inherited;
end;

function TXMLSettingsImportType.Get_FieldImport(Index: Integer): IXMLFieldImportType;
begin
  Result := List[Index] as IXMLFieldImportType;
end;

function TXMLSettingsImportType.Add: IXMLFieldImportType;
begin
  Result := AddItem(-1) as IXMLFieldImportType;
end;

function TXMLSettingsImportType.Insert(const Index: Integer): IXMLFieldImportType;
begin
  Result := AddItem(Index) as IXMLFieldImportType;
end;

{ TXMLFieldImportType }

function TXMLFieldImportType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLFieldImportType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

function TXMLFieldImportType.Get_Column: UnicodeString;
begin
  Result := AttributeNodes['Column'].Text;
end;

procedure TXMLFieldImportType.Set_Column(Value: UnicodeString);
begin
  SetAttribute('Column', Value);
end;

function TXMLFieldImportType.Get_FieldType: UnicodeString;
begin
  Result := AttributeNodes['FieldType'].Text;
end;

function TXMLFieldImportType.Get_FunctionName: UnicodeString;
begin
  Result := AttributeNodes['FuntionName'].Text;
end;

procedure TXMLFieldImportType.Set_FieldType(Value: UnicodeString);
begin
  SetAttribute('FieldType', Value);

end;

procedure TXMLFieldImportType.Set_FunctionName(Value: UnicodeString);
begin
  SetAttribute('FuntionName', Value);
  Func := TXMLFunctions.FindMethodByName(Value);
end;

function TXMLFieldImportType.GetFieldType: TFieldType;
var
  FTypeName: String;
  I: integer;
begin
  FTypeName := UpperCase(Get_FieldType);
  Result := ftString;
  if UpperCase(Get_Name) = 'AMOUNT' then
    result := ftInteger
  else
    if UpperCase(Get_Name) = 'DOB' then
      result := ftDateTime
    else
      for I := Low(XMLFieldTypes) to High(XMLFieldTypes) do
        if XMLFieldTypes[I].Name = FTypeName then
        begin
          Result := XMLFieldTypes[I].FType;
          Break;
        end;
end;

function TXMLFieldImportType.GetValue(Value: variant): variant;
begin
  Result := Func(Value);
end;

function TXMLFieldImportType.Get_Code: Boolean;
begin
  Result := AttributeNodes['Code'].NodeValue;
end;

procedure TXMLFieldImportType.Set_Code(Value: Boolean);
begin
  SetAttribute('Code', Value);
end;

{ TXMLFunctions }

class function TXMLFunctions.FindMethodByName(AName: String): TFunc;
var
  R : TRttiContext;
  T : TRttiType;
  M : TRttiMethod;
  FormClass : TPersistentClass;
  FExists : boolean;
begin
  Result := nil;
  FExists := false;
  T := R.GetType(TXMLFunctions);

  if Assigned(T) then
    for M in T.GetMethods do
      if (M.Parent = T) and (M.Name = AName) then
      begin
        TMethod(Result).Code := M.CodeAddress;
        TMethod(Result).Data := FormClass;
        FExists := true;
      end;
  if not FExists then
  begin
    M := T.GetMethod('Func');
    TMethod(Result).Code := M.CodeAddress;
    TMethod(Result).Data := FormClass;
  end;
end;

class function TXMLFunctions.Func(Value: variant): variant;
begin
  Result := Value;
end;

class function TXMLFunctions.LowerCase(Value: variant): variant;
begin
  Result := AnsiLowerCase(Value);
end;

class function TXMLFunctions.StrToInt(Value: variant): variant;
begin
  Result := System.SysUtils.StrToInt(Value);
end;

class function TXMLFunctions.UpperCase(Value: variant): variant;
begin
  Result := AnsiUpperCase(Value);
end;

Initialization
  RegisterClass(TXMLFunctions);

end.
