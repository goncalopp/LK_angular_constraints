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
    procedure translate(point: Point3D);
    procedure scale(x_, y_, z_: double);
	function coordinateNumberFromChar(coordinate: char):integer;
	function angleInProjection(x_coordinate,y_coordinate:integer): double;
    procedure rotateOver(rotationaxis: char; point: Point3d; angle: double);
    procedure rotate(rotationaxis: char; angle: double);
    procedure vectorTo(point: Point3d);
    procedure vectorFrom(point: Point3d);
    function distanceTo(point: Point3d): double;
    function norm():double;
    function clone(): Point3D;
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

procedure Point3d.translate(point: Point3d);
	begin
	x:=x+point.x;
	y:=y+point.y;
	z:=z+point.z;
	end;

procedure Point3d.scale(x_, y_, z_: double);
	begin
	x:=x*x_;
	y:=y*y_;
	z:=z*z_;
	end;

function Point3d.coordinateNumberFromChar(coordinate: char): integer;
	begin
    result:=0;
    if (coordinate='y') then
    	result:=1;
    if (coordinate='z') then
    	result:=2;
    end;

function Point3d.angleInProjection(x_coordinate, y_coordinate:integer): double;
//calculate angle in trig circle of *vector* in a plane projection
	begin
    result:= arctan2(coordinates[y_coordinate]^, coordinates[x_coordinate]^);
    end;


procedure Point3d.rotateOver(rotationaxis: char; point: Point3d; angle: double);
    var distance, current_angle, tmp: double; ce, c0, c1: integer; vector: point3d;
 	begin
	ce:=coordinateNumberFromChar(rotationaxis);	//excluded coordinate
    c0:=(ce+1) mod 3;          					//first coordinate to process
    c1:=(ce+2) mod 3;          					//second coordinate to process

    vector:=point.clone();
    vector.vectorTo(self);
	vector.coordinates[ce]^:=0; 	//project the vector into the plane of rotation...
    distance:= vector.norm();       //...so we can calculate the distance in the plane
	current_angle:=vector.angleInProjection(c0,c1);
    vector.free();

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

procedure Point3d.vectorTo(point: Point3d);
    begin
    x:=point.x-x;
    y:=point.y-y;
    z:=point.z-z;
    end;

procedure Point3D.vectorFrom(point: Point3d);
	begin
    x:=x-point.x;
    y:=y-point.y;
    z:=z-point.z;
    end;
    
function Point3d.distanceTo(point: Point3d): double;
    begin
    result:=sqrt( (x-point.x)*(x-point.x) + (y-point.y)*(y-point.y) + (z-point.z)*(z-point.z));
    end;

function Point3d.norm(): double;
var origin:point3d;
	begin
    origin:=point3d.create(0,0,0);
    result:=distanceTo(origin);
    origin.free();
    end;

function Point3D.clone: Point3D;
	begin
    result:=Point3D.create(x,y,z);
    end;
    
end.



