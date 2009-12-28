unit rigidgroup_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, point3d_unit, atom_unit, domain_unit, region_unit,Forms, dialogs;
  
type

RigidGroup = class
  private
  public
	   center: Point3D;    //in global coordinates
    atoms: array of Atom;
    constructor create();
    procedure addAtom(pos_x, pos_y, pos_z, dom_x1, dom_x2, dom_y1, dom_y2, dom_z1, dom_z2:double);
    procedure recalculateCenter();
    procedure rotateOver(rotationaxis: char; angle: double);
    procedure calculateCenterDomain(x_angle_step, y_angle_step: double; application:TApplication);
    //procedure calculateCenterDomain(x_angle_step, y_angle_step: double);
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
         	atoms[i].adomain.goodregion.point1.coordinates[c]^:=atoms[i].adomain.goodregion.point1.coordinates[c]^-translation.coordinates[c]^;
         	atoms[i].adomain.goodregion.point2.coordinates[c]^:=atoms[i].adomain.goodregion.point2.coordinates[c]^-translation.coordinates[c]^;
            end;
end;

procedure RigidGroup.rotateOver(rotationaxis: char; angle: double);
var i:integer;
	begin
	for i:=0 to length(atoms)-1 do
    	atoms[i].position.rotate(rotationaxis, angle);
    end;


procedure RigidGroup.calculateCenterDomain(x_angle_step, y_angle_step: double; application:TApplication);
//procedure RigidGroup.calculateCenterDomain(x_angle_step, y_angle_step: double);
var x,y,i, x_steps, y_steps: integer;
	centerDomain: Domain;
    vector: Point3D;
	begin
    centerDomain:= Domain.create(Region.create(Point3d.create(-10e9, -10e9, -10e9), Point3d.create(10e9, 10e9, 10e9)));
	y_steps:= trunc((2.0*pi) / y_angle_step);
    x_steps:= trunc( pi / x_angle_step);		//no need to do 360º to cover 3D space, only 180
 	for x:= 0 to x_steps - 1 do
    	begin
        self.rotateOver('x', x_angle_step);
    	for y:= 0 to y_steps - 1 do
        	begin
			self.rotateOver('y', y_angle_step);
			for i:= 0 to length(atoms) -1 do
            	begin
				vector:=atoms[i].position.vectorTo(center);
                application.processmessages();
                sleep(10);
                vector.Free();
                end;
			end;
		end;
    end;

end.

