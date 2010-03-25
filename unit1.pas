unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  domain_unit, region_unit, atom_unit, point3d_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls;

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
  sine1, sine2, sine3: sinewave;
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

    for i:=0 to 2 do
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
var i: integer;
	begin
    sineview.Canvas.moveto(0, (sineview.height div 2) - trunc(50*sine.valueat(0)));
    for i:=1 to sineview.width do
    	begin
        sineview.Canvas.lineto(i, (sineview.height div 2) - trunc(50*sine.valueat(i/sineview.Width*  2*pi)));
        end;

	sineview.Canvas.moveto(0, sineview.height div 2);
    sineview.Canvas.lineto(sineview.width, sineview.height div 2);
    end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
	rigid.rotateOver( 'z', double(trackbar1.Position-trackbarposition)/100*2*pi);
    trackbarposition:=trackbar1.Position;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var root:integer;
	begin
    drawCenterDomainCalculation();
    sineview.canvas.clear();


    sine1.phase:=sine1.phase+6*pi+0.01;
    //sine2.phase:=sine2.phase-4*pi+0.02;

    sine2.invert();
    sine3:=sine1.addWave(sine2);
    sine2.invert();

	root:=trunc  ((sine3.firstZero()/(2*pi))*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);
    root:=trunc  ((sine3.secondZero()/(2*pi))*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);;
    drawSine(sine1);
    drawSine(sine2);
    sineview.canvas.Pen.Color:=clRed;

    drawSine(sine3);
    sineview.canvas.Pen.Color:=$000000;

    sine3.Free();
	end;



procedure TForm1.Button1Click(Sender: TObject);
var i:integer; atomposition, atomupper, atomlower: Point3D;
	x,y,z:double;
	begin
    rigid:= rigidgroup.Create();
    sine1:=sinewave.create(1.5,0,0.5);
    sine2:=sinewave.create(0.8,0,0);
    for i:=0 to 2 do
    	begin
        x:= random()*120;
        y:= random()*120;
        z:= random()*120;

		rigid.addAtom(Point3d.create(x,y,z), point3d.create(x-10, y-10, z-10), point3d.create(x+10, y+10, z+10));
    	end;
    rigid.recalculateCenter();             
    timer1.enabled:=true;

    //rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;


initialization
  {$I unit1.lrs}

end.

