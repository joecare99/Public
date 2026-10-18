unit cls_fv2stddlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls, cls_fv2dialogs, cls_fv2forms,
  cls_fv2stdctrls;

type
  TFileDialog = class(TDialog)
  private
    FFileName: string;
    FDirectory: string;
    FFilter: string;
  public
    constructor Create(AOwner: TComponent); override;
    property FileName: string read FFileName write FFileName;
    property Directory: string read FDirectory write FDirectory;
    property Filter: string read FFilter write FFilter;
  end;

  TOpenDialog = class(TFileDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSaveDialog = class(TFileDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TFileDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Bounds := Rect(10, 4, 70, 20);
  AddButton('OK', drAccept);
  AddButton('Cancel', drCancel);
end;

constructor TOpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Open File';
end;

constructor TSaveDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Save File';
end;

end.
