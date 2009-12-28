unit point3d_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;


type
  Point3d = class
  private
    { private declarations }
  public
    x,y,z: double;
    coordinates: array[0..2] of Pdouble;
    constructor create(x_,y_,z_: double);
    procedure moveto(x_, y_, z_: double);
    procedure translate(x_, y_, z_: double);
    procedure rotateOver(rotationaxis: char; point: Point3d; angle: double);
    procedure rotate(rotationaxis: char; angle: double);
    function vectorTo(point: Point3d): Point3d;
    function distanceTo(point: Point3d): double;
  end;

implementation

constructor Point3d.create(x_,y_,z_: double);
	begin
	x:=x_;
	y:=y_;
	z:=z_;
    coordinates[0]:=@x; //"coordinate[0]" and "x" become the same variable
    coordinates[1]:=@y;
	coordinates[2]:=@z;
	end;

procedure Point3d.moveto(x_, y_, z_: double);
	begin
	x:=x_;
	y:=y_;
	z:=z_;
	end;

procedure Point3d.translate(x_, y_, z_: double);
	begin
	x:=x+x_;
	y:=y+y_;
	z:=z+z_;
	end;

procedure Point3d.rotateOver(rotationaxis: char; point: Point3d; angle: double);
    var distance, current_angle: double; ce, c0, c1: integer;
 	begin
    if rotationaxis='x' then
    	begin
     	ce:=0;          //excluded coordinate
        c0:=1;          //first coordinate to process
        c1:=2;          //second coordinate to process
        end;
        
    if rotationaxis='y' then
        begin c0:=0; ce:=1; c1:=2; end;
        
    if rotationaxis='z' then
     	begin c0:=0; c1:=1; ce:=2; end;
        
    point.coordinates[ce]^:=coordinates[ce]^; 	//project the point into the plane of rotation...
    distance:= distanceTo(point);               //...so we can calculate the distance in the plane
    
	current_angle:=arctan2(        //calculate current angle in trig circle
 			coordinates[c1]^-point.coordinates[c1]^,
    		        coordinates[c0]^-point.coordinates[c0]^);

    coordinates[c0]^:=point.coordinates[c0]^+distance*cos(current_angle+angle);
    coordinates[c1]^:=point.coordinates[c1]^+distance*sin(current_angle+angle);
	end;

procedure Point3d.rotate(rotationaxis:char; angle: double);
var tmppoint:Point3d;
	begin
	tmppoint:= Point3d.create(0,0,0);
    rotateOver(rotationaxis, tmppoint, angle);
    tmppoint.destroy();
    end;

function Point3d.vectorTo(point: Point3d): Point3d;
    begin
    result:=Point3d.create(point.x-x, point.y-y, point.z-z);
    end;
    
function Point3d.distanceTo(point: Point3d): double;
    begin
    result:=sqrt( (x-point.x)*(x-point.x) + (y-point.y)*(y-point.y) + (z-point.z)*(z-point.z));
    end;
    
end.



