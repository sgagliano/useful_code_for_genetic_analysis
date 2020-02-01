###PYTHON3###
##script written with dtaliun

import argparse
import pysam
from collections import Counter

argparser = argparse.ArgumentParser(description = 'Count number of variants per AF bins and per SNV, DEL, and INS.')
argparser.add_argument('--in', metavar = 'filename', dest = 'in_vcfs', required = True, nargs = '+', help = 'List of input VCF/BCF (sites only needed).')

if __name__ == '__main__':
    args = argparser.parse_args()

    counters = {
            'ALL': Counter(),
            '(0, 0.005]': Counter(),
            '(0.005, 0.01]': Counter(),
            '(0.01, 0.05]': Counter(),
            '(0.05, 1)': Counter()
            }

    for vcf in args.in_vcfs:
        print('I am processing file {}.'.format(vcf))
        with pysam.VariantFile(vcf, 'r') as ifile:
            for record in ifile:
                if len(record.info['AC']) > 1:
                    raise Exception('We don\'t allow multi-allelic entries.')
                af = record.info['AC'][0] / record.info['AN']
                af_bin = ''
                if af <= 0.005:
                    af_bin = '(0, 0.005]'
                elif af <= 0.01:
                    af_bin = '(0.005, 0.01]'
                elif af <= 0.05:
                    af_bin = '(0.01, 0.05]'
                else:
                    af_bin = '(0.05, 1)'

                ref = record.ref
                alt = record.alts[0]
                vtype = ''
                if len(ref) == len(alt):
                    if len(ref) == 1:
                        vtype = 'SNV'
                    else:
                        raise Exception('We don\'t handle MNVs.')
                elif len(ref) > len(alt):
                    vtype = 'DEL'
                else:
                    vtype = 'INS'

                counters['ALL'][vtype] += 1
                counters['ALL']['ALL'] += 1
                counters[af_bin][vtype] += 1
                counters[af_bin]['ALL'] += 1
    for af_bin, counter in counters.items():
        for vtype, count in counter.items():
            print('{}\t{}\t{:,}'.format(af_bin, vtype, count))

