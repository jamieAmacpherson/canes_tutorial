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

# pulling run
#$grompp -f pull.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o pull.tpr  -maxwarn 10 >& grompp_$job.log
$MPIRUN -np $nprocs $mdrun -deffnm pull -pf pull.xvg -px pullx-umbrella.xvg







