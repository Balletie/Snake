# Interrupt handlers
# See http://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html for information on scancodes.
.bss
KEYS:           .skip 0x80      #key status buffer.
                                #down = 1, up = 0
                                #index by scancode
.global set_handlers
.global KEYS

.text

set_handlers:   pushl   $irq0
                pushl   $0
                call    set_irq_handler
                call    enable_irq
                addl    $8, %esp

                pushl   $irq1
                pushl   $1
                call    set_irq_handler
                call    enable_irq
                addl    $8, %esp

                ret

#Timer IRQ Handler
irq0:           incl    time
                jmp     end_of_irq0

#Keyboard IRQ Handler
#Down: scancode
#Up:   scancode + 0x80
irq1:           pushl   %eax
                pushl   %ebx

        wait:   inb     $0x64, %al
                test    $1, %al
                jz      wait

                movb    $1, KEYS        #Set "ANY" to one
        
                xor     %eax, %eax      #Make EAX zero before loading the scancode
                inb     $0x60, %al      #Load the scancode

                #Check state of the scancode (make/break)
                movb    %al, %bl
                shrb    $7, %bl         #Shift to the right, only the highest bit remains
                xor     $1, %bl         #Check highest bit

                cmpb    $1, %bl         #If it's one, the key is down, else, it's up
                jne     end             #If it's zero, then don't alter the boolean value of this scancode
                                        #This is handled by the input handler

                andb    $0b01111111, %al#Set make/break bit to 0 to obtain the correct address
                movb    %bl, KEYS(%eax) #Set the key to 1

end:            popl    %ebx
                popl    %eax

                jmp     end_of_irq1
