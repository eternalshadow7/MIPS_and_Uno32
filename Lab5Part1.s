
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
loop:
    /* read value from switches */
    /* get a pointer and load from pointer */
    la $t0, PORTD
    /* $t1=PORTD */
    lw $t1, 0($t0)
    /* $t2= xxxx 0000 0000 */
    /* make a constant bitmask*/
    /* 0000 1111 0000 0000 is 0b1111 0000 0000 is xF00 */
    /* the xs are whatever the switches are set to (eg on or off)* */
    andi $t2, $t1, 0xF00
    /* $t2= 0b0000 xxxx */
    /* shift right logical 8 bits */
     /* get the value of the buttons and put where 0000 are */
    srl $t2, $t2, 8
    /* $t3 = 0bxxx0 0000 */
    /* now a different mask for 0000 1110 0000 */
    /* in hex is 0E0 is 0xE0 */
    andi $t3, $t1, 0xE0
    /* $t2 = obxxx0 xxxx */
    or $t2, $t2, $t3
    
    /* reading from button */
    la $t4, PORTF
    lw $t5, 0($t4)
    /* $t6= 0b0000 00x0 */
    andi $t6, $t5, 2
    /* $t6 = 0b00x0 0000 */
    sll $t6, $t6, 3
    /* $t2=0bxxxx xxxx */
    /* first xxxx is buttons and second is switches because of shifting */
    or $t2, $t2, $t6
    la $t0, TRISE
    sw $t0, 0($t0)
    
    /* loading for PORTE */
    la $t0, PORTE
    sw $t2, 0($t0)
    
    /* make a loop */
    /* sort of like BRnzp or BR in LC3 */
    b loop
    nop
hello:  
    LA $a0,HelloWorld
    JAL puts 
    
    NOP
   
hmm:    J hmm
    NOP
    
endProgram:
    J endProgram
    NOP
.end main



.data
HelloWorld: .asciiz "Assembly Hello World \n"
