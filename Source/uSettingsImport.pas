unit uSettingsImport;

interface

uses
  System.SysUtils,
  System.Classes,
  DB,
  NativeXml;

const
  C_AUTOSAVE_SETTINGS = false;

type
  TFiledImport = class
  private
    FFieldType : string;
    function GetFieldType: TFieldType;
  public
    Name : string;
    Column : string;
    Code : boolean;
    isUpperCase : Boolean;
    property FieldType: TFieldType read GetFieldType;
    function GetValue(AValue: variant) : Variant;
    procedure SaveToXML(XMLNode: TXmlNode);
    constructor Create(XMLNode: TXmlNode); overload;
    constructor Create(AName, AFieldType: string; ACode, AIsUpperCase: Boolean); overload;
  end;

type
  TSettingsImport = class
  private
    FSettingsFile : string;
  public
    FieldImport: array of TFiledImport;
    AutoSave : boolean;
    property SettingsFile : string read FSettingsFile write FSettingsFile;
    function GenerateXML: string;
    procedure Load(FileName: string);
    procedure Save(FileName: string);
    procedure Init;
    constructor Create; overload;
    constructor Create(FileName: string); overload;
    destructor Destroy; overload;
  end;

  function GetBooleanAttributeDef(Node: TXmlNode; AttributeName: string;
    Default: Boolean): Boolean;

implementation

function GetBooleanAttributeDef(Node: TXmlNode;
  AttributeName: string; Default: Boolean): Boolean;
var
  sdAttr: TsdAttribute;
begin
  Result := Default;
  if not Assigned(Node) then
    Exit;

  sdAttr := Node.AttributeByName[UTF8Encode(AttributeName)];
  if not Assigned(sdAttr) then
    Exit;

  Result := StrToBoolDef(sdAttr.ValueWide, Default);
end;

{ SettingsImport }

constructor TSettingsImport.Create;
begin
  AutoSave := C_AUTOSAVE_SETTINGS;
  Init;
end;

constructor TSettingsImport.Create(FileName: string);
begin
  AutoSave := C_AUTOSAVE_SETTINGS;
  FSettingsFile := FileName;
  Load(FSettingsFile);
end;

destructor TSettingsImport.Destroy;
begin
  if AutoSave then
    Save(FSettingsFile);
end;

function TSettingsImport.GenerateXML: string;
var
  XmlDoc: TNativeXml;
  Node: TXmlNode;
  Nodes: array of TXmlNode;
  I: integer;
begin
  XmlDoc := TNativeXml.CreateName('SettingsImport');
  XmlDoc.XmlFormat := xfReadable;
  try
    for I := 0 to Pred(Length(FieldImport)) do
    begin
      Node := XmlDoc.NodeNew('FieldImport');
      FieldImport[I].SaveToXML(Node);
      XmlDoc.Root.NodeAdd(Node);
    end;
    Result := UTF8ToWideString(XmlDoc.WriteToString);
  finally
    FreeAndNil(XmlDoc);
  end;
end;

procedure TSettingsImport.Init;
begin
  SetLength(FieldImport, 4);
  FieldImport[0] := TFiledImport.Create('Name', '', false, false);
  FieldImport[1] := TFiledImport.Create('Birthday', 'DOB', false, false);
  FieldImport[2] := TFiledImport.Create('Salary', 'Amount', false, false);
  FieldImport[3] := TFiledImport.Create('Surname', '',  true, true);
end;

procedure TSettingsImport.Load(FileName: string);
var
  XmlDoc: TNativeXml;
  Node: TXmlNode;
  I : Integer;
begin
  if not FileExists(FileName) then
  begin
    Init;
    Exit;
  end;

  XmlDoc := TNativeXml.Create(nil);
  XmlDoc.LoadFromFile(FileName);
  Node := XmlDoc.Root;
  SetLength(FieldImport, Node.NodeCount);
  for I := 0 to Pred(Node.NodeCount) do
    FieldImport[I] := TFiledImport.Create(Node.Nodes[I]);
end;

procedure TSettingsImport.Save(FileName: string);
var
  SaveList: TStringList;
begin
  SaveList := TStringList.Create;
  try
    SaveList.Text := AnsiToUtf8(GenerateXML);
    SaveList.SaveToFile(FileName,TEncoding.UTF8);
  finally
    FreeAndNil(SaveList);
  end;
end;

{ TFiledImport }

constructor TFiledImport.Create(XMLNode: TXmlNode);
begin
  Name := UTF8ToWideString(XMLNode.AttributeValueByName['Name']);
  FFieldType := AnsiUpperCase(UTF8ToWideString(XMLNode.AttributeValueByName['FieldType']));
  Code := GetBooleanAttributeDef(XMLNode, 'Code', false);
  isUpperCase := GetBooleanAttributeDef(XMLNode, 'UpperCase', false);
  Column := '';
end;

constructor TFiledImport.Create(AName, AFieldType: string; ACode, AIsUpperCase: Boolean);
begin
  Name := AName;
  FFieldType := AFieldType;
  Code := ACode;
  IsUpperCase := AIsUpperCase;
  Column := '';
end;

function TFiledImport.GetFieldType: TFieldType;
begin
  if FFieldType = 'AMOUNT' then
    result := ftInteger
  else
    if FFieldType = 'DOB' then
      result := ftDateTime;
  result := ftString
end;

function TFiledImport.GetValue(AValue: variant): Variant;
begin
  Result := AValue;
  if isUpperCase and (GetFieldType = ftString) then
    Result := AnsiUpperCase(Result);
end;

procedure TFiledImport.SaveToXML(XMLNode: TXmlNode);
begin
  XMLNode.AttributeAdd('Name', UTF8Encode(Name));
  XMLNode.AttributeAdd('FieldType', UTF8Encode(FFieldType));
  XMLNode.AttributeAdd('Code', UTF8Encode(sdBoolToString(Code)));
  XMLNode.AttributeAdd('UpperCase', UTF8Encode(sdBoolToString(isUpperCase)));
end;

end.
