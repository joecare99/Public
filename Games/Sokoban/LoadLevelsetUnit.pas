Unit LoadLevelsetUnit;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

Interface

Uses
{$IFNDEF FPC}
  Windows, msxmldom, xmldom, xmldoc, XMLIntf,
{$ELSE}
  dom, XMLRead,
{$ENDIF}
  Graphics, Controls, Forms,
  Buttons, Classes,
  SysUtils, Dialogs,
  SokoEngine;

{$IFDEF FPC}

Type

  { TXMLHelper }

  TXMLHelper = Class Helper For TDOMNodeList
  Private
    Function getActive: boolean;
    Procedure setActive(AValue: boolean);
    Procedure SetNodes(ANodeName: String; AValue: TDOMNode);
  Public
    Function FindNode(ANodeName: String): TDOMNode; Overload;
    Function FindNode(Aindex: integer): TDOMNode; Overload;
  public
    Property Active: boolean Read getActive Write setActive;
    Property Nodes[ANodeName: String]: TDOMNode Read FindNode Write SetNodes;
  End;

  { TXMNodeHelper }

  TXMNodeHelper = Class Helper For TDOMNode
  Private
    Function GetNamedAttributes(ANodeName: String): DOMString;
    Function GetText: DOMString;
    Procedure SetText(AValue: DOMString);
  Public
    Procedure Addchild(AChildName: String);
    Procedure SetAttributeNS(AAttrName, NS, AValue: String);
  Published
    Property Text: DOMString Read GetText Write SetText;
    Property Attributes[AAttributeName: String]: DOMString
      Read GetNamedAttributes;
  End;
{$ENDIF}

Procedure LoadPuzzleSet(AFileName: String; Var Levelset: TPuzzleCollectionData);
Procedure LoadXML(AFileName: String; Var Levelset: TPuzzleCollectionData);
Procedure LoadRDF(AFileName: String; Var Levelset: TPuzzleCollectionData);
Procedure LoadLP0(AFileName: String; Var Levelset: TPuzzleCollectionData);
Procedure LoadASCII(AFileName: String; Var Levelset: TPuzzleCollectionData);

Implementation

// uses mainunit;

Resourcestring
  SLevelSCouldnotbLoaded =
    'Level %s  in ''%s'' could not be loaded!/nPlease send an ' +
    'e-mail to benruyl@zonnet.nl.';

Type
  T2DArrayofBoolean = Array Of Array Of boolean;

Procedure LoadPuzzleSet(AFileName: String; Var Levelset: TPuzzleCollectionData);
  Var
    AExt: String;
  Begin
    AExt := LowerCase(ExtractFileExt(AFileName));
    If (AExt = '.xml') Or (AExt = '.slc') Then
      LoadXML(AFileName, Levelset)
    Else If AExt = '.rdf' Then
      LoadRDF(AFileName, Levelset)
    Else If AExt = '.lp0' Then
      LoadLP0(AFileName, Levelset)
    Else
      LoadASCII(AFileName, Levelset);
  End;

{$IFDEF FPC}

Procedure ReadXMLFile(Out TheDoc: TXMLDocument; AFileName: String);
  Var
    Parser: TDOMParser;
    Src: TXMLInputSource;
    AStream: TStream;

  Begin
    Try
      AStream := TFileStream.Create(AFileName, fmOpenRead + fmShareDenyWrite);
      Parser := TDOMParser.Create;
      Src := TXMLInputSource.Create(AStream);
      Parser.Options.Validate := false;
      Parser.Options.PreserveWhitespace := true;
      // parser.Options.;
      // Festlegen einer Methode, die bei Fehlern aufgerufen wird
      // Parser.OnError := @ErrorHandler;
      Parser.Parse(Src, TheDoc);
    Finally
      Src.Free;
      Parser.Free;
      AStream.Free;
    End;
  End;
{$ENDIF}

Function ExtractFileNameS(Const FileName: String): String;
  Var
    I, J: integer;
  Begin
    I := LastDelimiter(PathDelim + DriveDelim, FileName);

    J := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
    If (J > 0) And (FileName[J] = '.') Then
      Result := Copy(FileName, I + 1, J - I - 1)
    Else
      Result := '';
  End;

/// <info>
/// Marks all Empty Fields as ptNone as long as they are reachable by the player
/// </info>
Procedure CheckTransparency(Var ActLevel: TPuzzleField;
  Var CanAccess: T2DArrayofBoolean; AXPos, AYPos: smallint);

    Function AllowNextStep(ANextX, ANextY: smallint): boolean;
      Begin
        Result := false;
        If (ANextX >= 0) And (ANextY >= 0) And (ANextX <= High(CanAccess)) And
          (ANextY <= High(CanAccess[0])) Then
          Result := (CanAccess[ANextX, ANextY]) And
            ((ActLevel[ANextX, ANextY].FPartType = ptEmpty) Or
            (ActLevel[ANextX, ANextY].FPartType = ptCrate));
      End;

  Begin
    If ActLevel[AXPos, AYPos].FPartType = ptEmpty Then
      ActLevel[AXPos, AYPos].FPartType := ptNone;
    CanAccess[AXPos, AYPos] := false;

    If AllowNextStep(AXPos, Pred(AYPos)) Then
      CheckTransparency(ActLevel, CanAccess, AXPos, Pred(AYPos));
    If AllowNextStep(Succ(AXPos), AYPos) Then
      CheckTransparency(ActLevel, CanAccess, Succ(AXPos), AYPos);
    If AllowNextStep(AXPos, Succ(AYPos)) Then
      CheckTransparency(ActLevel, CanAccess, AXPos, Succ(AYPos));
    If AllowNextStep(Pred(AXPos), AYPos) Then
      CheckTransparency(ActLevel, CanAccess, Pred(AXPos), AYPos);
  End;

