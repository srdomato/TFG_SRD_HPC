#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

#ifndef N
#define N	2000000000
#endif

#ifndef TIMES
#define TIMES	40
#endif

int main(int argc, char *argv[])
{
    int n, myid, numprocs, i, j, t_total;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x;
    MPI_Status status;
    double buffpi;
    struct timeval  ti, tf;
    char name[256];
    int length;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    MPI_Get_processor_name(name, &length);

    n = N;

    if (n == 0) {
        if (myid == 0)
	         printf("N should be greater than 0\n");
         MPI_Finalize();
         return 0;
    }

    if (myid == 0)
	printf("NPROCS=%d, N=%d, TIMES=%d\n", numprocs, n,TIMES);

    printf("%s: I am process %d of %d\n", name, myid, numprocs);
    fflush(stdout);

    MPI_Barrier(MPI_COMM_WORLD);

    gettimeofday(&ti, NULL);

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    for (j = 0; j < TIMES; j++) {
	    h   = 1.0 / (double) n;
	    sum = 0.0;
	    for (i = myid + 1; i <= n; i += numprocs) {
        	x = h * ((double)i - 0.5);
	        sum += 4.0 / (1.0 + x*x);
	    }
	    mypi = h * sum;
    }
    
    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    gettimeofday(&tf, NULL);

    if (myid == 0) {
        t_total = (tf.tv_usec - ti.tv_usec)+ 1000000 * (tf.tv_sec - ti.tv_sec);
        printf("pi is approximately %.16f, Error is %.16f\n", pi, fabs(pi - PI25DT));
	printf ("Time (seconds) = %.10f\n", (double) t_total/1E6);
    }

    MPI_Finalize();
    return 0;
}
