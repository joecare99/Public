{$mode objfpc}{$H+}
{$inline on}

{$ifdef fpc}
  {$define HasInt64}
  {$define UseAnsiStrings}
  {$define HasStreams}
  {$define UsePChar}
  {$IF FPC_FULLVERSION<30101}
    {$define EmulateArrayInsert}
  {$endif}
  {$define HasFS}
{$endif}

{$IFDEF NODEJS}
  {$define HasFS}
{$ENDIF}

{$IF FPC_FULLVERSION>30100}
  {$IF FPC_FULLVERSION<30300}
    {$warn 6058 off} // cannot inline
  {$ENDIF}
{$ENDIF}

