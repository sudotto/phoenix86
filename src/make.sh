nasm -f elf32 -o main.o main.asm
ld -m elf_i386 -s -o app main.o
