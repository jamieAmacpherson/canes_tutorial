#!/bin/bash
srun -n 4 -J MPIdemo -o mpidemo.o -e mpidemo.e mpirun.openmpi -np 4 sleep 60 &

