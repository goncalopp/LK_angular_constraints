from region import Region
from rigidgroup import RigidGroup
from sine import Sine
from pointnd import PointND
from rigidgroup_centerlimits import calculateCenterLimits

def calculateAtomLimits(rigidgroup, rotation_axis):
	'''given a rigidgroup (which is in a certain orientation), returns
	an dictionary whose keys are Atoms and values are Regions, which
	represent the new atom limits'''
	#x and y coordinates, for rotating around rotation_axis
	x, y= [(rotation_axis + 1) % 3, (rotation_axis + 2) % 3]
	tmp= [calculateCenterLimits(rigidgroup, rotation_axis, c) for c in (x,y)]
	tmp2= zip(*tmp)	#tmp2 becomes two lists, one of sines, other of angulardomains
	sines= tmp2[0]	#sines[0] is the sines for x-coord, sines[1] for y-coord
	center_domains= tmp2[1]	#...and similarly for the domains
	
	for bound in (0,1):	#intersect the valid domains of the two coordinates
		center_domains[0][bound].intersect(center_domains[1][bound], bothways=True)
	
	atomdomains= [calculateAtomLimits_coord(sines[c], center_domains[c], c) \
	for c in (0,1)]
	
	region_dict= {}	#stores final atom regions
	minmaxes= [calculateAtomLimits_coord(sines[c], center_domains[c], rotation_axis) for c in (0,1)]	
	for atom in rigidgroup.atoms:
		atom_lower_limits= [minmaxes[c][atom][0] for c in (0,1)]
		atom_upper_limits= [minmaxes[c][atom][1] for c in (0,1)]
		print atom_lower_limits
		lower_limit= PointND([float("-inf")]*3)
		upper_limit= PointND([float("inf")]*3)
		lower_limit[x]= atom_lower_limits[0]
		lower_limit[y]= atom_lower_limits[1]
		upper_limit[x]= atom_upper_limits[0]
		upper_limit[y]= atom_upper_limits[1]
		
		region_dict[atom]= Region(lower_limit, upper_limit)
	return region_dict

def calculateAtomLimits_coord(sines, validdomains, coordinate):
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
