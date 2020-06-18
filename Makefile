CFLAGS := -I include
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
all: examples

.PHONY: archive
archive: lib/libcii.a

lib/libcii.a: $(libobjs)
	@$(AR) $(ARFLAGS) $@ $^

.PHONY: examples
examples: archive exampleobj $(examplebins)

.PHONY: exampleobj
exampleobj: $(exampleobjs)

.PHONY: clean
clean:
	@-rm -f lib/* dep/* bin/* obj/*

bin/%: obj/%.o
	@$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

obj/%.o: examples/%.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

obj/%.o: src/%.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

dep/%.d: src/%.c
	@$(COMPILE.c) -MM -MF $@ $<
	@sed -i '1s/^/obj\//' $@

dep/%.d: examples/%.c
	@$(COMPILE.c) -MM -MF $@ $<
	@sed -i '1s|^|obj/|' $@

-include $(libdeps)
-include $(exampledeps)
