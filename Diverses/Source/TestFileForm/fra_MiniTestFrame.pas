unit fra_MiniTestFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls;

type

  { TfraMiniTestFrame }

  TfraMiniTestFrame = class(TFrame)
    edtTestMemo: TMemo;
  private

  public
     Procedure LoadFile(aFilename:String);
     Procedure LoadString(aValue:String);
  end;

implementation

{$R *.lfm}

{ TfraMiniTestFrame }

procedure TfraMiniTestFrame.LoadFile(aFilename: String);
begin
  edtTestMemo.Lines.LoadFromFile(aFilename);
end;

procedure TfraMiniTestFrame.LoadString(aValue: String);
begin
  edtTestMemo.Lines.Text:=aValue;
end;

end.

