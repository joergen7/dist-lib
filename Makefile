PKG         := dist-lib
DEPS-FLAGS  := --check-pkg-deps --unused-pkg-deps
JOBS        := 16

.PHONY: all
all: setup test

.PHONY: install
install:
	raco pkg install --auto

.PHONY: remove
remove:
	raco pkg remove $(PKG)

.PHONY: setup
setup:
	raco setup -j 1 --tidy $(DEPS-FLAGS) --pkgs $(PKG)

.PHONY: clean
clean:
	raco setup --fast-clean --pkgs $(PKG)
	$(RM) -r coverage
	$(RM) -r `find ./ -type d -name compiled`

.PHONY: test
test:
	raco test -j $(JOBS) -x -p $(PKG)

.PHONY: cover
cover:
	raco cover .
