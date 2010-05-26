unit sinewaveinregion_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sinewave_unit, region_unit, pointnd_unit;

type
  SineWaveInRegion = class
    sine: sinewave;
   	region: TRegion;
    constructor create(sine_: sinewave; region_: TRegion);
    function getZerosInRegion():TPointNDArray;
    function getSubregions(): TRegionArray;
    end;

implementation

constructor SineWaveInRegion.create(sine_: sinewave; region_: TRegion);
	begin
    sine:=sine_;
    region:=region_;
    end;

function sineWaveInRegion.getZerosInRegion():TPointNDArray;
var i:integer;
zeros: TPointNDArray;
	begin
    setlength(result, 0);
    zeros:= sine.getZeros();
    for i:=0 to high(zeros) do
        if region.inside(zeros[i]) then
        	begin
            setlength(result,  length(result)+1);
            result[high(result)]:=zeros[i]
        	end
        else
        	zeros[i].destroy();
    end;


//example subregions: [region_begining -- zero0], [zero1 -- zero2], [zero2 -- region_end]
function sineWaveInRegion.getSubregions():TRegionArray;
var zeros: TPointNDArray;
i: integer;
	begin
    zeros:= getZerosInRegion();
    setlength(result, length(zeros) +1);
    if length(result)=1 then
    	result[0]:=TRegion.create(region.bounds[0].clone(), region.bounds[1].clone())
    else
    	begin
        result[0]:=TRegion.create(region.bounds[0].clone(), zeros[0]);
    	for i:= 0 to high(zeros)-1 do
    		result[i+1]:=TRegion.create(zeros[i], zeros[i+1]);
     	result[high(result)]:=TRegion.create(zeros[high(zeros)], region.bounds[1].clone());
        end;
    end;


end.
                                                   
