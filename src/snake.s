.global init_snake, shift_snake, mouse_collision, snake_collision, wall_collision, wall_portal

.text

init_snake:     pushl   %eax
                movl    $24, %eax
                movl    %eax, snake_length      #Set the length to twelve

                movl    $0, %eax
                movb    $3, snake(%eax)
                incl    %eax
                movb    $10, snake(%eax)
                incl    %eax
                movb    $4, snake(%eax)
                incl    %eax
                movb    $10, snake(%eax)
                incl    %eax
                movb    $4, snake(%eax)
                incl    %eax
                movb    $11, snake(%eax)
                incl    %eax
                movb    $4, snake(%eax)
                incl    %eax
                movb    $12, snake(%eax)
                incl    %eax
                movb    $4, snake(%eax)
                incl    %eax
                movb    $13, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $13, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $14, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $15, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $16, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $17, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $18, snake(%eax)
                incl    %eax
                movb    $5, snake(%eax)
                incl    %eax
                movb    $19, snake(%eax)

                popl    %eax
                ret

##Col max: 40
##Row max: 24
shift_snake:    pushl   %ebp
                movl    %esp, %ebp

                pushl   %eax
                pushl   %ebx
                pushl   %ecx
                pushl   %edx

                xor     %eax, %eax
                xor     %ebx, %ebx
                xor     %ecx, %ecx

                movl    8(%ebp), %ecx
                movl    $2, %ebx

        shift:  movb    snake(%ebx), %al
                subl    $2, %ebx                #Move the row or column one element lower
                movb    %al, snake(%ebx)        #"

                addl    $3, %ebx                #Add 3 to go to the next row or column
                cmpl    %ebx, snake_length      #Check if we've reached the end
                jne     shift                   #If not, jump back and do it again

                decl    %ebx                    #Decrement the index (value is out of the bounds of the array)

        if1:    cmpb    $1, direction           #1 direction
                jne     if2                     #jump to next one if this is not the direction
                decl    %ebx                    #Decrement once again to access the row variable
                movb    snake(%ebx), %al        #\
                decb    %al                     # |Row - 1
                movb    %al, snake(%ebx)        #/
                jmp     leave1                  #Done

        if2:    cmpb    $2, direction
                jne     if3
                decl    %ebx
                movb    snake(%ebx), %al
                incb    %al
                movb    %al, snake(%ebx)
                jmp     leave1

        if3:    cmpb    $3, direction
                jne     if4                     #No need to decrement again
                decb    %al                     #Increment the column by one (column is already in %al)
                movb    %al, snake(%ebx)        #Move it into place
                jmp     leave1

        if4:    incb    %al
                movb    %al, snake(%ebx)

        leave1: popl    %edx
                popl    %ecx
                popl    %ebx
                popl    %eax
                
                leave
                ret

snake_collision:pushl   %ebp
                movl    %esp, %ebp
                pushl   %ebx
                pushl   %ecx
                pushl   %edx

                xor     %eax, %eax
                xor     %ebx, %ebx
                movl    $-2, %ecx

                movl    snake_length, %ebx
                subl    $2, %ebx                
                movl    8(%ebp), %edx           #1 means we will check the snake itself, 0 for a next_mouse.
                cmpl    $1, %edx                #This way we can reuse this part of code.
                jne     check1_mouse

check1_snake:   movb    snake(%ebx), %al        #Load the column of the last element (the snake's head).
                jmp     check1
check1_mouse:   movl    snake_length, %ebx      #Move the snake_length to ebx again
                subl    $2, %ebx
                movb    mouse, %al              #Load the column of the mouse, in case we check the mouse.
check1:         addl    $2, %ecx                #We start at index 0
                cmpl    %ecx, %ebx              #If it's equal to the index of the head of the snake, leave
                je      leave3                  #No collision
                movb    snake(%ecx), %dl
                cmpb    %al, %dl                #Compare both columns
                jne     check1

                movl    8(%ebp), %eax           #Check again whether we're checking the mouse or not
                xor     $1, %eax                #In case we're checking the mouse, this part also loads the
                jnz     check2_mouse            #correct index for checking the row of the mouse with the row
                                                #of the current element of the snake
check2_snake:   incl    %ebx                    #If the columns are equal, we proceed to compare the rows
                incl    %ecx
                movb    snake(%ebx), %al
                movb    snake(%ecx), %dl
                
                decl    %ebx                    #\Prepare in case we have to jump back
                decl    %ecx                    #/

                cmpb    %al, %dl
                jne     check1_snake
                jmp     leave2

