r=1
c1= PointND([5.2,4.3,0.4])
c2= PointND([-4.9,0.1,0.2])
c3= PointND([-2.1,4.1,5.1])

rigid= RigidGroup()
rigid.addAtom(c1, c1-1*r, c1+1*r)
rigid.addAtom(c2, c2-1*r, c2+1*r)
rigid.addAtom(c3, c3-1*r, c3+1*r)
rigid.recalculateCenter()

#in this case, the group is limited in movement by c2
#rotating in x axis... x-coordinate is y, y-coordinate is z
a= 3.21886798597
p= atan(c2[2]/c2[1])  
assert round(p,12)==0.556403929189

tmp= atomsine_calc.do_it(rigid.atoms, 0, debug=False)

assert equal(tmp[0][0][0], 0)
assert equal(tmp[0][1][0], 0.5030380114026145)
assert equal(tmp[1][0][0], 5.8732823057359607)
assert equal(tmp[1][1][0], 2*pi)
