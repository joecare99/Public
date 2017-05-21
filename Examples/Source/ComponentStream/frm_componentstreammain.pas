unit Frm_ComponentStreamMain;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure OnPropNotFound(Reader: TReader; Instance: TPersistent;
      var PropName: string; IsPath: boolean; var Handled, Skip: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
    FProp :TComponent;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

type

{ TTestComp }

 TTestComp=Class(TComponent)
private
  FTestProp: String;
  FTestProp2: String;
  procedure SetTestProp(AValue: String);
  procedure SetTestProp2(AValue: String);
   published
     property TestProp:String read FTestProp write SetTestProp;
     property TestProp2:String read FTestProp2 write SetTestProp2;
  end;

procedure loadCompFromTxtFile(const aComp: TComponent; const aFilename: string;
  aPropNotFoundHandler: TPropertyNotFoundEvent = nil; anErrorHandler: TReaderError = nil);
var
  str1, str2: TMemoryStream;
  rdr: TReader;
begin
  str1 := TMemoryStream.Create;
  str2 := TMemoryStream.Create;
  try
    str1.LoadFromFile(aFilename);
    str1.Position := 0;
    ObjectTextToBinary(str1,str2);
    str2.Position := 0;
    try
      rdr := TReader.Create(str2, 4096);
      try
        rdr.OnPropertyNotFound := aPropNotFoundHandler;
        rdr.OnError := anErrorHandler;
        rdr.ReadRootComponent(aComp);
      finally
        rdr.Free;
      end;
    except
    end;
  finally
    str1.Free;
    str2.Free;
  end;
end;

procedure saveCompToTxtFile(const aComp: TComponent; const aFilename: string);
var
  str1, str2: TMemoryStream;
begin
  str1 := TMemoryStream.Create;
  str2 := TMemoryStream.Create;
  try
    str1.WriteComponent(aComp);
    str1.Position := 0;
    ObjectBinaryToText(str1,str2);
    ForceDirectories(ExtractFilePath(aFilename));
    str2.SaveToFile(aFilename);
  finally
    str1.Free;
    str2.Free;
  end;
end;

{ TForm1 }

function GetVendorName: String;
begin
  result:='JC-Soft';
end;

function GetAppName: String;
begin
  result:='TestCompStream';
end;

{ TTestComp }

procedure TTestComp.SetTestProp(AValue: String);
begin
  if FTestProp=AValue then Exit;
  FTestProp:=AValue;
end;

procedure TTestComp.SetTestProp2(AValue: String);
begin
  if FTestProp2=AValue then Exit;
  FTestProp2:=AValue;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  saveCompToTxtFile(FProp,SysUtils.GetAppConfigFile(False,true));
  memo1.Lines.LoadFromFile(SysUtils.GetAppConfigFile(False,true));
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  lOnPropNotFound: TPropertyNotFoundEvent;
begin
  lOnPropNotFound:=OnPropNotFound;
  loadCompFromTxtFile(FProp,SysUtils.GetAppConfigFile(False,true),lOnPropNotFound);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OnGetVendorName:=GetVendorName;
  OnGetApplicationName:=GetAppName;
  FProp := TTestComp.create(self);
  TTestComp(FProp).FTestProp:='Test-Prop-1';
  TTestComp(FProp).FTestProp2:='Test-Prop-2';
end;

procedure TForm1.OnPropNotFound(Reader: TReader; Instance: TPersistent;
  var PropName: string; IsPath: boolean; var Handled, Skip: Boolean);
begin
  Handled:=true;
  Skip:=true;
end;



end.

