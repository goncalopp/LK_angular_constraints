from atomsine import AtomSine
from orderedlist import OrderedList
from atomsine import AtomSine
from sineintersection import SineIntersection
from angulardomain import AngularDomain
from region import Region
from pointnd import PointND

from itertools import combinations
from math import pi

def calculateCenterLimits(rigidgroup, rotation_axis, limits_coordinate, debug=False):
	'''Given a rigidgroup, a rotation axis and a coordinate C, calculates
	the sine waves associated to the allowed translation of the center
	(in C) as a function of the rotation of the group (around
	rotation_axis)'''
	if rotation_axis == limits_coordinate:
		raise Exception("Your are trying to calculate the limits of \
		movements in a coordinate as the group rotates around that same \
		coordinate; not the smartest thing in the world, is it...?")
	#calculates center translation limit FOR EACH atom, as function of
	#rotation
	sines= AtomSine.atomsineListsFromAtomList(rigidgroup.atoms, rotation_axis, limits_coordinate)
	#calculate intersections between sines
	intersections= calculate_intersections(sines)
	#use the intersections to calculate which atom limits the center (the
	# most), as function of rotation
	angulardomains= calculate_bound_limits(sines, intersections)
	#"cut" the domains to prepare for next step 
	sliceRegions(angulardomains)
	#delete invalid rotations (where the center translation upper limit
	#is lower than the lower limit
	validdomains= validRegions(angulardomains)
	
	if debug:
		return (sines, angulardomains, validdomains)	#debug
	return (sines, validdomains)

def other(tuple, myobject):
	'''taking a tuple of 2 objects, if "myobject" is in tuple,
	returns the other object in the tuple, otherwise raises exception'''
	assert len(tuple)==2
	return tuple[(tuple.index(myobject)+1)%2]

def calculate_bound_limits(sine_lists, intersection_orderedlists):
	'''taking the sine list and intersection orderedlist *for each bound*,
	calculates the lowest upper bounds and the highest lower bounds
	along 0--2pi, stores them on angulardomains.
	Consumes intersection orderedlists'''
	angulardomains= [AngularDomain(), AngularDomain()] # one AngularDomain for each bound
	for bound in (0,1):
		sl= sine_lists[bound]
		iol= intersection_orderedlists[bound]
		ad= angulardomains[bound]
		
		current_region= calculate_first_region(bound, sl, iol)
		while current_region:
			ad.insertRegion(current_region)
			current_region= calculate_next_region(current_region, iol)
			
		if len(ad)>0:
			ad[-1][1]= PointND([2*pi])	#close last region
	return angulardomains

def validRegions(angulardomain_list):
	'''given two angulardomains, calculates the valid regions, that is, the regions where
	the sine segment in the lower bound is lower than the upper bound sine segment'''
	ad0, ad1= angulardomain_list[0], angulardomain_list[1]
	gooddomains=[AngularDomain(), AngularDomain()]
	for r1,r2 in zip(ad0,ad1):	#calculates where the domains are valid (upper bound sine > lower bound sine)
		s1,s2= r1.value, r2.value							#sines
		midpoint= r1.midpoint()[0]
		if s1.valueat(midpoint)<=s2.valueat(midpoint):
			gooddomains[0].insertRegion(Region(PointND(r1[0]),PointND(r1[1]), value=r1.value))
			gooddomains[1].insertRegion(Region(PointND(r1[0]),PointND(r1[1]), value=r2.value))
	return gooddomains


def calculate_intersections(sines):
	'''calculates the intersections between each pair of (lower-bound and
	upper bound) sines. Returns two OrderedList (for lower and upper
	bounds) of intersections.'''
	intersections=[[],[]]
	for bound in (0,1):
		for sine1, sine2 in combinations(sines[bound], 2):
				intersectionsine= sine1-sine2
				zeros= intersectionsine.calculateZeros()
				intersection_list= [ SineIntersection(sine1, sine2, zero) for zero in zeros]
				intersections[bound].extend( intersection_list )

	k= lambda x: x.angle
	ordered_intersections=[ OrderedList(intersections[i], key=k) for i in (0,1) ]
	return ordered_intersections


def calculate_first_region(bound, sinelist, intersection_orderedlist):
	'''auxiliary function to calculate_bound_limits. calculates the first
	Region, with correct beggining (0) and sine that is minimum/maximum
	in that Region, depending on Bound. Trims intersection_orderedlist
	if it's first intersections are on angle 0'''
	ending_intersections= intersection_orderedlist.peekMinimums()
	if ending_intersections and ending_intersections[0].angle==0.0: #current ending angle is 0, not what we want
			intersection_orderedlist.popMinimums()	#remove the intersections on 0
			ending_intersections= intersection_orderedlist.peekMinimums()	#and get the next ones
		
	if ending_intersections:
		beginning_angle=0.0
		ending_angle= ending_intersections[0].angle[0] # "0" is arbitrary, since all the intersections here have the same angle
	else:		#there are no intersections
		beginning_angle=0.0
		ending_angle= 2*pi
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
	current_sine= current_region.value
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
	
def sliceRegions(angulardomain_list):
	'''takes two angular domains (for lower/upper vound sine segments), slices them
	so they are cut in the same points and slices them in their intersection points.
	Everything is done in-place (inputs objects of function are modified)'''
	ad0, ad1= angulardomain_list[0], angulardomain_list[1]
	ad0.doubleCut(ad1)

	i=0
	while i<len(ad0):		#cuts where sines from both angulardomains intersect
		r1,r2=ad0[i], ad1[i]
		sine1, sine2 = r1.value, r2.value
		intersections= (sine1-sine2).calculateZeros()
		for intersection in intersections:
			if r1.pointInside(intersection):
				ad0.cutRegionOnPoint(i, intersection)
				i=ad1.cutRegionOnPoint(i, intersection)
		i+=1
	assert len(ad0)==len(ad1)