Function CreatePlayer(Var ActLevel: TPuzzleField; HasPlayer: boolean;
  AXPos, AYPos: smallint; OnPos: boolean): boolean;
  Begin
    Result := true;
    If Not HasPlayer Then // Only one player is allowed
      Begin
        ActLevel[AXPos, AYPos].FPartType := ptPlayer;
        If OnPos Then
          ActLevel[AXPos, AYPos].FSkinType := stPlayerUpStore
        Else
          ActLevel[AXPos, AYPos].FSkinType := stPlayerUp;
        Result := true;
      End
    Else
      Raise Exception.Create('');
  End;

Procedure CreateCrateTargetPart(Var ActLevel: TPuzzleField;
  Var HasPlayer: boolean; Var ArrayPos: integer; AXPos, AYPos, APart: smallint);
  Begin
    Case APart Of
      0:
        ActLevel[AXPos, AYPos].FPartType := ptEmpty;
      1:
        Begin
          ActLevel[AXPos, AYPos].FPartType := ptCrate;
          ActLevel[AXPos, AYPos].FCrateID := ArrayPos;

          Inc(ArrayPos);
        End;
      2:
        Begin
          HasPlayer := CreatePlayer(ActLevel, HasPlayer, AXPos, AYPos, true);
        End
    End;

    ActLevel[AXPos, AYPos].FIsCrateTarget := true;
  End;

Function MakeLevel(Var ActLevel: TPuzzleField; Var NewLevel, HasPlayer: boolean;
  LevelWidth, LevelHeight, FPlayerPosX, FPlayerPosY: integer): boolean;
  Var
    XPOs, YPos: integer;
    CanAccess: T2DArrayofBoolean;
    I: integer;

  Begin
    Result := false;
    If NewLevel = false Then
      Begin
        // LevelWidth := FMaxX;
        // LevelHeight := FMaxY;

        // FGameData[FPuzzleCount].FLevelWidth := LevelWidth;
        // FGameData[FPuzzleCount].FLevelHeight := LevelHeight;

        SetLength(ActLevel, LevelWidth, LevelHeight);
        SetLength(CanAccess, LevelWidth, LevelHeight);

        For XPOs := 0 To High(CanAccess) Do
          Begin
            For YPos := 0 To High(CanAccess[0]) Do
              CanAccess[XPOs, YPos] := true;
          End;

        If Not HasPlayer Then // skip this level
          Begin
            NewLevel := true;
            Exit;
          End;

        CheckTransparency(ActLevel, CanAccess, FPlayerPosX, FPlayerPosY);

        For YPos := 0 To Pred(LevelHeight) Do
          For XPOs := 0 To Pred(LevelWidth) Do
            Begin
              If ActLevel[XPOs, YPos].FPartType = ptWall Then
                Begin
                  I := 0;
                  If YPos <> 0 Then
                    If (ActLevel[XPOs, YPos - 1].FPartType = ptWall) Then
                      I := I Xor 12;
                  // i := i + 10;

                  If XPOs <> 0 Then
                    If (ActLevel[XPOs - 1, YPos].FPartType = ptWall) Then
                      I := I Xor 3;
                  // i := i + 13;

                  If YPos <> Pred(LevelHeight) Then
                    If (ActLevel[XPOs, YPos + 1].FPartType = ptWall) Then
                      I := I Xor 4;
                  // i := i + 12;

                  If XPOs <> Pred(LevelWidth) Then
                    If (ActLevel[XPOs + 1, YPos].FPartType = ptWall) Then
                      I := I Xor 1;
                  // i := i + 14;
                  With ActLevel[XPOs, YPos] Do
                    FSkinType := TskinType(ord(stWall) + I);
                  // case i of
                  // 00: FSkinType := stWall;
                  // 10: FSkinType := stWallUp;
                  // 12: FSkinType := stWallDown;
                  // 13: FSkinType := stWallLeft;
                  // 14: FSkinType := stWallRight;
                  // 22: FSkinType := stWallUpDown;
                  // 23: FSkinType := stWallUpLeft;
                  // 24: FSkinType := stWallUpRight;
                  // 25: FSkinType := stWallDownLeft;
                  // 26: FSkinType := stWallDownRight;
                  // 27: FSkinType := stWallLeftRight;
                  // 35: FSkinType := stWallUpDownLeft;
                  // 36: FSkinType := stWallUpDownRight;
                  // 37: FSkinType := stWallUpLeftRight;
                  // 39: FSkinType := stWallDownLeftRight;
                  // 49: FSkinType := stWallUpDownLeftRight;
                  // else
                  // FSkinType := stWall;
                  // end;
                End;
            End;
        Result := true;
      End;
  End;

Procedure LoadXML(AFileName: String; Var Levelset: TPuzzleCollectionData);
  Var
    HasPlayer: boolean;
    XPOs, YPos: smallint;
    I, FPuzzleCount: integer;
    LevelWidth, LevelHeight, ArrayPos: integer;
{$IFDEF FPC}
    FirstNode, CurrentLevel, CurrentNode: TDOMNode;
{$ELSE}
    FirstNode, CurrentLevel, CurrentNode: IXMLNode;
{$ENDIF}
    LevelRowData: String;
    FPlayerPosX: smallint;
    FPlayerPosY: smallint;
    FLevelDoc: TXMLDocument;
    NewLevel: boolean;
    LevelCount: LongWord;
    StartLevel: integer;
    J: integer;
    vv: integer;

  Begin
    SetLength(Levelset.FPuzzleFields, 0);

