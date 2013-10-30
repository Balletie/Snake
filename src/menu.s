##Menu
#  [1] Start
#       Select Difficulty:
#         [1] Turtle
#         [2] Llama
#         [3] Cheetah
#  [2] Options
#       Options:
#         [1][x] Walls
#  [3] High-scores
.global menu_screen

menu_screen:    pushl   %eax
                pushl   %ebx

        back:   call    clear_keys
                movb    $'[', vga_memory + 160*12+60
                movb    $'1', vga_memory + 160*12+62
                movb    $']', vga_memory + 160*12+64
                movb    $' ', vga_memory + 160*12+66
                movb    $'S', vga_memory + 160*12+68
                movb    $'t', vga_memory + 160*12+70
                movb    $'a', vga_memory + 160*12+72
                movb    $'r', vga_memory + 160*12+74
                movb    $'t', vga_memory + 160*12+76

                movb    $'[', vga_memory + 160*14+60
                movb    $'2', vga_memory + 160*14+62
                movb    $']', vga_memory + 160*14+64
                movb    $' ', vga_memory + 160*14+66
                movb    $'O', vga_memory + 160*14+68
                movb    $'p', vga_memory + 160*14+70
                movb    $'t', vga_memory + 160*14+72
                movb    $'i', vga_memory + 160*14+74
                movb    $'o', vga_memory + 160*14+76
                movb    $'n', vga_memory + 160*14+78
#               movb    $'s', vga_memory + 160*14+80

                movb    $'[', vga_memory + 160*16+60
                movb    $'3', vga_memory + 160*16+62
                movb    $']', vga_memory + 160*16+64
                movb    $' ', vga_memory + 160*16+66
                movb    $'H', vga_memory + 160*16+68
                movb    $'i', vga_memory + 160*16+70
                movb    $'g', vga_memory + 160*16+72
                movb    $'h', vga_memory + 160*16+74
                movb    $' ', vga_memory + 160*16+76
                movb    $'s', vga_memory + 160*16+78
                movb    $'c', vga_memory + 160*16+80
                movb    $'o', vga_memory + 160*16+82
                movb    $'r', vga_memory + 160*16+84
                movb    $'e', vga_memory + 160*16+86
                movb    $'s', vga_memory + 160*16+88

        wait1:  movl    $0x02, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      call1
                
                movl    $0x03, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      call2

                movl    $0x04, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                jne     wait1

        call3:  movb    $0, KEYS(%eax)
                call    menu_screen3
                cmpl    $0x01, %eax     #Check if escape has been pushed; if so, switch back to the main menu
                je      back
                jmp     done1

        call2:  movb    $0, KEYS(%eax)
                call    menu_screen2
                cmpl    $0x01, %eax
                je      back
                jmp     done1

        call1:  movb    $0, KEYS(%eax)
                call    menu_screen1
                cmpl    $0x01, %eax
                je      back
                jmp     done1

        done1:  movb    $0, KEYS(%eax)

                popl    %ebx
                popl    %eax
                ret

menu_screen1:   call    clear
                movb    $'[', vga_memory + 160*12+60
                movb    $'1', vga_memory + 160*12+62
                movb    $']', vga_memory + 160*12+64
                movb    $' ', vga_memory + 160*12+66
                movb    $'T', vga_memory + 160*12+68
                movb    $'u', vga_memory + 160*12+70
                movb    $'r', vga_memory + 160*12+72
                movb    $'t', vga_memory + 160*12+74
                movb    $'l', vga_memory + 160*12+76
                movb    $'e', vga_memory + 160*12+78

                movb    $'[', vga_memory + 160*14+60
                movb    $'2', vga_memory + 160*14+62
                movb    $']', vga_memory + 160*14+64
                movb    $' ', vga_memory + 160*14+66
                movb    $'L', vga_memory + 160*14+68
                movb    $'l', vga_memory + 160*14+70
                movb    $'a', vga_memory + 160*14+72
                movb    $'m', vga_memory + 160*14+74
                movb    $'a', vga_memory + 160*14+76

                movb    $'[', vga_memory + 160*16+60
                movb    $'3', vga_memory + 160*16+62
                movb    $']', vga_memory + 160*16+64
                movb    $' ', vga_memory + 160*16+66
                movb    $'C', vga_memory + 160*16+68
                movb    $'h', vga_memory + 160*16+70
                movb    $'e', vga_memory + 160*16+72
                movb    $'e', vga_memory + 160*16+74
                movb    $'t', vga_memory + 160*16+76
                movb    $'a', vga_memory + 160*16+78
                movb    $'h', vga_memory + 160*16+80

        wait2:  movl    $0x01, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      done2

                movb    $3, score_inc
                movb    $14, snake_speed
                movl    $0x02, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      done2

                movb    $6, score_inc
                movb    $10, snake_speed
                movl    $0x03, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      done2

                movb    $9, score_inc
                movb    $6, snake_speed
                movl    $0x04, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                jne     wait2

        done2:  movb    $0, KEYS(%eax)
                call    clear
                ret

