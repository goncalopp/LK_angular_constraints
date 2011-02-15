def fixed_tests(sines, domains, number_of_atoms):
	assert len(sines)==len(domains)==2	#upper and lower bounds
	assert len(sines[0])==len(sines[1])==2	#one sine for each atom
	for i in range(len(domains[0])):	#assert start and end of each region are equal between domains
		assert domains[0][i][0]==domains[1][i][0]
		assert domains[0][i][1]==domains[1][i][1]

#RIGIDGROUP1-----------------------------------------------------------------
def rigid1():
	r= RigidGroup()
	p1= PointND([-2,0,0])
	p2= PointND([2,0,0])
	r.addAtom(p1, p1-1, p1+1)
	r.addAtom(p2, p2-1, p2+1)
	return r

#RIGIDGROUP1, rotation around Z, limits of X------------------------------
r=rigid1()
sines, domains= calculateCenterLimits(r, 2, 0)
fixed_tests(sines, domains, 2)
assert len(domains[0])==len(domains[1])==2	#2 valid regions
assert domains[0][0][0][0]==0
assert equal(domains[0][0][1][0], 1.0471975511965974)
assert equal(domains[0][1][0][0], 2*pi-1.0471975511965974)
assert equal(domains[0][1][1][0], 2*pi)


#RIGIDGROUP1, rotation around Z, limits of Y------------------------------
r=rigid1()
sines, domains= calculateCenterLimits(r, 2, 1)
fixed_tests(sines, domains, 2)
assert len(domains[0])==len(domains[1])==4	#2 valid regions
assert domains[0][0][0][0]==0
assert equal(domains[0][0][1][0], 0.523598775598)
assert equal(domains[0][1][0][0], pi-0.523598775598)
assert equal(domains[0][1][1][0], pi)
assert equal(domains[0][2][0][0], pi)
assert equal(domains[0][2][1][0], pi+0.523598775598)
assert equal(domains[0][3][0][0], 2*pi-0.523598775598)
assert equal(domains[0][3][1][0], 2*pi)

#RIGIDGROUP1, rotation around Y, limits of X------------------------------
r=rigid1()
sines, domains= calculateCenterLimits(r, 1, 0)	#rotating around z, limits of x
fixed_tests(sines, domains, 2)
print domains[1]
print domains[1][1]
