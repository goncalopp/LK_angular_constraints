unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  pointnd_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls, linkedlist_unit, atom_unit, region_unit, sinewaveInRegion_unit;

type


  Tpointndarray = array of PointND;
  Tsinewaveinregionarray = array of SinewaveInRegion;
  Tgetmaximumfunction = function(sine1, sine2: sinewave; point: double): sinewave;
  { TForm1 }



  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    frontview: TImage;
    sineview: TImage;
    sideview: TImage;
    perspectiveview: TImage;    
    topview: TImage;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure drawPoint(p, lowlimit, highlimit:pointND; size: integer);
    procedure drawCenterDomainCalculation();
    procedure drawSine(sine: sinewave);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  rigid: rigidgroup;
  sines: array [0..1] of linkedList;
  trackbarposition: integer=0;

implementation

{ TForm1 }


function xtransformation(x: double): integer;
	begin
    result:= trunc(x+120);
	end;

function ytransformation(y: double): integer;
	begin
    result:= trunc(240- (y+120) );
    end;

procedure TForm1.drawCenterDomainCalculation();
var i: integer;
 	begin
    frontview.Canvas.Clear();
	sideview.Canvas.Clear();
	topview.Canvas.Clear();
	perspectiveview.Canvas.Clear();

    for i:=0 to length(rigid.atoms)-1 do
		begin
        drawPoint(rigid.atoms[i].position, rigid.atoms[i].adomain.goodregion.bounds[0], rigid.atoms[i].adomain.goodregion.bounds[1], 2);
		end;

    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(160,0);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(800,120);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(40,240);
    application.processmessages();
    end;

procedure TForm1.drawPoint(p, lowlimit, highlimit:pointnd; size: integer);
	begin
    frontview.Canvas.Rectangle(
    					xtransformation(lowlimit.x^), ytransformation(lowlimit.y^),
        				xtransformation(highlimit.x^), ytransformation(highlimit.y^)
						);


    frontview.Canvas.Rectangle(
    					xtransformation(p.x^)-size, ytransformation(p.y^)-size,
        				xtransformation(p.x^)+size, ytransformation(p.y^)+size
						);



	sideview.Canvas.Rectangle(
    					xtransformation(p.z^)-size, ytransformation(p.y^)-size,
        				xtransformation(p.z^)+size, ytransformation(p.y^)+size
						);

	topview.Canvas.Rectangle(
    					xtransformation(p.x^)-size, ytransformation(p.z^)-size,
        				xtransformation(p.x^)+size, ytransformation(p.z^)+size
						);
    perspectiveview.Canvas.Rectangle(
    					xtransformation(p.x^/1+p.z^*1.41/5)-size, ytransformation(p.y^/1+p.z^*1.41/5)-size,
        				xtransformation(p.x^/1+p.z^*1.41/5)+size, ytransformation(p.y^/1+p.z^*1.41/5)+size
						);

	perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(xtransformation(p.x^/1+p.z^*1.41/5) ,ytransformation(p.y^/1+p.z^*1.41/5));
	end;

procedure TForm1.drawSine(sine: sinewave);
var i, tmp: integer;
	begin
    sineview.Canvas.Pen.Color:=sine.color;
    sineview.Canvas.moveto(0, (sineview.height div 2) - trunc(sine.valueat(0)));
    for i:=1 to sineview.width do
    	begin
        tmp:= trunc(sine.valueat(i/sineview.Width*  2*pi)/1.8);
        sineview.Canvas.lineto(i, (sineview.height div 2) - tmp);
        end;

	sineview.Canvas.Pen.Color:=$AAAAAA;
	sineview.Canvas.moveto(0, sineview.height div 2);
    sineview.Canvas.lineto(sineview.width, sineview.height div 2);
    sineview.Canvas.Pen.Color:=0;
    end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
	rigid.rotateOver( 'z', double(trackbar1.Position-trackbarposition)/201*2*pi);
    trackbarposition:=trackbar1.Position;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var root, i,j:integer;
	begin
    drawCenterDomainCalculation();
    sineview.canvas.clear();

    for j:=0 to 1 do
    	begin
        sines[j].rewind();
   	 	for i:=0 to sines[0].length-1 do
            drawsine(sinewave(sines[j].advance));
        end;

	root:=trunc  (trackbarposition/201*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);

	end;

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
function sineIntersectionsInRegion(sine, sine2: sinewave; region: Region): Tpointndarray;
var intersectionsine: sinewave;
	intersection1, intersection2: PointND;
	begin
    intersectionsine:=sine.intersectWave(sine2);
    intersection1:=PointND.create(intersectionsine.zeros[0]);
    intersection2:=PointND.create(intersectionsine.zeros[1]);
    intersectionsine.destroy();

    if region.inside(intersection1)
    	then
        if region.inside(intersection2) then
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
    	if region.inside(intersection2) then
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

