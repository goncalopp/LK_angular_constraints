unit atom_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pointnd_unit, domain_unit, region_unit;

type
  Atom = class
  private
    { private declarations }
  public
    position: PointND;
    adomain: Domain;
    constructor create(position_, lowerlimit, higherlimit: pointND);
    function toText():String;
    procedure fromText(s: string);
    end;


implementation

constructor Atom.create(position_, lowerlimit, higherlimit: pointND);
var goodregion: TRegion; point1, point2: PointND;
    begin
    position:= 	position_;
    goodregion:= TRegion.Create(lowerlimit, higherlimit);
    adomain:=    Domain.create(goodregion);
    end;

function Atom.toText(): String;
var s:String;
	i: integer;
    begin
    s:='';
    for i:=0 to 2 do
    	s:=s+
        	floattostr(position.c[i])+#13#10+
        	floattostr(adomain.goodregion.bounds[0].c[i])+#13#10+
            floattostr(adomain.goodregion.bounds[1].c[i])+#13#10;
    result:=s;
    end;

procedure Atom.fromText(s: string);
var slist: TStrings;
    i: integer;
    begin
    ExtractStrings([],[], PChar(s), slist);
    for i:=0 to 2 do
    	begin
    	position.c[i]:=strtofloat(slist[i*3]);
        adomain.goodregion.bounds[0].c[i]:=strtofloat(slist[i*3+1]);
    	adomain.goodregion.bounds[1].c[i]:=strtofloat(slist[i*3+2]);
        end;
    end;


end.

