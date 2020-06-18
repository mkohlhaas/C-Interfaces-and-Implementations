vpath %.c src examples
vpath %.o build/obj

CFLAGS := -I include -g
LDLIBS := -L build/lib
LOADLIBES := -lcii
ARFLAGS := r

lib_src := $(notdir $(wildcard src/*.c)) 
lib_objs := $(foreach obj, $(lib_src:.c=.o), build/obj/$(obj))
lib_deps := $(foreach dep, $(lib_src:.c=.d), build/dep/$(dep))

example_src := $(notdir $(wildcard examples/*.c))
example_objs := $(foreach obj, $(example_src:.c=.o), build/obj/$(obj))
example_deps := $(foreach dep, $(example_src:.c=.d), build/dep/$(dep))
example_bins := $(foreach bin, $(example_src:.c=), build/bin/$(bin))

.PHONY: all
all: build/lib/libcii.a $(example_objs) $(example_bins)

.PHONY: clean
clean:
	@-rm -rf build/

build/lib/libcii.a: $(lib_objs)
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

-include $(lib_deps)
-include $(example_deps)
