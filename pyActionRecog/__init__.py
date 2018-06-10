from benchmark_db import *
from armlc import *


split_parsers = dict()
split_parsers['ucf101'] = parse_ucf_splits
split_parsers['hmdb51'] = parse_hmdb51_splits
split_parsers['armlc'] = parse_armlc_splits
split_parsers['activitynet_1.2'] = lambda : parse_activitynet_splits("1.2")
split_parsers['activitynet_1.3'] = lambda : parse_activitynet_splits("1.3")


def parse_split_file(dataset, frame_path=None):
	
	sp = split_parsers[dataset]
	if frame_path:
		return sp(frame_path)
	else:
		return sp()		
