unit frm_ComplexFrameMain;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
    ExtCtrls, Buttons, fra_ComplexFrame;

type

    { TfrmComplexFrameMain }

    TfrmComplexFrameMain = class(TForm)
        btnClose: TBitBtn;
        btnCreateNewSale: TBitBtn;
        Frame1_1: TfraComplexFrame;
        PageControl1: TPageControl;
        Panel1: TPanel;
        StatusBar1: TStatusBar;
        TabSheet1: TTabSheet;
        ToolBar1: TToolBar;
        procedure btnCreateNewSaleClick(Sender: TObject);
    private

    public

    end;

var
    frmComplexFrameMain: TfrmComplexFrameMain;

implementation

{$R *.lfm}

{ TfrmComplexFrameMain }

procedure TfrmComplexFrameMain.btnCreateNewSaleClick(Sender: TObject);
var
    k: integer;
    lNewTabSheet: TTabSheet;
    lNewFrame: TfraComplexFrame;
begin
    k := PageControl1.PageCount + 1;
    if k <= 15 then
      begin
        lNewTabSheet := PageControl1.AddTabSheet;
        with lNewTabSheet do
          begin
            Name := 'tab' + IntToStr(k);
            Caption := 'TPV ' + IntToStr(k);
          end;

        lNewFrame := TfraComplexFrame.Create(frmComplexFrameMain);
        with lNewFrame do
          begin
            Name := 'cplxframe' + IntToStr(k);  // <--- Here
            Parent := lNewTabSheet;
            Align := alClient;
          end;
      end;
end;

end.
