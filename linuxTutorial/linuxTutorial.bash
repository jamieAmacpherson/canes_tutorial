#! /bin/bash

#===============================================================================
# Linux tutorial
#===============================================================================

#_______________________________________________________________________________
# INTRO
#_______________________________________________________________________________
# The terminal runs a shell program that can interpret user input.
# Each line starts with a prompt of the type 'user@computer:',
#   but the particular format varies.
# There are different flavours of shell (csh, zsh, bash);
#   the syntax varies slightly between the shell flavours.
# We will only use the most commonly used 'bash' shell.

# If your current shell is not 'bash', just run 'bash':
bash
#   which you may exit later:
exit

# Our first input lists the content of the current directory:
ls

# Each Linux command has a manual page:
man ls
# You can search through the manual page after entering '/' plus key word.
# Progressive search is achieved with the 'n' (next) key and quit with 'q'.

# Create a long list to obtain more information about the listed
#   files and directories:
ls -l
# The output contains the file type, permissions, number of hard links,
#   owner name, group name, size in bytes and modification time:
#% drwxr-xr-x 4 canestutor ffuser    4 Jun 13 17:07 demodir

#_______________________________________________________________________________
# TREE
#_______________________________________________________________________________
# The file system is organised as a hierarchical tree of (sub)directories.
# To move into a subdirectory and back, use 'cd' (change directory):
cd demodir
cd ..
# By default '..' is the up-tree directory, '.' is the current directory.

# List the full path from the root to the current directory with 'pwd'
#   (print working directory):
pwd

# For a more complete view, use 'tree':
tree

# 'pwd' returns the absolute path, which is the full path from the root,
#   while 'ls', 'tree', '.' and '..' refer to the current and relative
#   location in the path.
# Commands can be used in combination with paths:
ls ./demodir/

# 'cd' without any path argument changes the current location to the user's
#   home directory, which can be abbreviated with the tilde symbol '~':
ls ~

#_______________________________________________________________________________
# NAMES
#_______________________________________________________________________________
# Names of files and directories are case sensitive and should contain symbols
#  [a-zA-Z], [0-9], '_', '-' and '.'. Other symbols are allowed but should
#  be avoided (like space ' '), some symbols are forbidden (like '*').
# Filenames starting with '.' will not be listed (hidden):
ls
ls -a
# The '-a' switch adds them to the listing.

# The first column of a long list tells us whether an entry is a file or directory:
ls -al

# Most shells have auto-completion enabled, which works with the <TAB> key:
ls demof<TAB>
# Auto-completion works for paths and file names.

#_______________________________________________________________________________
# CREATE and REMOVE
#_______________________________________________________________________________
# Create two empty files:
touch test.ff
touch test.ff.0

# Create two empty directories:
mkdir test.dd
mkdir test.dd.0

# Remove one file:
rm test.ff.0

# Remove one directory:
rmdir test.dd.0

# Both, 'rm' and 'rmdir', have a forcing switch '-f' and a recursive switch '-r'.
# The switch combination '-fr' is common but dangerous.

# Change the name of the remaining file:
mv test.ff newtest.ff

# Change the name of the remaining directory:
mv test.dd newtest.dd

# Copy the file:
cp newtest.ff testcopy.ff

# Copy the directory, which needs to be performed in recursive mode:
cp -r newtest.dd testcopy.dd

# File permissions are organised as rwx (read|write|execute)
#   for ugo (user|group|others)
# Change the permission:
ls -l testcopy.ff
chmod go-r testcopy.ff
ls -l testcopy.ff

ls -l
chmod g+w testcopy.dd
ls -l

# Symbolic links are pointers to a file or directory and provide useful
#   shortcuts without the need to copy files.
# Typically binaries, libraries or large data sets get linked.
ln -s /tmp
ln -s /tmp symlink_to_tmp
# The symbolic is clearly different from other files:
ls -l
# You may remove the link without affecting the target.

#_______________________________________________________________________________
# FILE CONTENT
#_______________________________________________________________________________
# Show file contents:
cat linuxTutorial.bash

# Show beginning or end of files (useful for large files):
head linuxTutorial.bash
tail linuxTutorial.bash

# Access file contents interactively:
less linuxTutorial.bash

# Popular editors are vim, emacs and nano

#_______________________________________________________________________________
# SEARCHING with WILDCARDS and PATTERNS
#_______________________________________________________________________________
# Wildcards provide ways to generalise commands.
# '*' matches any string:
ls test*

# '?' matches any single character:
ls testcopy.??

# '[]' allows for ambiguity:
ls testcopy.[fd][fd]

# Search for file or directory names that match specified criteria:
find ./ -name demodir? -print

# Search for content in files:
grep 'Wildcards provide' *

# More complex tasks can be performed with pattern matching,
#   which is probably easiest done with the Perl syntax (-P);
#   '-o' returns only the matched strings:
grep -P "lete?" *.bash
grep -Po "lete?" *.bash

#_______________________________________________________________________________
# STREAMS and PIPELINES
#_______________________________________________________________________________
# Linux tools accept input streams, therefore one can build pipelines:
cat linuxTutorial.bash | wc
cat linuxTutorial.bash | sort
cat linuxTutorial.bash | sort | grep "head"

# Output can be redirected by '>' (overwrite) and '>>' (append):
ls -1 > out.log
ls -l >> out.log
# 'cat' out.log to see the appended block.

