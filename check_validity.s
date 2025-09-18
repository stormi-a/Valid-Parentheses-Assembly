.text
valid_message: .asciz "valid"
invalid_message: .asciz "invalid"
format_character: .asciz "%c"

.include "basic.s"

.global main

# *******************************************************************************************
# Subroutine: check_validity                                                                *
# Description: checks the validity of a string of parentheses as defined in Assignment 6.   *
# Parameters:                                                                               *
#   first: the string that should be check_validity                                         *
#   return: the result of the check, either "valid" or "invalid"                            *
# *******************************************************************************************
check_validity:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	pushq %r13
	pushq %r15
	pushq %r14
	pushq %r12

	movq %rsp, %rcx
	movq $0, %r12		# r12 = counter for the open brackets
	movq $0, %r14		# r14 = counter for the closed brackets
	movq %rdi, %r13		# copy the MESSAGE in R13
	
	loop:
		cmpb $0, (%r13)
		je end_loop

		cmpb $'<', (%r13)
		je pushOpenBracketOnStack
		
		cmpb $'[', (%r13)
		je pushOpenBracketOnStack

		cmpb $'{', (%r13)
		je pushOpenBracketOnStack

		cmpb $'(', (%r13)
		je pushOpenBracketOnStack

		cmpb $'>', (%r13)
		je closedAngularBracket

		cmpb $']', (%r13)
		je closedSquareBracket

		cmpb $'}', (%r13)
		je closedCurlyBracket

		cmpb $')', (%r13)
		je closedRoundBracket

		pushOpenBracketOnStack:
			# movq (%r13), %rsi
			# movq $format_character, %rdi
			# call printf
			
			pushq (%r13)
			pushq (%r13)

			incq %r12
			incq %r13
			jmp loop

		closedAngularBracket:
			cmpb $'<', (%rsp)
			jne invalidCase

			popq %r15		# junk register
			popq %r15

			incq %r14
			incq %r13

			jmp loop
		
		closedSquareBracket:
			cmpb $'[', (%rsp)
			jne invalidCase

			popq %r15		# junk register
			popq %r15

			incq %r14
			incq %r13

			jmp loop
		
		closedCurlyBracket:
			cmpb $'{', (%rsp)
			jne invalidCase

			popq %r15		# junk register
			popq %r15

			incq %r14
			incq %r13

			jmp loop

		closedRoundBracket:
			cmpb $'(', (%rsp)
			jne invalidCase

			popq %r15		# junk register
			popq %r15

			incq %r14
			incq %r13

			jmp loop

		invalidCase:
		
			movq $invalid_message, %rax
			movq $invalid_message, %rdi
			call printf
			jmp end_function

	end_loop:

		cmpq %r12, %r14
		jne invalidCase2
			movq $valid_message, %rax
			movq $valid_message, %rdi
			call printf
			jmp end_function

		invalidCase2:
			movq $invalid_message, %rax
			movq $invalid_message, %rdi
			call printf

	end_function:

	movq %rcx, %rsp

	popq %r12
	popq %r14
	popq %r15
	popq %r13

	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	check_validity		# call check_validity

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

