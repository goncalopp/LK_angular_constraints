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
    domain: Domain;
    constructor create(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2: double);
    end;


implementation

constructor Atom.create(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2: double);
var goodregion: Region; point1, point2: Point3d;
    begin
    position:= 	Point3d.Create(pos_x, pos_y, pos_z);
    point1:=    Point3d.Create(dom_x1, dom_y1, dom_z1);
    point2:=    Point3d.Create(dom_x2, dom_y2, dom_z2);
    goodregion:=Region.Create(point1, point2);
    domain:=    Domain.create(goodregion);
    
    end;

end.

