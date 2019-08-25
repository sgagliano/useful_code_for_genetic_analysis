#python Commands2Array.py --in-commandlist <ListofCommands1perLine.txt> > <ARRAY.sh>

import argparse

argparser = argparse.ArgumentParser(description = 'Transform a list of commands to SLURM jobarray without dependicies.')
argparser.add_argument('--in-commandlist', metavar = 'CommandList', dest = 'CommandList', required = True, help = 'Input command list.')

def ReadList(CommandList):
	array=[]
	with open(CommandList, 'r') as f:
		for l in f:
			array.append(l.rstrip())	
	return array

if __name__ == "__main__":
	args = argparser.parse_args()
	commands = ReadList(args.CommandList)

	print "#!/bin/bash"
	print "#SBATCH --array=0-%d" % (len(commands) - 1)
	print "#SBATCH --job-name=%d" % len(commands)
	#print "#SBATCH --output=%d-%%a.log" % len(commands)
	print "#SBATCH --partition=main"
	print "#SBATCH --mem=4000"
	print "#SBATCH --time=50:00:00"
	print "#SBATCH --output=logs/%a.log"
	print "declare -a jobs"

 	for i in xrange(0, len(commands)):
		print "jobs[%d]=\"%s\"" % (i, commands[i])
	
	print "eval ${jobs[${SLURM_ARRAY_TASK_ID}]}"
