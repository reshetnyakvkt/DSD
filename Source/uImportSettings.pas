unit uImportSettings;

interface

uses
  xmldom,
  XMLDoc,
  XMLIntf,
  DB,
  System.AnsiStrings;

type

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
    function Add(AName, AColumn, AFieldType : string;
      ACode, AUpperCase: boolean): IXMLFieldImportType; overload;
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
    function Get_UpperCase: Boolean;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Column(Value: UnicodeString);
    procedure Set_FieldType(Value: UnicodeString);
    procedure Set_Code(Value: Boolean);
    procedure Set_UpperCase(Value: Boolean);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Column: UnicodeString read Get_Column write Set_Column;
    property FieldType: UnicodeString read Get_FieldType write Set_FieldType;
    property Code: Boolean read Get_Code write Set_Code;
    property UpperCase: Boolean read Get_UpperCase write Set_UpperCase;
    function GetFieldType: TFieldType;
    function GetValue(AValue: variant): Variant;
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
    function Add(AName, AColumn, AFieldType : string;
      ACode, AUpperCase: boolean): IXMLFieldImportType; overload;
    function Insert(const Index: Integer): IXMLFieldImportType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFieldImportType }

  TXMLFieldImportType = class(TXMLNode, IXMLFieldImportType)
  protected
    { IXMLFieldImportType }
    function Get_Name: UnicodeString;
    function Get_Column: UnicodeString;
    function Get_FieldType: UnicodeString;
    function Get_Code: Boolean;
    function Get_UpperCase: Boolean;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Column(Value: UnicodeString);
    procedure Set_FieldType(Value: UnicodeString);
    procedure Set_Code(Value: Boolean);
    procedure Set_UpperCase(Value: Boolean);
    function GetValue(AValue: variant): Variant;
    function GetFieldType: TFieldType;
  end;

{ Global Functions }

function GetSettingsImport(Doc: IXMLDocument): IXMLSettingsImportType;
function LoadSettingsImport(const FileName: string): IXMLSettingsImportType;
function NewSettingsImport: IXMLSettingsImportType;
function DefaultSettingsImport: IXMLSettingsImportType;

const
  TargetNamespace = '';

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
  Result.Add('Name', '', '', false, false);
  Result.Add('Birthday', 'DOB', '', false, false);
  Result.Add('Salary', 'AMOUNT', '', false, false);
  Result.Add('Surname', '', '', true, true);
end;

{ TXMLSettingsImportType }

function TXMLSettingsImportType.Add(AName, AColumn, AFieldType: string; ACode,
  AUpperCase: boolean): IXMLFieldImportType;
begin
  Result := AddItem(-1) as IXMLFieldImportType;
  Result.Name := AName;
  Result.Column := AColumn;
  Result.FieldType := AFieldType;
  Result.Code := ACode;
  Result.UpperCase := AUpperCase;
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

procedure TXMLFieldImportType.Set_FieldType(Value: UnicodeString);
begin
  SetAttribute('FieldType', Value);
end;

function TXMLFieldImportType.GetFieldType: TFieldType;
begin
  if Get_FieldType = 'AMOUNT' then
    result := ftInteger
  else
    if Get_FieldType = 'DOB' then
      result := ftDateTime;
  result := ftString
end;

function TXMLFieldImportType.GetValue(AValue: variant): Variant;
begin
  Result := AValue;
  if Get_UpperCase and (GetFieldType = ftString) then
    Result := AnsiUpperCase(Result);
end;

function TXMLFieldImportType.Get_Code: Boolean;
begin
  Result := AttributeNodes['Code'].NodeValue;
end;

procedure TXMLFieldImportType.Set_Code(Value: Boolean);
begin
  SetAttribute('Code', Value);
end;

function TXMLFieldImportType.Get_UpperCase: Boolean;
begin
  Result := AttributeNodes['UpperCase'].NodeValue;
end;

procedure TXMLFieldImportType.Set_UpperCase(Value: Boolean);
begin
  SetAttribute('UpperCase', Value);
end;

end.