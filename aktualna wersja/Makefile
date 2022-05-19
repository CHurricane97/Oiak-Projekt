execute:
	nasm -f elf32 -g -o projekt.o projekt.asm
	ld -m elf_i386 -s -o projekt projekt.o
	./projekt

debug:
	nasm -f elf32 -g -l projekt.lst -o projekt.o projekt.asm
	gcc -nostdlib -m32 -o projekt projekt.o
	gdb ./projekt