from rigidgroup_centerlimits import calculateCenterLimits

def calculateAtomLimits(rigidgroup):
	'''given a rigidgroup (which is in a certain orientation, returns
	an dictionary whose keys are Atoms and values are Regions, which
	represent the new atom limits'''
	for coordinate in (0,1,2):	#x,y,z
		center_domains= calculateCenterLimits(rigidgroup, coordinate)
	#...

def calculateAtomLimits(validdomains, sines, coordinate):
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
