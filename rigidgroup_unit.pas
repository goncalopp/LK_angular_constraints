unit rigidgroup_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, point3dunit;
  
type

RigidGroup = class
  private
    center: Point3D;    //global coordinates
    rx, ry, rz: double; //rotations, in radians
    points: array of Point3d;
  public
    constructor create();
    procedure addPoint(point: Point3d);
    procedure recalculateCenter();
  end;
  

implementation

constructor RigidGroup.create();
	begin
	center:= Point3D.create(0,0,0);
    setlength(points, 0);
	end;
    
procedure addPoint(point: Point3d);
    begin
    point.x:=point.x-center.x;
    point.y:=point.y-center.y;
    point.z:=point.z-center.z;
    setlength(points, length(points)+1);
    points[length(points-1]:=point;
    end;

procedure recalculateCenter();
var i,c: integer;
sum, translation: point3d;
	begin
    sum:= point3d.create(0,0,0);
    
    for i:= 0 to length(points)-1 do
        for c:=0 to 2 do
        	sum.coordinates[c]^:=sum.coordinates[c]+points[i].coordinates[c];
	for c:=0 to 2 do
        	sum.coordinates[c]^:=sum.coordinates[c] / length(points);

    translation:= center.vectorTo(sum);
    for c:=0 to 2 do
    	center.coordinates[c]^:=sum.coordinates[c];
        
    for i:= 0 to length(points)-1 do
        for c:=0 to 2 do
        	points[i].coordinates[c]^:=points[i].coordinates[c]^-center.coordinates[c]^;

end;

end.

