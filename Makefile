vpath %.c src
vpath %.d dep
vpath %.o obj
# vpath %.h include
# examples := $(wildcard examples/*.c)

src = $(notdir $(wildcard src/*.c))
objs := $(src:%.c=%.o)
deps := $(src:.c=.d)

all: $(objs) $(deps)

%.o: %.c
	@$(COMPILE.c) -Iinclude -o $@ $<
	mv $@ obj/

%.d: %.c
	@$(COMPILE.c) -Iinclude -MM -MP -MF $@ $<
	mv $@ dep/

-include $(deps)

