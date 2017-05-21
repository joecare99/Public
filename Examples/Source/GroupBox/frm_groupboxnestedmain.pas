unit Frm_GroupBoxNestedMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms, Controls;


type
  TFrmGroupBoxNested = class(TFORM)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var FrmGroupBoxNested : TFrmGroupBoxNested;

implementation


{ TFrmGroupBoxNested }

constructor TFrmGroupBoxNested.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner, 1);
  Name:='Form1';
  Caption:='Nested Groupbox demo';

  GroupBox1:=TGroupBox.Create(Self);
  with GroupBox1 do begin
    Name:='GroupBox1';
    SetBounds(0,0,350,350);
    Align:=alClient;
    Parent:=Self;
  end;

  GroupBox2:=TGroupBox.Create(Self);
  with GroupBox2 do begin
    Name:='GroupBox2';
    Align:=alClient;
    Parent:=GroupBox1;
  end;

  GroupBox3:=TGroupBox.Create(Self);
  with GroupBox3 do begin
    Name:='GroupBox3';
    Align:=alClient;
    Parent:=GroupBox2;
  end;
  SetBounds(100,50,300,250);
end;


end.

