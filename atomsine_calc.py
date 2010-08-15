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


def merge(l1, l2):
	'''merges 2 ordered lists, without repetitions'''
	result = []
	i=j=0
	while i<len(l1) and j<len(l2):
		if l1[i] < l2[j]:
			if (not result) or l1[i]<>result[-1]:
				result.append(l1[i])
			i+= 1
		else:
			if (not result) or l2[i]<>result[-1]:
				result.append(l2[j])
			j+= 1
	for x in range(i,len(l1)):
		if (not result) or l1[x]<>result[-1]:
				result.append(l1[x])
	for y in range(j, len(l2)):
		if (not result) or l2[y]<>result[-1]:
				result.append(l2[y])
	return result

	
def validRegions():
	angles=[None, None]
	for bound in [0,1]:
		angles[bound]= [sir.region[0][0] for sir in sirs[bound]]
		angles[bound].append(2*pi)
	merged=merge(angles[0], angles[1])
	return merged
		
		
	


def process():
	k=lambda intersection: intersection.angle
	for bound in [0,1]:
		intersections[bound].sort(key=k)
		sine= 	getFirstSine(bound)											#s is highest or lowest sine, depending on bound
		sir= SineInRegion(sine, Region(PointND([0]), None))
		
		sirs[bound].append(sir);
		iter= getNextIntersectionIndex(bound, sine, -1);
		while (iter<>None):
			sine= otherIntersectionSine(intersections[bound][iter], sine)	#swap s to the other sine in intersection
			p= PointND([intersections[bound][iter].angle])					#p marks current intersection
			sir.region.bounds[1]= p 										#last SIR's region ends in p...
			sir= SineInRegion(sine, Region(p, None))			  			#and the current (with sinewave s) begins on p

			sirs[bound].append(sir)											#add the constructed SIR to the list
			iter=getNextIntersectionIndex(bound, sine, iter)  				#find next intersection that has sine
		sir.region.bounds[1]= PointND([2*pi]);

	#validregions();
