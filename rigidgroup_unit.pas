unit rigidgroup_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, point3d_unit, atom_unit;
  
type

RigidGroup = class
  private
    center: Point3D;    //in global coordinates
    atoms: array of Atom;
  public
    constructor create();
    procedure addAtom(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2:double);
    procedure recalculateCenter();
  end;
  

implementation

constructor RigidGroup.create();
	begin
	center:= Point3D.create(0,0,0);
    setlength(atoms, 0);
	end;
    
procedure RigidGroup.addAtom(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2:double);
    begin
    pos_x:=pos_x-center.x;  //
    pos_y:=pos_y-center.y;  //transform into local coordinates
    pos_z:=pos_z-center.z;  //
    setlength(atoms, length(atoms)+1);
    atoms[length(atoms)-1]:=Atom.create(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2);
    end;

procedure RigidGroup.recalculateCenter();
var i,c: integer;
sum, translation: point3d;
	begin
    sum:= point3d.create(0,0,0);
    
    for i:= 0 to length(atoms)-1 do
        for c:=0 to 2 do
        	sum.coordinates[c]^:=sum.coordinates[c]^ +atoms[i].position.coordinates[c]^;
	for c:=0 to 2 do
        	sum.coordinates[c]^:=sum.coordinates[c]^ / length(atoms);

    translation:= center.vectorTo(sum);
    for c:=0 to 2 do
    	center.coordinates[c]^:=sum.coordinates[c]^;
        
    for i:= 0 to length(atoms)-1 do
        for c:=0 to 2 do
        	begin
         	atoms[i].position.coordinates[c]^:=atoms[i].position.coordinates[c]^-translation.coordinates[c]^;
         	atoms[i].domain.goodregion.point1.coordinates[c]^:=atoms[i].domain.goodregion.point1.coordinates[c]^-translation.coordinates[c]^;
         	atoms[i].domain.goodregion.point2.coordinates[c]^:=atoms[i].domain.goodregion.point2.coordinates[c]^-translation.coordinates[c]^;
            end;
end;

end.

