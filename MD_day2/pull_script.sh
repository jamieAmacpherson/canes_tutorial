#!/bin/bash

MPIRUN=/usr/bin/mpirun.openmpi
grompp=/apps/prod/gromacs-4.5.7_mpi/bin/grompp_mpi
mdrun=/apps/prod/gromacs-4.5.7_mpi/bin/mdrun_mpi


nprocs=8


# pulling run
$grompp -f pull.mdp -c npt.gro -p topol.top -n index.ndx -o pull.tpr
$MPIRUN -np $nprocs $mdrun -deffnm pull -pf pull.xvg -px pullx-umbrella.xvg -pf pullf-umbrella.xvg