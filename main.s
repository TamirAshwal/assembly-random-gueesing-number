.extern printf
.extern rand
.extern srand
.extern scrand
.extern scanf
.section .data
user_integer:
    .space 4, 0x0
user_guess:
    .space 4, 0x0
number_of_guesses:
    .long 0x0  
.section .rodata
user_format:
    .string "%d"
first_messege: 
    .string "Enter configuration seed: "
asking_user_guess:
    .string "What is your guess? "
Wrong_answer:
    .string "Incorrect.\n"
game_over_lost:
    .string "Game over, you lost :(. The correct answer was %d\n"
game_over_win:
    .string "Congratz! You won!\n" 

.section .text
.globl main

main:
# printing the user the first message
pushq %rbp
movq %rsp, %rbp  
movq $first_messege, %rdi
xorq %rax, %rax
call printf
# getting the user input
movq $user_format, %rdi
movq $user_integer, %rsi
xorq %rax, %rax
call scanf
# randomize the number
movq (user_integer), %rdi
xorq %rax, %rax
call srand
xorq %rax, %rax
call rand
# divide the number by 10 the remainder will be stored in rdx 
xorq %rdx, %rdx
movq $10, %rbx
idivq %rbx
movq %rdx, %rsi
movq %rsi, user_integer
# start of the game
loop:
# check if the number of tries is 5 if so jump to game over
    cmpq $5, (number_of_guesses)
    je game_over
    guess:
    # requset a number
        movq $asking_user_guess, %rdi
        xorq %rax, %rax
        call printf
        movq $user_format, %rdi
        movq $user_guess, %rsi
        xorq %rax, %rax
        call scanf
        # compare the user number with the random number if it's the same jump to correct
        movw (user_guess), %ax
        movw (user_integer), %bx
        cmpw %bx, %ax
        je correct
        # not the same number print wrong answer add 1 to the number of tries
        movq $Wrong_answer, %rdi
        xorq %rax, %rax
        call printf
        incq (number_of_guesses)
        # jump to the begging of the loop to try again     
        jmp loop
        # correct answer print win message and exit 
    correct:
        movq $game_over_win, %rdi
        xorq %rax, %rax
        call printf
        jmp done
    
    # the user lost the game print the correct number and exit
    game_over:
        xorq %rax, %rax
        movq $game_over_lost, %rdi
        movq (user_integer), %rsi
        call printf
        jmp done    
    jmp loop  
done:
    movq %rbp, %rsp
    popq %rbp
    ret

