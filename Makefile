vpath %.c src examples
vpath %.o obj

CFLAGS := -I include -g
LDLIBS := -L lib
LOADLIBES := -lcii
ARFLAGS := r

libsrc := $(notdir $(wildcard src/*.c)) 
libobjs := $(foreach obj, $(libsrc:.c=.o), obj/$(obj))
libdeps := $(foreach dep, $(libsrc:.c=.d), dep/$(dep))

examplesrc := $(notdir $(wildcard examples/*.c))
exampleobjs := $(foreach obj, $(examplesrc:.c=.o), obj/$(obj))
exampledeps := $(foreach dep, $(examplesrc:.c=.d), dep/$(dep))
examplebins := $(foreach bin, $(examplesrc:.c=), bin/$(bin))

.PHONY: all
all: lib/libcii.a $(exampleobjs) $(examplebins)

.PHONY: clean
clean:
	@-rm -rf lib/ bin/ obj/ dep/ 

lib/libcii.a: $(libobjs)
	@mkdir -p $(@D)
	@$(AR) $(ARFLAGS) $@ $^

bin/%: %.o
	@mkdir -p $(@D)
	@$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

obj/%.o: %.c
	@mkdir -p $(@D)
	$(COMPILE.c) $(OUTPUT_OPTION) $<

dep/%.d: %.c
	@mkdir -p $(@D)
	@$(COMPILE.c) -MM -MF $@ $<
	@sed -i '1s|^|obj/|' $@

-include $(libdeps)
-include $(exampledeps)
