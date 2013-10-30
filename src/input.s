##Handles input
##Rules:
#   -  The snake can't turn to a certain direction if the snake's current direction
#      is equal to the opposite of the new direction.
#   -  The last given input counts.
#
##Scan codes:
#Up:    0x48
#Down:  0x50
#Left:  0x4B
#Right: 0x4D
#ESC:   0x01
#
##TODO:
#Check status on each scan code
#Set the satus to zero when it's read
.global handle_input, clear_keys
.global UP, DOWN, LEFT, RIGHT, ESC, ANY

.equ    UP,     0x48
.equ    DOWN,   0x50
.equ    LEFT,   0x4B
.equ    RIGHT,  0x4D
.equ    ESC,    0x01
.equ    ANY,    0x00

handle_input:   pushl   %ebp
                movl    %esp, %ebp

                pushl   $UP
                call    handle_key
                addl    $4, %esp
                pushl   $DOWN
                call    handle_key
                addl    $4, %esp
                pushl   $LEFT
                call    handle_key
                addl    $4, %esp
                pushl   $RIGHT
                call    handle_key
                addl    $4, %esp
                pushl   $ESC
                call    handle_key
                addl    $4, %esp

                movl    %ebp, %esp
                popl    %ebp
                ret

handle_key:     pushl   %ebp
                movl    %esp, %ebp

                pushl   %eax
                pushl   %ebx
                xor     %eax, %eax
                xor     %ebx, %ebx

                movb    8(%ebp), %al
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                jne     return
                movb    $0, KEYS(%eax)          #0 indicates that the key has been read

case_up:        cmpb    $UP, %al
                jne     case_down
                cmpb    $2, direction           #If we're already going the opposite direction, don't change 
                je      return                  #the direction.
                movb    $1, new_direction       #We need another variable new direction so we can't
                jmp     return                  #press up and down between two renders.
                                                #Before each render, we make the direction final by moving
case_down:      cmpb    $DOWN, %al              #the new_direction to direction
                jne     case_left
                cmpb    $1, direction
                je      return
                movb    $2, new_direction
                jmp     return

case_left:      cmpb    $LEFT, %al
                jne     case_right
                cmpb    $4, direction
                je      return
                movb    $3, new_direction
                jmp     return

case_right:     cmpb    $RIGHT, %al
                jne     case_esc
                cmpb    $3, direction
                je      return
                movb    $4, new_direction
                jmp     return

case_esc:       cmpb    $ESC, %al
                call    halt

return:         popl    %ebx
                popl    %eax

                movl    %ebp, %esp
                popl    %ebp
                ret

clear_keys:     pusha
                movl    $0x80, %ecx
        clear:  movb    $0, KEYS(%ecx)
                decl    %ecx
                test    %ecx, %ecx
                jnz     clear
                popa
                ret
