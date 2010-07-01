unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  pointnd_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls, ComCtrls, linkedlist_unit, atom_unit, region_unit, sinewaveInRegion_unit,
  atomsine_calc_unit, mydebugger_unit;

type



  { TForm1 }



  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    frontview: TImage;
    sineview: TImage;
    sideview: TImage;
    perspectiveview: TImage;    
    topview: TImage;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure drawPoint(p, lowlimit, highlimit:pointND; size: integer);
    procedure drawCenterDomainCalculation();
    procedure drawSine(sine: sinewaveinregion);
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
        //angle:=PointND.create(i/sineview.Width*  0.007);
        //tmp:= trunc(sine.sine.valueat(angle.c[0])/0.2);
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

procedure TForm1.drawSine(sine:sinewave);
var tmpsir: sinewaveinregion;
	tmpregion: TRegion;
	begin
    tmpregion:=TRegion.create(PointND.create(0), PointND.create(2*pi));
	tmpsir:=sinewaveinregion.create(sine, tmpregion);
    drawsine(tmpsir);
    tmpsir.destroy();
    tmpregion.destroy();
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

    if checkbox1.checked then
    	begin
        allsines[0].rewind();
   	 	for i:=0 to allsines[0].length-1 do
            drawsine(sinewave(allsines[0].advance().element));
        end;

    if checkbox2.checked then
    	begin
        allsines[1].rewind();
   	 	for i:=0 to allsines[1].length-1 do
            drawsine(sinewave(allsines[1].advance().element));
        end;

    if checkbox3.checked then
    	begin
        sirs[0].rewind();
   	 	for i:=0 to sirs[0].length-1 do
            drawsine(sinewaveinregion(sirs[0].advance().element));
        end;

    if checkbox4.checked then
    	begin
        sirs[1].rewind();
   	 	for i:=0 to sirs[1].length-1 do
            drawsine(sinewaveinregion(sirs[1].advance().element));
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
    setlength(intersections[0],0);
    setlength(intersections[1],0);
    for i:=0 to length(rigid.atoms)-1 do
    	begin
        atomsine_calc_unit.addAtomtoSines(rigid.atoms[i], 1, (i*$200000) mod $AA0000 + (i*$005000) mod $00FF00 + (i*$000090) mod $0000FF )
       	end;

    atomsine_calc_unit.process();
    end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
	x,y,z,x1,x2,y1,y2,z1,z2:double;
    tf: textfile;
    s:string;
	begin
    dbg:= mydebugger.create('debug.log');

    assignfile(tf,'./debug.group');
    reset(tf);
    rigid:= rigidgroup.Create();

    for i:=0 to 2 do
    	begin
        {x:= random()*120;
        y:= random()*120;
        z:= random()*120;
        x1:= x-10+random();
        y1:= y-10+random();
        z1:= z-10+random();
        x2:= x+10+random();
        y2:= y+10+random();
        z2:= z+10+random();  }

        readln(tf,s);
        x:= strtofloat(s);
        readln(tf,s);
        x1:=strtofloat(s);
        readln(tf,s);
        x2:=strtofloat(s);
        readln(tf,s);
        y:= strtofloat(s);
        readln(tf,s);
        y1:=strtofloat(s);
        readln(tf,s);
        y2:=strtofloat(s);
        readln(tf,s);
        z:= strtofloat(s);
        readln(tf,s);
        z1:=strtofloat(s);
        readln(tf,s);
        z2:=strtofloat(s);
        readln(tf,s);


		rigid.addAtom(PointND.create(x,y,z), pointND.create(x1, y1, z1), pointND.create(x2, y2, z2));
        //dbg.write(rigid.atoms[high(rigid.atoms)].toText());
    	end;
    rigid.recalculateCenter();
    calculateSines();


    dbg.close;
    timer1.enabled:=true;

    //rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;



initialization
  {$I unit1.lrs}

end.

