unit AHW52PicturesFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PicturesFrame, ExtCtrls, fpcunit, testregistry;

type
  TTestAHW52PicturesFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsPicturesFrameAndPreservesLayout;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52PicturesFrame.
  TestMainFormStreamsPicturesFrameAndPreservesLayout;
var
  mainForm: TForm1;
  picturesFrame: TAHW52PicturesFrame;
  images: array[0..24] of TImage;
  imageIndex: Integer;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    picturesFrame := mainForm.PicturesFrame;
    AssertTrue('TabSheet9 should stream its production pictures frame.',
      Assigned(picturesFrame));
    AssertTrue('The pictures frame should be parented by TabSheet9.',
      picturesFrame.Parent = mainForm.TabSheet9);
    AssertEquals('The pictures tab caption should remain unchanged.',
      'Bilder', mainForm.TabSheet9.Caption);
    AssertEquals('The pictures tab image index should remain unchanged.',
      8, mainForm.TabSheet9.ImageIndex);
    AssertEquals('The pictures frame should own all 25 images and 6 labels.',
      31, picturesFrame.ComponentCount);

    images[0] := picturesFrame.Image2;
    images[1] := picturesFrame.Image3;
    images[2] := picturesFrame.Image4;
    images[3] := picturesFrame.Image5;
    images[4] := picturesFrame.Image6;
    images[5] := picturesFrame.Image7;
    images[6] := picturesFrame.Image13;
    images[7] := picturesFrame.Image12;
    images[8] := picturesFrame.Image11;
    images[9] := picturesFrame.Image10;
    images[10] := picturesFrame.Image9;
    images[11] := picturesFrame.Image8;
    images[12] := picturesFrame.Image14;
    images[13] := picturesFrame.Image15;
    images[14] := picturesFrame.Image16;
    images[15] := picturesFrame.Image17;
    images[16] := picturesFrame.Image18;
    images[17] := picturesFrame.Image19;
    images[18] := picturesFrame.Image26;
    images[19] := picturesFrame.Image25;
    images[20] := picturesFrame.Image24;
    images[21] := picturesFrame.Image23;
    images[22] := picturesFrame.Image22;
    images[23] := picturesFrame.Image21;
    images[24] := picturesFrame.Image20;

    for imageIndex := Low(images) to High(images) do
    begin
      AssertTrue('Every picture slot should keep the original click handler.',
        images[imageIndex].OnClick = @picturesFrame.ImageClick);
      AssertTrue('Every picture slot should retain proportional sizing.',
        images[imageIndex].Proportional);
      AssertTrue('Every picture slot should retain stretching.',
        images[imageIndex].Stretch);
      AssertEquals('Every picture slot should retain its original dimensions.',
        119, images[imageIndex].Width);
      AssertEquals('Every picture slot should retain its original height.',
        129, images[imageIndex].Height);
    end;

    AssertEquals('The first picture slot should retain its original position.',
      13, picturesFrame.Image2.Left);
    AssertEquals('The first picture slot should retain its original top.',
      29, picturesFrame.Image2.Top);
    AssertEquals('The final picture slot should retain its original position.',
      909, picturesFrame.Image26.Left);
    AssertEquals('The final picture slot should retain its original top.',
      533, picturesFrame.Image26.Top);
    AssertFalse('Label94 should remain initially hidden.',
      picturesFrame.Label94.Visible);
    AssertFalse('Label96 should remain initially hidden.',
      picturesFrame.Label96.Visible);
    AssertFalse('Label97 should remain initially hidden.',
      picturesFrame.Label97.Visible);
    AssertTrue('The pictures tab show event should route to the frame.',
      mainForm.TabSheet9.OnShow = @picturesFrame.TabSheet9Show);
    AssertTrue('The pictures tab exit event should route to the frame.',
      mainForm.TabSheet9.OnExit = @picturesFrame.TabSheet9Exit);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PicturesFrame);

end.
