##python3

import sys
import gzip
import argparse
import pysam
from contextlib import closing
import itertools
from collections import OrderedDict

argparser = argparse.ArgumentParser(description = 'Print number of singletons per person into output')
argparser.add_argument('-i', '--inGZVCF', metavar = 'filename', dest = 'inGZVCF', required = True, help = 'Input input VCF.gz')
argparser.add_argument('-o', '--out', metavar = 'filename', dest = 'outputTextFile', required = True, help = 'Output output text file count of singletons per person')

def CountSingletons(inGZVCF, outputTextFile):
	# BEGIN: initialize variables
	IDList = None
	counts = None
	n_variants_total = 0
	n_singletons_processed = 0
	with closing(pysam.VariantFile(inGZVCF, 'r')) as vfile:
		IDList = list(vfile.header.samples)
		print(f'{len(IDList)} individual(s) in VCF input file.')
		#prep data structure to store counts of singletons per person
		counts = [0] * len(IDList)
		assert sum(counts) == 0

		for vcfrow in vfile:
			n_variants_total += 1
			if vcfrow.info['AC'][0] == 1: #assumes biallelic variants
				for i, sample_name in enumerate(IDList):
					if sum(vcfrow.samples[sample_name]['GT']) == 1:
						counts[i] += 1
						break
			n_singletons_processed += 1

	with open(outputTextFile, 'w') as writeout:
		for id, count in zip(IDList, counts):
			writeout.write(f'{id}\t{count}\n')

	print(f'{n_singletons_processed} singletons processed out of {n_variants_total} variants')

if __name__ == '__main__':
	args = argparser.parse_args()
	CountSingletons(args.inGZVCF, args.outputTextFile)
