#!/bin/bash
#SBATCH --job-name=mpi
#SBATCH --output=%x_%j.out
echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_JOB_NUM_NODES"=$SLURM_JOB_NUM_NODES
echo "SLURM_NTASKS"=$SLURM_NTASKS

module purge

echo "Sequential execution with gnu9"
date
module load gnu9
module load openmpi4
mpicc -o mpi-pi-gnu9-openmpi4 mpi-pi.c
./mpi-pi-gnu9-openmpi4

#------------------------------------

echo "Sequential execution with gnu12 with openmpi4"
date
module swap gnu9/9.4.0 gnu12/12.2.0
#module load openmpi4
mpicc -o mpi-pi-gnu12-openmpi4 mpi-pi.c
./mpi-pi-gnu12-openmpi4

echo "Sequential execution with gnu12 with openmpi4"
date
module swap openmpi4/4.1.4 mvapich2/2.3.7
mpi -o mpi-pi-gnu12-mvapich mpi-pi.c
./mpi-pi-gnu12-mvapich

#------------------------------------

module swap gnu12/12.2.0 gnu9/9.4.0
module swap mvapich2/2.3.7 openmpi4/4.1.4
echo "Parallel execution using Open MPI 4 with gnu9: $MPI_DIR"
date
mpirun --version
mpirun -np $SLURM_NTASKS mpi-pi-gnu9-openmpi4

#------------------------------------

module swap gnu9/9.4.0 gnu12/12.2.0
module swap mvapich2/2.3.7 openmpi4
echo "Parallel execution using Open MPI 12 with gnu12: $MPI_DIR"
date
mpirun --version
mpirun -np $SLURM_NTASKS mpi-pi-gnu12-openmpi4

module swap openmpi4/4.1.4 mvapich2/2.3.7
echo "Parallel execution using mvapich2 with gnu12: $MPI_DIR"
date
mpirun --version
mpirun -np $SLURM_NTASKS mpi-pi-gnu12-mvapich
