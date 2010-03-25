unit atom_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, point3d_unit, domain_unit, region_unit;

type
  Atom = class
  private
    { private declarations }
  public
    position: Point3d;
    adomain: Domain;
    constructor create(position_, lowerlimit, higherlimit: point3D);
    end;


implementation

constructor Atom.create(position_, lowerlimit, higherlimit: point3D);
var goodregion: Region; point1, point2: Point3d;
    begin
    position:= 	position_;
    goodregion:=Region.Create(lowerlimit, higherlimit);
    adomain:=    Domain.create(goodregion);
    end;

end.

