unit uScaleDPI;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Graphics, ComCtrls, contnrs;

Procedure AutoAdjustAllForms;
procedure HighDPI(FromDPI: Integer);
procedure ScaleDPI(Control: TControl; FromDPI: Integer);
procedure ScaleImageList(ImgList: TImageList; FromDPI: Integer);

implementation

uses classes;

procedure HighDPI(FromDPI: Integer);
var
  i: Integer;
begin
  for i:=0 to Screen.FormCount-1 do begin
    if FromDPI<>-1 then
    ScaleDPI(Screen.Forms[i],FromDPI)
    else
    ScaleDPI(Screen.Forms[i],Screen.Forms[i].DesignTimeDPI);
  end;
end;

procedure ScaleImageList(ImgList: TImageList; FromDPI: Integer);

var
    TempBmp: TBitmap;
    Temp: array of TBitmap;
    NewWidth, NewHeight: integer;
    I: Integer;

begin
    NewWidth := ScaleX(ImgList.Width, FromDPI);
    NewHeight := ScaleY(ImgList.Height, FromDPI);

    SetLength(Temp, ImgList.Count);
    for I := 0 to ImgList.Count - 1 do
    begin
      TempBmp := TBitmap.Create;
      TempBmp.PixelFormat := pf32bit;
      ImgList.GetBitmap(I, TempBmp);
      Temp[I] := TBitmap.Create;
      Temp[I].SetSize(NewWidth, NewHeight);
      Temp[I].PixelFormat := pf32bit;
      Temp[I].TransparentColor := TempBmp.TransparentColor;
      //Temp[I].TransparentMode := TempBmp.TransparentMode;
      Temp[I].Transparent := True;
      Temp[I].Canvas.Brush.Style := bsSolid;
      Temp[I].Canvas.Brush.Color := Temp[I].TransparentColor;
      Temp[I].Canvas.FillRect(0, 0, Temp[I].Width, Temp[I].Height);

      if (Temp[I].Width = 0) or (Temp[I].Height = 0) then Continue;
      Temp[I].Canvas.StretchDraw(Rect(0, 0, Temp[I].Width, Temp[I].Height), TempBmp);
      TempBmp.Free;
    end;

    ImgList.Clear;
    ImgList.Width := NewWidth;
    ImgList.Height := NewHeight;

    for I := 0 to High(Temp) do
    begin
      ImgList.Add(Temp[I], nil);
      Temp[i].Free;
    end;
end;

procedure ScaleDPI(Control: TControl; FromDPI: Integer);
var
  n: Integer;
  WinControl: TWinControl;
  ToolBarControl: TToolBar;
begin
  if Screen.PixelsPerInch = FromDPI then exit;

  with Control do begin
    Left:=ScaleX(Left,FromDPI);
    Top:=ScaleY(Top,FromDPI);
    Width:=ScaleX(Width,FromDPI);
    Height:=ScaleY(Height,FromDPI);
    {$IFDEF LCL_Qt}
      Font.Size := 0;
    {$ELSE}
      Font.Height := ScaleY(Font.GetTextHeight('Hg'), FromDPI);
    {$ENDIF}
  end;

  if Control is TCoolBar then
  with TCoolBar(Control) do begin
    BeginUpdate;
    for n := 0 to Bands.Count - 1 do
      with Bands[n] do begin
        MinWidth := ScaleX(MinWidth, FromDPI);
        MinHeight := ScaleY(MinHeight, FromDPI);
        Width := ScaleX(Width, FromDPI);
      end;
    EndUpdate;
  end;

  if Control is TToolBar then begin
    ToolBarControl:=TToolBar(Control);
    with ToolBarControl do begin
      ButtonWidth:=ScaleX(ButtonWidth,FromDPI);
      ButtonHeight:=ScaleY(ButtonHeight,FromDPI);
    end;
  end;

  if Control is TWinControl then begin
    WinControl:=TWinControl(Control);
    if WinControl.ControlCount > 0 then begin
      for n:=0 to WinControl.ControlCount-1 do begin
        if WinControl.Controls[n] is TControl then begin
          ScaleDPI(WinControl.Controls[n],FromDPI);
        end;
      end;
    end;
  end;
end;

procedure AutoAdjustAllForms;
var
  I: Integer;
begin
  for I:= 0 to Screen.FormCount -1 do
    Screen.Forms[i].AutoAdjustLayout(
      lapAutoAdjustForDPI, Screen.Forms[i].DesignTimeDPI, Screen.PixelsPerInch,
      Screen.Forms[i].Width, ScaleX(Screen.Forms[i].Width, Screen.Forms[i].DesignTimeDPI));
end;

end.

