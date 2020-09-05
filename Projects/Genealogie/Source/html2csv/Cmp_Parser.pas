unit Cmp_Parser;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses classes;

type
  TBaseParser = Class(TObject)
  protected
    LineNo, Offset: Int64;
    FData: String;
  public
    constructor Init;
    destructor Done; virtual;
    procedure Feed(Data: string); virtual; abstract;
    procedure Error(sender: TObject; NewMessage: string); virtual; abstract;
    procedure Warning(sender: TObject; NewMessage: string); virtual; abstract;
    procedure reset;
    procedure GetPos(out ActLineNo, ActOffset: Int64);

  End;

  THTMLParseMode = (StandardText = 0, TagDesc = 1, TagModifyer = 2,
    Comment = 3, Script = 4);
  TTextNotification = Procedure(sender: TObject; Text: String) of Object;

  { ThtmlParser }

  ThtmlParser = Class(TBaseParser)
  Private
    FOnStdText, FOnStartTag, FOnTagMod, FOnEndTag, FOnComment,
      FOnScript: TTextNotification;
//    Taglevel: integer;
  protected
    FparseMode: THTMLParseMode;
  public
    procedure Feed(Data: string); override;
    procedure Error({%H-}sender: TObject; NewMessage: string); override;
    procedure Warning(sender: TObject; {%H-}NewMessage: string); override;
    Property OnStdText: TTextNotification read FOnStdText write FOnStdText;
    Property OnStartTag: TTextNotification read FOnStartTag write FOnStartTag;
    Property OnTagMod: TTextNotification read FOnTagMod write FOnTagMod;
    Property OnEndTag: TTextNotification read FOnEndTag write FOnEndTag;
    Property OnComment: TTextNotification read FOnComment write FOnComment;
    Property OnScript: TTextNotification read FOnScript write FOnScript;
  End;

 Function HTML2text(s: string): String;

implementation

uses sysutils;

Function HTML2text(s: string): String;
begin
  s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&gt;','>',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&lt;','<',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&Auml;','Ä',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&auml;','ä',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&Ouml;','Ö',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&ouml;','ö',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&Uuml;','Ü',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&uuml;','ü',[rfReplaceAll,rfIgnoreCase]);
  s:=StringReplace(s,'&nbsp;',' ',[rfReplaceAll,rfIgnoreCase]); // &nbsp;
  result := s;
end;

procedure TBaseParser.GetPos(out ActLineNo, ActOffset: Int64);
begin
  ActLineNo := LineNo;
  ActOffset := Offset;
end;

