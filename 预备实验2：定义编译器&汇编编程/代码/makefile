.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc example.S -o example.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./example.out
clean:
	rm -fr example.out
