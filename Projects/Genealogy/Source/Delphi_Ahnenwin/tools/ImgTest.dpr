program ImgTest;

{-------------------------------------------------------------------------------
  ImgTest - checks whether the images of every form are loaded from the DFM
  resources.

  A graphic that is stored in a DFM as "Picture.Data" is loaded by
  TBitmap.LoadFromStream, which dispatches over the graphic formats that are
  registered at run time. The JPEG format is only registered when the JPEG
  unit is linked into the program, so a program that forgets it silently
  loses every JPEG picture.

  This program reports, for every form, the images it contains and whether
  their graphic was loaded.
-------------------------------------------------------------------------------}

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Forms, Controls, Graphics, DBTables, ExtCtrls, JPEG,
  AHNStart in 'Units\AHNStart.pas',
  Unit1  in '..\Units\Unit1.pas',
  Unit2  in '..\Units\Unit2.pas',
  Unit3  in '..\Units\Unit3.pas',
  Unit4  in '..\Units\Unit4.pas',
  Unit5  in '..\Units\Unit5.pas',
  Unit6  in '..\Units\Unit6.pas',
  Unit7  in '..\Units\Unit7.pas',
  Unit8  in '..\Units\Unit8.pas',
  Unit9  in '..\Units\Unit9.pas',
  Unit10 in '..\Units\Unit10.pas',
  Unit11 in '..\Units\Unit11.pas',
  Unit12 in '..\Units\Unit12.pas',
  Unit13 in '..\Units\Unit13.pas',
  Unit14 in '..\Units\Unit14.pas',
  Unit15 in '..\Units\Unit15.pas',
  Unit16 in '..\Units\Unit16.pas',
  Unit17 in '..\Units\Unit17.pas',
  Unit18 in '..\Units\Unit18.pas',
  Unit19 in '..\Units\Unit19.pas',
  Unit20 in '..\Units\Unit20.pas',
  Unit21 in '..\Units\Unit21.pas',
  Unit22 in '..\Units\Unit22.pas',
  Unit23 in '..\Units\Unit23.pas',
  Unit24 in '..\Units\Unit24.pas',
  Unit25 in '..\Units\Unit25.pas',
  Unit26 in '..\Units\Unit26.pas',
  Unit27 in '..\Units\Unit27.pas',
  Unit28 in '..\Units\Unit28.pas',
  Unit29 in '..\Units\Unit29.pas',
  Unit30 in '..\Units\Unit30.pas',
  Unit31 in '..\Units\Unit31.pas',
  Unit32 in '..\Units\Unit32.pas',
  Unit33 in '..\Units\Unit33.pas',
  Unit34 in '..\Units\Unit34.pas',
  Unit35 in '..\Units\Unit35.pas',
  Unit36 in '..\Units\Unit36.pas',
  Unit37 in '..\Units\Unit37.pas',
  Unit38 in '..\Units\Unit38.pas',
  Unit39 in '..\Units\Unit39.pas',
  Unit40 in '..\Units\Unit40.pas';

var
  Total, Loaded, Missing: Integer;

procedure CheckForm(const AName: string; AForm: TForm);
var
  I: Integer;
  Img: TImage;
begin
  for I := 0 to AForm.ComponentCount - 1 do
    if AForm.Components[I] is TImage then
    begin
      Img := TImage(AForm.Components[I]);
      Inc(Total);
      if (Img.Picture.Graphic <> nil) and (Img.Picture.Graphic.Width > 0) then
        Inc(Loaded)
      else
      begin
        Inc(Missing);
        if Img.Picture.Graphic = nil then
          WriteLn('  FEHLT: ', AName, '.', Img.Name, '  (kein Graphic)')
        else
          WriteLn('  LEER: ', AName, '.', Img.Name, '  (', Img.Picture.Graphic.ClassName, ')');
      end;
    end;
end;

procedure Check(const AName: string; AForm: TForm);
begin
  CheckForm(AName, AForm);
  AForm.Free;
end;

{ Creates the form and checks its images. A form that cannot be created at
  all is reported and skipped, so that one problematic form does not hide
  the result of all the others. }
procedure TryCheck(const AName: string; AClass: TFormClass);
var
  F: TForm;
begin
  Write(AName, ' ... ');
  Flush(Output);
  try
    Application.CreateForm(AClass, F);
  except
    on E: Exception do
    begin
      WriteLn('KANN NICHT ERZEUGT WERDEN: ', E.ClassName, ': ', E.Message);
      Inc(Total);
      Inc(Missing);
      Exit;
    end;
  end;
  try
    CheckForm(AName, F);
  finally
    F.Free;
  end;
  WriteLn;
end;

begin
  SetCurrentDir(DatenVerzeichnisSetzen);
  { The data module has to exist before the forms are streamed: the
    resources of the forms refer to it by name. }
  Application.CreateForm(TDataModule2, DataModule2);
  { The BDE of Delphi 9 writes its net file into the root of the drive
    when it has no configuration; it belongs next to the data. }
  Session.NetFileDir := DatenVerzeichnis;
  Application.Initialize;
  SplashZeigen;
  TryCheck('Form1', TForm1);
  TryCheck('Form3', TForm3);
  TryCheck('Form4', TForm4);
  TryCheck('Form5', TForm5);
  TryCheck('Form6', TForm6);
  TryCheck('Form7', TForm7);
  TryCheck('Form8', TForm8);
  TryCheck('Form9', TForm9);
  TryCheck('Form10', TForm10);
  TryCheck('Form11', TForm11);
  TryCheck('Form12', TForm12);
  TryCheck('Form13', TForm13);
  TryCheck('Form14', TForm14);
  TryCheck('Form15', TForm15);
  TryCheck('Form16', TForm16);
  TryCheck('Form17', TForm17);
  TryCheck('Form18', TForm18);
  TryCheck('Form19', TForm19);
  TryCheck('Form20', TForm20);
  TryCheck('Form21', TForm21);
  TryCheck('Form22', TOKBottomDlg);
  TryCheck('Form23', TForm23);
  TryCheck('Form24', TForm24);
  TryCheck('Form25', TForm25);
  TryCheck('Form26', TForm26);
  TryCheck('Form27', TOKBottomDlg1);
  TryCheck('Form28', TForm28);
  TryCheck('Form29', TForm29);
  TryCheck('Form30', TForm30);
  TryCheck('Form31', TForm31);
  TryCheck('Form32', TForm32);
  TryCheck('Form33', TForm33);
  TryCheck('Form34', TForm34);
  TryCheck('Form35', TForm35);
  TryCheck('Form36', TForm36);
  TryCheck('Form37', TForm37);
  TryCheck('Form38', TForm38);
  TryCheck('Form39', TForm39);
  TryCheck('Form40', TForm40);

  WriteLn;
  WriteLn('Bilder gesamt: ', Total, '  geladen: ', Loaded, '  fehlend: ', Missing);

end.
