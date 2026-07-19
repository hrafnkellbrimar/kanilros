.PHONY: help install serve build check test audit clean update

help:
	@echo "Kanilrós Website"
	@echo ""
	@echo "  make install  Install dependencies"
	@echo "  make serve    Start the local server"
	@echo "  make build    Build the production site"
	@echo "  make check    Build, validate HTML, and audit dependencies"
	@echo "  make update   Update locked dependencies"
	@echo "  make clean    Remove generated files"

install:
	cd docs && bundle install

serve:
	cd docs && bundle exec jekyll serve --livereload

build:
	cd docs && JEKYLL_ENV=production bundle exec jekyll build --strict_front_matter

check: build
	cd docs && bundle exec ruby scripts/validate-site.rb
	cd docs && bundle exec htmlproofer ./_site --disable-external
	cd docs && bundle exec bundle-audit check --update

test: check

audit:
	cd docs && bundle exec bundle-audit check --update

clean:
	cd docs && bundle exec jekyll clean

update:
	cd docs && bundle update
