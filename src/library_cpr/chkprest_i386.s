	.file	"chkprest.c"
	.version	"01.01"
gcc2_compiled.:
.globl cprl_bin_name
.data
	.align 4
	.type	 cprl_bin_name,@object
	.size	 cprl_bin_name,4
cprl_bin_name:
	.long 0
.globl cprl_buffer_size
	.align 4
	.type	 cprl_buffer_size,@object
	.size	 cprl_buffer_size,4
cprl_buffer_size:
	.long 0
.globl cprl_saved_stack
	.align 4
	.type	 cprl_saved_stack,@object
	.size	 cprl_saved_stack,4
cprl_saved_stack:
	.long 0
.globl cprl_state
	.align 4
	.type	 cprl_state,@object
	.size	 cprl_state,4
cprl_state:
	.long 0
.globl cpr_restart_count
	.align 4
	.type	 cpr_restart_count,@object
	.size	 cpr_restart_count,4
cpr_restart_count:
	.long 0
.globl cpr_restart_ind
	.align 4
	.type	 cpr_restart_ind,@object
	.size	 cpr_restart_ind,4
cpr_restart_ind:
	.long 0
.text
	.align 4
.globl cpr_init
	.type	 cpr_init,@function
cpr_init:
	pushl %ebp
	movl %esp,%ebp
	subl $4,%esp
	movl %ebp,%eax
	movl %eax,cprl_start_stack
	movl $0,-4(%ebp)
.L2:
	movl -4(%ebp),%eax
	cmpl %eax,8(%ebp)
	jg .L5
	jmp .L3
	.align 4
.L5:
.L4:
	incl -4(%ebp)
	jmp .L2
	.align 4
.L3:
.L1:
	leave
	ret
.Lfe1:
	.size	 cpr_init,.Lfe1-cpr_init
.section	.rodata
.LC0:
	.string	"Checkpoint/Restart: cprl_prepare() issued in wrong state.\n"
.LC1:
	.string	"Checkpoint/Restart: Error deleting checkpoint %s (%d)"
.text
	.align 4
.globl cpr_prepare
	.type	 cpr_prepare,@function
cpr_prepare:
	pushl %ebp
	movl %esp,%ebp
	subl $4180,%esp
	cmpl $1,cprl_state
	jne .L7
	pushl $.LC0
	pushl $_IO_stderr_
	call fprintf
	addl $8,%esp
	pushl $1
	call exit
	addl $4,%esp
	.align 4
.L7:
	cmpl $0,cprl_state
	jne .L8
	movb $0,cprl_rst_name
	movb $0,cprl_old_name
	movb $0,cprl_del_name
.L8:
	cmpb $0,cprl_del_name
	je .L9
	pushl $cprl_del_name
	call unlink
	addl $4,%esp
	movl %eax,%eax
	movl %eax,-4(%ebp)
	cmpl $0,-4(%ebp)
	je .L10
	call __errno_location
	movl %eax,%eax
	movl %eax,%edx
	cmpl $2,(%edx)
	je .L10
	movl -4(%ebp),%eax
	pushl %eax
	pushl $cprl_del_name
	pushl $.LC1
	leal -4180(%ebp),%eax
	pushl %eax
	call sprintf
	addl $16,%esp
	leal -4180(%ebp),%eax
	pushl %eax
	call perror
	addl $4,%esp
	pushl $1
	call exit
	addl $4,%esp
	.align 4
.L10:
.L9:
	cmpl $0,cprl_bin_name
	jne .L11
	movl 12(%ebp),%eax
	pushl %eax
	call strlen
	addl $4,%esp
	movl %eax,%eax
	leal 1(%eax),%edx
	pushl %edx
	call malloc
	addl $4,%esp
	movl %eax,cprl_bin_name
	movl 12(%ebp),%eax
	pushl %eax
	movl cprl_bin_name,%eax
	pushl %eax
	call strcpy
	addl $8,%esp
.L11:
	pushl $cprl_old_name
	pushl $cprl_del_name
	call strcpy
	addl $8,%esp
	pushl $cprl_rst_name
	pushl $cprl_old_name
	call strcpy
	addl $8,%esp
	movl 8(%ebp),%eax
	pushl %eax
	pushl $cprl_rst_name
	call strcpy
	addl $8,%esp
	movl $1,cprl_state
.L6:
	leave
	ret
.Lfe2:
	.size	 cpr_prepare,.Lfe2-cpr_prepare
