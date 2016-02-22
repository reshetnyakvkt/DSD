{ unit sdDebug

  universal method for debugging

  Exceptions often are a hindrance, so instead use these classes
  to give important info to the application or user with these
  two basic classes

  Author: Nils Haeck M.Sc.
  Original Date: 08nov2010
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDebug;

{$ifdef lcl}{$MODE Delphi}{$endif}

interface

uses
  Classes;

type

  TsdWarnStyle = (wsInfo, wsHint, wsWarn, wsFail);

const
  cWarnStyleNames: array[TsdWarnStyle] of Utf8String = ('info', 'hint', 'warn', 'fail');

type
  // event with debug data
  TsdDebugEvent = procedure(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String) of object;

  // simple update event
  TsdUpdateEvent = procedure(Sender: TObject) of object;

  IDebugMessage = interface(IInterface)
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  end;

  TDebugComponent = class(TComponent)
  protected
    FOnDebugOut: TsdDebugEvent;
  public
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
  end;

  TDebugPersistent = class(TPersistent)
  protected
    FOwner: TDebugComponent;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
  end;

  TDebugObject = class(TObject)
  protected
    FOnDebugOut: TsdDebugEvent;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
  public
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;


implementation

{ TDebugComponent }

procedure TDebugComponent.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage)
end;

{ TDebugPersistent }

procedure TDebugPersistent.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if FOwner is TDebugComponent then
    TDebugComponent(FOwner).DoDebugOut(Sender, WarnStyle, AMessage);
end;

{ TDebugObject }

procedure TDebugObject.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

end.
