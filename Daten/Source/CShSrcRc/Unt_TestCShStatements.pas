unit Unt_TestCShStatements;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
   cEmpty = '';
   cSemiColon = ';';
   cDoubleSemiColon = ';;';
   // Assignment
   cAssign = 'a=1;';
   cAssignAdd = 'a+=1;';
   cAssignMinus = 'a-=1;';
   cAssignMul = 'a*=1;';
   cAssignDiv = 'a/=1;';
   cAssignMod = 'a%=1;';
   cAssignAnd = 'a&=1;';
   cAssignOr = 'a|=1;';
   cAssignXor = 'a^=1;';
   cAssignAsk = 'a??=1;';
   cAssignShr = 'a>>=1;';
   cAssignShl = 'a<<=1;';

var
   cEmptyblock,
    cDoubleEmptyBlock ,
    cCommentBlock,
    cCommentBlock2,
    cErrDblAssignoSK,
    cCall1,
    cCall2,
    cQualifiedCall,
    cQualifiedCall2,
    cCallArg,
    cCallArg2,
    cIfa,
    cIfaBlock,
    cIfaAssign,
    cIfaSKelseSK,
    cIfaBlockElseSK,
    cIfaBlockElseBlock,
    cBlockIfaCallElseSK,
    cIfaForWriteElseForWite,
    cIfaThrowElseForWrite,
    cIfaUsingElseForWrite,
    cWhileIfWhileElseCall,
    cWhileIfWhileBlockElseCall,
    cIfIfBlockElseBlock,
    cIfIfBlockElseBlockElseBlock,
    cIfIfCallElseElseCall,
    cIfIfBlockElseElseBlock,
    cErrIfElsenoSK,
    cErrIfNoSK,
    cErrIfSKElseNoSK,
    cErrIfIfSKElseElseSK,
    cErrIfBlockSKElseBlock,
    cWhileSK,
    cWhileBlock,
    cWhileCall,
    cWhileWhileBlock,
    cDoWhile,
    cDoBlockWhile,
    cDoCallWhile,
    cDoDoBlockWhileWhile,
    cDoWhileBlockWhile,
    cDummy:Array of string;
implementation

initialization
// Blocks
   cEmptyblock := ['{', '}'];
   cDoubleEmptyBlock := ['{', '}', '{', '}'];
   cCommentBlock := ['/* This is a comment */', '{', '}'];
   cCommentBlock2 := ['/* This is a comment */', '// Another comment', '{', '}'];
// Assignm
   cErrDblAssignoSK := ['a=1', 'a=2'];
// Call
   cCall1 := ['Doit();'];
   cCall2 := ['//comment line', 'Doit();'];
   cQualifiedCall := ['Unita.Doit();'];
   cQualifiedCall2 := ['Unita.ClassB.Doit();'];
   cCallArg := ['Doit(1);'];
   cCallArg2 := ['Doit(1,2);'];
// if
   cIfa := ['if (a)', ';'];
   cIfaBlock := ['if (a)', '  { }'];
   cIfaAssign := ['if (a)', '  a=False;'];
   cIfaSKelseSK := ['if (a) ;', 'else', ';'];
   cIfaBlockElseSK:= ['if (a)', '  {', '  }', 'else', ';'];
   cIfaBlockElseBlock := ['if (a)', '  {', '  }', 'else', '  {', '  }'];
   cBlockIfaCallElseSK := ['{', '  if (a)', '    DoA();', '  else ;', '}'];
   cIfaForWriteElseForWite := ['if (a) ', 'for (X = 1, X >= 0,X--) Write(X);',
        'else', 'for (X = 0, X<= 1, X++) Write(X);'];
   cIfaThrowElseForWrite := ['if (a)', 'throw(e);', 'else', 'for (X = 0,X<= 1,X++) Writeln(X);'];
   cIfaUsingElseForWrite := ['if (a)', 'using(b) Something();', 'else',
        'for (X = 0,X <= 1,X++) Writeln(X);'];
   cWhileIfWhileElseCall := ['while (a)', '  if (b)', 'while (c) ;', '  else', ' DoIt();'];
   cWhileIfWhileBlockElseCall := ['while (a)', '  if (b)', 'while (c) { }', '  else', ' DoIt();'];
   cIfIfBlockElseBlock := ['if (a)', '  if (b)', '    {', '    }', 'else', '  {', '  }'];
   cIfIfBlockElseBlockElseBlock := ['if (a)', '  if (b) ', '    {', '    }', '  else',
        '    {', '   }', 'else', '  {', '}'];
   cIfIfCallElseElseCall := ['if (a)', '  if (b)', '    DoA(); ',
        '   else;', ' else', '   DoB();'];
   cIfIfBlockElseElseBlock := ['if (a)', 'if (b)', '  {', '  }', 'else ;',
        'else', '  {', '  }'];
   cErrIfElsenoSK := ['if (a)', 'else'];
   cErrIfNoSK := ['if (a)'];
   cErrIfSKElseNoSK := ['if (a); else'];
   cErrIfIfSKElseElseSK := ['if (a) if (a); else else;'];
   cErrIfBlockSKElseBlock := ['if (a)', '  {','  };', 'else', '  {', '  }'];

// while
   cWhileSK := ['while(a) ;'];
   cWhileCall := ['while (a)', '  DoSomething();'];
   cWhileBlock := ['while (a)', '  {', '  }'];
   cWhileWhileBlock := ['while (a)', '  while (b)', '    {', '    }'];
   cDoWhile := ['do;', 'while (a);'];
   cDoBlockWhile := ['do', '{', '}', 'while (a);'];
   cDoCallWhile := ['do', '  Doit();', 'while (a);'];
   cDoDoBlockWhileWhile := ['do', 'do', '{', '}', 'while (b);', 'while (a);'];
   cDoWhileBlockWhile := ['do', 'while (b)', '{', '}', 'while (a);'];
end.

