{
 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
 *                                                                         *
 ***************************************************************************

  Author: Joost van der Sluis
  
  This unit registers the sqldb components of the FCL.
}
unit registersqldb_ext;

{$mode objfpc}{$H+}
{$IF FPC_FULLVERSION>=30000}
{$IF FPC_FULLVERSION<=30100}
{$DEFINE HASMYSQL57CONNECTION}
{$ENDIF}
{$DEFINE HASMYSQL60CONNECTION}
{$DEFINE HASMariaDBCONNECTION}
{$ENDIF}

interface

uses
  Classes, SysUtils, db, sqldb, registersqldb,
  {$IFDEF HASMARIADBCONNECTION}
    mariadbconn,
  {$ENDIF}
  {$IFDEF HASMYSQL60CONNECTION}
    mysql60conn,
  {$ENDIF}
  {$IFDEF HASMYSQL57CONNECTION}
    mysql57conn,
  {$ENDIF}
  LazarusPackageIntf ;

procedure Register;

implementation

{$R registersqldb_ext.res}

uses dynlibs;

procedure RegisterUnitSQLdb;
begin
  RegisterComponents('SQLdb',[
  {$IFDEF HASMARIADBCONNECTION}
       TMariaDBConnection
  {$ENDIF}
{$IFDEF HASMYSQL57CONNECTION}
     ,TMySQL57Connection
{$ENDIF}
{$IFDEF HASMYSQL60CONNECTION}
    ,TMySQL6Connection
{$ENDIF}
    ]);
end;

procedure Register;
begin

end;

initialization

finalization

end.
