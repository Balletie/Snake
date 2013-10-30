#Scores
.global add_score, add_high_score, show_score

add_score:      pusha
                xor     %ebx, %ebx
                movb    score_inc, %bl
                movl    score, %eax
                addl    %ebx, %eax
                movl    %eax, score

                popa
                ret

add_high_score: pushl   %ebp
                movl    %esp, %ebp
                pusha

                movl    8(%ebp), %eax
                test    %eax, %eax
                jz      leave1

        more:   movl    $32, %ecx               #Index (This is actually counter * 4)
                movl    $8, %edx                #Counter
                movl    8(%ebp), %ebx           #Load the score

        check:  movl    high_score(%ecx), %eax
                cmpl    %ebx, %eax              #Compare the score with the next high_score
                je      leave1                  #The high_score already exists
                jl      insert
                subl    $4, %ecx
                decl    %edx
                cmpl    $0, %edx
                je      insert
                jmp     check

        insert: movl    $4, %ebx

        loop:   movl    high_score(%ebx), %edx
                subl    $4, %ebx
                movl    %edx, high_score(%ebx)

                addl    $8, %ebx
                movl    %ecx, %edx
                addl    $4, %edx
                cmpl    %ebx, %edx
                jne     loop
                
                movl    score, %eax
                movl    %eax, high_score(%ecx)
                
        leave1: popa
                leave
                ret

show_score:     pusha
                movl    score, %eax
                movl    $vga_memory + 16, %edi
                movl    $10, %ebx               #Load the divisor
        print:  xor     %edx, %edx
                divl    %ebx
                addl    $0x30, %edx             #Convert remainder to ASCII
                movb    %dl, (%edi)             #Load it in vga_memory
                subl    $2, %edi                #Shift to the right
                test    %eax, %eax
                jnz     print

                popa
                ret
