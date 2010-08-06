class SineInRegion:
	def __init__(self, sine, region):
		self.sine= sine;
		self.region= region;

	def __repr__(self):
		return '<SineInRegion '+str(self.sine)+' '+str(self.region)+'>'
