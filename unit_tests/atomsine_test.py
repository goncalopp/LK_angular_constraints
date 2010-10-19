p1= PointND([1.5,8.4,1.87])

origin=PointND([0,0,0])

a= Atom(p1,p1-1,p1+1)

s = AtomSine(a, 0, 0)
#projecting on x axis. x coordinate is y, y coordinate is z
assert equal(s.a, sqrt(8.4*8.4+1.87*1.87))
assert equal(s.p, atan(p1[2]/p1[1])+pi)   # "+pi" because atom.toSine() calculates the vector from atom to origin, not the reverse
assert equal(s.y, 0.87)


s = AtomSine(a, 0, 1)
#projecting on y axis. x coordinate is z, y coordinate is x
assert equal(s.a, sqrt(1.5*1.5+1.87*1.87))
assert equal(s.p, atan(p1[0]/p1[2])+pi)   
assert equal(s.y, 0.5)

s = AtomSine(a, 0, 2)
#projecting on z axis. x coordinate is x, y coordinate is y
assert equal(s.a, sqrt(1.5*1.5+8.4*8.4))
assert equal(s.p, atan(p1[1]/p1[0])+pi)   
assert equal(s.y, 7.4)
