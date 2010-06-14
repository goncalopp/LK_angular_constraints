unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  pointnd_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls, linkedlist_unit, atom_unit, region_unit, sinewaveInRegion_unit,
  atomsine_calc_unit;

type



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
    procedure drawSine(sine: sinewaveinregion);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  rigid: rigidgroup;

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

procedure TForm1.drawSine(sine: sinewaveinregion);
var i, tmp: integer;
	angle: PointND;
	begin

    for i:=1 to sineview.width do
    	begin
        angle:=PointND.create(i/sineview.Width*  2*pi);
        tmp:= trunc(sine.sine.valueat(angle.c[0])/1.8);
        sineview.Canvas.moveto(i-1, (sineview.height div 2) - tmp);
        if sine.region.inside(angle) then
        	begin
            sineview.Canvas.Pen.Color:=sine.sine.color;
            sineview.Canvas.lineto(i, (sineview.height div 2) - tmp);
            end;

        angle.destroy();
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

    for j:=0 to 0 do
    	begin
        sirs[j].rewind();
   	 	for i:=0 to sirs[j].length-1 do
            drawsine(sinewaveinregion(sirs[j].advance().element));
        end;

	root:=trunc  (trackbarposition/201*sineview.Width);
    sineview.Canvas.moveto(root, sineview.canvas.height);
    sineview.Canvas.lineto(root,0);

	end;


procedure calculateSines();
    var i:integer;
    sine: sinewaveinregion;
	begin
    allsines[0]:= linkedlist.create();
    allsines[1]:= linkedlist.create();
    for i:=0 to length(rigid.atoms)-1 do
    	begin
        atomsine_calc_unit.addAtomtoSines(rigid.atoms[i], 1, (i*$200000) mod $AA0000 + (i*$005000) mod $00FF00 + (i*$000090) mod $0000FF )
       	end;

    atomsine_calc_unit.process();
    end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
	x,y,z:double;
	begin
    rigid:= rigidgroup.Create();

    for i:=0 to 2 do
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
var r1,r2: TRegion;
begin
r1:= TRegion.create(PointND.create(0,3),PointND.create(5,7));
r2:= TRegion.create(PointND.create(1,2),PointND.create(6,3));
r2:= r2.intersect(r1);
showmessage(floattostr(r2.bounds[0].c[0])+' '+floattostr(r2.bounds[1].c[0])+#13#10+floattostr(r2.bounds[0].c[1])+' '+floattostr(r2.bounds[1].c[1]))

end;


initialization
  {$I unit1.lrs}

end.

