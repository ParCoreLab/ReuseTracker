import collections


def bin_reader(file_path):

	range_list = []
	bin_list = []
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("#"):
				continue
			left, right, val = list(map(float, l.split()))
			range_list.append((left,right))
			bin_list.append(val)
	return {"file_type": "bin", "ranges":range_list, "bins": bin_list}

def hpcrun_old_reader(file_path):
	ret_histo = collections.defaultdict(int)
	num_records = 0
	num_accesses = 0
	max_memory_size = 0
	num_metrics = 1

	reuse_lines = []
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("FINAL_COUNTING:"):
				val, enabling, running = list(map(int,l.replace("FINAL_COUNTING:","").split()))
				num_accesses = int(round( val *enabling / running))
			if l.startswith("MAX_MEMORY:"):
				max_memory_size = int(l.split()[1]) ## in KBytes
				max_memory_size *= 1024 ##convert into bytes
				continue
			if l.find("REUSE_DISTANCE:") < 0:
				continue
			if not l.startswith("REUSE_DISTANCE:"):
				print("WARNING: Corrupted line: ", l)
				continue

			reuse_lines.append(l.replace("REUSE_DISTANCE:", ""))
	assert(reuse_lines)
	for i,l in enumerate(reuse_lines):
		d_val, d_enabling, d_running, inc = list(map(int, l.split()))
		if d_enabling == 0 or d_running == 0:
			reuse_distance = 1
		else:
			reuse_distance = d_val * (d_enabling / d_running)
		ret_histo[reuse_distance] += inc
		num_records += 1


	return {"file_type":"hpcrun", "num_records": num_records, "histo": ret_histo, "num_accesses": num_accesses, "max_memory_size": max_memory_size, "num_metrics": num_metrics}


def hpcrun_bin_reader(file_path):
	num_accesses = 0
	max_memory_size = 0
	bin_start = None
	bin_ratio = None

	reuse_lines = []
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("FINAL_COUNTING:"):
				num_accesses = 0
				for seg in l.replace("FINAL_COUNTING:","").split(","):
					seg = seg.strip().rstrip()
					if len(seg) == 0: continue
					val, enabling, running = list(map(int, seg.split()))
					if enabling == 0 and running == 0: # no multiplexing
						num_accesses += val
					else:
						num_accesses += int(round( val *enabling / running))
			elif l.startswith("MAX_MEMORY:"):
				max_memory_size = int(l.split()[1]) ## in KBytes
				max_memory_size *= 1024 ##convert into bytes
			elif l.startswith("BIN_START:"):
				bin_start = float(l.split()[1])
			elif l.startswith("BIN_RATIO:"):
				bin_ratio = float(l.split()[1])
			elif l.startswith("BIN:"):
				reuse_lines.append(l)

	bin_list = []
	intervals = [0]
	for i, l in enumerate(reuse_lines):
		_, index, count = l.split()
		index, count = int(index), int(count)
		assert(i == index)
		bin_list.append(count)
		if i == 0:
			intervals.append(bin_start)
		else:
			intervals.append(intervals[-1]*bin_ratio)

	range_list = list(zip(intervals, intervals[1:]))
	return {"file_type":"hpcrun",  "num_accesses": num_accesses, "max_memory_size": max_memory_size, "bins": bin_list, "intervals": intervals, "ranges": range_list }




