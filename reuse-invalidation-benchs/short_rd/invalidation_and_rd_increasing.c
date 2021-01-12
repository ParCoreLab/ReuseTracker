#include <stdio.h>
#include <omp.h>

// bin start size: 130
int main () {
	int val = 0;
	int num_threads = 0;
	/*__asm__ __volatile__ ("movl $100000000, %%ecx\n\t"
                "movl $0, %%edx\n\t"
                "1:\n\t"
                "incl %0\n\t"
                "loop 1b\n\t"
		: "=m" (val)
		:
		: "memory", "%ecx", "%edx"
		);*/
	char shared_array[4000000];
	// a2 must be bigger than 0

	int outer = 10, a = 20, a1 = 1000, b = 20, b1 = 2000, c = 20, c1 = 4000, d = 20, d1 = 8000, e = 20, e1 = 16000, s1 = 1;
#pragma omp parallel
	{
	int output;
	char array1[100000];
	char array2[200000];
	char array3[400000];
	char array4[800000];
	char array5[1600000];
	// time distance: 200000, frequency: 10 M 
	for(int i =  0; i < outer; i++) {
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t" // debug
		"loop1:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop01:\n\t"
                "movl %%edx, (%%r8)\n\t"
                //"mfence\n\t"
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
                : "c" (array1), "S" (shared_array), "b" (a1), "D" (s1), "d" (a)
                : "%eax", "memory", "cc"
            );
	__asm__ __volatile__ (
		//"movl $0, %%r10d\n\t" // debug
		"loop2:\n\t"
                "movl %%edi, %%eax\n\t"
                "movq %%rsi, %%r8\n\t"
                "loop02:\n\t"
                "movl %%edx, (%%r8)\n\t"
                //"mfence\n\t"
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
                : "c" (array2), "S" (shared_array), "b" (b1), "D" (s1), "d" (b)
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
                //"mfence\n\t"
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
                : "c" (array3), "S" (shared_array), "b" (c1), "D" (s1), "d" (c)
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
                //"mfence\n\t"
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
                : "c" (array4), "S" (shared_array), "b" (d1), "D" (s1), "d" (d)
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
                //"mfence\n\t"
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
                : "c" (array5), "S" (shared_array), "b" (e1), "D" (s1), "d" (e)
                : "%eax", "memory", "cc"
            );
        }

	#pragma omp single
	{
		num_threads = omp_get_num_threads();
		/*for(int i = 0; i < s1; i++) {
                        fprintf(stderr, "shared_array[%d]: %d\n", i, shared_array[i]);
                }*/
		/*for(int i = 0; i < a1; i++) {
                	fprintf(stderr, "array1[%d]: %d\n", i, array1[i]);
        	}*/
	}
	}
	return 0;
}
