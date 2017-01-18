
#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

.text
.set noreorder
.ent main
    
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
    /* your code goes underneath this */
 # ------------------------------------------------------------------------
 
    # hello label which prints out the greeting message "Hi!"
hello:  
    LA $a0, GREETING
    JAL puts 
    NOP
    # clear TRISE
    # set LEDs as outputs
    la $t0, TRISE
    sw $zero, 0($t0)
    # write to switches for the first LED
    # load immediate 0xf00 t0 $t0 and write TRISDSET to $t0
    # load address of LATE to $t0
    # load immediate 1 ot the $t0 register and write LATE to $t1
    li $t0, 0xf00
    sw $t0, TRISDSET
    
    la $t0, LATE
    li $t1, 0x1
    sw $t1, 0($t0)
 
    # for delay
    li $a0, 10000
LEFT:
    # wait and jump to the mydelay subroutine for the delay in turining off and
    # on and shifting left until it reaches the end
    # then from the 8th LED, travel or bounce back until it reaches the 1st LED
    jal mydelay
    nop
    # move on to next LED
    sll $t1, $t1, 1
    # write $t0 to LEDs
    sw $t1, LATE
    # bitmasking for $t1=0x80
    ori $t0, $zero, 0x80
    bne $t0, $t1, LEFT
    NOP
RIGHT:
    # wait and jump to mydelay
    jal mydelay
    nop
    # move on to next LED
    srl $t1, $t1, 1
    # write $t0 to LEDs
    sw $t1, LATE
    # set $t2 as 0x01 
    ori $t2, $zero, 0x01
    bne $t1, $t2, RIGHT
    NOP
    b LEFT
    nop
mydelay:
    # load the delay value into $a0
    lw $a0, delay
    # load $t5 with PORTD
    lw $t5, PORTD
    # shift $t5 right by 8 bits and then add the immediate 0xf to $t5
    # and tehm add 1
    # and then multiply the $a0 with $t5 and put into $a0 and then 
    # go into the loop for counter
    srl $t5, $t5, 8
    andi $t5, $t5, 0xf
    addi $t5, $t5, 1
    mul $a0, $a0, $t5
    loop:
        # a counter loop for the delay
	# subtract (add -1 or I could have used the subtract function) 
	# branch to loop counter if a0 is greater than or equal to 0
	# else jup out of the counter loop
	add $a0, $a0, -1
        bgez $a0, loop
        nop
	j $ra
	nop
hmm:    J hmm
    NOP
    
endProgram:
    J endProgram
    NOP
.end main

.data
delay: .word 0xfff
GREETING: .asciiz "Hi! \n"