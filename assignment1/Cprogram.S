# Translate (by hand) the given C program into an equivalent MIPS I assembly program. 
# Check to see if your program assembles. Run your program in MARS or QTSPIM and 
# capture the screenshot of the display. Submit both the program and the screenshot.
# int a[4];
# main() {
#   int i, j;
#   print_str(“Input an integer: \n”); // MARS/SPIM call
#   i = read_int(); // MARS/SPIM call
#   j = fibonacci(i);
#   print_str(“The Fibonacci number is: ”); // MARS/SPIM call
#   print_int(j); // MARS/SPIM call
#   exit();
# }
# fibonacci(int p)
# {
#   int rv = 1;
#   if (p > 2)
#       rv = fibonacci(p-1) + fibonacci(p-2);
#   return rv;
# }

    .data
a:          .space 16 # reserve space for the int array(4 bytes each)
prompt1:    .asciiz "Input an integer: \n"
prompt2:    .asciiz "The Fibonacci number is: \n"

    .text
    .globl main
main:
    # Print "Input an integer: \n"
    li      $v0, 4
    la      $a0, prompt1
    syscall

    # Read integer input and store it in $a0
    li      $v0, 5
    syscall
    move    $a0, $v0  # Move input to $a0 for fib

    # Call fibonacci(i)
    jal     fib        # Result will be in $v0
    move    $t0, $v0  # Store returned value in $t0

    # Print "The Fibonacci number is: \n"
    li      $v0, 4
    la      $a0, prompt2
    syscall

    # Print the Fibonacci number stored in $t0
    li      $v0, 1
    move    $a0, $t0  # Correctly move from $t0 instead of $t1
    syscall

    # Exit the program
    li      $v0, 10
    syscall

fib:
    # Prologue
    addi    $sp, $sp, -12
    sw      $ra, 8($sp)        # Store return address
    sw      $a0, 4($sp)        # Store parameter p
    sw      $s0, 0($sp)        # Store $s0

    # if (p <= 2), return 1
    ble     $a0, 2, base_case

    # rv = fibonacci(p-1) + fibonacci(p-2)
    addi    $a0, $a0, -1       # p-1
    jal     fib                 # Call fibonacci(p-1)
    move    $s0, $v0            # Store fib(p-1) in $s0

    lw      $a0, 4($sp)         # Reload original p
    addi    $a0, $a0, -2        # p-2
    jal     fib                 # Call fibonacci(p-2)
    add     $v0, $v0, $s0       # fib(p-1) + fib(p-2)
    j       end_fib

base_case:
    li      $v0, 1

end_fib:
    # Epilogue
    lw      $s0, 0($sp)
    lw      $a0, 4($sp)
    lw      $ra, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra
