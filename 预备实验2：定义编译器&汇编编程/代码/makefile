.PHONY: test-fib, clean
test-fib:
	arm-linux-gnueabihf-gcc fib.s sylib.c -o fib.out -static
	qemu-arm ./fib.out
test-fac:
	arm-linux-gnueabihf-gcc fac.s sylib.c -o fac.out -static
	qemu-arm ./fac.out
clean:
	rm -fr *.out