constructor TBaseParser.Init;
begin
  if self.ClassType = TBaseParser then
    // raise Texception.Create('BaseParser must not used directly');
  end;

  procedure TBaseParser.reset;
  begin
    LineNo := 1;
    Offset := 0;
    FData := '';
  end;

  destructor TBaseParser.Done;
  begin
    // Destructor ParserBase
  end;

  procedure ThtmlParser.Feed(Data: string);

  var
    LenFData: Int64;
    pp, ePos, tde, ps: Int64;
    TagTyp, Tagmod: string;

  begin
    FData := FData + Data;
    LenFData := length(FData);
    pp := 1;
    ePos := 1;
    tde:= -1;
    While pp < length(FData) Do
    Begin
      case FparseMode of
        StandardText: // Text ausserhalb von Tags
          begin
            ePos := pp + pos('<', copy(FData, pp, LenFData));
            if ePos = pp then
              ePos := LenFData + 1;
            if Assigned(FOnStdText) and (trim(copy(FData, pp, ePos - pp - 1))
                <> '') then
              FOnStdText(self, HTML2text(copy(FData, pp, ePos - pp - 1)));
            pp := ePos - 1;
            FparseMode := TagDesc;
          end;
        TagDesc:
          Begin
            // pp zeigt auf '<'
            // Mgliche Descende: ' ' oder '>'
            if copy(FData, pp + 1, 2) = '!-' then
            begin
              FparseMode := Comment;
              pp := pp + 3;
              continue;
            end;
            // Normal Tag
            ePos := pp + pos('>', copy(FData, pp, LenFData));

            if ePos > pp then
            begin
              tde := pp + pos(' ', copy(FData, pp, ePos - pp - 1));
              if tde = pp then
                tde := ePos - 2
              else
                tde := tde - 2;
            end
            else
            begin
              FData := copy(FData, pp, LenFData - pp);
              break;
              // vorzeitiges Ende
            end;

            TagTyp := copy(FData, pp + 1, tde - pp);
            if copy(TagTyp, 1, 1) = '/' then
            begin
              // End-Tag
              if Assigned(FOnEndTag) then
                FOnEndTag(self, copy(TagTyp, 2, length(TagTyp)));
            end
            else if copy(TagTyp, length(TagTyp), 1) <> '/' then
            begin
              // Start-Tag
              if Assigned(FOnStartTag) then
                FOnStartTag(self, TagTyp);
            end
            else
            begin
              // Unary Tag
              if Assigned(FOnStartTag) then
                FOnStartTag(self, copy(TagTyp, 1, length(TagTyp) - 1));
              if Assigned(FOnEndTag) then
                FOnEndTag(self, '');
            end;
            pp := tde + 2;
            if copy(FData, pp - 1, 1) = '>' then
              FparseMode := StandardText
            else
              FparseMode := TagModifyer;

          End;
        TagModifyer:
          begin
            tde := pp;
            if ePos > pp then
            begin
              tde := pp + pos(' ', copy(FData, pp, ePos - pp - 1));
              if tde = pp then
                tde := ePos - 2
              else
                tde := tde - 2;
            end
            else
              // ???
              ;
            Tagmod := copy(FData, pp, tde - pp + 1);
            if pos('="', Tagmod) <> 0 then
            begin
              tde := pp + pos('" ', copy(FData, pp, ePos - pp - 1));
              if tde = pp then
                tde := ePos - 2
              else
                tde := tde - 1;
              Tagmod := copy(FData, pp, tde - pp + 1);
            end;
            if pos('=''', Tagmod) <> 0 then
            begin
              tde := pp + pos(''' ', copy(FData, pp, ePos - pp - 1));
              if tde = pp then
                tde := ePos - 2
              else
                tde := tde - 1;
              Tagmod := copy(FData, pp, tde - pp + 1);
            end;
            if (Tagmod = '/') and (copy(FData, tde + 1, 1) = '>') then
            begin
              if Assigned(FOnEndTag) then
                FOnEndTag(self, '');
            end
            else if Assigned(FOnTagMod) then
              FOnTagMod(self, Tagmod);
            pp := tde + 2;
            if copy(FData, pp - 1, 1) = '>' then
            begin
              FparseMode := StandardText;
              if uppercase(TagTyp) = 'SCRIPT' then
                FparseMode := Script;
            end;
          end;
        Comment:
          begin
            ePos := pp + pos('->', copy(FData, pp, LenFData));
            if ePos = pp then
            begin
              FData := copy(FData, pp, LenFData - pp);
              break;
              // vorzeitiges Ende
            end;
            if Assigned(FOnComment) then
              FOnComment(self, copy(FData, pp, ePos - pp - 1));
            pp := ePos + 1;
            FparseMode := StandardText;
          end;
        Script:
          begin
            ps := pp;
            ePos := pp;
            repeat
              pp := ePos;
              ePos := pp + pos('</', copy(FData, pp, LenFData - pp));
            until (uppercase(copy(FData, ePos + 1, 6)) = 'SCRIPT') or
              (pp = ePos);
            if ePos = pp then
            begin
              FData := copy(FData, ps, LenFData - ps);
              break;
              // vorzeitiges Ende
            end;
            if Assigned(FOnScript) and (trim(copy(FData, ps, ePos - ps - 1))
                <> '') then
              FOnScript(self, copy(FData, ps, ePos - ps - 1));
            pp := ePos - 1;
            FparseMode := TagDesc;
          end;
      else
      end; { Case }
      {
        If eDivPos > divPos Then
        Else
        Begin // \DIV
        flag := false;
        For I := 0 To High(tokens) Do
        If copy(Dtyp, pos('=', Dtyp) + 1, length(Dtyp)) = tokens[I] Then
        flag := true;
        If flag Or ( High(tokens) = -1) Then
        Begin
        parseDiv(copy(Source, PP, eDivPos - PP), copy
        (Dtyp, pos('=', Dtyp) + 1, length(Dtyp)), dest);
        End;
        dec(TagLevel);
        PP := eDivPos + 4;
        End;
        divPos := PP + pos('<div', copy(Source, PP, length(Source)));
        eDivPos := PP + pos('</div', copy(Source, PP, length(Source)));
        If (divPos = eDivPos) Or (divPos = PP) Then PP := length(Source); }
    end; { while }
  end; { procedure }

  procedure ThtmlParser.Error(sender: TObject; NewMessage: string);
  var
    e: Exception;
  begin
    e:=Exception.Create(NewMessage);
    Raise(e);
  end;

  procedure ThtmlParser.Warning(sender: TObject; NewMessage: string);
  begin
    // Todo:
  end;

end.
