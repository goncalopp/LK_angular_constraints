unit point3d_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type
  Point3d = class
  private
    { private declarations }
  public
    x,y,z: double;
    constructor create(x_,y_,z_: double);
    procedure moveto(x_, y_, z_: double);
    procedure translate(x_, y_, z_: double);
    procedure rotateOver(rotationaxis: char; point: Point3d; angle: double);
  end;

implementation

function anglefromcoordinates(x,y : double): double;
    var distance: double;
    begin
    if x=0 then x:= 0.000000000001;
	if y=0 then y:= 0.000000000001;
    
    distance:= sqrt( x*x + y*y );     		//
    x:= x/distance;                         //normalize
    y:= y/distance;                         //

    result:=arctan(y/x);
    if (x<0) then
        result:=result+pi;
    if (result<0) then
        result:=result+2*pi;
    end;

constructor Point3d.create(x_,y_,z_: double);
	begin
	x:=x_;
	y:=y_;
	z:=z_;
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
    var distance, current_angle: double;
 	begin
    if rotationaxis='x' then
        begin
        
        distance:= sqrt( (y-point.y)*(y-point.y) + (z-point.z)*(x-point.z) );
		current_angle:=anglefromcoordinates(y-point.y, z-point.z);
        x:=x;
        y:=point.y+distance*cos(current_angle+angle);
        z:=point.z+distance*sin(current_angle+angle);
        end;
    if rotationaxis='y' then
        begin
		distance:= sqrt( (x-point.x)*(x-point.x) + (z-point.z)*(x-point.z) );
		current_angle:=anglefromcoordinates(x-point.x, z-point.z);
        x:=point.x+distance*cos(current_angle+angle);
        y:=y;
        z:=point.z+distance*sin(current_angle+angle);
        end;
	if rotationaxis='z' then
        begin
		distance:= sqrt( (x-point.x)*(x-point.x) + (y-point.y)*(y-point.y) );
		current_angle:=anglefromcoordinates(x-point.x, y-point.y);
        x:=point.x+distance*cos(current_angle+angle);
        y:=point.y+distance*sin(current_angle+angle);
        z:=z;
        end;
	end;

end.



