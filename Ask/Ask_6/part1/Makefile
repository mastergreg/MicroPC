TARGET=part1
CC=avr-gcc
OBJCOPY=avr-objcopy
CHIP=atmega16
CFLAGS=-Os -g 
ASFLAGS=-x assembler-with-cpp 
FREQ=8000000


all: 	$(TARGET).hex
.PHONY: clean debug elf hex

elf:	$(TARGET).elf
hex:	$(TARGET).hex


%.elf:	%.s
	$(CC) -mmcu=$(CHIP) $< $(CFLAGS) -o $@
%.s:	%.S
	$(CC) -S -mmcu=$(CHIP) $(ASFLAGS) $< > $@
%.s:	%.c
	$(CC) -S -mmcu=$(CHIP) $(ASFLAGS) $< > $@
%.hex: 	%.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
clean:
	rm $(TARGET).{elf,s,hex}

debug:	sim
	ddd --debugger avr-gdb
sim:
	simulavr -d $(CHIP) -F $(FREQ) -g -p5123
flash:	hex
	avrprog2 -m $(CHIP) -f $(FREQ) --flash w:$(TARGET).hex
