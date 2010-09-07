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
	raise Exception('Given sine does not belong to this intersection')


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
	for i in range(len(angulardomains[0])):
		r1,r2 = angulardomains[0][i], angulardomains[1][i] 	#regions
		s1,s2= r1.value, r2.value							#sines
		midpoint= (r1[0][0]+r1[1][0])/2.0
		if s1.valueat(midpoint)<=s2.valueat(midpoint):
			gooddomain.insertRegion(Region(PointND(r1[0]),PointND(r1[1]), value=r1.value))

	return gooddomain
		

def process():
	'''calculates the lowest upper bounds and the highest lower bounds along 0--2pi,
	stores them on angulardomains'''
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
