p1= PointND([1.5,8.4,1.87])
origin=PointND([0,0,0])
atom= Atom(p1,p1-1.35,p1+1.12)

bounds= [None, 0, 1]
coordinates=[0,1,2]
axis=[0,1,2]

for a in axis:
	for b in bounds:
		for c in coordinates:
			if a!=c:
				s = AtomSine(atom, a, c, b)
				
				if a==0:
					assert equal(s.a, 8.6056318768583)
					assert equal(s.p, 3.3606397189314)
				elif a==1:
					assert equal(s.a, 2.3972692798265)
					assert equal(s.p, 3.8176365266721)
				elif a==2:
					assert equal(s.a, 8.5328775919967)
					assert equal(s.p, 4.5356801243146)
					
				assert equal(s.y, (0 if b==None else atom.region[b][c]))
				assert equal(s.valueat(0), \
					(-p1[c] if b==None else atom.region[b][c]-p1[c]))