function maximizeSinesInRegion(sine1, sine2: sinewave; region: Region; maximumFunction: Tgetmaximumfunction): TsinewaveInRegionArray;
var intersections: array of PointND;
	i: integer;
    var mean: double;
	maxsine: sinewave;
	begin
    intersections:=sineIntersectionsInRegion(sine1, sine2, region);

    setlength(intersections, length(intersections) +2);  //shift intersections,
    for i:= length(intersections)-3 to 0 do              //so we can insert 2 new,
    	intersections[i+1]:=intersections[i];            //on beginning and end of array
    intersections[0]:=region.bounds[0];
    intersections[length(intersections)-1]:=region.bounds[1];

    for i:=0 to length(intersections)-2 do
    	begin
        mean:= (intersections[i].c[0] + intersections[i+1].c[0]) /2 ;
    	maxsine:= maximumFunction(sine1, sine2, mean);
    	if (i>0) and (maxsine=result[length(result)-1].sine) then
    		begin
            result[length(result)-1].region.bounds[1]:=intersections[i+1];
            intersections[i].destroy();
        	end
        else
        	begin
            setlength(result, length(result)+1);
            result[length(result)-1]:=sinewaveinregion.create();
            result[length(result)-1].region:= Region.create(intersections[i], intersections[i+1]);
            result[length(result)-1].sine:=maxsine;
            end;
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
	iteratedsine: sinewaveInRegion;
    maxsines: array of sinewaveInRegion;
	i, j, bound:integer;
	begin
    for bound:=0 to 1 do
    	begin
        sines[bound].rewind();
        atomsine:= sineFromAtomDomain(a, coordinate, bound);
        atomsine.color:=color;

        if sines[bound].length=0 then
        	sines[bound].addElement(atomsine)

        else
            for i:=0 to sines[bound].length - 1 do
            	begin
                iteratedsine:= sineWaveInRegion(  sines[bound].advance()  );
                //maxsines(sines[bound], iteratedsine.sine, iteratedsine.region,  sines );
                for j:= 0 to length(maxsines)-1 do
                	sines[bound].addElement(maxsines[j]);
                end;

    	end;
    end;

procedure calculateSines();
    var i:integer;
	begin
    sines[0]:= linkedlist.create();
    sines[1]:= linkedlist.create();
    for i:=0 to length(rigid.atoms)-1 do
    	begin
        addAtomtoSines(rigid.atoms[i], 1, (i*$D2A67A) mod $FFFFFF)
       	end;

    end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
	x,y,z:double;
	begin
    rigid:= rigidgroup.Create();

    for i:=0 to 1 do
    	begin
        x:= random()*120;
        y:= random()*120;
        z:= random()*120;
		rigid.addAtom(PointND.create(x,y,z), pointND.create(x-10, y-10, z-10), pointND.create(x+10, y+10, z+10));
    	end;
    rigid.recalculateCenter();

    calculateSines();

    timer1.enabled:=true;

    //rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;

procedure TForm1.Button2Click(Sender: TObject);
begin

end;

initialization
  {$I unit1.lrs}

end.