{$IFDEF FPC}
    ReadXMLFile(FLevelDoc, AFileName);
{$ELSE}
    FLevelDoc := TXMLDocument.Create(Nil);
    FLevelDoc.LoadFromFile(AFileName);
{$ENDIF}
    Try
{$IFNDEF FPC}
      FLevelDoc.Active := true;
{$ENDIF}
      FirstNode := FLevelDoc.DocumentElement.ChildNodes.FindNode
        ('LevelCollection');

      With Levelset Do
        Begin
          CurrentNode := FLevelDoc.DocumentElement;
          Title := CurrentNode.ChildNodes.Nodes['Title'].Text;
          Description := CurrentNode.ChildNodes.Nodes['Description'].Text;
          Email := CurrentNode.ChildNodes.Nodes['Email'].Text;
          Copyright := FirstNode.Attributes['Copyright'];
          tryStrToInt(FirstNode.Attributes['MaxWidth'], vv);
          MaxWidth := vv;
          tryStrToInt(FirstNode.Attributes['MaxHeight'], vv);
          MaxHeight := vv;
        End;

      LevelCount := FirstNode.ChildNodes.Count;
{$IFDEF FPC}
      If (LevelCount > 0) And Not FirstNode.ChildNodes.Nodes[0].InheritsFrom
        (TDOMElement) Then
        Begin
          dec(LevelCount);
          StartLevel := 1;
        End
      Else
        StartLevel := 0;
{$ENDIF}
      SetLength(Levelset.FPuzzleFields, FirstNode.ChildNodes.Count);

      FPuzzleCount := 0;
      For I := 0 To LevelCount Do
        Begin

          CurrentLevel := FirstNode.ChildNodes.Nodes[I];
{$IFDEF FPC}
          If Not CurrentLevel.InheritsFrom(TDOMElement) Then
            Continue;
{$ENDIF}
          Inc(FPuzzleCount);
          LevelWidth := StrToInt(CurrentLevel.Attributes['Width']);
          LevelHeight := StrToInt(CurrentLevel.Attributes['Height']);

          SetLength(Levelset.FPuzzleFields[FPuzzleCount - 1], LevelWidth,
            LevelHeight);
          ArrayPos := 0;
          HasPlayer := false;

          YPos := -1;
          For J := 0 To CurrentLevel.ChildNodes.Count - 1 Do
            Begin
{$IFDEF FPC}
              If Not CurrentLevel.ChildNodes.Nodes[J].InheritsFrom
                (TDOMElement) Then
                Continue;
{$ENDIF}
              Inc(YPos);
              LevelRowData := CurrentLevel.ChildNodes.Nodes[J].Text;

              For XPOs := Length(LevelRowData) + 1 To LevelWidth Do
                With Levelset.FPuzzleFields[FPuzzleCount - 1][XPOs - 1, YPos] Do
                  Begin
                    // If it is outside the level, fill it with ptEmpty
                    FPartType := ptEmpty;
                    FIsCrateTarget := false;
                    FCrateID := -1;
                  End;

              For XPOs := 1 To Length(LevelRowData) Do
                With Levelset.FPuzzleFields[FPuzzleCount - 1][XPOs - 1, YPos] Do
                  Begin
                    FIsCrateTarget := false;
                    FCrateID := -1;
                    If LevelRowData[XPOs] = '#' Then
                      FPartType := ptWall;
                    If LevelRowData[XPOs] = '@' Then
                      Begin
                        HasPlayer :=
                          CreatePlayer(Levelset.FPuzzleFields[FPuzzleCount - 1],
                          HasPlayer, XPOs - 1, YPos, false);
                        FPlayerPosX := XPOs - 1;
                        FPlayerPosY := YPos;
                      End;
                    If LevelRowData[XPOs] = '$' Then
                      Begin
                        FPartType := ptCrate;
                        FCrateID := ArrayPos;
                        Inc(ArrayPos);
                      End;
                    If LevelRowData[XPOs] = ' ' Then
                      FPartType := ptEmpty;
                    If LevelRowData[XPOs] = '.' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount - 1], HasPlayer,
                        ArrayPos, XPOs - 1, YPos, 0);
                    If LevelRowData[XPOs] = '*' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount - 1], HasPlayer,
                        ArrayPos, XPOs - 1, YPos, 1);
                    If LevelRowData[XPOs] = '+' Then
                      Begin
                        CreateCrateTargetPart
                          (Levelset.FPuzzleFields[FPuzzleCount - 1], HasPlayer,
                          ArrayPos, XPOs - 1, YPos, 2);
                        If HasPlayer Then
                          Begin
                            FPlayerPosX := XPOs - 1;
                            FPlayerPosY := YPos;
                          End;

                      End;
                  End;
            End;

          NewLevel := false;
          If MakeLevel(Levelset.FPuzzleFields[FPuzzleCount - 1], NewLevel,
            HasPlayer, LevelWidth, LevelHeight, FPlayerPosX, FPlayerPosY) Then
            Begin
            End
          Else
            Raise Exception.Create('');

        End;
      SetLength(Levelset.FPuzzleFields, FPuzzleCount);

    Except
{$IFDEF FPC}
      MessageDlg('Error', Format(SLevelSCouldnotbLoaded,
        [IntToStr(FPuzzleCount), ExtractFileName(AFileName)]), mtError,
        [mbOK], 0);
{$ELSE}
      MessageDlg(Format(SLevelSCouldnotbLoaded, [IntToStr(FPuzzleCount),
        ExtractFileName(AFileName)]), mtError, [mbOK], 0);

      // MessageBox(frmSokoban.Handle, PChar('Level ' + IntToStr(frmSokoban.LevelNumber) +
      // ' in ' + '''' + ExtractFileName(FLevelFileName) + '''' +
      // ' could not be loaded!' + #13#10 +
      // 'Please send an e-mail to benruyl@zonnet.nl.'),
      // 'Error', MB_OK or MB_ICONERROR);
{$ENDIF}
    End;
    FreeAndNil(FLevelDoc);
  End;

