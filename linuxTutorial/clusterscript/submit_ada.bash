#! /bin/bash

# number of cores
#$ -pe MPI* 16

# jobname
#$ -N test

# project name
#$ -P hpc_p_canes

# what you want to run
hostname
pwd

