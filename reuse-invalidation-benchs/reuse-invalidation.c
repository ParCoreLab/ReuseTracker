#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <omp.h>

// bin start size: 130
int main (int argc, char* argv[]) {
	int val = 0;
	int num_threads = 0;
	char shared_array[4000000];
	
	int outer = 10, a = 100, a1 = 1000, b = 30, b1 = 2000, c = 24, c1 = 4000, d = 8, d1 = 8000, e = 7, e1 = 16000, inv = 1;	
	for (int i = 1; i < argc; ++i) {
        	if (strncmp(argv[i], "-outer", 7) == 0) {
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		outer = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 1\n");
                		return 1;
            		}  
        	} else if (strncmp(argv[i], "-a0", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
				a = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 2\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-a1", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		a1 = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 3\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-b0", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		b = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 4\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-b1", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		b1 = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 5\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-c0", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		c = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 6\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-c1", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		c1 = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 7\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-d0", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		d = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 8\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-d1", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		d1 = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 9\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-e0", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		e = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 10\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-e1", 3) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		e1 = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 11\n");
                		return 1;
            		}
        	} else if (strncmp(argv[i], "-inv", 4) == 0){
            		if (i + 1 < argc) { // Make sure we aren't at the end of argv!
                		inv = atoi(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
            		} else { // Uh-oh, there was no argument to the destination option.
                  		fprintf(stderr, "There is an error in parsing the command line argument 12\n");
                		return 1;
            		}
        	} else { // Uh-oh, there was no argument to the destination option.
                  	fprintf(stderr, "There is an error in parsing the command line argument 13\n");
			fprintf(stderr,"%s\n", argv[i]);
                	return 1;
            	}
    	}

	fprintf(stderr, "outer: %d, a: %d, a1: %d, b: %d, b1: %d, c: %d, c1: %d, d: %d, d1: %d, e: %d, e1: %d, inv: %d\n", outer, a, a1, b, b1, c, c1, d, d1, e, e1, inv);
	#pragma omp parallel
	{
	int output;
	char array1[100000];
	char array2[200000];
	char array3[400000];
	char array4[800000];
	char array5[1600000];
	// time distance: 200000, frequency: 10 M 
	for(int i =  0; i < outer; ++i) {
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t" // debug
		"loop1:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop01:\n\t"
                "movl %%edx, (%%r8)\n\t"
                "mfence\n\t"
                //"movl %%r10d, (%%r8)\n\t" // debug
                "addq $1, %%r8\n\t"
                "decl %%eax\n\t"
                "jnz loop01\n\t"
		"movl %%ebx, %%eax\n\t"
		"movq %%rcx, %%r8\n\t"
		"loop:\n\t"
		"movb (%%r8), %%r9b\n\t"
		"addq $1, %%r8\n\t"
		"movl %%edx, (%%r8)\n\t"
		//"movl %%r10d, (%%r8)\n\t" // debug
		"addq $1, %%r8\n\t"
		"subl $2, %%eax\n\t"
		"jnz loop\n\t"
		//"addl $1, %%r10d\n\t" // debug
		"decl %%edx\n\t"
		"jnz loop1\n\t"
                :
                : "c" (array1), "S" (shared_array), "b" (a1), "D" (inv), "d" (a)
                : "%eax", "memory", "cc"
            );
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t" // debug
		"loop2:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop02:\n\t"
                "movl %%edx, (%%r8)\n\t"
                "mfence\n\t"
                //"movl %%r10d, (%%r8)\n\t" // debug
                "addq $1, %%r8\n\t"
                "decl %%eax\n\t"
                "jnz loop02\n\t"
		"movl %%ebx, %%eax\n\t"
		"movq %%rcx, %%r8\n\t"
		"loop12:\n\t"
		"movb (%%r8), %%r9b\n\t"
		"addq $1, %%r8\n\t"
		"movl %%edx, (%%r8)\n\t"
		//"movl %%r10d, (%%r8)\n\t" // debug
		"addq $1, %%r8\n\t"
		"subl $2, %%eax\n\t"
		"jnz loop12\n\t"
		//"addl $1, %%r10d\n\t" // debug
		"decl %%edx\n\t"
		"jnz loop2\n\t"
                :
                : "c" (array2), "S" (shared_array), "b" (b1), "D" (inv), "d" (b)
                : "%eax", "memory", "cc"
            );	
	// time distance: 1000000, frequency: 40 M 
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t"
		"loop3:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop03:\n\t"
                "movl %%edx, (%%r8)\n\t"
                "mfence\n\t"
                //"movl %%r10d, (%%r8)\n\t"
                "addq $1, %%r8\n\t"
                "decl %%eax\n\t"
                "jnz loop03\n\t"
		"movl %%ebx, %%eax\n\t"
		"movq %%rcx, %%r8\n\t"
		"loop13:\n\t"
		"movb (%%r8), %%r9b\n\t"
		"addq $1, %%r8\n\t"
		"movl %%edx, (%%r8)\n\t"
		//"movl %%r10d, (%%r8)\n\t"
		"addq $1, %%r8\n\t"
		"subl $2, %%eax\n\t"
		"jnz loop13\n\t"
		//"addl $1, %%r10d\n\t"
		"decl %%edx\n\t"
		"jnz loop3\n\t"
                :
                : "c" (array3), "S" (shared_array), "b" (c1), "D" (inv), "d" (c)
                : "%eax", "memory", "cc"
            );
           // now this one
	// time distance: 2000000, frequency: 20 M 
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t"
		"loop4:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop04:\n\t"
                "movl %%edx, (%%r8)\n\t"
                "mfence\n\t"
                //"movl %%r10d, (%%r8)\n\t"
                "addq $1, %%r8\n\t"
                "decl %%eax\n\t"
                "jnz loop04\n\t"
		"movl %%ebx, %%eax\n\t"
		"movq %%rcx, %%r8\n\t"
		"loop14:\n\t"
		"movb (%%r8), %%r9b\n\t"
		"addq $1, %%r8\n\t"
		"movl %%edx, (%%r8)\n\t"
		//"movl %%r10d, (%%r8)\n\t"
		"addq $1, %%r8\n\t"
		"subl $2, %%eax\n\t"
		"jnz loop14\n\t"
		//"addl $1, %%r10d\n\t"
		"decl %%edx\n\t"
		"jnz loop4\n\t"
                :
                : "c" (array4), "S" (shared_array), "b" (d1), "D" (inv), "d" (d)
                : "%eax", "memory", "cc"
            );
        // time distance: 4000000, frequency: 8 M 
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t"
		"loop5:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop05:\n\t"
                "movl %%edx, (%%r8)\n\t"
                "mfence\n\t"
                //"movl %%r10d, (%%r8)\n\t"
                "addq $1, %%r8\n\t"
                "decl %%eax\n\t"
                "jnz loop05\n\t"
		"movl %%ebx, %%eax\n\t"
		"movq %%rcx, %%r8\n\t"
		"loop15:\n\t"
		"movb (%%r8), %%r9b\n\t"
		"addq $1, %%r8\n\t"
		"movl %%edx, (%%r8)\n\t"
		//"movl %%r10d, (%%r8)\n\t"
		"addq $1, %%r8\n\t"
		"subl $2, %%eax\n\t"
		"jnz loop15\n\t"
		//"addl $1, %%r10d\n\t"
		"decl %%edx\n\t"
		"jnz loop5\n\t"
                :
                : "c" (array5), "S" (shared_array), "b" (e1), "D" (inv), "d" (e)
                : "%eax", "memory", "cc"
            );
        }

	#pragma omp single
	{
		num_threads = omp_get_num_threads();
		/*for(int i = 0; i < inv; ++i) {
                        fprintf(stderr, "shared_array[%d]: %d\n", i, shared_array[i]);
                }*/
		/*for(int i = 0; i < a1; ++i) {
                	fprintf(stderr, "array1[%d]: %d\n", i, array1[i]);
        	}*/
	}
	}
	return 0;
}
