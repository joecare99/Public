unit frm_ObjectInspector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls;

type

  { TfrmObjectInspector }

  TfrmObjectInspector = class(TForm)
    Splitter1: TSplitter;
    TreeView1: TTreeView;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmObjectInspector: TfrmObjectInspector;

implementation

{$R *.lfm}

end.

