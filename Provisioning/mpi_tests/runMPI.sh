#!/bin/bash
#SBATCH --job-name=mpi
#SBATCH --output=%x_%j.out
# sbatch -t 10000 -N1 -n2 runMPI.sh
# sbatch -t 10000 -N2 -n4 runMPI.sh

echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_JOB_NUM_NODES"=$SLURM_JOB_NUM_NODES
echo "SLURM_NTASKS"=$SLURM_NTASKS



# ----------------- SEQUENTIAL -----------------

module purge
echo -e "\n"

echo "Sequential execution with gnu9 and openmpi4"
date
module load gnu9
module load openmpi4
mpicc -w -o $HOME/mpi-pi-gnu9-openmpi4 $HOME/mpi-pi.c
./mpi-pi-gnu9-openmpi4

echo -e "\n"
echo "-----------------------------------------"
#------------------------------------
echo -e "\n"

echo "Sequential execution with gnu12 and openmpi4"
date
module swap gnu9 gnu12
#module load openmpi4
mpicc -w -o $HOME/mpi-pi-gnu12-openmpi4 $HOME/mpi-pi.c
./mpi-pi-gnu12-openmpi4

echo -e "\n"
echo "-----------------------------------------"
echo -e "\n"


echo "Compilation with gnu12 and mpich"
date
module swap openmpi4 mpich
mpicc -w -o $HOME/mpi-pi-gnu12-mpich $HOME/mpi-pi.c

echo -e "\n"
echo "-----------------------------------------"
echo -e "\n"

# ----------------- PARALLEL -----------------

module purge
module load gnu9
module load openmpi4
echo "Parallel execution using Open MPI 4 with gnu9: $MPI_DIR"
date
mpiexec --version
mpiexec -n $SLURM_NTASKS $HOME/mpi-pi-gnu9-openmpi4

echo -e "\n"
echo "-----------------------------------------"
#------------------------------------
echo -e "\n"

module swap gnu9 gnu12
echo "Parallel execution using Open MPI 12 with gnu12: $MPI_DIR"
date
mpiexec --version
mpiexec -n $SLURM_NTASKS $HOME/mpi-pi-gnu12-openmpi4

echo -e "\n"
echo "-----------------------------------------"
echo -e "\n"

module swap openmpi4 mpich
echo "Parallel execution using mpich with gnu12: $MPI_DIR"
date
mpiexec --version
mpiexec -n $SLURM_NTASKS $HOME/mpi-pi-gnu12-mpich

echo -e "\n"
echo "-----------------------------------------"