vpath %.c src examples
vpath %.o build/obj

CFLAGS := -I include -g
LDLIBS := -L build/lib
LOADLIBES := -lcii
ARFLAGS := r

libsrc := $(notdir $(wildcard src/*.c)) 
libobjs := $(foreach obj, $(libsrc:.c=.o), build/obj/$(obj))
libdeps := $(foreach dep, $(libsrc:.c=.d), build/dep/$(dep))

examplesrc := $(notdir $(wildcard examples/*.c))
exampleobjs := $(foreach obj, $(examplesrc:.c=.o), build/obj/$(obj))
exampledeps := $(foreach dep, $(examplesrc:.c=.d), build/dep/$(dep))
examplebins := $(foreach bin, $(examplesrc:.c=), build/bin/$(bin))

.PHONY: all
all: build/lib/libcii.a $(exampleobjs) $(examplebins)

.PHONY: clean
clean:
	@-rm -rf build/

build/lib/libcii.a: $(libobjs)
	@mkdir -p $(@D)
	@$(AR) $(ARFLAGS) $@ $^

build/bin/%: %.o
	@mkdir -p $(@D)
	@$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

build/obj/%.o: %.c
	@mkdir -p $(@D)
	$(COMPILE.c) $(OUTPUT_OPTION) $<

build/dep/%.d: %.c
	@mkdir -p $(@D)
	@$(COMPILE.c) -MM -MF $@ $<
	@sed -i '1s|^|obj/|' $@

-include $(libdeps)
-include $(exampledeps)
