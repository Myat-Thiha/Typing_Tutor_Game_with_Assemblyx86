// InlineAssembler_Calling_C_Functions_in_Inline_Assembly.cpp
// processor: x86
#include <stdio.h>

char format[] = "%s %s\n";
char hello[] = "Hello";
char world[] = "world";
int main(void)
{
    __asm
    {
        mov  eax, offset world
        push eax
        mov  eax, offset hello
        push eax
        mov  eax, offset format
        push eax
        call printf
        //clean up the stack so that main can exit cleanly
        //use the unused register ebx to do the cleanup
        pop  ebx
        pop  ebx
        pop  ebx
    }
}
