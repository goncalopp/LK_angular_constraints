from sine import Sine
from pointnd import PointND
from angulardomain import AngularDomain
from region import Region
from math import pi

class Intersection:
	def __init__(self, sine1, sine2, angle_point):
		self.sines=(sine1,sine2)
		self.angle= angle_point


allsines= [[],[]]
intersections= [[],[]] 
angulardomains= [AngularDomain(),AngularDomain()]

def reset():
	allsines= [[],[]]
	intersections= [[],[]] 
	angulardomains= [AngularDomain(),AngularDomain()]

def  sineFromAtomDomain(atom, bound, coordinate):
	s= Sine.fromPoint(atom.position, PointND([0,0,0]), coordinate)
	s.y= atom.region[bound][(coordinate+2)%3]
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


def validRegions():
	angulardomains[0].doubleCut(angulardomains[1])
	
	i=0
	while i<len(angulardomains[0]):		#cuts where sines from both angulardomains intersect
		r1,r2=angulardomains[0][i],angulardomains[1][i]
		sine1, sine2 = r1.value, r2.value
		intersections= sine1.intersectWave(sine2).calculateZeros()
		for intersection in intersections:
			if r1.pointInside(intersection):
				angulardomains[0].cutRegionOnPoint(i, intersection)
				i=angulardomains[1].cutRegionOnPoint(i, intersection)
		i+=1
	
	
	gooddomain=AngularDomain()
	for i in range(len(angulardomains[0])):	#calculates where the domains are valid (upper bound sine > lower bound sine)
		r1,r2 = angulardomains[0][i], angulardomains[1][i] 	#regions
		s1,s2= r1.value, r2.value							#sines
		midpoint= (r1[0][0]+r1[1][0])/2.0
		if s1.valueat(midpoint)<=s2.valueat(midpoint):
			gooddomain.insertRegion(Region(PointND(r1[0]),PointND(r1[1]), value=r1.value))

	return gooddomain
		



def other(tuple, myobject):
	'''taking a tuple of 2 objects, if "myobject" is in tuple,
	returns the other object in the tuple, otherwise raises exception'''
	for i in [0,1]:
		if tuple[i]==myobject:
			return tuple[(i+1)%2]
	raise Exception('Given object does not belong to this tuple')

	
def calculate_intersections():
	pass #done on addatomtosines

def calculate_first_region(bound, sinelist, intersection_orderedlist):
	'''auxiliary function to calculate_bound_limits. calculates the first
	Region, with correct beggining (0) and sine that in minimum/maximum
	in that Region, depending on Bound. Trims intersection_orderedlist
	if it's first intersections are on angle 0'''
	ending_intersections= intersection_orderedlist.peekMinimums()
	if ending_intersections[0].angle==0.0: #current ending angle is 0, not what we want
		intersection_orderedlist.popMinimums()	#remove the intersections on 0
		ending_intersections= intersection_orderedlist.peekMinimums()	#and get the next ones
	
	beginning_angle=0.0
	ending_angle= ending_intersections[0].angle[0] # "0" is arbitrary, since all the intersections here have the same angle
	midpoint= (beginning_angle+ending_angle) / 2.0
	
	k=lambda sine: sine.valueat(midpoint)
	if bound==0:
		firstsine= max(sinelist, key=k)
	else:
		firstsine= min(sinelist, key=k)
	return Region(  PointND([beginning_angle])  ,  PointND([ending_angle])  , value= firstsine)
	
def calculate_next_region(current_region, intersection_orderedlist):
	'''auxiliary function to calculate_bound_limits. given the current
	processed region, closes it and calculates the next one.'''
	cr= current_region
	current_sine= current_region.value #cs: current sine
	eis=[] #eis: ending intersections
	while len(eis)==0:
		eis= intersection_orderedlist.popMinimums()
		if len(eis)==0:
			return None
		eis= filter( lambda x: current_sine in x.sines, eis) # gives the intersections that have current_sine
	if not len(eis)==1:
		raise Exception('ALGORITHM ERROR: found more than one sine that intersects current_sine on the same angle')
	ei= eis[0] #ei: ending intersection
	
	cr[1]= PointND(ei.angle)	#closes last Region
	new_beggining=   PointND(ei.angle)
	new_sine= other(ei.sines, cr.value)	#takes the other sine in the intersection
	new_region= Region(new_beggining, None, value=new_sine)
	return new_region
	

def calculate_bound_limits(sine_lists, intersection_orderedlists):
	'''taking the sine list and intersection orderedlist *for each bound*,
	calculates the lowest upper bounds and the highest lower bounds
	along 0--2pi, stores them on angulardomains.
	Consumes intersection orderedlists'''
	angulardomains= [AngularDomain(), AngularDomain()] # one AngularDomain for each bound
	for bound in [0,1]:
		sl= sine_lists[bound]
		iol= intersection_orderedlists[bound]
		ad= angulardomains[bound]
		
		current_region= calculate_first_region(bound, sl, iol)
		ad.insertRegion(current_region)
		while len(iol)>0:
			current_region= calculate_next_region(current_region, iol)
			if current_region==None:
				current_region= ad[-1]
				break
			ad.insertRegion(current_region)
			
		current_region[1]= PointND([2*pi])	#close last region
	return angulardomains