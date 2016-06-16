#! /bin/bash

# number of cores
#$ -pe MPI* 16

# jobname
#$ -N test

# project name
#$ -P hpc_p_canes

# what you want to run
mpirun -np 4 hostname
mpirun -np 4 pwd

