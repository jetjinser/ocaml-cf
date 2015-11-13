.PHONY: build install uninstall reinstall clean

FINDLIB_NAME=cf
MOD_NAME=cf

OCAML_LIB_DIR=$(shell ocamlc -where)

CTYPES_LIB_DIR=$(shell ocamlfind query ctypes)

OCAMLBUILD=CTYPES_LIB_DIR=$(CTYPES_LIB_DIR) OCAML_LIB_DIR=$(OCAML_LIB_DIR) \
	ocamlbuild -use-ocamlfind -classic-display

TARGETS=.cma .cmxa

PRODUCTS=$(addprefix $(MOD_NAME),$(TARGETS)) \
	lib$(MOD_NAME)_stubs.a dll$(MOD_NAME)_stubs.so

TYPES=.mli .cmi .cmti

INSTALL=$(addprefix $(MOD_NAME), $(TYPES)) \
	$(addprefix $(MOD_NAME), $(TARGETS))

build:
	$(OCAMLBUILD) $(PRODUCTS)

install:
	ocamlfind install $(FINDLIB_NAME) META \
		$(addprefix _build/lib/,$(INSTALL)) \
		-dll _build/lib/dll$(MOD_NAME)_stubs.so \
		-nodll _build/lib/lib$(MOD_NAME)_stubs.a \
		_build/lib/$(MOD_NAME).a

uninstall:
	ocamlfind remove $(FINDLIB_NAME)

reinstall: uninstall install

clean:
	rm -rf _build
	rm -f lib/cf.cm? lib/cf.o