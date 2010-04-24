unit region_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pointnd_unit, math;

type
  Region = class
  private
  public
  	bounds: array [0..1] of PointND;
    constructor create(bound1, bound2: PointND);
    function inside(point: PointND): boolean;
  end;

implementation

constructor Region.create(bound1, bound2: PointND);
var i:integer;
	begin
	bounds[0]:= PointND.create(bound1);
    bounds[1]:= PointND.create(bound2);
    for i:=0 to length(bounds[0].c) do
    	bounds[0].c[i]:=min(bound1.c[i], bound2.c[i]);
    for i:=0 to length(bounds[1].c) do
    	bounds[1].c[i]:=max(bound1.c[i], bound2.c[i]);
	bound1.Destroy();
    bound2.Destroy();
 	end;

function Region.inside(point: PointND): boolean;
var i: integer;
	begin
    result:=true;
    for i:=0 to length(point.c) - 1 do
        if (point.c[i] < bounds[0].c[i]) or (point.c[i] > bounds[1].c[i]) then
        	begin
         	result:=false;
            break;
            end;
    end;

end.