def hpcrun_reader(file_path):
	ret_histo = collections.defaultdict(int)
	num_records = 0
	num_accesses = 0
	max_memory_size = 0

	## it is only to get compatible with the old version
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("REUSE_DISTANCE:"):
				if l.find(",") < 0: ## old version
					return hpcrun_old_reader(file_path)


	reuse_lines = []
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("FINAL_COUNTING:"):
				num_accesses = 0
				for seg in l.replace("FINAL_COUNTING:","").split(","):
					seg = seg.strip().rstrip()
					if len(seg) == 0: continue
					val, enabling, running = list(map(int, seg.split()))
					if enabling == 0 and running == 0: # no multiplexing
						num_accesses += val
					else:
						num_accesses += int(round( val *enabling / running))
				continue
			if l.startswith("MAX_MEMORY:"):
				max_memory_size = int(l.split()[1]) ## in KBytes
				max_memory_size *= 1024 ##convert into bytes
				continue
			if l.startswith("BIN:"):
				return hpcrun_bin_reader(file_path)
			if l.find("REUSE_DISTANCE:") < 0:
				continue
			if not l.startswith("REUSE_DISTANCE:"):
				print("WARNING: Corrupted line: ", l)
				continue

			reuse_lines.append(l.replace("REUSE_DISTANCE:", ""))
	assert(reuse_lines)
	num_metrics = len(list(filter(lambda x: x.strip().rstrip(), reuse_lines[0].split(","))))-1
	reuse_values = [ [None for _ in range(0, num_metrics)] for _ in range(0, len(reuse_lines))]
	reuse_buffers = [ [None for _ in range(0, num_metrics)] for _ in range(0, len(reuse_lines))] ## save the raw data
	inc_list = [0]*len(reuse_lines)
	ctxt_line_dict = collections.defaultdict(list)
	ctxt_list = [None] * len(reuse_lines)
	##parse each line first time
	for i,l in enumerate(reuse_lines):
		seg1, *remains =  filter(lambda x: x.strip().rstrip(), l.split(","))
		ctxt1, ctxt2, inc = seg1.split()
		ctxt_list[i] = (ctxt1, ctxt2)
		inc_list[i] = int(inc)
		for j,seg in enumerate(remains):
			d_val, d_enabling, d_running = list(map(int, seg.split()))
			if d_enabling == 0 and d_running == 0: ## no multiplexing
				reuse_values[i][j] = d_val
			elif d_enabling == 0 or d_running == 0:
				pass
			else:
				reuse_values[i][j] = d_val * (d_enabling / d_running)
			reuse_buffers[i][j] = (d_val, d_enabling, d_running)

		ctxt_line_dict[(ctxt1,ctxt2)].append(i)


	def backForthFind(search_list, start_index, check_fn): ## return index
		## check_fn: accept receive element from search_list
		descending_list = range(start_index-1, -1, -1)
		ascending_list  = range(start_index+1, len(search_list))
		interleaving_list = (val for pair in zip(descending_list, ascending_list) for val in pair)
		for i in interleaving_list:
			if check_fn(search_list[i]): return i
		return -1

	## second time: estimate based on the same context
	for c,index_list in ctxt_line_dict.items():
		for i, line_index in enumerate(index_list):
			for metric_index,v in enumerate(reuse_values[line_index]):
				if v != None: continue
				found = backForthFind(index_list, i, lambda x: reuse_values[x][metric_index] != None)
				if found >= 0:
					#print("SECOND TIME: copied a value")
					copy_val = reuse_values[index_list[found]][metric_index]
					reuse_values[line_index][metric_index] = copy_val

	'''
	## third time: estimate based on the neighborhood
	for i, v_list in enumerate(reuse_values):
		for j, v in enumerate(v_list):
			if v != None: continue
			#found = backForthFind(reuse_values, i, lambda x: x[j] != None)
			found = backForthFind(reuse_buffers, i, lambda x: x[j][0] != 0)
			if found >= 0:
				#print("THIRD TIME: Success")
				#reuse_values[i][j] = reuse_values[found][j]
				reuse_values[i][j] = reuse_buffers[i][j][1] * (reuse_buffers[found][j][0]/reuse_buffers[found][j][2])
				#print("THIRD TIME: Success", reuse_values[i][j])
			else: ## maybe just assign 1 ??
				#print("THIRD TIME: FAIL")
				reuse_values[i][j] = 1

	'''

	if False :
		merged_reuse_values = []
		for val_list  in reuse_values:
			val_list = list(map(lambda x:x if x else 0, val_list))
			merged_reuse_values.append(sum(val_list))

		return reuse_lines, merged_reuse_values

	num_records = len(reuse_values)
	final_val_list = []
	for reuse_list, inc in zip(reuse_values, inc_list):
		#reuse_list = list(map(lambda x: x if x!=None else 2E9, reuse_list))
		reuse_list = list(map(lambda x: x if x else 0, reuse_list))

		val = sum(reuse_list)
		final_val_list.append(val)
		ret_histo[val] += max(1,inc)
		#ret_histo[sum(reuse_list)] += 1 ##jqswang: disable proportional attribution
	#[ print("inc", inc) for inc in inc_list]
	'''
	## parse "REUSE_DISTANCE:" lines
	delayed_processing_lines = []
	context_reuse_distance_dict = collections.defaultdict()
	def setRecord(ctxt, index, val):
		identifier = "#".join([ctxt,str(index)])
		context_reuse_distance_dict[identifier] = val
	def getEstimation(ctxt, index):
		identifier = "#".join([ctxt,str(index)])
		if identifier in context_reuse_distance_dict:
			return context_reuse_distance_dict[identifier]
		else:
			return None


	def parseLine(line, remeber_flag):
		seg1, *remains =  l.split(",")
		ctxt1, ctxt2, inc = seg1.split()
		inc = int(inc)
		ctxt = "#".join([ctxt1, ctxt2])
		sub_reuse_list = []
		for i,seg in enumerate(remains):
			d_val, d_enabling, d_running = seg.split()
			#if d_enabling == 0: continue
			if d_running == 0: ##estimation
				sub_reuse_list.append(getEstimation(ctxt, i))
			else:
				r = d_val * (d_enabling / d_running)
				if remeber_flag: setRecord(ctxt,i, r)
				sub_reuse_list.append(r)
		if all(map(lambda x: x!=None, sub_reuse_list)): ## reuse_distance can be successfully obtained
			num_records += 1
			reuse_distance = sum(sub_reuse_list)
			ret_histo[reuse_distance] += inc
			return True
		return False


	for l in reuse_lines:
		if not parseLine(l, True):
			delayed_processing_lines.append(l)
		i = 0
		while i < len(delayed_processing_lines):
			if parseLine(delayed_processing_lines[i], False):
				del delayed_processing_lines[i]
			i += 1
	for l in delayed_processing_lines:
		seg1, *remains =  l.split(",")
		ctxt1, ctxt2, inc = seg1.split()
		inc = int(inc)
		sub_reuse_list = []
		for i,seg in enumerate(remains):
			d_val, d_enabling, d_running = seg.split()
			#if d_enabling == 0: continue
			if d_running == 0: ##estimation
				sub_reuse_list.append(1)
			else:
				r = d_val * (d_enabling / d_running)
				sub_reuse_list.append(r)
		num_records += 1
		reuse_distance = sum(sub_reuse_list)
		ret_histo[reuse_distance] += inc
	'''
	assert(len(final_val_list) == len(inc_list))
	assert(len(inc_list) == len(ctxt_list))
	return {"file_type":"hpcrun", "num_records": num_records, "histo": ret_histo, "num_accesses": num_accesses, "max_memory_size": max_memory_size, "num_metrics": num_metrics, "attribution_details":list(zip(ctxt_list, final_val_list,inc_list ) ) }