Procedure LoadASCII(AFileName: String; Var Levelset: TPuzzleCollectionData);
  Var
    AFile: TextFile;
    HasPlayer: boolean;
    XPOs, YPos: smallint;
    FPuzzleCount, FMaxX, FMaxY: integer;
    ArrayPos: integer;
    ALine: String;
    NewLevel: boolean;

    FPlayerPosX: smallint;
    FPlayerPosY: smallint;

    // procedure _CheckTransparency(AXPos, AYPos: smallint);

    // function AllowNextStep(ANextX, ANextY: smallint): boolean;
    // begin
    // Result := (CanAccess[ANextX, ANextY]) and
    // ((Levelset.FPuzzleFields[FPuzzleCount][ANextX, ANextY].FPartType =
    // ptEmpty) or (Levelset.FPuzzleFields[FPuzzleCount][ANextX,
    // ANextY].FPartType = ptCrate));
    // end;

    // begin
    // if Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType = ptEmpty then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptNone;
    // CanAccess[AXPos, AYPos] := False;

    // if AllowNextStep(AXPos, Pred(AYPos)) then
    // CheckTransparency(AXPos, Pred(AYPos));
    // if AllowNextStep(Succ(AXPos), AYPos) then
    // CheckTransparency(Succ(AXPos), AYPos);
    // if AllowNextStep(AXPos, Succ(AYPos)) then
    // CheckTransparency(AXPos, Succ(AYPos));
    // if AllowNextStep(Pred(AXPos), AYPos) then
    // CheckTransparency(Pred(AXPos), AYPos);
    // end;

    // procedure CreatePlayer(AXPos, AYPos: smallint; OnPos: boolean);
    // begin
    // if not HasPlayer then // Only one player is allowed
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptPlayer;
    // if OnPos then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType :=
    // stPlayerUpStore
    // else
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType := stPlayerUp;
    // FPlayerPosX := AXPos;
    // FPlayerPosY := AYPos;
    // HasPlayer := True;
    // end
    // else
    // raise Exception.Create('');
    // end;

    // procedure CreateCrateTargetPart(AXPos, AYPos, APart: smallint);
    // begin
    // case APart of
    // 0: Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptEmpty;
    // 1:
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptCrate;
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FCrateID := ArrayPos;
    // Inc(ArrayPos);
    // end;
    // 2: CreatePlayer(AXPos, AYPos, True);
    // end;

    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FIsCrateTarget := True;
    // end;

    Function IsValid(AString: String): boolean;
      Var
        I: integer;
      Begin
        Result := Not(AString = '');

        For I := 1 To Length(AString) Do
{$IFDEF FPC}
          If Not(AString[I] In ['#', '@', '$', '+', '*', '.', ' ']) Then
{$ELSE}
          If Not charinset(AString[I], ['#', '@', '$', '+', '*', '.', ' ']) Then
{$ENDIF}
            Begin
              Result := false;
              Break;
            End;
      End;

  Begin
    SetLength(Levelset.FPuzzleFields, 0);
    YPos := 0;

    AssignFile(AFile, AFileName);
    Try
      Try
        Reset(AFile);

        With Levelset Do
          Begin
            Title := ExtractFileNameS(AFileName);
            Description := '';
            Email := '';
            Copyright := 'NA';
          End;

        SetLength(Levelset.FPuzzleFields, 1000); // 1000 is max

        FPuzzleCount := 0;
        NewLevel := true;
        While Not EOF(AFile) Do
          Begin
            Readln(AFile, ALine);
            If IsValid(ALine) Then
              Begin
                If NewLevel = true Then
                  Begin
                    NewLevel := false;
                    FMaxX := 0;
                    FMaxY := 0;

                    SetLength(Levelset.FPuzzleFields[FPuzzleCount], 100, 100);

                    For YPos := 0 To 99 Do
                      For XPOs := 0 To 99 Do
                        Begin
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FPartType := ptEmpty;
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FIsCrateTarget := false;
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FCrateID := -1;
                        End;

                    YPos := 0;
                    ArrayPos := 0;
                    HasPlayer := false;
                  End;
                If FMaxX < Length(ALine) Then
                  FMaxX := Length(ALine);
                Inc(FMaxY);

                For XPOs := 1 To Length(ALine) Do
                  Begin
                    If ALine[XPOs] = '#' Then
                      Levelset.FPuzzleFields[FPuzzleCount][XPOs - 1, YPos]
                        .FPartType := ptWall;
                    If ALine[XPOs] = '@' Then
                      Begin
                        CreatePlayer(Levelset.FPuzzleFields[FPuzzleCount],
                          HasPlayer, XPOs - 1, YPos, false);
                        FPlayerPosX := XPOs - 1;
                        FPlayerPosY := YPos;
                      End;
                    If ALine[XPOs] = '$' Then
                      Begin
                        Levelset.FPuzzleFields[FPuzzleCount][XPOs - 1, YPos]
                          .FPartType := ptCrate;
                        Levelset.FPuzzleFields[FPuzzleCount][XPOs - 1, YPos]
                          .FCrateID := ArrayPos;

                        Inc(ArrayPos);
                      End;
                    If ALine[XPOs] = ' ' Then
                      Levelset.FPuzzleFields[FPuzzleCount][XPOs - 1, YPos]
                        .FPartType := ptEmpty;
                    If ALine[XPOs] = '.' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                        ArrayPos, XPOs - 1, YPos, 0);
                    If ALine[XPOs] = '*' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                        ArrayPos, XPOs - 1, YPos, 1);
                    If ALine[XPOs] = '+' Then
                      Begin
                        CreateCrateTargetPart
                          (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                          ArrayPos, XPOs - 1, YPos, 2);
                        If HasPlayer Then
                          Begin
                            FPlayerPosX := XPOs - 1;
                            FPlayerPosY := YPos;
                          End;
                      End;
                  End;

                Inc(YPos);
              End
            Else
              Begin
                If MakeLevel(Levelset.FPuzzleFields[FPuzzleCount], NewLevel,
                  HasPlayer, FMaxX, FMaxY, FPlayerPosX, FPlayerPosY) Then
                  Begin
                    Inc(FPuzzleCount);
                  End;
                NewLevel := true;
              End;
          End;
        If MakeLevel(Levelset.FPuzzleFields[FPuzzleCount], NewLevel, HasPlayer,
          FMaxX, FMaxY, FPlayerPosX, FPlayerPosY) Then
          Begin
            Inc(FPuzzleCount);
            if Levelset.MaxHeight < FMaxY then
              Levelset.MaxHeight := FMaxY;
            if Levelset.MaxWidth < FMaxX then
              Levelset.MaxWidth := FMaxX;
          End;

        SetLength(Levelset.FPuzzleFields, FPuzzleCount);
      Except
{$IFDEF FPC}
        MessageDlg('Error', Format(SLevelSCouldnotbLoaded,
          [IntToStr(FPuzzleCount), ExtractFileName(AFileName)]), mtError,
          [mbOK], 0);
{$ELSE}
        MessageDlg(Format(SLevelSCouldnotbLoaded, [IntToStr(FPuzzleCount),
          ExtractFileName(AFileName)]), mtError, [mbOK], 0);
{$ENDIF}
      End;
    Finally
      CloseFile(AFile);
    End;
  End;