.section	.rodata
.LC2:
	.string	"Checkpoint/Restart: Internal state error.\n"
.LC3:
	.string	"Checkpoint/Restart: unable to allocate %d byte stack.\n"
.LC4:
	.string	"mv %s %s"
.LC5:
	.string	"Checkpoint/Restart: Error moving checkpoint %s"
.text
	.align 4
.globl cpr_take
	.type	 cpr_take,@function
cpr_take:
	pushl %ebp
	movl %esp,%ebp
	subl $16468,%esp
	cmpl $1,cprl_state
	je .L13
	pushl $.LC2
	pushl $_IO_stderr_
	call fprintf
	addl $8,%esp
	pushl $1
	call exit
	addl $4,%esp
	.align 4
.L13:
	movl %esp,%eax
	movl %eax,cprl_sp
	movl %ebp,%eax
	movl %eax,cprl_bp
	movl cprl_start_stack,%edx
	subl cprl_sp,%edx
	movl %edx,cprl_stack_size
	movl cprl_buffer_size,%eax
	cmpl %eax,cprl_stack_size
	jbe .L14
	movl cprl_stack_size,%edx
	addl $1024,%edx
	movl %edx,cprl_buffer_size
	cmpl $0,cprl_saved_stack
	je .L15
	movl cprl_saved_stack,%eax
	pushl %eax
	call free
	addl $4,%esp
.L15:
	movl cprl_buffer_size,%eax
	pushl %eax
	call malloc
	addl $4,%esp
	movl %eax,cprl_saved_stack
	cmpl $0,cprl_saved_stack
	jne .L16
	movl cprl_buffer_size,%eax
	pushl %eax
	pushl $.LC3
	pushl $_IO_stderr_
	call fprintf
	addl $12,%esp
	pushl $1
	call exit
	addl $4,%esp
	.align 4
.L16:
.L14:
	movl cprl_stack_size,%eax
	pushl %eax
	movl cprl_sp,%eax
	pushl %eax
	movl cprl_saved_stack,%eax
	pushl %eax
	call memcpy
	addl $12,%esp
	movl $1,cpr_restart_ind
	incl cpr_restart_count
	movl $2,cprl_state
	leal -4096(%ebp),%eax
	pushl %eax
	call tmpnam
	addl $4,%esp
	pushl $0
	pushl $0
	pushl $0
	movl cprl_bin_name,%eax
	pushl %eax
	leal -4096(%ebp),%eax
	pushl %eax
	call unexec
	addl $20,%esp
	pushl $cprl_rst_name
	leal -4096(%ebp),%eax
	pushl %eax
	pushl $.LC4
	leal -12292(%ebp),%eax
	pushl %eax
	call sprintf
	addl $16,%esp
	leal -12292(%ebp),%eax
	pushl %eax
	call system
	addl $4,%esp
	movl %eax,%eax
	testl %eax,%eax
	jge .L17
	pushl $cprl_rst_name
	pushl $.LC5
	leal -16468(%ebp),%eax
	pushl %eax
	call sprintf
	addl $12,%esp
	leal -16468(%ebp),%eax
	pushl %eax
	call perror
	addl $4,%esp
	pushl $1
	call exit
	addl $4,%esp
	.align 4
.L17:
	decl cpr_restart_count
	movl $0,cpr_restart_ind
.L12:
	leave
	ret
.Lfe3:
	.size	 cpr_take,.Lfe3-cpr_take
	.align 4
.globl cpr_restart
	.type	 cpr_restart,@function
cpr_restart:
	pushl %ebp
	movl %esp,%ebp
	movl cprl_sp,%eax
	movl %eax,%esp
	movl cprl_stack_size,%eax
	pushl %eax
	movl cprl_saved_stack,%eax
	pushl %eax
	movl cprl_sp,%eax
	pushl %eax
	call memcpy
	addl $12,%esp
	movl cprl_bp,%eax
	movl %eax,%ebp
.L18:
	leave
	ret
.Lfe4:
	.size	 cpr_restart,.Lfe4-cpr_restart
	.comm	cprl_start_stack,4,4
	.comm	cprl_rst_name,4095,1
	.comm	cprl_old_name,4095,1
	.comm	cprl_del_name,4095,1
	.comm	cprl_sp,4,4
	.comm	cprl_bp,4,4
	.comm	cprl_stack_size,4,4
	.ident	"GCC: (GNU) 2.7.2.3"
