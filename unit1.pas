unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  domain_unit, region_unit, atom_unit, point3d_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls, linkedlist_unit;

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
    procedure Timer1Timer(Sender: TObject);
    procedure drawPoint(p, lowlimit, highlimit:point3d; size: integer);
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
  uppersines: linkedlist;
  lowersines: linkedlist;
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
var i: integer; p: point3d;
 	begin
    frontview.Canvas.Clear();
	sideview.Canvas.Clear();
	topview.Canvas.Clear();
	perspectiveview.Canvas.Clear();

    for i:=0 to length(rigid.atoms)-1 do
		begin
        drawPoint(rigid.atoms[i].position, rigid.atoms[i].adomain.goodregion.point1, rigid.atoms[i].adomain.goodregion.point2, 2);
		end;

    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(160,0);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(800,120);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(40,240);
    application.processmessages();
    end;

procedure TForm1.drawPoint(p, lowlimit, highlimit:point3d; size: integer);
var x1,x2,y1,y2,z1,z2: integer;
	begin
    frontview.Canvas.Rectangle(
    					xtransformation(lowlimit.x), ytransformation(lowlimit.y),
        				xtransformation(highlimit.x), ytransformation(highlimit.y)
						);
    frontview.Canvas.Rectangle(
    					xtransformation(p.x)-size, ytransformation(p.y)-size,
        				xtransformation(p.x)+size, ytransformation(p.y)+size
						);



	sideview.Canvas.Rectangle(
    					xtransformation(p.z)-size, ytransformation(p.y)-size,
        				xtransformation(p.z)+size, ytransformation(p.y)+size
						);

	topview.Canvas.Rectangle(
    					xtransformation(p.x)-size, ytransformation(p.z)-size,
        				xtransformation(p.x)+size, ytransformation(p.z)+size
						);
    perspectiveview.Canvas.Rectangle(
    					xtransformation(p.x/1+p.z*1.41/5)-size, ytransformation(p.y/1+p.z*1.41/5)-size,
        				xtransformation(p.x/1+p.z*1.41/5)+size, ytransformation(p.y/1+p.z*1.41/5)+size
						);

	perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(xtransformation(p.x/1+p.z*1.41/5) ,ytransformation(p.y/1+p.z*1.41/5));
	end;

procedure TForm1.drawSine(sine: sinewave);
var i, tmp: integer;
	begin
    sineview.Canvas.moveto(0, (sineview.height div 2) - trunc(sine.valueat(0)));
    for i:=1 to sineview.width do
    	begin
        sineview.Canvas.lineto(i, (sineview.height div 2) - trunc(sine.valueat(i/sineview.Width*  2*pi)));
        tmp:= trunc(sine.valueat(i/sineview.Width*  2*pi));
        end;

	sineview.Canvas.Pen.Color:=$AAAAAA;
	sineview.Canvas.moveto(0, sineview.height div 2);
    sineview.Canvas.lineto(sineview.width, sineview.height div 2);
    sineview.Canvas.Pen.Color:=0;
    end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
	rigid.rotateOver( 'z', double(trackbar1.Position-trackbarposition)/200*2*pi);
    trackbarposition:=trackbar1.Position;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var root, i:integer; sine: sinewave;
	begin
    drawCenterDomainCalculation();
    sineview.canvas.clear();

    uppersines.rewind();
    lowersines.rewind();
    for i:=0 to uppersines.counter-1 do
        	begin
            drawsine(sinewave(uppersines.advance));
            drawsine(sinewave(lowersines.advance));
         	end;
	root:=trunc  (trackbarposition/201*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);

	end;



procedure TForm1.Button1Click(Sender: TObject);
var i:integer; tmppoint: Point3D;
	x,y,z:double;
	begin
    rigid:= rigidgroup.Create();

    for i:=0 to 2 do
    	begin
        x:= random()*120;
        y:= random()*120;
        z:= random()*120;
		rigid.addAtom(Point3d.create(x,y,z), point3d.create(x-10, y-10, z-10), point3d.create(x+10, y+10, z+10));
    	end;
    rigid.recalculateCenter();

    uppersines:= linkedlist.create();
    lowersines:= linkedlist.create();

    for i:=0 to length(rigid.atoms)-1 do
        with rigid.atoms[i] do
        	begin
            tmppoint:=adomain.goodregion.point1.clone();
            tmppoint.vectorFrom(position);
        	lowersines.addElement(Sinewave.create(position.norm(),position.angleInProjection(0,2),tmppoint.x));
            tmppoint.Destroy();

            tmppoint:=adomain.goodregion.point2.clone();
            tmppoint.vectorFrom(position);
        	uppersines.addElement(Sinewave.create(position.norm(),position.angleInProjection(0,2),tmppoint.x));
            tmppoint.Destroy();
            end;

    timer1.enabled:=true;
    //rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;


initialization
  {$I unit1.lrs}

end.

