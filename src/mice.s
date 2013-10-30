##Linear Congruential Pseudo-random number generator
#Defined by:
#X = (a*s + b) (mod m)
#With:
# s as seed (start value)
# a as a constant multiplier
# b as another constant, called the increment
# m as the modulus
#We will use:
# m = 2^31-1
# a = 1103515245
# b = 12345
# As the seed, we obtain the value of "time" at the moment the person starts the game.
# The moment a person chooses to start the game is inherently random.
# To obtain a random number within the bounds of the play area, for columns: maximum 40, for
# rows: maximum 24, we take the modulo 40 and the modulo 24 of the random number, respectively.
.global LCG, next_mouse
.global rnd_nr, mouse

.text

LCG:            pushl   %ebp
                movl    %esp, %ebp
                pushl   %eax
                pushl   %ebx
                pushl   %ecx

                movl    rnd_nr, %eax            #Our seed
                movl    $2147483647, %ebx       #The modulus
                movl    $1103515245, %ecx       #The multiplier
                mull    %ecx
                xor     %edx, %edx              #Discard the higher portion of the product
                addl    $12345, %eax            #Add the increment
                divl    %ebx                    #Do the modulus operation
                movl    %edx, rnd_nr            #Move the answer to rnd_nr for the next random number
                movl    8(%ebp), %ebx           #\
                movl    %edx, %eax              # |Here we do another modulus operation, to make sure the number
                xor     %edx, %edx              # |is within the bounds of the field. rnd_nr remains unaffected.
                divl    %ebx                    #/

                popl    %ecx
                popl    %ebx
                popl    %eax
                leave
                ret

next_mouse:     pushl   %ebp
                movl    %esp, %ebp

                pushl   %eax
                pushl   %ebx
                pushl   %ecx
                pushl   %edx

        again:  xor     %ecx, %ecx
                
                pushl   $24                     #\
                call    LCG                     # |Generate a new random number
                addl    $4, %esp                #/
                
                movb    %dl, mouse(%ecx)        #Return value of LCG is in %dl
                
                pushl   $40
                call    LCG
                addl    $4, %esp
                
                incl    %ecx
                movb    %dl, mouse(%ecx)

                pushl   $0                      #\
                call    snake_collision         # |Check if it collides with the snake, if it does
                addl    $4, %esp                # |then we will generate new coordinates until it does 
                cmpb    $1, %al                 # |not collide with the snake.
                je      again                   #/

                popl    %edx    
                popl    %ecx
                popl    %ebx
                popl    %eax

                leave
                ret
.data
mouse:  .skip   2, 0
rnd_nr: .long   0
