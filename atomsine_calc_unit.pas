unit atomsine_calc_unit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, atom_unit, sinewave_unit, pointnd_unit, sinewaveinregion_unit,
  region_unit, Graphics, linkedlist_unit;

  type
  Tpointndarray = array of PointND;
  Tsinewaveinregionarray = array of SinewaveInRegion;
  Tgetmaximumfunction = Function(sine1, sine2: sinewave; point: double): sinewave;

procedure addAtomToSines(a: atom; coordinate: integer; color: TColor);

  var
sines: array [0..1] of linkedList;

implementation

function  sineFromAtomDomain(a: atom; coordinate, bound: integer): sineWave;
var tmppoint: PointND;
 	begin
    tmppoint:= a.position.clone();
    tmppoint.scale(-1); 	//transform in a vector from atom to center
    tmppoint.c[(coordinate+1) mod 3]:=0;
    result:= Sinewave.create(
           				tmppoint.norm(),
              			tmppoint.angleInProjection2D((coordinate-1) mod 2,coordinate),
                		a.adomain.goodregion.bounds[bound].c[coordinate]);
    tmppoint.destroy();
    end;


//returns array of PointND that represents the intersection points of the two
//sines that are inside the given region
function sineIntersectionsInRegion(sine, sine2: sinewave; theregion: Region): Tpointndarray;
var intersectionsine: sinewave;
	intersection1, intersection2: PointND;
	begin
    intersectionsine:=sine.intersectWave(sine2);
    intersectionsine.calculateZeros();
    intersection1:=PointND.create(intersectionsine.zeros[0]);
    intersection2:=PointND.create(intersectionsine.zeros[1]);
    intersectionsine.destroy();

    if theregion.inside(intersection1)
    	then
        if theregion.inside(intersection2) then
        	begin  		//two intersection points
            setlength(result,2);
            result[0]:= intersection1;
            result[1]:= intersection2;
            end
		else
        	begin      	//one intersection point: intersection1
            setlength(result,1);
            result[0]:=intersection1;
            intersection2.destroy();
            end
	else
    	if theregion.inside(intersection2) then
        	begin       //one intersection point: intersection2
            setlength(result,1);
            result[0]:=intersection2;
            intersection1.destroy();
            end
		else
        	begin		//no intersection points
            setlength(result,0);
            intersection1.destroy();
            intersection2.destroy();
            end;
    end;


//given two sines, a region and a sine intersection inside that region, returns
//an array of sinewaveinregion that represents the sines maximizing
//maximumFunction() in each corresponding sinewaveinregion's region
function maximizeSinesInRegion(sine1, sine2: sinewave; theregion: Region; maximumFunction: Tgetmaximumfunction): TsinewaveInRegionArray;
var intersections: array of PointND;
	i,j: integer;
    tmp1, tmp2: double;
	mean: double;
	maxsine: sinewave;

 	begin
    intersections:=sineIntersectionsInRegion(sine1, sine2, theregion);

    setlength(intersections, length(intersections) +2);  //shift intersections,
    for i:= length(intersections)-3 downto 0 do          //so we can insert 2 new,
    	intersections[i+1]:=intersections[i];            //on beginning and end of array
    intersections[0]:=theregion.bounds[0];
    intersections[length(intersections)-1]:=theregion.bounds[1];

    setlength(result,length(intersections)-1);
    for i:=0 to length(intersections)-2 do
    	begin
        mean:= (intersections[i].c[0] + intersections[i+1].c[0]) /2 ;
    	maxsine:= maximumFunction(sine1, sine2, mean);
        result[i]:=sinewaveinregion.create
           	(
           	maxsine,
           	Region.create(intersections[i], intersections[i+1])
           	);
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
var atomsine: SineWave;
	iteratedsineinregion, tmpnewsineregion: sinewaveInRegion;
    maxsines: array of sinewaveInRegion;
	i, j, bound, numsines:integer;

	begin
    for bound:=0 to 1 do
    	begin
        sines[bound].rewind();
        numsines:= sines[bound].length;
        atomsine:= sineFromAtomDomain(a, coordinate, bound);
        atomsine.color:=color;

        if sines[bound].length=0 then
        	sines[bound].addElement
         		(
         		SineWaveInRegion.create
           			(
           			atomsine,
              		Region.create(PointND.create(0), PointND.create(2*PI))
                    )
              	)
        else
            for i:=0 to numsines-1 do
            	begin
                iteratedsineinregion:= sineWaveInRegion(  sines[bound].position.element  );
                sines[bound].removeElement(sines[bound].position);
                if bound=0 then
                	maxsines:= maximizeSinesInRegion(atomsine, iteratedsineinregion.sine, iteratedsineinregion.region, @highline )
                else
                    maxsines:= maximizeSinesInRegion(atomsine, iteratedsineinregion.sine, iteratedsineinregion.region, @lowline );
                for j:= 0 to length(maxsines)-1 do
                	begin
                    tmpnewsineregion:=maxsines[j];
                	sines[bound].addElement(maxsines[j]);
                    end;
                end;
    	end;
    end;



end.

