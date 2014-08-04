
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	cpr_init
	.type	cpr_init,2
cpr_init:
	save	%sp,-104,%sp
	st	%i0,[%fp+68]

	! block 1
.L177:

! File chkprest.c:
!    2	#define SPARC
!    3	  /*
!    4	   * File chkprest.c contains checkpoint/restart functions to take 
!    5	   * checkpoints and effect restarts once the restart code has been 
!    6	   * given control. The restart code is generated using unexec (eg. unexelf.c)
!    7	   * by Spencer W. Thomas (available under the  GNU General Public License
!    8	   * from the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
!    9	   * Boston, MA 02111-1307, USA).
!   10	   *
!   11	   * This file is used to generate a template assembler source code for 
!   12	   * a particular machine (gcc -S or as -S). The assmebler source must be 
!   13	   * edited to correct the references to the dummy variables (see below)
!   14	   * to be references to the corresponding registers.
!   15	   *
!   16	   * Internal names are prefixed with "cprl_" and names in the external 
!   17	   * interfaces are prefixed "cpr_".
!   18	   *
!   19	   * Author: Stephen Donaldson.
!   20	   */
!   21	
!   22	#include <stdlib.h>
!   23	#include <stdio.h>
!   24	#include <string.h>
!   25	#include <errno.h>
!   26	
!   27	#define CPR_STACK_EXTRA 1024      /* extra padding on stack for realloc */
!   28	
!   29	char *cprl_start_stack;           /* highest stack address in checkpoint */
!   30	char *cprl_bin_name = NULL;       /* ELF executable file name */
!   31	char cprl_rst_name[FILENAME_MAX]; /* name of the restartable ELF binary */
!   32	char cprl_old_name[FILENAME_MAX]; /* name of the old restartable binary */
!   33	char cprl_del_name[FILENAME_MAX]; /* name of the old restartable binary */
!   34	
!   35	char *cprl_sp;                    /* stack pointer at time of checkpoint */
!   36	char *cprl_bp;                    /* frame pointer at time of checkpoint */
!   37	#ifndef I386
!   38	char *cprl_pc;                    /* program counter at time of checkpoint */
!   39	#endif
!   40	unsigned long cprl_stack_size;    /* size of stack included in checkpoint */
!   41	unsigned long cprl_buffer_size=0; /* size of buffer containing the stack */
!   42	char *cprl_saved_stack = NULL;    /* saved stack data in the checkpoint */
!   43	
!   45	int cprl_state = 0;              /* state indicator */
!   46	#define CPR_INITIAL   0          /* ... initial state - no checkpoint exists */
!   47	#define CPR_READY     1          /* ... ready to take checkpoint */
!   48	#define CPR_DONE      2          /* ... checkpoint taken */
!   49	
!   50	/* 
!   51	   * Flag that can be tested in the application program to determine
!   52	   * whether the code is the original code or a checkpointed version 
!   53	   * of the code.
!   54	   */
!   55	
!   56	int cpr_restart_count = 0;        /* number of times execution restarted */
!   57	int cpr_restart_ind = 0;          /* restart indicator */
!   58	
!   59	/*
!   60	   * Dummy variables for registers should not be defined. The corresponding
!   61	   * assembler source file should be edited to correct references to these
!   62	   * variables to references to the corresponding registers:
!   63	   *
!   64	   *            Stack pointer(sp)  Frame pointer(bp) Return address(pc)
!   65	   * SPARC      %sp                %fp              %i7
!   66	   * I386       %esp               %ebp             N/A (on stack)
!   67	   *
!   68	   */
!   69	
!   70	extern char *_sp_register;     /* reference to stack pointer register */
!   71	extern char *_bp_register;     /* reference to frame pointer register */
!   72	#ifndef I386
!   73	extern char *_pc_register;     /* reference to return address */
!   74	#endif
!   75	
!   76	  /*
!   77	   * Local prototypes:
!   78	   */
!   79	
!   80	void unexec(char *new, char *old, int, int, int);
!   81	
!   82	void cprl_take(int depth);
!   83	void cprl_restart(int depth);
!   84	 
!   85	#ifdef SPARC
!   86	void cprl_flush_win(int depth);
!   87	#endif /* SPARC */
!   88	
!   89	/*
!   90	   * Function cprl_init() is called once at a fixed depth in the main
!   91	   * program in order to mark the highest stack address which should
!   92	   * be included in the checkpoints.
!   93	   */
!   94	
!   95	void cpr_init(int depth)
!   96	{
!   97	  int i;
!   98	  cprl_start_stack = _bp_register;

	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	st	%fp,[%l0+0]

!   99	#ifdef SPARC
!  100	  cprl_flush_win(33);

	mov	33,%l0
	mov	%l0,%o0
	call	cprl_flush_win
	nop

!  101	#endif
!  102	
!  103	  /*
!  104	   * The following code jumps back up the the frame that is
!  105	   * the correct activation record that allows main to return
!  106	   * properly. Repeat for each increase in the nesting level
!  107	   * from which cprl_init() is called.
!  108	   */
!  109	  for(i=0;i<depth;i++) {

	mov	0,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bge	.L180
	nop

	! block 2
.L181:
.L178:

!  110	#ifdef SPARC
!  111	    cprl_start_stack = cprl_start_stack+56;

	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	ld	[%l0+0],%l0
	add	%l0,56,%l1
	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	st	%l1,[%l0+0]

!  112	    cprl_start_stack = *(char **)cprl_start_stack;

	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	ld	[%l0+0],%l0
	ld	[%l0+0],%l1
	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	st	%l1,[%l0+0]

!  113	    cprl_start_stack = cprl_start_stack+56;


!  114	    cprl_start_stack = *(char **)cprl_start_stack;


!  115	#endif /* SPARC */
!  116	#ifdef IX86
!  117	    cprl_start_stack = *(char **)cprl_start_stack;
!  118	    cprl_start_stack = *(char **)cprl_start_stack;
!  119	#endif /* IX86 */
!  120	  }

	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L178
	nop

	! block 3
.L182:
.L180:
.L176:
	jmp	%i7+8
	restore
	.size	cpr_init,(.-cpr_init)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	cpr_prepare
	.type	cpr_prepare,2
cpr_prepare:
	save	%sp,-1208,%sp
	st	%i1,[%fp+72]
	st	%i0,[%fp+68]

	! block 1
.L186:

! File chkprest.c:
!  121	}
!  122	
!  123	/*
!  124	   * Function cpr_prepare() deletes the oldest checkpoint and 
!  125	   * prepares for the next checkpoint.
!  126	   */
!  127	
!  128	void cpr_prepare(char *chkp_name, char *prog_name)
!  129	{
!  130	  int rc;
!  131	  char msg[FILENAME_MAX+80];
!  132	
!  133	  if (cprl_state == CPR_READY)

	sethi	%hi(cprl_state),%l0
	or	%l0,%lo(cprl_state),%l0
	ld	[%l0+0],%l0
	cmp	%l0,1
	bne	.L187
	nop

	! block 2
.L188:

!  134	    {
!  135	      fprintf(stderr,
!  136		      "Checkpoint/Restart: cprl_prepare() issued in wrong state.\n");

	sethi	%hi(_iob+32),%l0
	or	%l0,%lo(_iob+32),%l0
	sethi	%hi(.L189),%l1
	or	%l1,%lo(.L189),%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	fprintf
	nop

!  137	      exit(1);

	mov	1,%l0
	mov	%l0,%o0
	call	exit
	nop

	! block 3
.L187:

!  138	    }
!  139	
!  140	  if (cprl_state == CPR_INITIAL)

	sethi	%hi(cprl_state),%l0
	or	%l0,%lo(cprl_state),%l0
	ld	[%l0+0],%l0
	cmp	%l0,0
	bne	.L190
	nop

	! block 4
.L191:

!  141	    {
!  142	      cprl_rst_name[0] = 0;

	mov	0,%l1
	sethi	%hi(cprl_rst_name),%l0
	or	%l0,%lo(cprl_rst_name),%l0
	stb	%l1,[%l0+0]

!  143	      cprl_old_name[0] = 0;

	mov	0,%l1
	sethi	%hi(cprl_old_name),%l0
	or	%l0,%lo(cprl_old_name),%l0
	stb	%l1,[%l0+0]

!  144	      cprl_del_name[0] = 0;

	mov	0,%l1
	sethi	%hi(cprl_del_name),%l0
	or	%l0,%lo(cprl_del_name),%l0
	stb	%l1,[%l0+0]

	! block 5
.L190:

!  145	    }
!  146	
!  147	  if (cprl_del_name[0])

	sethi	%hi(cprl_del_name),%l0
	or	%l0,%lo(cprl_del_name),%l0
	ldsb	[%l0+0],%l0
	sll	%l0,24,%l0
	sra	%l0,24,%l0
	cmp	%l0,%g0
	be	.L192
	nop

	! block 6
.L193:

!  148	    {
!  149	      rc = unlink(cprl_del_name);

	sethi	%hi(cprl_del_name),%l0
	or	%l0,%lo(cprl_del_name),%l0
	mov	%l0,%o0
	call	unlink
	nop
	mov	%o0,%l0
	st	%l0,[%fp-4]

!  150	      if (rc && errno != ENOENT)

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L195
	nop

	! block 7
.L196:
	sethi	%hi(errno),%l0
	or	%l0,%lo(errno),%l0
	ld	[%l0+0],%l0
	cmp	%l0,2
	be	.L195
	nop

	! block 8
.L197:

!  151		{
!  152		  sprintf(msg,"Checkpoint/Restart: Error deleting checkpoint %s (%d)",
!  153			  cprl_del_name,rc);

	add	%fp,-1108,%l0
	sethi	%hi(.L198),%l1
	or	%l1,%lo(.L198),%l1
	sethi	%hi(cprl_del_name),%l2
	or	%l2,%lo(cprl_del_name),%l2
	ld	[%fp-4],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	call	sprintf
	nop

!  154		  perror(msg);

	add	%fp,-1108,%l0
	mov	%l0,%o0
	call	perror
	nop

!  155		  exit(1);

	mov	1,%l0
	mov	%l0,%o0
	call	exit
	nop

	! block 9
.L195:
.L192:

!  156		}
!  157	    }
!  158	
!  159	  if (!cprl_bin_name)

	sethi	%hi(cprl_bin_name),%l0
	or	%l0,%lo(cprl_bin_name),%l0
	ld	[%l0+0],%l0
	cmp	%l0,%g0
	bne	.L200
	nop

	! block 10
.L201:

!  160	    {
!  161	      cprl_bin_name = malloc(strlen(prog_name)+1);

	ld	[%fp+72],%l0
	mov	%l0,%o0
	call	strlen
	nop
	mov	%o0,%l0
	add	%l0,1,%l0
	mov	%l0,%o0
	call	malloc
	nop
	mov	%o0,%l1
	sethi	%hi(cprl_bin_name),%l0
	or	%l0,%lo(cprl_bin_name),%l0
	st	%l1,[%l0+0]

!  162	      strcpy(cprl_bin_name,prog_name);

	sethi	%hi(cprl_bin_name),%l0
	or	%l0,%lo(cprl_bin_name),%l0
	ld	[%l0+0],%l0
	ld	[%fp+72],%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	strcpy
	nop

	! block 11
.L200:

!  163	    }
!  164	
!  165	  strcpy(cprl_del_name,cprl_old_name);

	sethi	%hi(cprl_del_name),%l0
	or	%l0,%lo(cprl_del_name),%l0
	sethi	%hi(cprl_old_name),%l1
	or	%l1,%lo(cprl_old_name),%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	strcpy
	nop

!  166	  strcpy(cprl_old_name,cprl_rst_name);

	sethi	%hi(cprl_old_name),%l0
	or	%l0,%lo(cprl_old_name),%l0
	sethi	%hi(cprl_rst_name),%l1
	or	%l1,%lo(cprl_rst_name),%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	strcpy
	nop

!  167	  strcpy(cprl_rst_name,chkp_name);

	sethi	%hi(cprl_rst_name),%l0
	or	%l0,%lo(cprl_rst_name),%l0
	ld	[%fp+68],%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	strcpy
	nop

!  169	  cprl_state = CPR_READY;

	mov	1,%l1
	sethi	%hi(cprl_state),%l0
	or	%l0,%lo(cprl_state),%l0
	st	%l1,[%l0+0]

	! block 12
.L185:
	jmp	%i7+8
	restore
	.size	cpr_prepare,(.-cpr_prepare)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	cpr_take
	.type	cpr_take,2
cpr_take:
	sethi	%hi(-4280),%g1
	or	%g1,%lo(-4280),%g1
	save	%sp,%g1,%sp

	! block 1
.L205:

! File chkprest.c:
!  170	}
!  171	
!  172	/*
!  173	   * Function cprl_take() creates a new checkpoint file under the 
!  174	   * name passed in the cprl_init() call. 
!  175	   */
!  176	
!  177	void cpr_take() {
!  178	  char temp_file[FILENAME_MAX];
!  179	  char mv_cmd[2*FILENAME_MAX+3];
!  180	  char msg[FILENAME_MAX+80];
!  181	
!  182	#ifdef SPARC
!  183	  cprl_flush_win(33);

	mov	33,%l0
	mov	%l0,%o0
	call	cprl_flush_win
	nop

!  184	#endif
!  185	  if (cprl_state != CPR_READY)

	sethi	%hi(cprl_state),%l0
	or	%l0,%lo(cprl_state),%l0
	ld	[%l0+0],%l0
	cmp	%l0,1
	be	.L206
	nop

	! block 2
.L207:

!  186	    {
!  187	      fprintf(stderr,"Checkpoint/Restart: Internal state error.\n");

	sethi	%hi(_iob+32),%l0
	or	%l0,%lo(_iob+32),%l0
	sethi	%hi(.L208),%l1
	or	%l1,%lo(.L208),%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	fprintf
	nop

!  188	      exit(1);

	mov	1,%l0
	mov	%l0,%o0
	call	exit
	nop

	! block 3
.L206:

!  189	    }
!  190	  cprl_sp = _sp_register;

	sethi	%hi(cprl_sp),%l0
	or	%l0,%lo(cprl_sp),%l0
	st	%sp,[%l0+0]

!  191	  cprl_bp = _bp_register;

	sethi	%hi(cprl_bp),%l0
	or	%l0,%lo(cprl_bp),%l0
	st	%fp,[%l0+0]

!  192	#ifndef I386
!  193	  cprl_pc = _pc_register;

	sethi	%hi(cprl_pc),%l0
	or	%l0,%lo(cprl_pc),%l0
	st	%i7,[%l0+0]

!  194	#endif
!  195	  cprl_stack_size = cprl_start_stack-cprl_sp;

	sethi	%hi(cprl_start_stack),%l0
	or	%l0,%lo(cprl_start_stack),%l0
	ld	[%l0+0],%l2
	sethi	%hi(cprl_sp),%l0
	or	%l0,%lo(cprl_sp),%l0
	ld	[%l0+0],%l1
	sub	%l2,%l1,%l1
	sethi	%hi(cprl_stack_size),%l0
	or	%l0,%lo(cprl_stack_size),%l0
	st	%l1,[%l0+0]

!  196	  
!  197	  if (cprl_buffer_size<cprl_stack_size)

	sethi	%hi(cprl_buffer_size),%l0
	or	%l0,%lo(cprl_buffer_size),%l0
	ld	[%l0+0],%l1
	sethi	%hi(cprl_stack_size),%l0
	or	%l0,%lo(cprl_stack_size),%l0
	ld	[%l0+0],%l0
	cmp	%l1,%l0
	bgeu	.L209
	nop

	! block 4
.L210:

!  198	     {
!  199	     cprl_buffer_size=cprl_stack_size+CPR_STACK_EXTRA;

	sethi	%hi(cprl_stack_size),%l0
	or	%l0,%lo(cprl_stack_size),%l0
	ld	[%l0+0],%l0
	add	%l0,1024,%l1
	sethi	%hi(cprl_buffer_size),%l0
	or	%l0,%lo(cprl_buffer_size),%l0
	st	%l1,[%l0+0]

!  200	     if (cprl_saved_stack) free(cprl_saved_stack);

	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	ld	[%l0+0],%l0
	cmp	%l0,%g0
	be	.L211
	nop

	! block 5
.L212:
	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	ld	[%l0+0],%l0
	mov	%l0,%o0
	call	free
	nop

	! block 6
.L211:

!  201	     cprl_saved_stack = malloc(cprl_buffer_size);

	sethi	%hi(cprl_buffer_size),%l0
	or	%l0,%lo(cprl_buffer_size),%l0
	ld	[%l0+0],%l0
	mov	%l0,%o0
	call	malloc
	nop
	mov	%o0,%l1
	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	st	%l1,[%l0+0]

!  202	     if (cprl_saved_stack==NULL)

	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	ld	[%l0+0],%l1
	mov	0,%l0
	cmp	%l1,%l0
	bne	.L213
	nop

	! block 7
.L214:

!  203	        {
!  204	        fprintf(stderr,
!  205			"Checkpoint/Restart: unable to allocate %d byte stack.\n",
!  206			cprl_buffer_size);

	sethi	%hi(_iob+32),%l1
	or	%l1,%lo(_iob+32),%l1
	sethi	%hi(.L215),%l2
	or	%l2,%lo(.L215),%l2
	sethi	%hi(cprl_buffer_size),%l0
	or	%l0,%lo(cprl_buffer_size),%l0
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l0,%o2
	call	fprintf
	nop

!  207	        exit(1);

	mov	1,%l0
	mov	%l0,%o0
	call	exit
	nop

	! block 8
.L213:
.L209:

!  208	        }
!  209	     }
!  210	  memcpy(cprl_saved_stack,cprl_sp,cprl_stack_size);

	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	ld	[%l0+0],%l1
	sethi	%hi(cprl_sp),%l0
	or	%l0,%lo(cprl_sp),%l0
	ld	[%l0+0],%l2
	sethi	%hi(cprl_stack_size),%l0
	or	%l0,%lo(cprl_stack_size),%l0
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l0,%o2
	call	memcpy
	nop

!  211	  /* initialise values for new binary */
!  212	  cpr_restart_ind = 1; 

	mov	1,%l1
	sethi	%hi(cpr_restart_ind),%l0
	or	%l0,%lo(cpr_restart_ind),%l0
	st	%l1,[%l0+0]

!  213	  cpr_restart_count++;

	sethi	%hi(cpr_restart_count),%l0
	or	%l0,%lo(cpr_restart_count),%l0
	ld	[%l0+0],%l0
	add	%l0,1,%l1
	sethi	%hi(cpr_restart_count),%l0
	or	%l0,%lo(cpr_restart_count),%l0
	st	%l1,[%l0+0]

!  214	  cprl_state = CPR_DONE;

	mov	2,%l1
	sethi	%hi(cprl_state),%l0
	or	%l0,%lo(cprl_state),%l0
	st	%l1,[%l0+0]

!  216	  tmpnam(temp_file);

	add	%fp,-1024,%l0
	mov	%l0,%o0
	call	tmpnam
	nop

!  217	  unexec(temp_file,cprl_bin_name,0,0,0);

	add	%fp,-1024,%l1
	sethi	%hi(cprl_bin_name),%l0
	or	%l0,%lo(cprl_bin_name),%l0
	ld	[%l0+0],%l0
	mov	0,%l2
	mov	0,%l3
	mov	0,%l4
	mov	%l1,%o0
	mov	%l0,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l4,%o4
	call	unexec
	nop

!  218	  sprintf(mv_cmd,"mv %s %s",temp_file,cprl_rst_name);

	add	%fp,-3075,%l0
	sethi	%hi(.L217),%l1
	or	%l1,%lo(.L217),%l1
	add	%fp,-1024,%l2
	sethi	%hi(cprl_rst_name),%l3
	or	%l3,%lo(cprl_rst_name),%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	call	sprintf
	nop

!  219	  if (system(mv_cmd)<0) 

	add	%fp,-3075,%l0
	mov	%l0,%o0
	call	system
	nop
	mov	%o0,%l0
	cmp	%l0,0
	bge	.L218
	nop

	! block 9
.L219:

!  220	     {
!  221	     sprintf(msg,"Checkpoint/Restart: Error moving checkpoint %s",
!  222		     cprl_rst_name);

	sethi	4,%l0
	xor	%l0,-83,%l0
	add	%fp,%l0,%l0
	sethi	%hi(.L220),%l1
	or	%l1,%lo(.L220),%l1
	sethi	%hi(cprl_rst_name),%l2
	or	%l2,%lo(cprl_rst_name),%l2
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	sprintf
	nop

!  223	     perror(msg);

	sethi	4,%l0
	xor	%l0,-83,%l0
	add	%fp,%l0,%l0
	mov	%l0,%o0
	call	perror
	nop

!  224	     exit(1);

	mov	1,%l0
	mov	%l0,%o0
	call	exit
	nop

	! block 10
.L218:

!  225	     }
!  226	  /* restore to values for this binary */
!  227	  cpr_restart_count--;

	sethi	%hi(cpr_restart_count),%l0
	or	%l0,%lo(cpr_restart_count),%l0
	ld	[%l0+0],%l0
	sub	%l0,1,%l1
	sethi	%hi(cpr_restart_count),%l0
	or	%l0,%lo(cpr_restart_count),%l0
	st	%l1,[%l0+0]

!  228	  cpr_restart_ind = 0;

	mov	0,%l1
	sethi	%hi(cpr_restart_ind),%l0
	or	%l0,%lo(cpr_restart_ind),%l0
	st	%l1,[%l0+0]

	! block 11
.L204:
	jmp	%i7+8
	restore
	.size	cpr_take,(.-cpr_take)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	cpr_restart
	.type	cpr_restart,2
cpr_restart:
	save	%sp,-96,%sp

	! block 1
.L224:

! File chkprest.c:
!  229	}
!  230	
!  231	/*
!  232	   * Function cprl_restart() executed as part of a restarted checkpoint
!  233	   * restores the stack to the original state as when the checkpoint was
!  234	   * taken and continues execution from this checkpoint.
!  235	   */
!  236	
!  237	void cpr_restart()
!  238	{
!  239	
!  240	#ifdef SPARC
!  241	  cprl_flush_win(33);

	mov	33,%l0
	mov	%l0,%o0
	call	cprl_flush_win
	nop

!  242	#endif
!  243	  _sp_register = cprl_sp;

	sethi	%hi(cprl_sp),%l0
	or	%l0,%lo(cprl_sp),%l0
	ld	[%l0+0],%sp

!  244	  memcpy(cprl_sp,cprl_saved_stack,cprl_stack_size);

	sethi	%hi(cprl_sp),%l0
	or	%l0,%lo(cprl_sp),%l0
	ld	[%l0+0],%l1
	sethi	%hi(cprl_saved_stack),%l0
	or	%l0,%lo(cprl_saved_stack),%l0
	ld	[%l0+0],%l2
	sethi	%hi(cprl_stack_size),%l0
	or	%l0,%lo(cprl_stack_size),%l0
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l0,%o2
	call	memcpy
	nop

!  245	  _bp_register = cprl_bp;

	sethi	%hi(cprl_bp),%l0
	or	%l0,%lo(cprl_bp),%l0
	ld	[%l0+0],%fp

!  246	#ifndef I386
!  247	  _pc_register = cprl_pc;

	sethi	%hi(cprl_pc),%l0
	or	%l0,%lo(cprl_pc),%l0
	ld	[%l0+0],%i7

	! block 2
.L223:
	jmp	%i7+8
	restore
	.size	cpr_restart,(.-cpr_restart)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	cprl_flush_win
	.type	cprl_flush_win,2
cprl_flush_win:
	save	%sp,-96,%sp
	st	%i0,[%fp+68]

	! block 1
.L227:

! File chkprest.c:
!  248	#endif
!  249	
!  250	}
!  251	
!  252	#ifdef SPARC
!  253	/*
!  254	   * The recursive calls cause the register windows to be dumped 
!  255	   * onto the stack.
!  256	   */
!  257	void cprl_flush_win(int depth)
!  258	{
!  259	  if (depth) cprl_flush_win(depth-1);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	be	.L228
	nop

	! block 2
.L229:
	ld	[%fp+68],%l0
	sub	%l0,1,%l0
	mov	%l0,%o0
	call	cprl_flush_win
	nop

	! block 3
.L228:
.L226:
	jmp	%i7+8
	restore
	.size	cprl_flush_win,(.-cprl_flush_win)
	.align	8
	.common	cprl_start_stack,4,4

	.section	".data",#alloc,#write
	.align	4
	.global	cprl_state
cprl_state:
	.skip	4
	.type	cprl_state,#object
	.size	cprl_state,4

	.section	".data1",#alloc,#write
	.align	4
.L189:
	.ascii	"Checkpoint/Restart: cprl_prepare() issued in wrong state.\n\000"
	.skip	1
	.type	.L189,#object
	.size	.L189,60
	.common	cprl_rst_name,1024,1
	.common	cprl_old_name,1024,1
	.common	cprl_del_name,1024,1
	.align	4
.L198:
	.ascii	"Checkpoint/Restart: Error deleting checkpoint %s (%d)\000"
	.skip	2
	.type	.L198,#object
	.size	.L198,56

	.section	".data",#alloc,#write
	.align	4
	.global	cprl_bin_name
cprl_bin_name:
	.skip	4
	.type	cprl_bin_name,#object
	.size	cprl_bin_name,4

	.section	".data1",#alloc,#write
	.align	4
.L208:
	.ascii	"Checkpoint/Restart: Internal state error.\n\000"
	.skip	1
	.type	.L208,#object
	.size	.L208,44
	.common	cprl_sp,4,4
	.common	cprl_bp,4,4
	.common	cprl_pc,4,4
	.common	cprl_stack_size,4,4

	.section	".data",#alloc,#write
	.align	4
	.global	cprl_buffer_size
cprl_buffer_size:
	.skip	4
	.type	cprl_buffer_size,#object
	.size	cprl_buffer_size,4
	.align	4
	.global	cprl_saved_stack
cprl_saved_stack:
	.skip	4
	.type	cprl_saved_stack,#object
	.size	cprl_saved_stack,4

	.section	".data1",#alloc,#write
	.align	4
.L215:
	.ascii	"Checkpoint/Restart: unable to allocate %d byte stack.\n\000"
	.skip	1
	.type	.L215,#object
	.size	.L215,56

	.section	".data",#alloc,#write
	.align	4
	.global	cpr_restart_ind
cpr_restart_ind:
	.skip	4
	.type	cpr_restart_ind,#object
	.size	cpr_restart_ind,4
	.align	4
	.global	cpr_restart_count
cpr_restart_count:
	.skip	4
	.type	cpr_restart_count,#object
	.size	cpr_restart_count,4

	.section	".data1",#alloc,#write
	.align	4
.L217:
	.ascii	"mv %s %s\000"
	.skip	3
	.type	.L217,#object
	.size	.L217,12
	.align	4
.L220:
	.ascii	"Checkpoint/Restart: Error moving checkpoint %s\000"
	.type	.L220,#object
	.size	.L220,47

	.file	"chkprest.c"
	.xstabs	".stab.index","Xs ; V=3.1 ; R=SC4.0 18 Oct 1995 C 4.0",60,0,0,0
	.xstabs	".stab.index","/amd/tmp_mnt/garnet/fs25/jonh/BSP/build/Solaris/library_cpr; /opt/SUNWspro/SC4.0/bin/acc -Xs -YP,:/usr/ucblib:/opt/SUNWspro/SC4.0/bin/../lib:/opt/SUNWspro/SC4.0/bin:/usr/ccs/lib:/usr/lib -S -I/usr/ucbinclude  -c chkprest.c -Qoption acomp -xp",52,0,0,0
	.ident	"@(#)stdlib.h	1.27	95/08/28 SMI"
	.ident	"@(#)feature_tests.h	1.7	94/12/06 SMI"
	.ident	"@(#)stdio.h	1.7	95/06/08 SMI"
	.ident	"@(#)va_list.h	1.6	96/01/26 SMI"
	.ident	"@(#)string.h	1.17	95/08/28 SMI"
	.ident	"@(#)errno.h	1.13	95/09/10 SMI"
	.ident	"@(#)errno.h	1.15	95/01/22 SMI"
	.ident	"acomp: SC4.0 18 Oct 1995 C 4.0"
