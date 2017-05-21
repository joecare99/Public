unit frm_MemoEmptyLineMain;

{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  FileUtil,
{$ELSE}

{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnAddTextTS: TButton;
    btnClearMemo: TButton;
    btnClearTS: TButton;
    btnInsertTextTS: TButton;
    btnMemoAdd: TButton;
    btnTSAdd: TButton;
    btnSetText: TButton;
    btnAddText: TButton;
    btnInsertText: TButton;
    btnSetTextTS: TButton;
    btnTrimText: TButton;
    btnTrimTextTS: TButton;
    btnUpdate: TButton;
    lblLineCount: TLabel;
    lblShowText: TLabel;
    Memo1: TMemo;
    procedure btnAddTextTSClick(Sender: TObject);
    procedure btnClearMemoClick(Sender: TObject);
    procedure btnClearTSClick(Sender: TObject);
    procedure btnInsertTextTSClick(Sender: TObject);
    procedure btnMemoAddClick(Sender: TObject);
    procedure btnSetTextClick(Sender: TObject);
    procedure btnAddTextClick(Sender: TObject);
    procedure btnInsertTextClick(Sender: TObject);
    procedure btnSetTextTSClick(Sender: TObject);
    procedure btnTrimTextClick(Sender: TObject);
    procedure btnTrimTextTSClick(Sender: TObject);
    procedure btnTSAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure StringsOnChange(Sender: TObject);
  private
    { private declarations }
    FStrings: TStrings;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}

const
  LineEnding = #10#13;

{$ENDIF}
{ TForm1 }

procedure TForm1.btnClearMemoClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TForm1.btnAddTextTSClick(Sender: TObject);
begin
   {$IFDEF FPC}
  FStrings.AddText('AddText Testline ' + IntToStr(FStrings.Count));
  {$ENDIF}
end;

procedure TForm1.btnClearTSClick(Sender: TObject);
begin
  FStrings.Clear;
end;

procedure TForm1.btnInsertTextTSClick(Sender: TObject);
begin
  FStrings.Insert(0, 'Insert Testline ' + IntToStr(FStrings.Count));
end;

procedure TForm1.btnMemoAddClick(Sender: TObject);
begin
  memo1.Lines.add('Add Testline ' + IntToStr(memo1.Lines.Count));
end;

procedure TForm1.btnSetTextClick(Sender: TObject);
begin
  memo1.Lines.Text := 'This is a test' + LineEnding +
    'if there is alway an empty line' + LineEnding + 'at the end.';
end;

procedure TForm1.btnAddTextClick(Sender: TObject);
begin
  {$IFDEF FPC}
  memo1.Lines.AddText('AddText Testline ' + IntToStr(memo1.Lines.Count));
  {$ENDIF}
end;

procedure TForm1.btnInsertTextClick(Sender: TObject);
begin
  memo1.Lines.Insert(0, 'Insert Testline ' + IntToStr(memo1.Lines.Count));
end;

procedure TForm1.btnSetTextTSClick(Sender: TObject);
begin
  FStrings.Text := 'This is a test' + LineEnding +
    'if there is alway an empty line' + LineEnding + 'at the end.';
end;

procedure TForm1.btnTrimTextClick(Sender: TObject);
begin
  memo1.Lines.Text := TrimRight(Memo1.Lines.Text);
end;

procedure TForm1.btnTrimTextTSClick(Sender: TObject);
begin
  FStrings.Text := TrimRight(FStrings.Text);
end;

procedure TForm1.btnTSAddClick(Sender: TObject);
begin
  FStrings.add('Add Testline ' + IntToStr(FStrings.Count));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FStrings := TStringList.Create;
  TStringList(FStrings).OnChange := {$ifdef fpc}@{$endif}StringsOnChange;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStrings);
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  lblShowText.Caption := '''' + memo1.Lines.Text + '''';
  lblLineCount.Caption := IntToStr(Memo1.Lines.Count);
end;

procedure TForm1.StringsOnChange(Sender: TObject);
begin
  lblShowText.Caption := '''' + FStrings.Text + '''';
  lblLineCount.Caption := IntToStr(FStrings.Count);
end;

end.
