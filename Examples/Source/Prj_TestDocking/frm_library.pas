unit frm_Library;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TfrmLibrary }

  TfrmLibrary = class(TForm)
    ImageList1: TImageList;
    ListView1: TListView;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmLibrary: TfrmLibrary;

implementation

{$R *.lfm}

{ TfrmLibrary }

procedure TfrmLibrary.FormCreate(Sender: TObject);
begin
  // Init the Library
  //

end;

end.

