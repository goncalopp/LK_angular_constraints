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
    procedure addAtom(position, lowerlimit, upperlimit: point3D);
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
    
procedure RigidGroup.addAtom(position, lowerlimit, upperlimit: point3D);
    begin
    position.vectorFrom(center);    //
    lowerlimit.vectorFrom(center);  //transform into local coordinates
    upperlimit.vectorFrom(center);  //

    setlength(atoms, length(atoms)+1);
    atoms[length(atoms)-1]:=Atom.create(position, lowerlimit, upperlimit);
    end;                                                                          

procedure RigidGroup.recalculateCenter();
var i,c: integer;
sum, translation: point3d;
resizescale: double;
	begin
    sum:= point3d.create(0,0,0);
    
    for i:= 0 to length(atoms)-1 do
    	sum.translate(atoms[i].position);
    resizescale:= 1/length(atoms);
	sum.scale(resizescale,resizescale, resizescale);

    translation:= sum.clone();
    translation.vectorFrom(center);

    center.destroy();
    center:=sum;
        
    for i:= 0 to length(atoms)-1 do
    	begin
    	atoms[i].position.vectorFrom(translation);
        atoms[i].adomain.goodregion.point1.vectorFrom(translation);
        atoms[i].adomain.goodregion.point2.vectorFrom(translation);
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

                application.processmessages();
                sleep(10);

                end;
			end;
		end;
    end;

end.

