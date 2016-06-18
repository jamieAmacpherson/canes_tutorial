/*=============================================================================
| Example program for MPI implementation of multiple sequence alignment
| (C) Jens Kleinjung, 2003-2013
==============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <mpi.h>

main(int argc, char *argv[])
{
	int my_rank;          /* rank of 'this' node */
	int nodes;            /* number of nodes */
	int jobid;            /* job identifier */
	int njobs;            /* number of jobs */
	int avjobs;           /* average number of jobs per node */
	int locdata;          /* number of data to communicate */
	int alldata;          /* number of data produced on all nodes */
	int alljobs;          /* all jobs on nodes */
	int firstjob;         /* the first job of array assigned to 'this' node */
	int my_job;           /* job processed on 'this' node */
	int j,k,l,m;          /* loop counters */
	int *my_j, *my_k;     /* arrays of sequence identifiers */
	int *locresult;       /* holds data produced on 'this' node */ 
	int *globresult;      /* holds data produced on all nodes */
	int nseq = 6;         /* example number of sequences */
	int aliscore[6][6];   /* the assumed alignment score */

	/* initialize MPI routines */
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &nodes);
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	/* number of pairwise alignments */
	njobs = (int)(nseq*(nseq-1)/2);    

	/* calculate smallest integer divisor of njobs and nodes */
	if ((njobs % nodes) == 0) {
		avjobs = (int)(njobs/nodes);
	} else {
		avjobs = (int)((njobs/nodes)+1);
	}

	/* number of data to communicate */
	locdata = avjobs;
	alldata = nodes*locdata;

	/* total number of jobs assigned to nodes */
	alljobs = nodes*avjobs;

	/* map nested loop of 'j,k' onto linear array of 'jobid' */
	my_j = (int *) malloc(njobs * sizeof(int));
	my_k = (int *) malloc(njobs * sizeof(int));
	jobid = -1;
	for (j=0; j < nseq; j++) {
		for (k = j+1; k < nseq; k++) {
			jobid++;
			my_j[jobid] = j;
			my_k[jobid] = k;
		}
    }  

	/* 'locresult' holds data produced on this node */
	/* 'globresult' holds data produced on all nodes */
	locresult = (int *) malloc(locdata * sizeof(int));
	globresult = (int *) malloc(alldata * sizeof(int));

	/* each node calculates its result array slice of size 'avjobs' */
	/* note that 'my_rank' defines the slice of data that is calculated by each node */
	/*   because each node starts its calculation at a different 'firstjob' */
	firstjob = my_rank*avjobs;
	for (l=0; l<avjobs; l++) {
		my_job = l+firstjob;
		/* avoid calculating jobs of non-mapped j and k values, */
		/*   because nodes*avjobs is probably larger than njobs */
		if (my_job<=jobid) {
		/* assign data to array for sending */
		/* node specific results because of my_j[jobid] and my_k[jobid] */
		/* assume that the alignment score of 'j''k' is sum of identifiers */
		locresult[l] = my_j[my_job] + my_k[my_job];
		} else {
			locresult[l] = 0;
		}
    }

	for (l=0; l<nodes; l++) {
		for (m=0; m<avjobs; m++) {
			if (my_rank==l) printf("node%d: locresult[%d] = %d\n", l,m,locresult[m]);
		}
		if (my_rank==l) printf("\n");
	}

	/* communicate slices of data between all nodes */
	MPI_Allgather(locresult, locdata, MPI_INT, globresult, locdata, MPI_INT, MPI_COMM_WORLD);

	/* assemble the matrix of 'aliscore' from the received 'globresult' array */
	for (l=0; l<alljobs; l++) {
		if (l<=jobid) {
			j = my_j[l];
			k = my_k[l];
			aliscore[j][k] = globresult[l];
			/* let node0 print out results */
			if (my_rank==0) printf("node0: globresult[%d] = aliscore[%d][%d] = %d\n", l,j,k,aliscore[j][k]);
		}
	}

	/* de-allocate memory */
	free(locresult);
	free(globresult);
	free(my_j);
	free(my_k);

	/* stop MPI processes */
	MPI_Finalize();
}

