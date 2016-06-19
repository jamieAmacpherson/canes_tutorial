#! /usr/bin/R

# assuming we need to perform 6 jobs on 2 CPUs
job = seq(0, 5);
cpu = seq(0 ,1);

# number of jobs per CPU
n_job_cpu = ceiling(length(job) / length(cpu));

# focussing on the first CPU
# (repeat from here for cpu[2])
for (i in c(1:2)) {
	my_rank = cpu[i];

	job_first = my_rank * n_job_cpu;
	job_last = (my_rank * n_job_cpu) + n_job_cpu - 1;

	# add 1 because R arrays start at element '1'
	my_job = job[seq(job_first+1, job_last+1)]
	print(paste("CPU", cpu[i]));
	print( my_job);
}
