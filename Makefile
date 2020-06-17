vpath %.c src:examples
vpath %.d dep
vpath %.o obj
vpath %.a lib
# vpath %.h include

libsrc := $(notdir $(wildcard src/*.c))
libobjs := $(libsrc:%.c=%.o)
libdeps := $(libsrc:.c=.d)
examplesrc := $(notdir $(wildcard examples/*.c))
exampleobjs := $(examplesrc:%.c=%.o)
exampledeps := $(examplesrc:.c=.d)

all: examples objs

libcii: $(libobjs)
	$(AR) rcs lib/$@ $^

objs: $(libobjs) $(libdeps)

examples: $(exampleobjs) $(exampledeps)

%.o: %.c
	@$(COMPILE.c) -Iinclude -o obj/$@ $<

%.d: %.c
	@$(COMPILE.c) -Iinclude -MM -MP -MF dep/$@ $<

.PHONY: clean
clean:
	-find -name '*.[od]' -exec rm {} \;
	-rm lib/libcii

-include $(deps)

