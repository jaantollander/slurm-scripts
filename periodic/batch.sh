#!/bin/bash
#SBATCH --job-name=slurm-periodic-job
#SBATCH --account=project_462000007
#SBATCH --partition=small
#SBATCH --time=00:02:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000
#SBATCH --output=log.out
#SBATCH --error=log.err

# Remove environment variables that messes up further jobs
export -n SLURM_MEM_PER_CPU
export -n SLURM_MEM_PER_GPU
export -n SLURM_MEM_PER_NODE

# Add new job to the queue
NEW_DATE=$(date +"%Y-%m-%dT%H:%M:%S" -d "+2 minutes")
sbatch --dependency="afterok:$SLURM_JOB_ID" --begin="$NEW_DATE" batch.sh
echo "New job is sheduled to begin at $NEW_DATE"

# Work should exit succesfully before the time limit is up
echo "Working on job $SLURM_JOB_ID"
echo "Testing GET request"
curl --silent --request GET https://httpbin.org/get
echo "Testing POST request"
curl --silent --request POST --data '{"test": "event"}' -H "Content-Type: application/json" https://httpbin.org/post
sleep 60
exit 0
