

import collections

def hpcrun_calibration(reuse_histo, plan):
	new_histo = collections.defaultdict(float)
	if plan == 1:
		for k, val in reuse_histo.items():
			k -=  2600
			k = max(1, k)
			new_histo[k] += val
		return new_histo

	elif plan == 2:
		for k, val in reuse_histo.items():
			k -= 6300
			k = max(1, k)
			new_histo[k] += val
		return new_histo
	elif plan == "10M":
		for k, val in reuse_histo.items():
			k -= 85
			k = max(1, k)
			new_histo[k] += val
		return new_histo

	else:
		print("Undefined plan")
		assert(False)
