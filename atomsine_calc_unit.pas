unit atomsine_calc_unit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, dialogs, atom_unit, sinewave_unit, pointnd_unit, sinewaveinregion_unit,
  Graphics, region_unit, linkedlist_unit, quicksort_unit;

  type

  Tsinewaveinregionarray = array of SinewaveInRegion;
  Tgetmaximumfunction = Function(sine1, sine2: sinewave; point: double): sinewave;
  TIntersection = class
  	sine1, sine2: Sinewave;
    intersection: PointND;
    constructor create(s1,s2: sinewave; inter: PointND);
  	end;

procedure addAtomToSines(a: atom; coordinate: integer; color: TColor);
procedure process();

  var
allsines: array [0..1] of linkedList;
intersections: array [0..1] of QSArray;
sirs: array [0..1] of linkedList;

implementation

constructor TIntersection.create(s1,s2: sinewave; inter: PointND);
	begin
    sine1:= s1; sine2:=s2; intersection:=inter;
	end;

function  sineFromAtomDomain(a: atom; coordinate, bound: integer): sineWave;
var tmppoint: PointND;
sine: sinewave;
 	begin
    tmppoint:= a.position.clone();
    tmppoint.scale(-1); 				//transform in a vector from atom to center
    tmppoint.c[(coordinate+1) mod 3]:=0;//project
    sine:= Sinewave.create(
           				tmppoint.norm(),
              			tmppoint.angleInProjection2D((coordinate-1) mod 2,coordinate),
                		a.adomain.goodregion.bounds[bound].c[coordinate]);
    tmppoint.destroy();
    result:=sine;
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
var atomsine, itersine, intersectionsine: sinewave;
	i, j, bound, intersectionindex :integer;
    zeros: array of PointND;
	begin
    for bound:=0 to 1 do
    	begin
        allsines[bound].rewind();
        atomsine:=sineFromAtomDomain(a, coordinate, bound);
        atomsine.color:=color;

        for i:=0 to allsines[bound].length-1 do
        	begin
            itersine:= sinewave( allsines[bound].advance().element);
            intersectionsine:=itersine.intersectWave(atomsine);
            zeros:= intersectionsine.getZeros();
            intersectionindex:= length(intersections[bound]);
            setlength(intersections[bound], length(intersections[bound]) + length(zeros));
            for j:=0 to high(zeros) do
            	intersections[bound][intersectionindex+j]:= TIntersection.create(atomsine, itersine, zeros[j]);
        	end;
        allsines[bound].add(atomsine);
    	end;
	end;

function intersectionDouble(intersection: Tobject): double;
	begin
    result:= TIntersection(intersection).intersection.c[0];
    end;

function getFirstSine(bound: integer): Sinewave;
var i:integer;
	s: sinewave;
    f: Tgetmaximumfunction;
    begin
    if bound=0 then
    	f:= @highline
    else
    	f:= @lowline;
    allsines[bound].rewind();
    s:= Sinewave(allsines[bound].advance().element);
    for i:=0 to allsines[bound].length-2 do
        	s:= f(s, Sinewave(allsines[bound].advance().element), 0);
	result:=s;
    end;

function getNextIntersectionIndex(bound: integer; sine: sinewave; offset: integer):integer;
    var inter: TIntersection;
    begin
    while (offset+1<length(intersections[bound])) do
    	begin
    	offset:= offset+1;
        inter:=TIntersection(intersections[bound][offset]);
        if ((sine=inter.sine1) or (sine=inter.sine2)) then
        	begin
            result:=offset;
            exit();
            end;
        end;
    result:= -1;
    end;

function otherIntersectionSine(i: TIntersection; s: sinewave): sinewave;
	begin
    result:=nil;
    if i.sine1=s then
    	result:=i.sine2;
    if i.sine2=s then
    	result:=i.sine1;
    end;


procedure process();
var i, bound, iter:integer;
	sir: SinewaveInRegion;
    s: sinewave;
    p: pointND;
	begin
    Quicksort(intersections[0], @intersectionDouble, length(intersections[0]));
    Quicksort(intersections[1], @intersectionDouble, length(intersections[1]));


    bound:=0;
    sirs[bound]:= linkedlist.create();


    s:=getFirstSine(bound);    //s is highest or lowest sine, depending on bound
    sir:=SinewaveInRegion.create(s, TRegion.create(PointND.create(0), nil));
    sirs[bound].add(sir);
    iter:=getNextIntersectionIndex(bound, s, -1);
    while (iter<>-1) do
    	begin
        s:= otherIntersectionSine(Tintersection(intersections[bound][iter]), s);//swap s to the other sine in intersection
        p:= TIntersection(intersections[bound][iter]).intersection.clone();     //p marks current intersection
		sir.region.bounds[1]:=p;                                                //last SIR's region ends in p...
        sir:= SinewaveInRegion.create(s, TRegion.create(p, nil));               //and the current (with sinewave s) begins on p

        sirs[bound].add(sir);                                                   //add the constructed SIR to the list
        iter:=getNextIntersectionIndex(bound, s, iter);  						//find next intersection that has s
        end;
    sir.region.bounds[1]:= PointND.create(2*pi);




    end;

end.
