unit atomsine_calc_unit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, atom_unit, sinewave_unit, pointnd_unit, sinewaveinregion_unit,
  Graphics, region_unit, linkedlist_unit;

  type

  Tsinewaveinregionarray = array of SinewaveInRegion;
  Tgetmaximumfunction = Function(sine1, sine2: sinewave; point: double): sinewave;

procedure addAtomToSines(a: atom; coordinate: integer; color: TColor);

  var
sines: array [0..1] of linkedList;

implementation

function  SIRFromAtomDomain(a: atom; coordinate, bound: integer): sineWaveInRegion;
var tmppoint: PointND;
sine: sinewave;
region: TRegion;
 	begin
    tmppoint:= a.position.clone();
    tmppoint.scale(-1); 				//transform in a vector from atom to center
    tmppoint.c[(coordinate+1) mod 3]:=0;//project
    sine:= Sinewave.create(
           				tmppoint.norm(),
              			tmppoint.angleInProjection2D((coordinate-1) mod 2,coordinate),
                		a.adomain.goodregion.bounds[bound].c[coordinate]);
    tmppoint.destroy();
    region:= TRegion.create(PointND.create(0), PointND.create(2*PI));
    result:=SineWaveInRegion.create(sine, region);



    end;



//given two SIR, returns an array of SIR with the sines maximizing
// maximumFunction() in each subregion of its (SIRs) intersection
function maximizeSIR(sine1, sine2: sinewaveInRegion; maximumFunction: Tgetmaximumfunction): TsinewaveInRegionArray;
var i: integer;
	mean: double;
    newregion: TRegion;
    newsine, maxsine: sinewave;
    newsr: sineWaveInRegion;
    regions: TRegionArray;

 	begin
    newregion:=sine1.region.intersect(sine2.region);
    newsine:=sine1.sine.intersectWave(sine2.sine);
    newsr:=sineWaveInRegion.create(newsine, newregion);
    regions:= newsr.getSubregions();
    newregion.Destroy();
    newsine.Destroy();
    newsr.Destroy();

    setlength(result, length(regions));

    for i:=0 to high(regions) do
    	begin
        mean:= (regions[i].bounds[0].c[0] + regions[i].bounds[1].c[0]) /2 ;
    	maxsine:= maximumFunction(sine1.sine, sine2.sine, mean);
        result[i]:=sinewaveinregion.create(maxsine, regions[i]);
        end;
    end;

function highline(sine1, sine2: sinewave; point: double): sinewave;
	begin
    if sine1.valueat(point)>sine2.valueat(point) then
    	result:=sine1
    else
    	result:=sine2;
    end;

function lowline(sine1, sine2: sinewave; point: double): sinewave;
	begin
    if sine1.valueat(point)>sine2.valueat(point) then
    	result:=sine2
    else
    	result:=sine1;
    end;

procedure addAtomToSines(a: atom; coordinate: integer; color: TColor);
var atomSIR, iterSIR: sinewaveInRegion;
    maxsines: array of sinewaveInRegion;
	i, j, bound, numsines:integer;

	begin
    for bound:=0 to 1 do
    	begin
        sines[bound].rewind();
        numsines:= sines[bound].length; //necessary! it changes during operations
        atomSIR:=SIRFromAtomDomain(a, coordinate, bound);
        atomSIR.sine.color:=color;

        if sines[bound].length=0 then
        	sines[bound].add(atomSIR)
        else
            for i:=0 to numsines-1 do
            	begin
                iterSIR:= sineWaveInRegion(  sines[bound].remove()  );
                if bound=0 then
                	maxsines:= maximizeSIR(atomSIR, iterSIR, @highline )
                else
                    maxsines:= maximizeSIR(atomSIR, iterSIR, @lowline );
                for j:= 0 to high(maxsines) do
                    sines[bound].add(maxsines[j]);
                end;
    	end;
    end;



end.

