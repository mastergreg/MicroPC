TARGET=1
CC=avr-gcc
OBJCOPY=avr-objcopy
CHIP=atmega16
CFLAGS=-Os


all: 	$(TARGET).hex

%.elf:	%.s
	$(CC) $< -o $@
%.s:	%.S
	$(CC) -S -mmcu=$(CHIP) $< > $@
%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
clean:
	rm $(TARGET).{elf,s,hex}