Procedure LoadRDF(AFileName: String; Var Levelset: TPuzzleCollectionData);
  Var
    AFile: TextFile;
    HasPlayer: boolean;
    XPOs, YPos, AXPos: smallint;
    FPuzzleCount, FMaxX, FMaxY, AStart: integer;
    ArrayPos: integer;
    ALine: String;
    NewLevel: boolean;

    FPlayerPosX: smallint;
    FPlayerPosY: smallint;

    // procedure CheckTransparency(AXPos, AYPos: smallint);

    // function AllowNextStep(ANextX, ANextY: smallint): boolean;
    // begin
    // Result := (CanAccess[ANextX, ANextY]) and
    // ((Levelset.FPuzzleFields[FPuzzleCount][ANextX, ANextY].FPartType =
    // ptEmpty) or (Levelset.FPuzzleFields[FPuzzleCount][ANextX,
    // ANextY].FPartType = ptCrate));
    // end;

    // begin
    // if Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType = ptEmpty then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptNone;
    // CanAccess[AXPos, AYPos] := False;

    // if AllowNextStep(AXPos, Pred(AYPos)) then
    // CheckTransparency(AXPos, Pred(AYPos));
    // if AllowNextStep(Succ(AXPos), AYPos) then
    // CheckTransparency(Succ(AXPos), AYPos);
    // if AllowNextStep(AXPos, Succ(AYPos)) then
    // CheckTransparency(AXPos, Succ(AYPos));
    // if AllowNextStep(Pred(AXPos), AYPos) then
    // CheckTransparency(Pred(AXPos), AYPos);
    // end;

    // procedure CreatePlayer(AXPos, AYPos: smallint; OnPos: boolean);
    // begin
    // if not HasPlayer then // Only one player is allowed
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptPlayer;
    // if OnPos then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType :=
    // stPlayerUpStore
    // else
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType := stPlayerUp;
    // FPlayerPosX := AXPos;
    // FPlayerPosY := AYPos;
    // HasPlayer := True;
    // end
    // else
    // raise Exception.Create('');
    // end;

    // procedure CreateCrateTargetPart(AXPos, AYPos, APart: smallint);
    // begin
    // case APart of
    // 0: Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptEmpty;
    // 1:
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptCrate;
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FCrateID := ArrayPos;
    // Inc(ArrayPos);
    // end;
    // 2: CreatePlayer(AXPos, AYPos, True);
    // end;

    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FIsCrateTarget := True;
    // end;

    Function IsValid(AString: String): boolean;
      Var
        I: integer;
      Begin
        Result := Not(AString = '');

        For I := 1 To Length(AString) Do
{$IFDEF FPC}
          If Not(AString[I] In ['#', '@', '$', '+', '*', '.', ' ']) Then
{$ELSE}
          If Not charinset(AString[I], ['#', '@', '$', '+', '*', '.', ' ']) Then
{$ENDIF}
            Begin
              Result := false;
              Break;
            End;
      End;

  // procedure MakeLevel;
  // var
  // XPos, YPos: integer;
  // begin
  // if NewLevel = False then
  // begin
  // LevelWidth := FMaxX;
  // LevelHeight := FMaxY;

  // SetLength(Levelset.FPuzzleFields[FPuzzleCount], LevelWidth, LevelHeight);
  // SetLength(CanAccess, LevelWidth, LevelHeight);

  // for XPos := 0 to High(CanAccess) do
  // begin
  // for YPos := 0 to High(CanAccess[0]) do
  // CanAccess[XPos, YPos] := True;
  // end;

  // if not HasPlayer then // skip this level
  // begin
  // NewLevel := True;
  // Exit;
  // end;

  // CheckTransparency(Levelset.FPuzzleFields[FPuzzleCount - 1],CanAccess,FPlayerPosX, FPlayerPosY);


  // for YPos := 0 to Pred(LevelHeight) do
  // for XPos := 0 to Pred(LevelWidth) do
  // begin
  // if Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos].FPartType =
  // ptWall then
  // begin
  // i := 0;
  // if YPos <> 0 then
  // if (Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos - 1].FPartType =
  // ptWall) then
  // i := i + 10;

  // if XPos <> 0 then
  // if (Levelset.FPuzzleFields[FPuzzleCount][XPos - 1, YPos].FPartType =
  // ptWall) then
  // i := i + 13;

  // if YPos <> Pred(LevelHeight) then
  // if (Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos + 1].FPartType =
  // ptWall) then
  // i := i + 12;

  // if XPos <> Pred(LevelWidth) then
  // if (Levelset.FPuzzleFields[FPuzzleCount][XPos + 1, YPos].FPartType =
  // ptWall) then
  // i := i + 14;

  // with Levelset do
  // case i of
  // 00: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWall;
  // 10: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUp;
  // 12: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallDown;
  // 13: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallLeft;
  // 14: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallRight;
  // 22: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpDown;
  // 23: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpLeft;
  // 24: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpRight;
  // 25: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallDownLeft;
  // 26: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallDownRight;
  // 27: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallLeftRight;
  // 35: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpDownLeft;
  // 36: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpDownRight;
  // 37: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpLeftRight;
  // 39: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallDownLeftRight;
  // 49: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
  // stWallUpDownLeftRight;
  // end;
  // end;
  // end;
  // Inc(FPuzzleCount);
  // frmSokoban.LevelCB.ItemsEx.AddItem('Level ' + IntToStr(FPuzzleCount) +
  // '   -   ' + ExtractFileNameS(AFileName), -1, -1, -1, 0, nil);
  // end;
  // end;

  Begin
    SetLength(Levelset.FPuzzleFields, 0);
    YPos := 0;

    AssignFile(AFile, AFileName);
    Try
      Try
        Reset(AFile);

        With Levelset Do
          Begin
            Title := ExtractFileNameS(AFileName);
            Description := '';
            Email := '';
            Copyright := 'NA';
          End;

        SetLength(Levelset.FPuzzleFields, 1000); // 1000 is max

        FPuzzleCount := 0;
        NewLevel := true;
        While Not EOF(AFile) Do
          Begin
            Readln(AFile, ALine);
            If Pos('Room_', ALine) = 1 Then
              Begin
                If NewLevel = true Then
                  Begin
                    NewLevel := false;
                    FMaxX := 0;
                    FMaxY := 0;

                    SetLength(Levelset.FPuzzleFields[FPuzzleCount], 100, 100);

                    For YPos := 0 To 99 Do
                      For XPOs := 0 To 99 Do
                        Begin
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FPartType := ptEmpty;
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FIsCrateTarget := false;
                          Levelset.FPuzzleFields[FPuzzleCount][XPOs, YPos]
                            .FCrateID := -1;
                        End;

                    YPos := 0;
                    ArrayPos := 0;

                    HasPlayer := false;
                  End;

                AStart := Pos('"', ALine);

                FPlayerPosY := StrToInt('$' + Copy(ALine, AStart + 1, 2)) - 1;
                FPlayerPosX := StrToInt('$' + Copy(ALine, AStart + 3, 2)) - 1;

                AXPos := 1;
                FMaxX := 0;
                FMaxY := 1;
                For XPOs := AStart + 5 To Length(ALine) - 1 Do
                  Begin
                    If ALine[XPOs] = '2' Then
                      Levelset.FPuzzleFields[FPuzzleCount][AXPos - 1, YPos]
                        .FPartType := ptWall;

                    If ALine[XPOs] = '3' Then
                      Begin
                        Levelset.FPuzzleFields[FPuzzleCount][AXPos - 1, YPos]
                          .FPartType := ptCrate;
                        Levelset.FPuzzleFields[FPuzzleCount][AXPos - 1, YPos]
                          .FCrateID := ArrayPos;

                        Inc(ArrayPos);
                      End;
                    If ALine[XPOs] = '0' Then
                      Levelset.FPuzzleFields[FPuzzleCount][AXPos - 1, YPos]
                        .FPartType := ptEmpty;
                    If ALine[XPOs] = '1' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                        ArrayPos, AXPos - 1, YPos, 0);
                    If ALine[XPOs] = '4' Then
                      CreateCrateTargetPart
                        (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                        ArrayPos, AXPos - 1, YPos, 1);

                    If (FPlayerPosY = YPos) And (FPlayerPosX = AXPos - 1) Then
                      If ALine[XPOs] = '.' Then
                        CreateCrateTargetPart
                          (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                          ArrayPos, FPlayerPosX, FPlayerPosY, 2)
                      Else
                        HasPlayer :=
                          CreatePlayer(Levelset.FPuzzleFields[FPuzzleCount],
                          HasPlayer, FPlayerPosX, FPlayerPosY, false);

                    If ALine[XPOs] = 'f' Then
                      Begin
                        Inc(YPos);
                        Inc(FMaxY);
                        If FMaxX < AXPos Then
                          FMaxX := AXPos - 1;

                        AXPos := 0;
                      End;

                    Inc(AXPos);
                  End;

                If MakeLevel(Levelset.FPuzzleFields[FPuzzleCount], NewLevel,
                  HasPlayer, FMaxX, FMaxY, FPlayerPosX, FPlayerPosY) Then
                  Begin
                    Inc(FPuzzleCount);
                    if Levelset.MaxHeight < FMaxY then
                      Levelset.MaxHeight := FMaxY;
                    if Levelset.MaxWidth < FMaxX then
                      Levelset.MaxWidth := FMaxX;
                  End;
                NewLevel := true;
              End;
          End;

        SetLength(Levelset.FPuzzleFields, FPuzzleCount);
      Except
{$IFDEF FPC}
        MessageDlg('Error', Format(SLevelSCouldnotbLoaded,
          [IntToStr(FPuzzleCount), ExtractFileName(AFileName)]), mtError,
          [mbOK], 0);
{$ELSE}
        MessageDlg(Format(SLevelSCouldnotbLoaded,
          [IntToStr(FPuzzleCount), ExtractFileName(AFileName)]), mtError,
          [mbOK], 0);
{$ENDIF}
      End;
    Finally
      CloseFile(AFile);
    End;
  End;

