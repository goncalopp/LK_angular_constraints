from region import Region
from rigidgroup import RigidGroup
from rigidgroup_centerlimits import calculateCenterLimits

def calculateAtomLimits(rigidgroup):
	'''given a rigidgroup (which is in a certain orientation, returns
	an dictionary whose keys are Atoms and values are Regions, which
	represent the new atom limits'''
	tmp= \
		[calculateCenterLimits(rigidgroup, coordinate)
		for coordinate in (0,1,2)]	#x,y,z
	print "tmp",tmp
	raw_input()
	tmp2= zip(tmp)	#tmp2 becomes two lists, one of sines, other of angulardomains
	sines= tmp2[0]
	centerdomains= tmp2[1]
	
	for bound in (0,1):
		for coord in (0,1,2):
			centerdomains[coord%3][bound].intersect(centerdomains[coord%3][bound], bothways=True)
	
	atomdomains= [calculateAtomLimits_coord(sines[c], center_domains[c], c) \
	for c in (0,1,2)]
	
	region_dict= {}	#stores final atom regions
	for atom in rigidgroup.atoms:
		minmaxes= [centerdomains[c][atom] for c in (0,1,2)]
		lower_limit= PointND([minmaxes[c][0] for c in (0,1,2)])
		upper_limit= PointND([minmaxes[c][1] for c in (0,1,2)])
		region_dict[atom]= Region(lower_limit, upper_limit)
		print atom, lower_limit, upper_limit
	
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