check2_mouse:   movl    %eax, %ebx
                incl    %ecx
                movb    mouse(%ebx), %al
                movb    snake(%ecx), %dl

                xor     %ebx, %ebx
                decl    %ecx

                cmpb    %al, %dl
                jne     check1_mouse

        leave2: movb    $1, %al                 #1 indicates collision as true
                popl    %edx
                popl    %ecx
                popl    %ebx
                leave
                ret

        leave3: movb    $0, %al                 #0 indicates collision as false
                popl    %edx
                popl    %ecx
                popl    %ebx
                leave
                ret

mouse_collision:pusha
                xor     %eax, %eax
                xor     %ebx, %ebx
                xor     %ecx, %ecx
                xor     %edx, %edx

                movl    snake_length, %ebx
                subl    $2, %ebx
                movb    snake(%ebx), %al        #Compare the rows
                movb    mouse(%ecx), %dl        #
                cmpb    %al, %dl                #
                jne     leave4
                incl    %ecx
                incl    %ebx
                movb    snake(%ebx), %al        #Compare the columns
                movb    mouse(%ecx), %dl        #
                cmpb    %al, %dl                #
                jne     leave4                  #Only if both are the same, call next_mouse and add_element
                call    next_mouse
                call    add_element
                call    add_score
                call    show_score

        leave4: popa
                ret

add_element:    pusha
                xor     %eax, %eax
                xor     %ebx, %ebx
                xor     %ecx, %ecx
                movl    snake_length, %ebx      #\
                addl    $2, %ebx                # |Increment snake_length
                movl    %ebx, snake_length      #/

shift_right:    subl    $3, %ebx                #Start with the last column, shift each element to the right
                movb    snake(%ebx), %al        #individually.  
                addl    $2, %ebx
                movb    %al, snake(%ebx)
                cmpb    $2, %bl                 #If the index is 2 (Therefore, we've shifted the element at
                jne     shift_right             #index 0 to index 2), then we're done.

###########################################################
#This next section will check where to put the new element,
#and adds the next element at the correct location.

                addl    $2, %ecx                #Start at index 2
        cmp_row:movb    snake(%ecx), %al
                addl    $2, %ecx
                movb    snake(%ecx), %bl
                subb    %bl, %al                #If the result is -1, then it should be added to the right of the
                jz      cmp_col                 #last element.
                js      row_s                   #If it's signed (in other words, if the result is -1),
                                                #jump to this instruction
        row_ns: movb    snake, %al              #\
                decb    %al                     # |Put it above the last element of the snake.
                movb    %al, snake              #/
                jmp     leave5
        row_s:  movb    snake, %al              #\
                incb    %al                     # |Put it under the last element of the snake.
                movb    %al, snake              #/
                jmp     leave5
        cmp_col:decl    %ecx                    #Start at index 3
                movb    snake(%ecx), %al
                addl    $2, %ecx
                movb    snake(%ecx), %bl
                subb    %bl, %al                #This subtraction can't be zero, given that the game is correct
                movl    $1, %ecx                #Index 1 (i.e. the column)
                js      col_s

        col_ns: movb    snake(%ecx), %al        #\
                decb    %al                     # |Put it to the left of the snake.
                movb    %al, snake(%ecx)        #/
                jmp     leave5
        col_s:  movb    snake(%ecx), %al        #\
                incb    %al                     # |Put it to the right of the snake.
                movb    %al, snake(%ecx)        #/
                jmp     leave5
        leave5: popa
                ret

wall_collision: pushl   %ebx
                pushl   %ecx
                pushl   %edx
                movl    snake_length, %ebx
                subl    $2, %ebx
                movb    snake(%ebx), %al
                cmpb    $24, %al
                je      leave6
                cmpb    $-1, %al
                je      leave6
                incl    %ebx
                movb    snake(%ebx), %al
                cmpb    $40, %al
                je      leave6
                cmpb    $-1, %al
                je      leave6

                movb    $0, %al                 #0 indicates collision as false
                popl    %edx
                popl    %ecx
                popl    %ebx
                ret

        leave6: movb    $1, %al                 #1 indicates collision as true
                popl    %edx
                popl    %ecx
                popl    %ebx
                ret

wall_portal:    pusha
                movl    snake_length, %ebx
                subl    $2, %ebx                #Access the row of the snake's head
                movb    snake(%ebx), %al        #Load the row
        row1:   cmpb    $24, %al
                jne     row2
                movb    $0, snake(%ebx)
                jmp     leave7
        row2:   cmpb    $-1, %al
                jne     col1
                movb    $23, snake(%ebx)
                jmp     leave7
        col1:   incl    %ebx                    #Increment to access the column
                movb    snake(%ebx), %al        #Load the column
                cmpb    $40, %al
                jne     col2
                movb    $0, snake(%ebx)
                jmp     leave7
        col2:   cmpb    $-1, %al
                jne     leave7
                movb    $39, snake(%ebx)
        leave7: popa
                ret