Procedure LoadLP0(AFileName: String; Var Levelset: TPuzzleCollectionData);
  Var
    f: File Of byte;
    I, kollevel, ttt, Pos, t1, t2, t3, t4, k, t, size, J, FPuzzleCount,
      ArrayPos: integer;
    HasPlayer: boolean;
    c, tt, leveltype, dx, dy, xx, yy: byte;
    ch: char;
    Name, comment, author: Array [0 .. 255] Of char;
    buf: Array [0 .. 10000] Of char;
    FPlayerPosX: smallint;
    FPlayerPosY: smallint;
    NewLevel: boolean;

    // procedure CheckTransparency(AXPos, AYPos: smallint);

    // function AllowNextStep(ANextX, ANextY: smallint): boolean;
    // begin
    // Result := (CanAccess[ANextX, ANextY]) and
    // ((Levelset.FPuzzleFields[FPuzzleCount][ANextX, ANextY].FPartType =
    // ptEmpty) or (Levelset.FPuzzleFields[FPuzzleCount][ANextX,
    // ANextY].FPartType = ptCrate));
    // end;

    // begin
    // if Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType = ptEmpty then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptNone;
    // CanAccess[AXPos, AYPos] := False;

    // if AllowNextStep(AXPos, Pred(AYPos)) then
    // CheckTransparency(AXPos, Pred(AYPos));
    // if AllowNextStep(Succ(AXPos), AYPos) then
    // CheckTransparency(Succ(AXPos), AYPos);
    // if AllowNextStep(AXPos, Succ(AYPos)) then
    // CheckTransparency(AXPos, Succ(AYPos));
    // if AllowNextStep(Pred(AXPos), AYPos) then
    // CheckTransparency(Pred(AXPos), AYPos);
    // end;

    // procedure CreatePlayer(AXPos, AYPos: smallint; OnPos: boolean);
    // begin
    // if not HasPlayer then // Only one player allowed
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptPlayer;
    // if OnPos then
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType :=
    // stPlayerUpStore
    // else
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FSkinType := stPlayerUp;
    // FPlayerPosX := AXPos;
    // FPlayerPosY := AYPos;
    // HasPlayer := True;
    // end
    // else
    // raise Exception.Create('');
    // end;

    // procedure CreateCrateTargetPart(AXPos, AYPos, APart: smallint);
    // begin
    // case APart of
    // 0: Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptEmpty;
    // 1:
    // begin
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FPartType := ptCrate;
    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FCrateID := ArrayPos;

    // Inc(ArrayPos);
    // end;
    // 2: CreatePlayer(AXPos, AYPos, True);
    // end;

    // Levelset.FPuzzleFields[FPuzzleCount][AXPos, AYPos].FIsCrateTarget := True;
    // end;

    // procedure MakeLevel;
    // var
    // XPos, YPos: integer;

    // begin
    // SetLength(CanAccess, dx, dy);

    // for XPos := 0 to High(CanAccess) do
    // begin
    // for YPos := 0 to High(CanAccess[0]) do
    // CanAccess[XPos, YPos] := True;
    // end;

    // if not HasPlayer then // skip this level
    // Exit;

    // CheckTransparency(Levelset.FPuzzleFields[FPuzzleCount - 1], CanAccess, FPlayerPosX,
    // FPlayerPosY);

    // for YPos := 0 to Pred(dy) do
    // for XPos := 0 to Pred(dx) do
    // begin
    // if Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos].FPartType =
    // ptWall then
    // begin
    // i := 0;
    // if YPos <> 0 then
    // if (Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos - 1].FPartType =
    // ptWall) then
    // i := i + 10;

    // if XPos <> 0 then
    // if (Levelset.FPuzzleFields[FPuzzleCount][XPos - 1, YPos].FPartType =
    // ptWall) then
    // i := i + 13;

    // if YPos <> Pred(dy) then
    // if (Levelset.FPuzzleFields[FPuzzleCount][XPos, YPos + 1].FPartType =
    // ptWall) then
    // i := i + 12;

    // if XPos <> Pred(dx) then
    // if (Levelset.FPuzzleFields[FPuzzleCount][XPos + 1, YPos].FPartType =
    // ptWall) then
    // i := i + 14;

    // with Levelset do
    // case i of
    // 00: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWall;
    // 10: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUp;
    // 12: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallDown;
    // 13: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallLeft;
    // 14: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallRight;
    // 22: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpDown;
    // 23: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpLeft;
    // 24: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpRight;
    // 25: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallDownLeft;
    // 26: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallDownRight;
    // 27: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallLeftRight;
    // 35: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpDownLeft;
    // 36: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpDownRight;
    // 37: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpLeftRight;
    // 39: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallDownLeftRight;
    // 49: FPuzzleFields[FPuzzleCount][XPos, YPos].FSkinType :=
    // stWallUpDownLeftRight;
    // end;
    // end;
    // end;
    // Inc(FPuzzleCount);
    // frmSokoban.LevelCB.ItemsEx.AddItem('Level ' + IntToStr(FPuzzleCount) +
    // '   -   ' + ExtractFileNameS(AFileName), -1, -1, -1, 0, nil);
    // end;

  Begin
    SetLength(Levelset.FPuzzleFields, 0);
    c := 0;
    I := 0;

    AssignFile(f, AFileName);
    Try
      Reset(f);
      BlockRead(f, buf{%H-}, 17, I);
      // 'Soko level pack [some number]' - a header
      BlockRead(f, kollevel{%H-}, 4, I); // number of levels
      BlockRead(f, ttt{%H-}, 4, I);      // info position
      BlockRead(f, Pos{%H-}, 4, I);      // level position

      If ttt <> 0 Then // if there are no credits
        Begin

          Seek(f, ttt); // to the info

          BlockRead(f, t1{%H-}, 4, I); // length name
          BlockRead(f, t2{%H-}, 4, I); // length e-mail
          BlockRead(f, t3{%H-}, 4, I); // length copyright
          BlockRead(f, t4{%H-}, 4, I); // length comments
          BlockRead(f, buf, t1, I);
          buf[t1] := #0;
          Levelset.Title := String(buf);
          BlockRead(f, buf, t2, I);
          buf[t2] := #0;
          Levelset.Email := String(buf);
          BlockRead(f, buf, t3, I);
          buf[t3] := #0;
          Levelset.Copyright := String(buf);
          BlockRead(f, buf, t4, I);
          buf[t4] := #0;
          Levelset.Description := String(buf);

        End;
      Seek(f, Pos); // go to the begin of the level

      SetLength(Levelset.FPuzzleFields, kollevel);

      FPuzzleCount := 0;

      For k := 1 To kollevel Do
        Begin
          BlockRead(f, buf, 16, I); // Soko level file [some number]
          BlockRead(f, leveltype{%H-}, 1, I);
          // level type, 1 is true sokoban
          BlockRead(f, tt{%H-}, 1, I);
          BlockRead(f, buf, 4, I);
          BlockRead(f, dx{%H-}, 1, I); // length level
          BlockRead(f, dy{%H-}, 1, I); // height level
          BlockRead(f, xx{%H-}, 1, I); // player x
          BlockRead(f, yy{%H-}, 1, I); // player y

          SetLength(Levelset.FPuzzleFields[FPuzzleCount], dx, dy);

          If tt <> $10 Then
            Begin
              BlockRead(f, t{%H-}, 4, I);
              If (tt <> $12) And (t = 0) Then
              Else
                Begin
                  BlockRead(f, Name{%H-}, t, I);
                  Name[t] := #0;
                  BlockRead(f, t, 4, I);
                  If (tt <> $12) And (t = 0) Then
                  Else
                    Begin
                      BlockRead(f, comment{%H-}, t, I);
                      comment[t] := #0;
                      BlockRead(f, t, 4, I);
                      If (tt <> $12) And (t = 0) Then
                      Else
                        Begin
                          BlockRead(f, author{%H-}, t, I);
                          author[t] := #0;
                          BlockRead(f, t, 4, I);
                        End;
                    End;
                End;
            End
          Else
            Begin
              Name[0] := #0;
              comment[0] := #0;
              author[0] := #0;
            End;

          size := dx * dy; // level size

          If leveltype = 1 Then
            Begin
              ArrayPos := 0;

              HasPlayer := false;

              For I := 0 To dy - 1 Do
                For J := 0 To dx - 1 Do
                  Begin
                    BlockRead(f, c{%H-}, 1);
                    ch := ' ';
                    With Levelset Do
                      Case c Of
                        $0:
                          FPuzzleFields[FPuzzleCount][J, I].FPartType
                            := ptEmpty;
                        $1:
                          FPuzzleFields[FPuzzleCount][J, I].FPartType := ptWall;
                        $11:
                          CreateCrateTargetPart
                            (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                            ArrayPos, J, I, 0);
                        $0C:
                          Begin
                            FPuzzleFields[FPuzzleCount][J, I].FPartType
                              := ptCrate;
                            FPuzzleFields[FPuzzleCount][J, I].FCrateID
                              := ArrayPos;

                            Inc(ArrayPos);
                          End;
                        $12:
                          CreateCrateTargetPart
                            (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                            ArrayPos, J, I, 1);
                      End;

                    If (I = yy) And (J = xx) Then
                      Case ch Of
                        ' ':
                          CreatePlayer(Levelset.FPuzzleFields[FPuzzleCount],
                            HasPlayer, J, I, false);
                        '.':
                          CreateCrateTargetPart
                            (Levelset.FPuzzleFields[FPuzzleCount], HasPlayer,
                            ArrayPos, J, I, 2);
                      End;
                    If HasPlayer Then
                      Begin
                        FPlayerPosX := J;
                        FPlayerPosY := I;
                      End;
                  End;

              NewLevel := false;
              If MakeLevel(Levelset.FPuzzleFields[FPuzzleCount], NewLevel,
                HasPlayer, dx, dy, FPlayerPosX, FPlayerPosY) Then
                Begin
                  Inc(FPuzzleCount);
                  if Levelset.MaxHeight < dy then
                    Levelset.MaxHeight := dy;
                  if Levelset.MaxWidth < dx then
                    Levelset.MaxWidth := dx;
               End;
            End
          Else
            BlockRead(f, buf, size, I); // read through the whole level
        End;
      SetLength(Levelset.FPuzzleFields, FPuzzleCount);

    Finally
      CloseFile(f);
    End;
  End;

