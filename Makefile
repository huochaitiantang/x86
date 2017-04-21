all: 2_1_cmp.exe 2_3_sort.exe

2_1_cmp.exe: 2_1_cmp.o
2_3_sort.exe: 2_3_sort.o

%.exe: %.o
	bwlink format dos name $@ file $^

%.o: %.asm
	bwasm -0 -zcm=masm -fo$@ $^
	
clean:
	rm *.o *.err
	rm 2_1_cmp.exe
	rm 2_3_sort.exe


