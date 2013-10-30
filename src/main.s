## Main file:
#Updates
#Rendering
.global main, clear
.global time 
.global score, score_inc, high_score, score_count
.global snake, snake_length, snake_speed
.global direction, new_direction

.text

main:           # Set the timer frequency to 1Hz
                pushl   $1
                call    set_timer_frequency
                addl    $4, %esp

                # Set the handlers for the timer and the keyboard
                call    set_handlers

                # Set up VGA stuff
                call    color_text_mode
                call    hide_cursor

                # Clear the screen
                call    clear

                # Show a border at the top
                movb    $205, %al
                movb    $0x08, %ah
                movl    $80, %ecx
                movl    $vga_memory, %edi
                cld
                rep     stosw

                # Text at the top, some "graphics"
                movb    $213, vga_memory
                movb    $181, vga_memory + 8    #\
                movb    $' ', vga_memory + 10   # |
                movb    $' ', vga_memory + 12   # |This part "holds" the score.
                movb    $' ', vga_memory + 14   # |
                movb    $' ', vga_memory + 16   # |
                movb    $198, vga_memory + 18   #/
                movb    $181, vga_memory + 74
                movb    $'S', vga_memory + 76
                movb    $'N', vga_memory + 78
                movb    $'A', vga_memory + 80
                movb    $'K', vga_memory + 82
                movb    $'E', vga_memory + 84
                movb    $198, vga_memory + 86
                movb    $184, vga_memory + 158

new_game:       call    clear
                movb    $'0', vga_memory + 10   #\
                movb    $'0', vga_memory + 12   # |Clear score display
                movb    $'0', vga_memory + 14   # |
                movb    $'0', vga_memory + 16   #/

                pushl   score
                call    add_high_score
                addl    $4, %esp
                movl    $0, score               #Reset the score
        
                call    menu_screen
                movl    time, %eax
                movl    %eax, rnd_nr
                movb    $4, new_direction
                xor     %ebx, %ebx
                movb    snake_speed, %bl
                call    init_snake
                call    next_mouse
                call    clear
                call    request_render

#The game loop
#EAX: Holds the collision information (true or false)
#EBX: Holds the timing speed (Turtle, Llama and Cheetah)
#ECX: Holds the wall portal option (0: disable, 1: enabled)

update_loop:    call    handle_input
                cmpl    %ebx, time
                jl      update_loop

                movb    new_direction, %al      #Make the direction change final
                movb    %al, direction          #
                pushl   direction               #Push the direction
                call    shift_snake             #Shift snake before each render
                addl    $4, %esp

                pushl   $1                      #\
                call    snake_collision         # |Check if the snake collides with itself.
                addl    $4, %esp                # |(snake_collision takes 1 or 0 as parameter)
                cmpb    $1, %al                 #/
                je      new_game

                cmpl    $1, %ecx                #Skip the wall collision detection if the 
                je      no_wall                 #"no walls" option is enabled

                call    wall_collision          #Check for wall collision
                cmpb    $1, %al
                je      new_game
                jmp     wall

        no_wall:call    wall_portal

        wall:   call    mouse_collision         #Check for mouse collision
                call    request_render
                movl    $0, time
                jmp     update_loop

request_render: pushl   %eax
                pushl   %ebx
                pushl   %ecx    
                pushl   %edx

                call    clear
                xor     %ecx, %ecx
                xor     %ebx, %ebx
        render: xor     %eax, %eax
                movb    snake(%ecx), %al        #Row
                movl    $160, %ebx              #Skip 160 for each row (80 columns in one row)
                mull    %ebx
                incl    %ecx

                xor     %ebx, %ebx
                movb    snake(%ecx), %bl        #Column
                shlb    $2, %bl                 #Column times four
                addl    $vga_memory, %eax
                addl    %ebx, %eax
                addl    $160, %eax              #Shift everything down one row (because of top bar)
                movb    $219, (%eax)
                movb    $219,2(%eax)

                incl    %ecx
                movl    snake_length, %edx
                subl    $2, %edx
                cmpl    %ecx, %edx
                jne     render

                xor     %eax, %eax
                movb    snake(%ecx), %al
                movl    $160, %ebx
                mull    %ebx
                incl    %ecx
                xor     %ebx, %ebx
                movb    snake(%ecx), %bl
                shlb    $2, %bl
                addl    $vga_memory, %eax
                addl    %ebx, %eax
                addl    $160, %eax
                movb    $219, (%eax)
                movb    $0x81, 1(%eax)
                movb    $219, 2(%eax)
                movb    $0x81, 3(%eax)
                

                xor     %eax, %eax
                xor     %ebx, %ebx              #Render the mouse
                xor     %ecx, %ecx
                movb    mouse(%ecx), %al        #Row
                movl    $160, %ebx
                mull    %ebx
                incl    %ecx

                movb    mouse(%ecx), %bl        #Column
                shlb    $2, %bl
                addl    $vga_memory, %eax
                addl    %ebx, %eax
                addl    $160, %eax
                movb    $177, (%eax)
                movb    $177,2(%eax)

                popl    %edx
                popl    %ecx
                popl    %ebx
                popl    %eax
                ret

clear:          pushl   %eax
                pushl   %ecx

                movb    $' ', %al
                movb    $0x8F, %ah
                movl    $24*80, %ecx
                movl    $vga_memory + 160, %edi
                cld
                rep     stosw

                popl    %ecx
                popl    %eax
                ret

.bss
time:           .long   0       #The timer in ms. Important note: This game was developed in a virtual machine
                                #which has a much lower (virtual) oscillator frequency than that of an actual
                                #machine. For an actual machine the correct timer frequency is 1000Hz,
                                #and the correct speeds for Turtle, Llama and Cheetah are 300, 600 and 900
                                #respectively.
score:          .long   0       #The score
score_inc:      .byte   0       #The score increment
high_score:     .skip   32, 0   #8 high scores

snake:          .skip   1920, 0
snake_speed:    .byte   0
snake_length:   .long   0       #The length of the snake

direction:      .byte   0       #The current direction of the snake
new_direction:  .byte   0       #The next direction of the snake
