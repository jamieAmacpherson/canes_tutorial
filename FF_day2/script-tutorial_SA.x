#!/bin/bash

MPIRUN=/usr/local/bin/mpirun
grompp=grompp_mpid
mdrun=mdrun_mpid

source ~/.GM455mpid

nprocs=8
job=npt


# Short equilibration
#$grompp -f npt.mdp -c min.gro -p topol.top -n index.ndx -o npt.tpr  -maxwarn 10 >& grompp_$job.log
$MPIRUN -np $nprocs $mdrun -deffnm npt

# Simulated Annealing run
#$grompp -f npt_SA.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o SA_0_300.tpr  -maxwarn 10 >& grompp_$job.log
$MPIRUN -np $nprocs $mdrun -deffnm npt_SA 







