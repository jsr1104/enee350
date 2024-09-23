# Write a MIPS I assembly language program “NextToMax.S” that inputs 10 integers from the 
# user, and finds the second largest number from them and prints it on the display. Use 
# system calls to input the 10 integers and output the result. Check to see if your program 
# assembles. Run your program in MARS or QTSPIM and capture the 
# screenshot of the display. Submit both the program and the screenshot.

    .data
input_prompt:   .asciiz "Please enter an integer: "
result:         .asciiz "The second largest int is: "

    .text
    .globl main
main:
    li      $t0, 10  # initialize the counter for input
    li      $t8, -2147483648  # will store second to max value
    li      $t9, -2147483647  # will store max value
input_loop:
    # check loop condition (if counter <= 0 then jump to end_program)
    ble     $t0, $zero, end_program

    # show prompt
    li      $v0, 4  # print_string
    la      $a0, input_prompt
    syscall

    # take input
    li      $v0, 5  # read_int
    syscall
    move    $t1, $v0  #store input into t1 register

    # check if current max < current input
    blt     $t9, $t1, new_max_found

    # check if  second max < current input < current max
    blt     $t8, $t1, new_second_max_found

    # decrement counter if no change
    sub     $t0, $t0, 1
    j       input_loop

new_max_found:
    move    $t8, $t9  # move previous max to second-to-max register
    move    $t9, $t1  # change the current max to the current input
    sub     $t0, $t0, 1  # decrement the counter
    j       input_loop

new_second_max_found:
    move    $t8, $t1  # change the second max to the current input
    sub     $t0, $t0, 1  # decrement the counter
    j       input_loop

end_program:
    # output result
    li      $v0, 4
    la      $a0, result  # print result string
    syscall
    
    li      $v0, 1
    move      $a0, $t8  # print second largest
    syscall

    # call for exit system
    li      $v0, 10
    syscall