# Data streams have file descriptors (FDs).
# Standard input has one stream 'stdin' (FD=0).
# Output is generated in two streams, 'stdout' (FD=1) and 'stderr' (FD=2).
# You can separate the two output streams:
cat out.log out1.log 2>stderr.log 1>stdout.log
# 'cat' the new log files to compare their content.
# Cluster jobs stream their output into separate stderr and stdout files.

# You may do the reverse and bundle both streams by redirecting 
#   stderr to the address of stdout:
cat out.log out1.log > allout.log 2>&1

# Sometimes a pipeline creates multiple, blank-separated entries.
# To process those one may need to resolve them with 'xargs'
#   as separate items:
ls -1 *.log | xargs -i bash -c "echo {}"
ls -1 *.log | xargs -i bash -c "cat {}"

# Output can be modified with 'cut' and 'paste':
ps -ef  | tail | cut -b 1-20 > list_short
ps -ef  | tail | cut -b 1-30 > list_long
paste list_short list_long > list_merged
# 'cat' list_merged to see whether the PIDs match.

#_______________________________________________________________________________
# PROCESS CONTROL
#_______________________________________________________________________________
# Active processes can be listed:
top
# Option '1' shows the CPUs, 'M' sorts by memory usage.

# All current processes are shown in a process snapshot:
ps -ef
ps -elf
# Every process in Linux is attached to a process identifier (PID).
# The PID can be used to monitor and control the process.

# If you own the process and want to terminate it (use cautiously):
kill <PID>
#  and if it is very persistent:
kill -9 <PID>

# A process runs usually in the foreground:
sleep 10 ; ls
# You can stop the foreground process and send it to the background:
sleep 10
[CNTRL Z]
bg

# Alternatively you may start it directly in the background:
sleep 1 &
# The shell returns the PID.

# PIDs can be accessed by %<PID>:
sleep 10 &
#% [1] <PID>
wait %1

# The location of programs as the system knows them:
which rsync

# The program can be tested for executability:
test -x /usr/bin/rsync
# Every command has a return value that is caught by the variable '?',
#   the value of which can be returned with 'echo':
echo $?

# Another frequently used variable is the path of executables:
echo ${PATH}

# The 'test' program is a generic tool to evaluate expressions:
( test 2 -eq 2 ) && ( echo "True" || echo "False" )
( test -e  demodir ) && ( echo "True" || echo "False" )

#_______________________________________________________________________________
# COMMAND HISTORY
#_______________________________________________________________________________
# Commands are stored in 'history':
history

# You can use the history to find previous commands:
history | grep 'find'
#% 599  find ./ -name demodir? -print 

# The command can be re-run by using a '!' prefix and the command number:
!599

# Alternatively you may search with [CNTRL r] and keyword.

#_______________________________________________________________________________
# REMOTE ACCESS, COPY and SYNCHRONISATION
#_______________________________________________________________________________
# Remote access may be granted to known users via secure shell 'ssh':
ssh canes@159.92.55.65

# Similarly, scp allows for remote copy from the remote source to the
#   local target:
scp canes@159.92.55.65:/my_source ./my_target
# The reverse direction works as well:
scp ./my_source canes@159.92.55.65:/my_target

# To synchronise directories depending on the time stamp of files use 'rsync':
rsync -av canes@159.92.55.65:/my_source/ ./my_target/
# 'rsync' is sensitive to the trailing slash: everything after the slash will be
#   synchronised to the location after the slash.
rsync -av canes@159.92.55.65:/my_source ./my_target/
# In this example the 'my_source' directory would be appended to 'my_target/'.
#  'rsync' is useful for large directories, because only files that are
#   additional or more recent in the source are going to be transfered.

#_______________________________________________________________________________
# COMPUTER CLUSTER
#_______________________________________________________________________________
# Computer clusters provide an easy way to parallelise repetitive tasks,
#   for example several replica simulations of the same system.
# A cluster is usually composed of a single head node and several compute nodes.
# Users log-in to the head node and submit jobs to the 'queue'.
# The queue is a resource manager running on the head node that assigns compute
# nodes to the jobs depending on the requested resources.
# A job can run on one or several nodes, where the (sometimes limiting)
#  communication speed between compute nodes depends mostly on the network
#  hardware.
# A job submission command is composed of these components:
<queue_submit> <queue_parameters> <program> <program_parameters>

# Users belong to groups with defined permissions, priorities and resource
#   allocations. Usually several queues exist with specific time quotas.
# It is useful to get informed about the options and limitations to maximise
#   the usage of the resources.
# The streams stdout and stderr are stored in default files unless the user
#   specifies alternative file names.

# on ada
qsub -ar 265 submit_MPI_ada.sh &
qstat
# with MPI
qsub -ar 265 submit_MPI_ada.sh &
qstat

# on mull
srun --job-name tst --nodes=1 --ntasks-per-node=1 --ntasks=1 --cpus-per-task=1 -o output.o -e output.e submit_mull.bash &
squeue
# with MPI
srun --job-name tst --nodes=1 --ntasks-per-node=1 --ntasks=1 --cpus-per-task=4 -o output_MPI.o -e output_MPI.e submit_MPI_mull.bash &

# Advice: Learn one scripting language (bash, Perl, Python) that allows you
#   to automate repetitive processes, for example the analysis of replicas.

# Typical problems in cluster jobs:
# - Environmental variables are not found, because they exist only on
#     the head node and not on the compute nodes.
# - Programs or files are not found because the path on the head node is
#     not known to the compute node.
# - A program (or compute node) crashes because the jobs exceed the available
#     memory.
# - A program is terminated by the scheduler because it has exceeded the
#     time quota of the queue.

