#! /bin/bash
srun -n 4 -o mpidemo.o -e mpidemo.e mpirun.openmpi -np 4 ./mpidemo &

