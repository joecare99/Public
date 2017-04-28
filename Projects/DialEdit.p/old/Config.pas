program config; {general-purpose configuration method}

{
	Change the configuration of the target file named as a parameter
	to the configuration specified by option parameters; the amount
	of data copied is the shorter of the source and target lengths.
	A temporary copy (named FName+'.ex$') of the target is used.
}

const
	CopyNote = 'CONFIG  (c) 2-12-92 J. M. Clark';
	MagLen	= 10;	{length of 'magic' string}

type
	tConfig = record
		Magic: string[MagLen];	{special signature}
		Data:  string[50];		{options}
	end;

const
	vConfig: tConfig = (
		Magic:	'!)@(#*$&%^';	{special signature}
		{used for self-test:}
		Data:	'//////////////////////////////////////////////////'
	);

{------------------ buffer description: ----------------------------}
const
	BlockSz = 30*1024;		{preferred size for BlockRead/Write}
	BufStart= -MagLen-1;	{extra buffer space prefixing the block}
	BufEnd	= BlockSz-1;	{max end of buffer data}

type
	tByteArray = array[BufStart..BufEnd] of byte;

var
	Bufr: tByteArray;		{workspace buffer}
	NumRead,				{# of bytes read into buffer}
	NumWritten: 			{# of bytes written from buffer}
		integer;

{	.-----------.-----------------------------------------------.	}
{	|	prefix	|	read/write area; max length = BlockSz		|	}
{	`-----------'-----------------------------------------------'	}
{	 ^			 ^												 ^	}
{	BufStart	 0								   NumRead<=BlockSz }

{	For search continuation, the last MagLen bytes of read/write	}
{	area are copied to BufStart+1..-1 (prefix).  Bufr[BufStart] is	}
{	used for a string-length byte.	The earliest search position	}
{	is (lengths shown inside fields; "1" are string length bytes):	}

{	.-- prefix --.													}
{	.---.--------.---.------------------.							}
{	| 1 | MagLen | 1 |		TargetLen	|							}
{	`---'--------'---'------------------'							}
{	  ^ 		   ^												}
{	  b=BufStart   p=0												}

{	The latest search position is:									}

{	------- read/write area -------------.							}
{						.---.--------.---.------------------.		}
{						| 1 | MagLen | 1 |		TargetLen	|		}
{						`---'--------'---'------------------'		}
{						  ^ 		   ^							}
{		 NumRead-MagLen-2=e 		   p=NumRead-1					}

{	b= first, e= last, search position to try; p= target position	}

{-------------------------------------------------------------------}

	ParStr: string[255];	{parameter string}
	Data: string[255];		{source configuration data}
	FName: string[79];		{file name of target}
	SaveBackup: boolean;	{save backup file}
						{lengths of configuration data:}
	SourceLen: byte;		{of source, excluding padding}
	TargetLen: byte;		{of target, including padding}
	InFile, OutFile: file;	{old, new target file}
					{processing state:}
	State: (Searching,	{looking for magic string in target}
			Changing,	{found it, not done changing configuration}
			Copying);	{done changing, copying the rest as is}
	Found: boolean; 	{found magic string (pos'n of target config)}
	Changed: boolean;	{configuration change done}
	b, e, p: integer;	{used to search the buffer}
	Part1: integer; 	{part of TargetLen bytes first in buffer}

{Search from position b to position e; i.e., position of length-byte}
{of magic string.  Set p = position of length-byte of target config }
{data, else p = -1 if not found.  Outside this procedure, b .. e is }
{the search range over the buffer.	Inside, sb .. se is used for	}
{the search range over string-sized (<=255 bytes) buffer portions.	}

procedure Search(b, e: integer);
var
	sb, se, sp: integer;
	ssp: ^string;
	tmp: byte;
begin
	p:= -1; 	{default}
	if b > e then exit;
	sb:= b;
	repeat
		p:= -1; 	{default, indicates not found}
		se:= sb+255 - MagLen;	{max string search end}
		if se > e then se:= e;
		if sb > se then exit;	{can't find it}

		tmp:= Bufr[sb]; 	{save byte at sb}
		{define buffer portion as string:}
		Bufr[sb]:= se+MagLen - sb;
		ssp:= @Bufr[sb];
		{search for magic:}
		sp:= Pos(vConfig.Magic, ssp^);
		{convert string index sp of magic position}
		{ to buffer index p of target position:}
		p:= sb + sp + MagLen;
		Bufr[sb]:= tmp; 	{restore byte at sb}
		sb:= se+1;		{start of next try, if needed}
	until sp > 0;	{until found}
end;

var
	ChrPos: integer;

begin
	if ParamCount < 2 then begin
		writeln(CopyNote);
		writeln('Reconfigures a target program with given options.');
		writeln('Usage:   config TargetPath Options [ +s ]');
		writeln('Example: config c:\bin\target /c+/b-/a12/xname');
		writeln('The parameters may be in any order.');
		writeln('TargetPath is the program filename minus the final ''.exe''.');
		writeln('Options is one parameter beginning with ''/''.');
		writeln('Use ''+s'' to retain the backup (.ex$) file.');
		writeln('Messages report reconfiguration success or failure.');
		writeln('Run the target program with option ''/?''');
		writeln('to check that the options are appropriate.');

		{show test data, if any:}
		ChrPos:= Pos('//', vConfig.Data) - 1;
		if ChrPos < 0 then begin
			ChrPos:= Length(vConfig.Data);
			if vConfig.Data[ChrPos] = '/' then dec(ChrPos);
		end;
		if ChrPos > 0 then begin
			writeln;
			writeln('Test data =');
			writeln(Copy(vConfig.Data, 1, ChrPos));
		end;
		halt;
	end;

	SaveBackup:= false;
	Data:= '';
	for p:= 1 to ParamCount do begin
		ParStr:= ParamStr(p);
		if ParStr[1] = '/' then begin
			Data:= Data + ParStr;
		end else if ParStr = '+s' then begin
			SaveBackup:= true;
		end else begin
			FName:= ParStr;
		end;
	end;
	SourceLen:= Length(Data);
	if SourceLen < 255 then begin
		FillChar(Data[SourceLen+1], 255-SourceLen, '/');
		Data[0]:= #255;
	end;

	Assign(InFile, FName+'.ex$');
	{$I-} Erase(InFile); {$I+}
	p:= IOresult;
	Assign(InFile, FName+'.exe');
	{$I-} Rename(InFile, FName+'.ex$'); {$I+}
	if IOresult <> 0 then begin
		writeln('Cannot find target file "', FName, '.exe".');
		Halt;
	end;
	Assign(OutFile, FName+'.exe');
	reset(InFile, 1);
	rewrite(OutFile, 1);

	State:= Searching;
	Found:= false;
	Changed:= false;
	b:= -1; 	{prefix not available at first}
	repeat
		BlockRead(InFile, Bufr[0], BlockSz, NumRead);	{read a block}

		case State of
		  Searching: begin
			e:= NumRead-MagLen-2;

			Search(b, e);	{search from b to e, and set p}

			if p >= 0 then begin	{found at p}
				Found:= true;
				TargetLen:= Bufr[p];

				if TargetLen < SourceLen	{insufficient room for data}
				then State:= Copying		{give up}
				else begin
					Part1:= NumRead-1 - p;
					if Part1 >= TargetLen
					then begin				{target all in buffer}
						{Part1:= TargetLen; not needed}
						{copy all of data into buffer:}
						Move(Data[1], Bufr[p+1], TargetLen);
						Changed:= true;
						State:= Copying;	{done}
					end else begin			{do part 1 of target}
						{copy part 1 of data into buffer:}
						Move(Data[1], Bufr[p+1], Part1);
						State:= Changing;	{do part 2 next}
					end;
				end;

			end else begin			{p < 0; not found (yet)}
				if NumRead <= MagLen then begin {insufficient room for magic}
					State:= Copying;			{give up}
				end else begin
					{copy last MagLen bytes into prefix:}
					Move(Bufr[NumRead-MagLen], Bufr[BufStart+1], MagLen);
					b:= BufStart;
					State:= Searching;			{keep looking}
				end;
			end; {if p}
		  end; {Searching}

		  Changing: begin
			{copy part 2 of data into buffer:}
			Move(Data[Part1+1], Bufr[0], TargetLen-Part1);
			Changed:= true;
			State:= Copying;
		  end; {Changing}

		  {else Copying; i.e., just copying}
		end; {case}

		BlockWrite(OutFile, Bufr[0], NumRead, NumWritten);	{write block}
	until (NumRead = 0) or (NumWritten <> NumRead);

	close(OutFile);
	close(InFile);

	if not Found
	then writeln('Could not locate target data.')

	else if TargetLen < SourceLen
	then writeln('Source data is too long for target.')

	else if not Changed
	then writeln('Could not change target.')

	else if NumWritten <> NumRead
	then writeln('Could not finish rewriting target.')

	else begin
		if not SaveBackup then erase(InFile);
		writeln('Reconfiguration completed.');
		writeln('Run the target program with option ''/?''');
		writeln('to check that the options are appropriate.');
		halt;
	end;	{else reconfiguration failed}

	{restore original target file from backup:}
	if SaveBackup then begin
		writeln('Original target is now named ', FName+'.ex$');
		writeln('New (bad?) target is now named ', FName+'.exe');
		writeln('Try: fc /b '+FName+'.ex$ '+FName+'.exe');
	end else begin
		erase(OutFile);
		rename(InFile, FName+'.exe');
		writeln('Original target file is unchanged.');
	end;
end.