{$IFDEF FPC}
{ TXMNodeHelper }

Function TXMNodeHelper.GetNamedAttributes(ANodeName: String): DOMString;

  Var
    aa: TDOMNamedNodeMap;
  Begin
    aa := getattributes;
    If assigned(aa) Then
      Result := aa.GetNamedItem(ANodeName).GetText;
  End;

Function TXMNodeHelper.GetText: DOMString;
  Begin
    If assigned(self) Then
      Result := TextContent
    Else
      Result := '';
  End;

Procedure TXMNodeHelper.SetText(AValue: DOMString);
  Begin
    SetTextContent(AValue);
  End;

Procedure TXMNodeHelper.Addchild(AChildName: String);
  Begin
    AppendChild(TDOMElement.Create(OwnerDocument));
  End;

Procedure TXMNodeHelper.SetAttributeNS(AAttrName, NS, AValue: String);
  Begin

  End;

{ TXMLHelper }

Function TXMLHelper.getActive: boolean;
  Begin
    Result := true;
  End;

Function TXMLHelper.FindNode(Aindex: integer): TDOMNode;
  Begin
    Result := getItem(Aindex);
  End;

Procedure TXMLHelper.setActive(AValue: boolean);
  Begin
    If AValue Then;
  End;

Procedure TXMLHelper.SetNodes(ANodeName: String; AValue: TDOMNode);
  Begin

  End;

Function TXMLHelper.FindNode(ANodeName: String): TDOMNode;
  Var
    I: integer;
  Begin
    Result := Nil;
    For I := 0 To Count - 1 Do
      If item[I].NodeName = ANodeName Then
        Begin
          Result := item[I];
          Break;
        End;
  End;
{$ENDIF}

End.
