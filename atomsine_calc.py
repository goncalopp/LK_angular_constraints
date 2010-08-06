from sine import Sine
from pointnd import PointND
from sineinregion import SineInRegion
from region import Region
from math import pi

class Intersection:
	def __init__(self, sine1, sine2, angle_point):
		self.sine1= sine1
		self.sine2= sine2
		self.angle= angle_point;


allsines= [[],[]]
intersections= [[],[]] 
sirs= [[],[]]

def reset():
	allsines= [[],[]]
	intersections= [[],[]] 
	sirs= [[],[]]

def  sineFromAtomDomain(atom, bound, coordinate):
	s= Sine.fromPoint(atom.position, PointND([0,0,0]), coordinate)
	s.y= atom.region[bound][0]
	return s


def addAtomToSines(atom, coordinate):
	for bound in [0,1]:
		newsine= sineFromAtomDomain(atom, bound, coordinate)
		for oldsine in allsines[bound]:
			intersectionsine= oldsine.intersectWave(newsine)
			zeros= intersectionsine.calculateZeros()
			for zero in zeros:
				intersections[bound].append( Intersection(newsine, oldsine, zero) )
		allsines[bound].append(newsine);


def getFirstSine(bound):
	k=lambda sine: sine.valueat(0)
	if bound==0:
		return max(allsines[bound], key=k)
	else:
		return min(allsines[bound], key=k)


def getNextIntersectionIndex(bound, sine, offset):
	for i in range(offset+1, len(intersections[bound])):
		if sine==intersections[bound][i].sine1 or sine==intersections[bound][i].sine2:
			return i
	return None

def otherIntersectionSine(intersection, sine):
	if intersection.sine1==sine:
		return intersection.sine2
	if intersection.sine2==sine:
		return intersection.sine1



'''function validRegions(): LinkedList;
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
	current_region_intersection:= TRegion.create(  SineWaveInRegion(currentsirs[0].element).region.bounds[0]  ,		 nil		);
	current_valid_region:=nil;

	while ((currentsirs[0]<> nil) and (currentsirs[1]<>nil)) do
		begin
		done_sir:=0;
		if ((currentsirs[0]=nil) or (SineWaveInRegion(currentsirs[0].element).region.bounds[1].c[0] > SineWaveInRegion(currentsirs[1].element).region.bounds[1].c[0])) then
			done_sir:= 1;
		current_region_intersection.bounds[1]:=SineWaveInRegion(currentsirs[done_sir].element).region.bounds[1];
		valid_beggining := SineWaveInRegion(currentsirs[0].element).sine.valueat(current_region_intersection.bounds[0].c[0]) < SineWaveInRegion(currentsirs[1].element).sine.valueat(current_region_intersection.bounds[0].c[0]);
		valid_ending	:= SineWaveInRegion(currentsirs[0].element).sine.valueat(current_region_intersection.bounds[1].c[0]) < SineWaveInRegion(currentsirs[1].element).sine.valueat(current_region_intersection.bounds[1].c[0]);
		if valid_beggining<>valid_ending then
			begin	 							//change - valid region becomes non-valid, or vice-versa
			intersectionwave:= SineWaveInRegion(currentsirs[0].element).sine.intersectWave(SineWaveInRegion(currentsirs[1].element).sine);
			if current_region_intersection.inside(intersectionwave.getZeros()[0]) then
				intersection:= intersectionwave.getZeros()[0]
			else
				intersection:= intersectionwave.getZeros()[1];
			if current_valid_region=nil then		  //in the beggining...
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

	result.rewind();				 //all that follows is debug
	for i:=0 to result.length-1 do
		begin
		current_region_intersection:= Tregion(result.advance().element);
		showmessage('from ' + floattostr(current_region_intersection.bounds[0].c[0]) + ' to ' +floattostr(current_region_intersection.bounds[1].c[0]));
		end;
	end;
'''

def process():
	k=lambda intersection: intersection.angle
	for bound in [0,1]:
		intersections[bound].sort(key=k)
		sine= 	getFirstSine(bound)													#s is highest or lowest sine, depending on bound
		sir= SineInRegion(sine, Region(PointND([0]), None))
		
		sirs[bound].append(sir);
		iter= getNextIntersectionIndex(bound, sine, -1);
		while (iter<>None):
			sine= otherIntersectionSine(intersections[bound][iter], sine)					#swap s to the other sine in intersection
			p= PointND([intersections[bound][iter].angle])						#p marks current intersection
			sir.region.bounds[1]= p 													#last SIR's region ends in p...
			sir= SineInRegion(sine, Region(p, None))			  						 #and the current (with sinewave s) begins on p

			sirs[bound].append(sir)												   #add the constructed SIR to the list
			iter=getNextIntersectionIndex(bound, sine, iter)  						#find next intersection that has s
		sir.region.bounds[1]= PointND([2*pi]);

	#validregions();
