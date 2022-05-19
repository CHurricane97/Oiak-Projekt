execute:
	nasm -f elf32 -g -o Tic-Tac-Toe.o Tic-Tac-Toe.asm
	ld -m elf_i386 -s -o Tic-Tac-Toe Tic-Tac-Toe.o
	./Tic-Tac-Toe

debug:
	nasm -f elf32 -g -l Tic-Tac-Toe.lst -o Tic-Tac-Toe.o Tic-Tac-Toe.asm
	gcc -nostdlib -m32 -o Tic-Tac-Toe Tic-Tac-Toe.o
	gdb ./Tic-Tac-Toe
experiment:
	nasm -f elf32 -g -o ./bin/Experiment.o Experiment.asm
	ld -m elf_i386 -s -o ./bin/Experiment ./bin/Experiment.o
	./bin/Experiment

debug-experiment:
	nasm -f elf32 -g -l ./bin/Experiment.lst -o ./bin/Experiment.o Experiment.asm
	gcc -nostdlib -m32 -o ./bin/Experiment ./bin/Experiment.o
	gdb ./bin/Experiment

clean:
	rm -r ./bin/*
