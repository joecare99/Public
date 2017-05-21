{ $Header$
 /***************************************************************************
                               EditTest.pp
                             -------------------
                           Test aplication for editors
                   Initial Revision  : Sun Dec 31 17:30:00:00 CET 2000




 ***************************************************************************/

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
 *   Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.   *
 *                                                                         *
 ***************************************************************************
}
{
@author(Marc Weustink <marc@lazarus.dommelstein.net>)
@created(31-Dec-2000)

Detailed description of the Unit.
}
program EditTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Classes, SysUtils, Forms, Frm_EditTestMain;


begin
   Application.Initialize;
   Application.CreateForm(TEditTestForm, EditTestForm);
   Application.Run;
end.