menu_screen2:   call    clear
                movb    $'[', vga_memory + 160*12+60
                movb    $'1', vga_memory + 160*12+62
                movb    $']', vga_memory + 160*12+64
                movb    $'[', vga_memory + 160*12+66
                cmpb    $1, %cl                         #Check if the "No Walls" option is enabled
                je      enabled
                movb    $' ', vga_memory + 160*12+68
                jmp     disabld
        enabled:movb    $'X', vga_memory + 160*12+68
        disabld:movb    $']', vga_memory + 160*12+70
                movb    $' ', vga_memory + 160*12+72
                movb    $'N', vga_memory + 160*12+74
                movb    $'o', vga_memory + 160*12+76
                movb    $' ', vga_memory + 160*12+78
                movb    $'W', vga_memory + 160*12+80
                movb    $'a', vga_memory + 160*12+82
                movb    $'l', vga_memory + 160*12+84
                movb    $'l', vga_memory + 160*12+86
                movb    $'s', vga_memory + 160*12+88

        wait3:  movl    $0x01, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                je      done3
                movl    $0x02, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                jne     wait3

        toggle: movb    $0, KEYS(%eax)
                cmpl    $1, %ecx
                je      off
        on:     movl    $1, %ecx
                movb    $'X', vga_memory + 160*12+68
                jmp     wait3
        off:    movl    $0, %ecx
                movb    $' ', vga_memory + 160*12+68
                jmp     wait3
        done3:  movb    $0, KEYS(%eax)
                call    clear
                ret

menu_screen3:   pushl   %ebx
                pushl   %ecx
                call    clear

                movb    $8, %cl                 #8 High scores
                movl    $vga_memory + 160*16 + 60, %edi

        print1: movb    %cl, %al
                addb    $0x30, %al              #Convert to ASCII character
                movb    %al, (%edi)             #Load it in vga memory
                decb    %cl
                subl    $160, %edi
                test    %ecx, %ecx              #Check if we're done
                jnz     print1

                movl    $0, %ecx                

                movl    $vga_memory + 160*16 + 70, %edi

        print2: movl    high_score(%ecx), %eax  #Move the high score to eax
                movl    $10, %ebx               #Load the divisor
                pushl   %edi                    #Push edi, we need it later to maintain correct formatting
        loop:   xor     %edx, %edx
                divl    %ebx
                addb    $0x30, %dl
                movb    %dl, (%edi)
                subl    $2, %edi                #If we didn't push edi it would constantly shift each high score
                test    %eax, %eax              #to the left.
                jnz     loop

                addl    $4, %ecx
                cmpl    $32, %ecx               #If ecx is zero we're done printing
                popl    %edi                    #Pop edi back
                je      wait5
                subl    $160, %edi
                jmp     print2

        print3: call    clear
                movb    $'N', vga_memory + 160*12+60
                movb    $'o', vga_memory + 160*12+62
                movb    $' ', vga_memory + 160*12+64
                movb    $'s', vga_memory + 160*12+66
                movb    $'c', vga_memory + 160*12+68
                movb    $'o', vga_memory + 160*12+70
                movb    $'r', vga_memory + 160*12+72
                movb    $'e', vga_memory + 160*12+74
                movb    $'s', vga_memory + 160*12+76

        wait5:  movl    $0x01, %eax
                movb    KEYS(%eax), %bl
                cmpb    $1, %bl
                jne     wait5
                movb    $0, KEYS(%eax)
                call    clear_keys

        done5:  popl    %ecx
                popl    %ebx
                call    clear
                ret
