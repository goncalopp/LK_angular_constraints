from sine import Sine
from pointnd import PointND
from angulardomain import AngularDomain
from region import Region
from math import pi

class Intersection:
	def __init__(self, sine1, sine2, angle_point):
		self.sine1= sine1
		self.sine2= sine2
		self.angle= angle_point;


allsines= [[],[]]
intersections= [[],[]] 
angulardomains= [AngularDomain(),AngularDomain()]

def reset():
	allsines= [[],[]]
	intersections= [[],[]] 
	angulardomains= [AngularDomain(),AngularDomain()]

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

def nextSir(indexes):
	i, j= indexes[0], indexes[1]
	try:
		a= sirs[0][i]
	except:
		try:
			b=sirs[1][j]
			return 1
		except:
			return None
	try:
		b= sirs[1][j]
	except:
		return 0

		
	if sirs[0][i].region[1]<sirs[1][j].region[1]:
		return 0
	else:
		return 1



	
def validRegions():

	while (True):
		a=raw_input()
		if not a:
			break
		print eval(a)
	


def process():
	k=lambda intersection: intersection.angle
	for bound in [0,1]:
		intersections[bound].sort(key=k)
		sine=   getFirstSine(bound)									  #s is highest or lowest sine, depending on bound
		region= Region(PointND([0]), None, value=sine)  #creates a region from 0 to Null, holding sine as value
		angulardomains[bound].insertRegion(region)
		iter= getNextIntersectionIndex(bound, sine, -1);
		while (iter<>None):
			sine= otherIntersectionSine(intersections[bound][iter], sine)   #swap s to the other sine in intersection
			p= PointND([intersections[bound][iter].angle[0]])				#p marks current intersection
			region.bounds[1]= p									  #last region ends in p...
			region= Region(PointND(p), None, value=sine)			#and the current (with sinewave s) begins on p
			angulardomains[bound].insertRegion(region)
			iter=getNextIntersectionIndex(bound, sine, iter)				#find next intersection that has sine
		region.bounds[1]= PointND([2*pi]);		#close last region

	#validregions();
