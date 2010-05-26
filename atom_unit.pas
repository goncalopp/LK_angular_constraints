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
    end;


implementation

constructor Atom.create(position_, lowerlimit, higherlimit: pointND);
var goodregion: Region; point1, point2: PointND;
    begin
    position:= 	position_;
    goodregion:=Region.Create(lowerlimit, higherlimit);
    adomain:=    Domain.create(goodregion);
    end;

end.

