all: 2_1_cmp.exe 2_2_set.exe 2_3_sort.exe 3_1_fac.exe 3_2_set.exe 3_3_lst.exe

2_1_cmp.exe: 2_1_cmp.o
2_2_set.exe: 2_2_set.o
2_3_sort.exe: 2_3_sort.o
3_1_fac.exe: 3_1_fac.o
3_2_set.exe: 3_2_set.o
3_3_lst.exe: 3_3_lst.o

%.exe: %.o
	bwlink format dos name $@ file $^

%.o: %.asm
	bwasm -0 -zcm=masm -fo$@ $^
	
clean:
	rm 2_1_cmp.exe
	rm 2_2_set.exe
	rm 2_3_sort.exe
	rm 3_1_fac.exe
	rm 3_2_set.exe
	rm 3_3_lst.exe
	rm *.o
	rm *.err


