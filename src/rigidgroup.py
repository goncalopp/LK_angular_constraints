from pointnd import PointND
from atomsine import AtomSine
from sineintersection import SineIntersection
from orderedlist import OrderedList
from angulardomain import AngularDomain
from sine import Sine
from region import Region
from atom import Atom
from math import pi, trunc
from itertools import combinations

def other(tuple, myobject):
	'''taking a tuple of 2 objects, if "myobject" is in tuple,
	returns the other object in the tuple, otherwise raises exception'''
	assert len(tuple)==2
	return tuple[(tuple.index(myobject)+1)%2]

class RigidGroup:
	'''Represents a rigid group of atoms'''
	def __init__(self):
		self.center= PointND([0,0,0])
		self.atoms=[]
    
	def addAtom(self, position, lowerlimit, upperlimit):
		position-=		self.center	#
		lowerlimit-=	self.center	#transform in local coordinates
		upperlimit-=	self.center	#
		self.atoms.append(Atom(position, lowerlimit, upperlimit))                                                                       

	def recalculateCenter(self):
		sum= PointND([0,0,0])
		for atom in self.atoms:
			sum+=atom.position
		sum*= 1.0/len(self.atoms)
		translation= PointND(sum)
		translation-= self.center
		self.center= sum
		for atom in self.atoms:
			atom.position-=translation
			atom.region.bounds[0]-=translation;
			atom.region.bounds[1]-=translation;

	def rotateOver(self, rotationaxis, angle):
		for atom in self.atoms:
			atom.position.rotate3D(rotationaxis, angle)

	def calculateCenterRegion(self, x_angle_step, y_angle_step):
		centerRegion= Region(PointND(-10e9, -10e9, -10e9), PointND(10e9, 10e9, 10e9))
		y_steps= trunc((2*pi) / y_angle_step)
		x_steps=trunc( pi/x_angle_step )   #no need to do 360 to cover 3D space, only 180
		for x in range(x_steps):
			self.rotateOver(0, x_angle_step);
			for y in range(y_steps):
				self.rotateOver(1, y_angle_step)
				for atom in self.atoms:
					pass
					
	@staticmethod
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

	@staticmethod
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
	
	@staticmethod
	def calculate_intersections(sines):
		'''calculates the intersections between each pair of (lower-bound and
		upper bound)sines. Returns two lists (for lower and upper bounds) of
		intersections, ordered.'''
		intersections=[[],[]]
		for bound in (0,1):
			for sine1, sine2 in combinations(sines[bound], 2):
					intersectionsine= sine1-sine2
					zeros= intersectionsine.calculateZeros()
					intersection_list= [ SineIntersection(sine1, sine2, zero) for zero in zeros]
					intersections[bound].extend( intersection_list )
		return intersections
	
	@staticmethod
	def calculate_first_region(bound, sinelist, intersection_orderedlist):
		'''auxiliary function to calculate_bound_limits. calculates the first
		Region, with correct beggining (0) and sine that is minimum/maximum
		in that Region, depending on Bound. Trims intersection_orderedlist
		if it's first intersections are on angle 0'''
		ending_intersections= intersection_orderedlist.peekMinimums()
		if ending_intersections:
			if ending_intersections[0].angle==0.0: #current ending angle is 0, not what we want
				intersection_orderedlist.popMinimums()	#remove the intersections on 0
				ending_intersections= intersection_orderedlist.peekMinimums()	#and get the next ones
			
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
	
	@staticmethod
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
		
	@staticmethod
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
			
			current_region= RigidGroup.calculate_first_region(bound, sl, iol)
			while current_region:
				ad.insertRegion(current_region)
				current_region= RigidGroup.calculate_next_region(current_region, iol)
			if len(ad)>0:
				ad[-1][1]= PointND([2*pi])	#close last region
		
		return angulardomains

	@staticmethod
	def calculate_atom_limits(validdomains, sines, coordinate):
		'''given the list of valid angles and the list of sines, calculates
		the reduced atom limits; returns them in a dictionary of atom'''
		sines_minmax={}	#dictionary. key: atom. value: list of float [min,max]
		for bound in (0,1):
			for region in validdomains[bound]:
				limiting_sine= region.value
				for atom_sine in sines[bound]:
					atom= atom_sine.atom
					tmp_sine= Sine().fromPoint(None, atom.position, coordinate) #TODO: maybe use AtomSine
					limits_sine= tmp_sine + limiting_sine
					if not atom in sines_minmax:
						sines_minmax[atom]= [float('inf'), -float('inf')]
					minmax= sines_minmax[atom]
					if bound==0:
						minmax[0]= min(minmax[0], limits_sine.minInRegion(region))
					if bound==1:
						minmax[1]= max(minmax[1], limits_sine.maxInRegion(region))
		return sines_minmax



	def solve_instance(self, coordinate, debug=False):
		'''main function. Given an atom list and a coordinate, calculates the
		sine waves associated to the variation of that coordinate when each
		atom rotates, and using those it calculates on which rotations the
		atoms are on valid positions (inside their domains). Using that data,
		each atom domain is reduced to the strictly necessary, ensuring no
		valid group positions are lost.'''
		atomlist= self.atoms
		sines= AtomSine.atomsineListsFromAtomList(atomlist, coordinate)
		intersections= RigidGroup.calculate_intersections(sines)
		ordered_intersections=[ OrderedList(intersections[i], key=lambda x: x.angle) for i in (0,1) ]
		angulardomains= RigidGroup.calculate_bound_limits(sines, ordered_intersections)
		RigidGroup.sliceRegions(angulardomains)
		validdomains= RigidGroup.validRegions(angulardomains)
		#validdomains.mergeAdjacentRegions()
		newlimits= RigidGroup.calculate_atom_limits(validdomains, sines, coordinate)
		
		if debug:
			return (sines, angulardomains, validdomains, newlimits)	#debug
		return validdomains
	
