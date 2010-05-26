unit pointnd_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;


type
  PointND = class
  private
  	procedure creator(number_of_coordinates: integer);
    { private declarations }
  public
    c: array of double;          //coordinates; terse because it will be frequently used
    x,y,z,w,v: PDouble;
    constructor create(point: PointND);
    constructor create(x_: double);
    constructor create(x_, y_: double);
    constructor create(x_, y_, z_: double);
    constructor create(x_, y_, z_, w_: double);
    constructor create(x_, y_, z_, w_, v_: double);
    procedure translate(point: PointND);
    procedure scale(point: PointND);
    procedure scale(vector: double);
	class function coordinateNumberFromChar(coordinate: char):integer;
 	procedure vectorTo(point: PointND);
    procedure vectorFrom(point: PointND);
    function distanceTo(point: PointND): double;
    function norm():double;
    function clone(): PointND;

	function angleInProjection2D(x_coordinate,y_coordinate:integer): double;
    procedure rotateOver3D(rotationaxis: char; point: PointND; angle: double);
    procedure rotate3D(rotationaxis: char; angle: double);


  end;

implementation

procedure PointND.creator(number_of_coordinates: integer);
	begin
    setlength(c, number_of_coordinates);
    x:=@c[0];
    if number_of_coordinates>1 then
    	y:=@c[1];
    if number_of_coordinates>2 then
    	z:=@c[2];
    if number_of_coordinates>3 then
    	w:=@c[3];
    if number_of_coordinates>4 then
    	v:=@c[4];
    end;

constructor PointND.create(point: PointND);
	begin
    creator(length(point.c));
	end;

constructor PointND.create(x_: double);
	begin
    creator(1);
    c[0]:=x_;
	end;

constructor PointND.create(x_, y_: double);
	begin
    creator(2);
    c[0]:=x_;
    c[1]:=y_;
	end;

constructor PointND.create(x_, y_, z_: double);
	begin
    creator(3);
    c[0]:=x_;
    c[1]:=y_;
    c[2]:=z_;
	end;

constructor PointND.create(x_, y_, z_, w_: double);
	begin
    creator(4);
    c[0]:=x_;
    c[1]:=y_;
    c[2]:=z_;
    c[3]:=w_;
	end;

constructor PointND.create(x_, y_, z_, w_, v_: double);
	begin
    creator(5);
    c[0]:=x_;
    c[1]:=y_;
    c[2]:=z_;
    c[3]:=w_;
    c[4]:=v_;
	end;

procedure PointND.translate(point: PointND);
var i:integer;
	begin
    for i:=0 to length(c)-1 do
    	c[i]:=c[i]+point.c[i];
	end;

procedure PointND.scale(point: PointND);
var i:integer;
	begin
    for i:=0 to length(c)-1 do
    	c[i]:=c[i]*point.c[i];
	end;

procedure PointND.scale(vector: double);
var i:integer;
	begin
    for i:=0 to length(c)-1 do
    	c[i]:=c[i]*vector;
	end;

class function PointND.coordinateNumberFromChar(coordinate: char): integer;
	begin
    case coordinate of
        'y': result:=1;
        'z': result:=2;
        'w': result:=3;
        'v': result:=4;
        else result:=0;
        end;

    end;

function PointND.angleInProjection2D(x_coordinate, y_coordinate:integer): double;
//calculate angle in trig circle of bidimensional *vector*
	begin
    result:= arctan2(c[y_coordinate], c[x_coordinate]);
    if (result<0) then
    	result:= result+2*pi;
    end;


procedure PointND.rotateOver3D(rotationaxis: char; point: PointND; angle: double);
    var distance, current_angle, tmp: double; ce, c0, c1: integer; vector: pointND;
 	begin
	ce:=coordinateNumberFromChar(rotationaxis);	//excluded coordinate
    c0:=(ce+1) mod 3;          					//first coordinate to process
    c1:=(ce+2) mod 3;          					//second coordinate to process

    vector:=point.clone();
    vector.vectorTo(self);
	vector.c[ce]:=0; 	//project the vector into the plane of rotation...
    distance:= vector.norm();       //...so we can calculate the distance in the plane
	current_angle:=vector.angleInProjection2D(c0,c1);
    vector.free();


    c[c0]:=point.c[c0]+distance*cos(current_angle+angle);
    c[c1]:=point.c[c1]+distance*sin(current_angle+angle);
	end;

procedure PointND.rotate3D(rotationaxis:char; angle: double);
var tmppoint:PointND;
	begin

	tmppoint:= PointND.create(0,0,0);
    rotateOver3D(rotationaxis, tmppoint, angle);
    tmppoint.destroy();
    end;

procedure PointND.vectorTo(point: PointND);
var i:integer;
	begin
    for i:=0 to length(c)-1 do
    	c[i]:=point.c[i]-c[i];
	end;

procedure PointND.vectorFrom(point: PointND);
var i:integer;
	begin
    for i:=0 to length(c)-1 do
    	c[i]:=c[i]-point.c[i];
	end;

function PointND.distanceTo(point: PointND): double;
var tmp:PointND;
    begin
    tmp:=self.clone();
    tmp.vectorTo(point);
    result:=tmp.norm();
    tmp.destroy();
    end;

function PointND.norm(): double;
var i:integer;
	begin
    result:=0;
    for i:=0 to length(c)-1 do
    	result:= result + c[i]*c[i];
    result:= sqrt(result);
    end;

function PointND.clone: PointND;
var i: integer;
	begin
    result:=PointND.create(self);
    for i:=0 to length(c)-1 do
    	result.c[i]:=c[i];
    end;

end.



