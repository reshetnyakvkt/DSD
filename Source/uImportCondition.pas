unit uImportCondition;

interface

uses xmldom, XMLDoc, XMLIntf,
  DB,
//  System.Classes,
//  System.SysUtils,
//  System.AnsiStrings,
  Classes,
  SysUtils,
  AnsiStrings,
  uImportFunctions,
  Variants;

type
  TXMLFieldTypeName = record
    Name: string;
    FType: TFieldType;
  end;

{ Forward Decls }
  IXMLConditionType = interface;
  IXMLFieldType = interface;

{ IXMLConditionType }

  IXMLConditionType = interface(IXMLNodeCollection)
    ['{6FD45B72-E447-4F51-BF6C-00426B952662}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Field(Index: Integer): IXMLFieldType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLFieldType;
    function Insert(const Index: Integer): IXMLFieldType;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Field[Index: Integer]: IXMLFieldType read Get_Field; default;
  end;

{ IXMLFieldType }

  IXMLFieldType = interface(IXMLNode)
    ['{E9FA5B6F-9229-459E-B653-C17EB246361E}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Function_: UnicodeString;
    function Get_SkipRowIfEmpty: Boolean;
    function Get_Column: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Function_(Value: UnicodeString);
    procedure Set_SkipRowIfEmpty(Value: Boolean);
    procedure Set_Column(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Function_: UnicodeString read Get_Function_ write Set_Function_;
    property SkipRowIfEmpty: Boolean read Get_SkipRowIfEmpty write Set_SkipRowIfEmpty;
    property Column: UnicodeString read Get_Column write Set_Column;
    function GetFieldType: TFieldType;
    function GetValue(Value: variant): variant;
  end;

{ Forward Decls }

  TXMLConditionType = class;
  TXMLFieldType = class;

{ TXMLConditionType }

  TXMLConditionType = class(TXMLNodeCollection, IXMLConditionType)
  protected
    { IXMLConditionType }
    function Get_Name: UnicodeString;
    function Get_Field(Index: Integer): IXMLFieldType;
    procedure Set_Name(Value: UnicodeString);
    function Add: IXMLFieldType;
    function Insert(const Index: Integer): IXMLFieldType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFieldType }

  TXMLFieldType = class(TXMLNode, IXMLFieldType)
  protected
    Func : TFunc;
    { IXMLFieldType }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Function_: UnicodeString;
    function Get_SkipRowIfEmpty: Boolean;
    function Get_Column: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Function_(Value: UnicodeString);
    procedure Set_SkipRowIfEmpty(Value: Boolean);
    procedure Set_Column(Value: UnicodeString);
    function GetFieldType: TFieldType;
    function GetValue(Value: variant): variant;
  public
    procedure AfterConstruction; override;
  end;

const
  TargetNamespace = '';
  XMLFieldTypeNames : array [0..3] of TXMLFieldTypeName = (
    (Name: 'String';  FType: ftString),
    (Name: 'Integer'; FType: ftInteger),
    (Name: 'Date'; FType: ftDate),
    (Name: 'Float'; FType: ftFloat)
  );

implementation

{ TXMLConditionType }

procedure TXMLConditionType.AfterConstruction;
begin
  RegisterChildNode('Field', TXMLFieldType);
  ItemTag := 'Field';
  ItemInterface := IXMLFieldType;
  inherited;
end;

function TXMLConditionType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLConditionType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

function TXMLConditionType.Get_Field(Index: Integer): IXMLFieldType;
begin
  Result := List[Index] as IXMLFieldType;
end;

function TXMLConditionType.Add: IXMLFieldType;
begin
  Result := AddItem(-1) as IXMLFieldType;
end;

function TXMLConditionType.Insert(const Index: Integer): IXMLFieldType;
begin
  Result := AddItem(Index) as IXMLFieldType;
end;

{ TXMLFieldType }

function TXMLFieldType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLFieldType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLFieldType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLFieldType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

procedure TXMLFieldType.AfterConstruction;
begin
  inherited;
  Set_Function_(Get_Function_);
end;

function TXMLFieldType.GetFieldType: TFieldType;
var
  FTypeName: String;
  I: integer;
begin
  FTypeName := UpperCase(Get_Type_);
  Result := ftString;
  if UpperCase(Get_Name) = 'AMOUNT' then
    result := ftInteger
  else
    if UpperCase(Get_Name) = 'DOB' then
      result := ftDateTime
    else
      for I := Low(XMLFieldTypeNames) to High(XMLFieldTypeNames) do
        if XMLFieldTypeNames[I].Name = FTypeName then
        begin
          Result := XMLFieldTypeNames[I].FType;
          Break;
        end;
end;

function TXMLFieldType.GetValue(Value: variant): variant;
begin
  Result := Func(Value);
end;

function TXMLFieldType.Get_Column: UnicodeString;
begin
  Result := AttributeNodes['Column'].Text;
end;

function TXMLFieldType.Get_Function_: UnicodeString;
begin
  Result := AttributeNodes['function'].Text;
end;

procedure TXMLFieldType.Set_Column(Value: UnicodeString);
begin
  SetAttribute('Column', Value);
end;

procedure TXMLFieldType.Set_Function_(Value: UnicodeString);
begin
  SetAttribute('function', Value);
  Func := TXMLFunctions.GetFuncByName(Value);
end;

function TXMLFieldType.Get_SkipRowIfEmpty: Boolean;
var
  FNodeValue : OleVariant;
begin
  Result := False;
  FNodeValue := AttributeNodes['SkipRowIfEmpty'].NodeValue;
  if not VarIsNull(FNodeValue) then
    TryStrToBool(FNodeValue, Result);
end;

procedure TXMLFieldType.Set_SkipRowIfEmpty(Value: Boolean);
begin
  SetAttribute('SkipRowIfEmpty', Value);
end;

end.