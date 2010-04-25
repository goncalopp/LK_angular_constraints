unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  pointnd_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls, linkedlist_unit, atom_unit, region_unit;

type

  { TForm1 }



  TForm1 = class(TForm)
    Button1: TButton;
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
  sinesdomains: array [0..1] of linkedList;
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
   	 	for i:=0 to sines[0].counter-1 do
            drawsine(sinewave(sines[j].advance));
        end;

	root:=trunc  (trackbarposition/201*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);

	end;



function  sineFromAtomDomain(a: atom; coordinate, bound: integer): SineWave;
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

procedure addAtomToSines(a: atom; coordinate: integer; color: TColor);
var atomsine, intersection, iteratedsine: SineWave;
	domainsine, iterateddomainsine: Region;
	i, bound:integer;
	begin
    for bound:=0 to 1 do
    	begin
        sines[bound].rewind();
        sinesdomains[bound].rewind();
        atomsine:= sineFromAtomDomain(a, coordinate, bound);
        atomsine.color:=color;

        if sines[bound].counter=0 then
        	begin
            sines[bound].addElement(atomsine);
            sinesdomains[bound].addElement(region.create(pointnd.create(0), pointnd.create(2*pi)));
    		end
        else
            for i:=0 to sines[bound].counter - 1 do
            	begin
                iteratedsine:= sineWave(  sines[bound].advance()  );
                iterateddomainsine:= Region(  sinesdomains[bound].advance()  );
                intersection:=atomsine.intersectWave(iteratedsine);
               // if iterateddomainsine.inside(intersection.zeros[0]) then

                end;

    	end;
    end;

procedure calculateSines();
    var i:integer;
	begin
    sinesdomains[0]:= linkedlist.create();
    sinesdomains[1]:= linkedlist.create();
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

initialization
  {$I unit1.lrs}

end.

