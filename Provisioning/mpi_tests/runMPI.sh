#!/bin/bash
#SBATCH --job-name=mpi
#SBATCH --output=%x_%j.out
echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_JOB_NUM_NODES"=$SLURM_JOB_NUM_NODES
echo "SLURM_NTASKS"=$SLURM_NTASKS

module purge
echo "Sequential execution"
date
./mpi-pi-openmpi-4.0.7
module load openmpi/gcc/4.0.7
echo "Parallel execution using Open MPI: $MPI_DIR"
date
mpirun --version
mpirun -np $SLURM_NTASKS mpi-pi-openmpi-4.0.7
module switch openmpi/gcc/4.0.7 openmpi/gcc/4.1.4
echo "Parallel execution using Open MPI: $MPI_HOME"
date
mpirun --version
mpirun -np $SLURM_NTASKS mpi-pi-openmpi-4.1.4
