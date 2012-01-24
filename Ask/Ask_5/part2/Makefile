TARGET=part2_2
CC=avr-gcc
OBJCOPY=avr-objcopy
CHIP=atmega16
CFLAGS=-Os -g


all: 	$(TARGET).hex
.PHONY: clean debug

%.elf:	%.s
	$(CC) -mmcu=$(CHIP) $< $(CFLAGS) -o $@
%.s:	%.S
	$(CC) -S -mmcu=$(CHIP) $< > $@
%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
clean:
	rm $(TARGET).{elf,s,hex}

debug:	sim
	ddd --debugger avr-gdb

sim:
	simulavr -d $(CHIP) -g -p5123