def trd_reader(file_path):
	ret_histo = collections.defaultdict(int)
	num_records = 0
	num_accesses = 0
	num_elements = 0
	with open(file_path) as f:
		for l in f.readlines():
			if l.startswith("#ACCESSES"):
				num_accesses = int(l.split()[1])
				continue
			if l.startswith("#ELEMENTS:"):
				num_elements = int(l.split()[1])
				continue
			if l.startswith("#"): continue
			val, count = map(int, l.split())
			num_records += 1
			ret_histo[val] += count

	return {"file_type": "trd", "num_records": num_records, "histo": ret_histo, "num_accesses": num_accesses, "num_elements": num_elements}

def loca_reader(file_path):
	if file_path.endswith("g1.dat.d"):
		ret_histo_64 = collections.defaultdict(float)
		ret_histo_1 = collections.defaultdict(float)
		num_records = 0
		with open(file_path) as f:
			for l in f.readlines()[1:]:
				_, _, rd64, count64, _, rd1, count1, _  = l.split()
				rd64, count64, rd1, count1 = map(float, [rd64, count64, rd1, count1])
				ret_histo_64[int(round(rd64/64))] += count64
				ret_histo_1[int(round(rd1/1))] += count1
				num_records += 1
		return {"file_type":"loca", "num_records": num_records, "histo64": ret_histo_64, "histo1": ret_histo_1}

	else:
		ret_histo_64 = collections.defaultdict(float)
		ret_histo_4 = collections.defaultdict(float)
		num_records = 0
		with open(file_path) as f:
			for l in f.readlines()[1:]:
				_, _, rd64, count64, _, rd4, count4, _  = l.split()
				rd64, count64, rd4, count4 = map(float, [rd64, count64, rd4, count4])
				ret_histo_64[int(round(rd64/64))] += count64
				ret_histo_4[int(round(rd4/4))] += count4
				num_records += 1
		return {"file_type":"loca", "num_records": num_records, "histo64": ret_histo_64, "histo4": ret_histo_4}


def readFile(file_path):
	# decide the file reader
	if file_path.endswith(".reuse.hpcrun"):
		return hpcrun_reader(file_path)
	elif file_path.endswith(".dat.d"): #loca
		return loca_reader(file_path)
	elif file_path.endswith(".srd"): # stack reuse distance file
		ret_dict = trd_reader(file_path)
		ret_dict["file_type"] = "srd"
		return ret_dict
	elif file_path.endswith(".trd"): # time reuse distance file
		return trd_reader(file_path)
	elif file_path.endswith(".bin"):
		return bin_reader(file_path)
	else:
		print("Unknown file type")
		assert(False)
