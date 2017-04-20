all: 2_1_cmp.exe 

2_1_cmp.exe: 2_1_cmp.o

%.exe: %.o
	bwlink format dos name $@ file $^

%.o: %.asm
	bwasm -0 -zcm=masm -fo$@ $^
	
clean:
	rm *.exe *.o *.err

