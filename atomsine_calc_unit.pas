unit atomsine_calc_unit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, dialogs, atom_unit, sinewave_unit, pointnd_unit, sinewaveinregion_unit,
  Graphics, region_unit, linkedlist_unit, quicksort_unit, mydebugger_unit;

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
	s, maxs: sinewave;
    f: Tgetmaximumfunction;
    begin
    if bound=0 then
    	f:= @highline
    else
    	f:= @lowline;
    allsines[bound].rewind();
    s:= Sinewave(allsines[bound].advance().element);
    maxs:=s;
    for i:=0 to allsines[bound].length-2 do
		begin
       	s:= Sinewave(allsines[bound].advance().element);
        maxs:=f(maxs,s, 0);
    	end;
	result:=maxs;
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

function validRegions(): LinkedList;
var currentsirs: array [0..1] of LinkedNode; // ..of SinewaveInRegion;
	valid_beggining, valid_ending, valid_current_region: boolean;
    current_valid_region, current_region_intersection: TRegion;
	intersection: PointND;
    done_sir, i: integer;
    intersectionwave: sinewave;
	begin
    for i:=0 to 1 do
		begin
    	sirs[i].rewind();
        currentsirs[i]:= sirs[i].advance();
        end;

    result:=LinkedList.create();
    current_region_intersection:= TRegion.create(  SineWaveInRegion(currentsirs[0].element).region.bounds[0]  ,         nil        );
    current_valid_region:=nil;

    while ((currentsirs[0]<> nil) and (currentsirs[1]<>nil)) do
    	begin
        done_sir:=0;
        if ((currentsirs[0]=nil) or (SineWaveInRegion(currentsirs[0].element).region.bounds[1].c[0] > SineWaveInRegion(currentsirs[1].element).region.bounds[1].c[0])) then
        	done_sir:= 1;
        current_region_intersection.bounds[1]:=SineWaveInRegion(currentsirs[done_sir].element).region.bounds[1];
        valid_beggining := SineWaveInRegion(currentsirs[0].element).sine.valueat(current_region_intersection.bounds[0].c[0]) < SineWaveInRegion(currentsirs[1].element).sine.valueat(current_region_intersection.bounds[0].c[0]);
        valid_ending    := SineWaveInRegion(currentsirs[0].element).sine.valueat(current_region_intersection.bounds[1].c[0]) < SineWaveInRegion(currentsirs[1].element).sine.valueat(current_region_intersection.bounds[1].c[0]);
        if valid_beggining<>valid_ending then
        	begin     							//change - valid region becomes non-valid, or vice-versa
            intersectionwave:= SineWaveInRegion(currentsirs[0].element).sine.intersectWave(SineWaveInRegion(currentsirs[1].element).sine);
            if current_region_intersection.inside(intersectionwave.getZeros()[0]) then
            	intersection:= intersectionwave.getZeros()[0]
            else
            	intersection:= intersectionwave.getZeros()[1];
            if current_valid_region=nil then          //in the beggining...
            	if valid_beggining then
                	begin
                    current_valid_region:= TRegion.create(PointND.create(0), nil);
                    valid_current_region:= true;
                	end
                else
                	valid_current_region:=false;
            if valid_current_region then
            	begin
                current_valid_region.bounds[1]:=intersection.clone();
                result.add(current_valid_region);
                end
            else
            	begin
                current_valid_region:= Tregion.create( current_region_intersection.bounds[0].clone(), nil );
                end;
            valid_current_region:= not valid_current_region
            end;
    	current_region_intersection.bounds[0]:=current_region_intersection.bounds[1];
        current_region_intersection.bounds[1]:=SinewaveInRegion(currentsirs[done_sir].element).region.bounds[1];
        currentsirs[done_sir]:= sirs[done_sir].advance();
        end;

    if valid_current_region then
            	begin
                current_valid_region.bounds[1]:=intersection.clone();
                result.add(current_valid_region);
                end ;

    result.rewind();                 //all that follows is debug
    for i:=0 to result.length-1 do
    	begin
        current_region_intersection:= Tregion(result.advance().element);
    	showmessage('from ' + floattostr(current_region_intersection.bounds[0].c[0]) + ' to ' +floattostr(current_region_intersection.bounds[1].c[0]));
        end;
    end;


procedure process();
var i,j, bound, iter:integer;
	sir: SinewaveInRegion;
    s: sinewave;
    p: pointND;
    begin
    Quicksort(intersections[0], @intersectionDouble, length(intersections[0]));
    Quicksort(intersections[1], @intersectionDouble, length(intersections[1]));

	for bound:= 0 to 1 do
    	begin
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
    validregions();
    end;

end.
