unit fra_Edit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, GenealogyDataModule, StdCtrls, ExtCtrls, Grids,
  db, DbCtrls, DBGrids;

type

  { TFrame2 }

  TFrame2 = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Label79: TLabel;
    Label90: TLabel;
    Label81: TLabel;
    Shape2:TShape;
    Shape3:TShape;
    Image1:TImage;
// ---------------------
StringGrid1:TStringGrid;
StringGrid2:TStringGrid;
StringGrid5:TStringGrid;
FileListBox1:TFileListBox;
FileListBox2:TFileListBox;
    Edit1:TEdit;
    Edit2:TEdit;
    Edit3:TEdit;
    Edit7:TEdit;
    Edit11:TEdit;
    Edit12:TEdit;
    Edit16:TEdit;
    Memo1:TMemo;
    ComboBox4:TComboBox;
    ComboBox6:TComboBox;
    ComboBox7:TComboBox;
    ComboBox8:TComboBox;
    ComboBox9:TComboBox;
// ---------------------------
   UpDown1:TUpDown;
   Button1:TButton;
//------------------------
    DBNavigator1:TDBNavigator;
    DBEdit2:TDBEdit;
    DBEdit3:TDBEdit;
    DBEdit4:TDBEdit;
    DBEdit5:TDBEdit;
    DBEdit6:TDBEdit;
    DBEdit7:TDBEdit;
    DBEdit8:TDBEdit;
    DBEdit9:TDBEdit;
    DBEdit10:TDBEdit;
    DBEdit12:TDBEdit;
    DBEdit13:TDBEdit;
    DBEdit14:TDBEdit;
    DBEdit16:TDBEdit;
    DBEdit17:TDBEdit;
    DBEdit18:TDBEdit;
    DBEdit20:TDBEdit;
    DBEdit21:TDBEdit;
    DBEdit22:TDBEdit;
    DBEdit69:TDBEdit;
    DBCheckbox1:TDBCheckBox;
    DBCombobox2:TDBComboBox;
    DBCombobox3:TDBComboBox;
    DBGrid3:TDbGrid;
    DBText1:TDBText;
    procedure DBNavigator1BeforeAction(Sender : TObject); //
    procedure DBNavigator1Click(Sender : TObject); //
   procedure ComboBox4DblClick(Sender : TObject); //
   procedure DBEdit2Exit(Sender : TObject); //
    procedure DBEdit3Exit(Sender : TObject);
    procedure DBEdit32Exit(Sender : TObject);
    procedure DBComboBox3Change(Sender : TObject);
    procedure DBComboBox3Exit(Sender : TObject);
    procedure DBGrid3DblClick(Sender : TObject);
    procedure DBGrid3Exit(Sender : TObject);
    procedure DBGrid3KeyDown(Sender : TObject);
    procedure DBEdit5MouseDown(Sender : TObject);//
    procedure DBEdit8Change(Sender : TObject);//
    procedure DBEdit9Change(Sender : TObject);//
    procedure DBEdit10Change(Sender : TObject);//
     procedure DBEdit14Exit(Sender : TObject); //
    procedure DBEdit18Exit(Sender : TObject); //
    procedure DBEdit22Exit(Sender : TObject); //
    procedure DBEdit9Exit(Sender : TObject); //
    procedure DBEdit8Exit(Sender : TObject); //
    procedure DBEdit13Exit(Sender : TObject);//
    procedure DBEdit12Exit(Sender : TObject);//
    procedure DBEdit17Exit(Sender : TObject);//
    procedure DBEdit16Exit(Sender : TObject);//
    procedure DBEdit21Exit(Sender : TObject);//
    procedure DBEdit20Exit(Sender : TObject);//
    procedure StringGrid1DblClick(Sender : TObject); //
    procedure StringGrid2DblClick(Sender : TObject); //
    procedure StringGrid5KeyDown(Sender : TObject); //
    procedure StringGrid5DblClick(Sender : TObject); //
    procedure StringGrid5MouseDown(Sender : TObject);//
    procedure ComboBox4Exit(Sender : TObject);//
    procedure Edit1DblClick(Sender : TObject);//
    procedure Edit2DblClick(Sender : TObject);//
    procedure UpDown1Click(Sender : TObject);
  private

  public

  end;

implementation

{$R *.lfm}

{ TFrame2 }

procedure TFrame2.DBNavigator1BeforeAction(Sender: TObject);
begin

end;

procedure TFrame2.DBNavigator1Click(Sender: TObject);
begin

end;

procedure TFrame2.ComboBox4DblClick(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit2Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit3Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit32Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBComboBox3Change(Sender: TObject);
begin

end;

procedure TFrame2.DBComboBox3Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBGrid3DblClick(Sender: TObject);
begin

end;

procedure TFrame2.DBGrid3Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBGrid3KeyDown(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit5MouseDown(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit8Change(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit9Change(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit10Change(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit14Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit18Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit22Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit9Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit8Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit13Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit12Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit17Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit16Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit21Exit(Sender: TObject);
begin

end;

procedure TFrame2.DBEdit20Exit(Sender: TObject);
begin

end;

procedure TFrame2.StringGrid1DblClick(Sender: TObject);
begin

end;

procedure TFrame2.StringGrid2DblClick(Sender: TObject);
begin

end;

procedure TFrame2.StringGrid5KeyDown(Sender: TObject);
begin

end;

procedure TFrame2.StringGrid5DblClick(Sender: TObject);
begin

end;

procedure TFrame2.StringGrid5MouseDown(Sender: TObject);
begin

end;

procedure TFrame2.ComboBox4Exit(Sender: TObject);
begin

end;

procedure TFrame2.Edit1DblClick(Sender: TObject);
begin

end;

procedure TFrame2.Edit2DblClick(Sender: TObject);
begin

end;

procedure TFrame2.UpDown1Click(Sender: TObject);
begin

end;

end.

