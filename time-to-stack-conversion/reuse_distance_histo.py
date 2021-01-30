#!/usr/bin/env python3

#import scipy
import collections
import argparse
from pylib import *
import cProfile
import bisect
from termcolor import colored
import io
## tunable parameters
g_length_per_percent = 2

g_time_distance_range_plan = None
g_stack_distance_range_plan = None



def print2Str(*args, **kwargs):
	output = io.StringIO()
	print(*args, file=output, **kwargs)
	contents = output.getvalue()
	output.close()
	return contents


def draw_histo(markers:list, counts:list)->None:
	print(len(markers), len(counts))
	assert(len(markers) == len(counts))
	if len(markers) == 0: return
	#all_counts = sum(counts)
	#percent_counts = [ counts[i]/all_counts * 100.0 for i in range(0, len(counts))]
	percent_counts = [counts[i]*100.0 for i in range(0, len(counts))]
	print(percent_counts)
	for i in range(0, len(markers)):
		print("-"*int(round(g_length_per_percent* percent_counts[i]))," ", round(percent_counts[i],1),"%", sep="", end="")
		print("  ", markers[i], sep="")

def report_collection(range_list, fraction_list):

	markers = [ "["+"{:.2E}".format(r[0])+","+"{:.2E}".format(r[1])+")"  for r in range_list] ## convert to scientific notation

	draw_histo(markers, fraction_list)


def process_input(input_file, output):
	reading_result = reuse_file_reader.readFile(input_file)
	if reading_result["file_type"] not in ["hpcrun", "trd"]:
		print("Only time reuse file is accepted.")
		return




	for item in ["file_type", "num_records", "num_accesses", "num_elements", "max_memory_size"]:
		if item in reading_result:
			print(item+":", reading_result[item])

	num_accesses = reading_result["num_accesses"]
	if "num_elements" in reading_result:
		num_elements = reading_result["num_elements"]
	else:
		num_elements = reading_result["max_memory_size"] // 4
	print("num_lements:", num_elements,", num_accesses:", num_accesses, ", max_memory_size:", reading_result["max_memory_size"])


	if reading_result["file_type"] == "hpcrun" and "intervals" in reading_result:
		trh_bin_list = reading_result["bins"]
		trh_range_list = reading_result["ranges"]
		intervals = [ r[0] for r in trh_range_list] +[ trh_range_list[-1][1] ]
		#print(trh_bin_list, len(trh_bin_list))
		#print(intervals, len(intervals))
		histo = reuse_model.Histogram(trh_bin_list, intervals, None, None)
	else:
		reuse_histo = reading_result["histo"]
		total_count = sum(reuse_histo.values())

		if reading_result["file_type"] == "hpcrun":
			#pass
			reuse_histo = calibration.hpcrun_calibration(reuse_histo, "10M")
			#reuse_histo = calibration.hpcrun_calibration(reuse_histo, reading_result["num_metrics"])


		if g_time_distance_range_plan.startswith("F,"):
			time_range_list =  config.time_distance_range_list(g_time_distance_range_plan.split(",")[1])
			time_intervals = [ r[0] for r in time_range_list] +[ time_range_list[-1][1] ]
			print(time_intervals)
			histo = reuse_model.Histogram(reuse_histo, time_intervals, None, None)
		elif g_time_distance_range_plan.startswith("D,"):
			first_term, ratio = list(map(float, g_time_distance_range_plan.split(",")[1:] ))
			histo = reuse_model.Histogram(reuse_histo, None, first_term, ratio)
		else: ## no such plan
			assert(False)


	model = reuse_model.Tdh2RdhModelExt(histo, num_elements , num_accesses)
	print("g_stack_distance_range_plan", g_stack_distance_range_plan)
	stack_range_list =  config.stack_distance_range_list(g_stack_distance_range_plan)
	stack_intervals = [ r[0] for r in stack_range_list] +[ stack_range_list[-1][1] ]
	histo = reuse_model.Histogram({0:1}, stack_intervals, None, None)

	stack_distance_range_list = histo.getRanges()
	rdh = model.getRdh(stack_distance_range_list)
	#print(sum(rdh))
	report_collection(stack_distance_range_list, rdh)

	with open(output, "w") as f:
		for r, b in zip(stack_distance_range_list, rdh):
			f.write(" ".join([str(r[0]),str(r[1]), str(b)])+"\n")


def main():

	parser = argparse.ArgumentParser()
	parser.add_argument("input_file", help="the path to the hpcrun or time reuse data file")
	parser.add_argument("-o", "--output", default=None, help="Specify the name of the bin output file")
	parser.add_argument("--trh-plan", default="F,L3", help="The ways of bins for splitting time reuse histogram")
	parser.add_argument("--srh-plan", default="L3", help="The ways of bins for splitting stack reuse histogram")


	args = parser.parse_args()

	#print(args)
	#pr = cProfile.Profile()
	#pr.enable()
	if args.output:
		output = args.output
	else:
		output = args.input_file + ".bin"

	global g_time_distance_range_plan, g_stack_distance_range_plan
	g_time_distance_range_plan = args.trh_plan
	g_stack_distance_range_plan = args.srh_plan
	#g_time_distance_range_list = config.time_distance_range_list(args.trh_plan)
	#g_stack_distance_range_list = config.stack_distance_range_list(args.srh_plan)

	process_input(args.input_file, output)
	#pr.disable()
	#pr.print_stats(sort='time')
main()
