# Write a MIPS I assembly language program “Max.S” that prints the maximum between two
# numbers inputted by the end user. Use system calls to input the two integers. Check to see 
# if your program assembles. Run your program in MARS or QTSPIM and capture the 
# screenshot of the display. Submit both the program and the screenshot.

.data
prompt1:    .asciiz "Please enter first integer: "
prompt2:    .asciiz "Please enter second integer: "
result:     .asciiz "The maximum number is: "
result_eq:  .asciiz "Inputs are equal."
newline:    .asciiz "\n"

.text

.global main
main:
    # read integer 1 into in1 and store into temporary register 0
    li      $v0, 4  # print_string
    la      $a0, prompt1
    syscall

    li      $v0, 5  # read_integer
    syscall
    move    $t0, $v0  # copy from v0 to temp register 0

    # read integer 2 into in2 and store into temporary register 1
    li      $v0, 4  # print_string
    la      $a0, prompt2
    syscall

    li      $v0, 5 # read_integer
    syscall
    move    $t1, $v0  # copy from v0 to temp register 0

    # compare the two integer inputs
    bgt     $t0, $t1, int_one_is_greater  #go to label if t0 > t1
    blt     $t0, $t1, int_two_is_greater  #go to label if t0 < t1
    beq     $t0, $t1, int_inputs_are_equal
    # these cases should move to a label, this ends the instructions in the main method

int_one_is_greater:
    li      $v0, 4  # load print_string instruction
    la      $a0, result
    syscall

    move    $a0, $t0
    li      $v0, 1  # load print_integer instruction
    syscall
    j       end_program


int_two_is_greater:
    li      $v0, 4  # load print_string instruction
    la      $a0, result
    syscall

    move    $a0, $t1
    li      $v0, 1  # load print_integer instruction
    syscall
    j       end_program

int_inputs_are_equal:
li      $v0, 4  # load print_string instruction
    la      $a0, result_eq
    syscall
    j       end_program

end_program:
    li      $v0, 4
    la      $a0, newline
    syscall

    li      $v0, 10  # exit the program
    syscall