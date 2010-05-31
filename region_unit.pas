unit region_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pointnd_unit, math;

type
  TRegion = class
  private
  public
  	bounds: array [0..1] of PointND;
    constructor create(bound1, bound2: PointND);
    destructor destroy();
    function inside(point: PointND): boolean;
    function intersect(other: TRegion): TRegion;
  end;

  TRegionArray = array of TRegion;

implementation

constructor TRegion.create(bound1, bound2: PointND);
var i:integer;
	begin
	bounds[0]:= bound1;
    bounds[1]:= bound2;
 	end;

destructor Tregion.destroy();
	begin
    bounds[0].destroy();
    bounds[1].destroy();
    end;

function TRegion.inside(point: PointND): boolean;
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

function TRegion.intersect(other: TRegion): TRegion;
var i: integer;
	newbound0, newbound1: PointND;
	begin
    newbound0:=PointND.create(bounds[0]);
    newbound1:=PointND.create(bounds[1]);
    for i:=0 to high(bounds[0].c) do
       	newbound0.c[i]:=max(bounds[0].c[i], other.bounds[0].c[i]);
    for i:=0 to high(bounds[1].c) do
       	newbound1.c[i]:=min(bounds[1].c[i], other.bounds[1].c[i]);
    for i:=0 to high(bounds[1].c) do
       	if newbound0.c[i]>newbound1.c[i] then
            begin
            result:= nil;
            exit;
            end;
    result:= TRegion.create(newbound0, newbound1)


    end;

end.

