.PHONY: help install build serve clean deploy-local test lint

help:
	@echo "Kanilrós Website - Development Commands"
	@echo "========================================="
	@echo ""
	@echo "Setup:"
	@echo "  make install       - Install dependencies"
	@echo ""
	@echo "Development:"
	@echo "  make serve         - Start local development server"
	@echo "  make build         - Build the site"
	@echo "  make build-prod    - Build site for production"
	@echo ""
	@echo "Testing:"
	@echo "  make lint          - Run code quality checks"
	@echo "  make test          - Build and validate output"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean         - Remove build artifacts"
	@echo "  make update        - Update dependencies"
	@echo ""

install:
	cd docs && bundle install

serve:
	@echo "⚠️  Note: Local builds require Ruby 2.7. Using GitHub Actions for deployment."
	@echo "For local preview with Ruby 4.x, use: make serve-docker"
	@echo ""
	@echo "Alternatively, view the deployed site at: https://kanilros.is"

serve-local:
	@echo "⚠️  Ruby 2.7 or older required. Current Ruby: $$(ruby --version)"
	cd docs && bundle exec jekyll serve --incremental --livereload

serve-docker:
	@echo "Starting Jekyll with Docker (requires Docker to be running)..."
	docker run --rm -it -v "$$PWD:/site" -p 4000:4000 jekyll/jekyll:latest \
		bash -c "cd /site/docs && bundle install && bundle exec jekyll serve --host 0.0.0.0"

build:
	cd docs && bundle exec jekyll build

build-prod:
	cd docs && JEKYLL_ENV=production bundle exec jekyll build --strict_front_matter

build-profile:
	cd docs && bundle exec jekyll build --profile

test: build
	@echo "Build successful!"
	@echo "Site generated in docs/_site/"

lint:
	@echo "Checking for HTML issues..."
	cd docs && bundle exec jekyll build --strict_front_matter
	@echo "✓ HTML validation passed"

clean:
	cd docs && bundle exec jekyll clean
	rm -rf docs/.jekyll-cache
	rm -rf docs/_site
	@echo "✓ Build artifacts cleaned"

update:
	cd docs && bundle update
	@echo "✓ Dependencies updated (check Gemfile.lock)"

# Watch for changes and rebuild (useful for development)
watch:
	cd docs && bundle exec jekyll build --watch

# Server with live reload (requires jekyll-watch)
live:
	cd docs && bundle exec jekyll serve --livereload --incremental

# Check for broken links (requires html-proofer)
check-links:
	@echo "Checking for broken links..."
	gem install html-proofer 2>/dev/null
	cd docs && jekyll build
	html_proofer ./docs/_site --disable-external --allow-hash-href

# Security audit
audit:
	@echo "Running security audit..."
	gem install bundler-audit 2>/dev/null
	cd docs && bundle audit check --update

# Show build profiling information
profile: build-profile
	@echo "✓ See timing information above"

# Display Jekyll version
version:
	cd docs && bundle exec jekyll --version

# Display site config
config:
	@echo "Jekyll Configuration:"
	cd docs && cat _config.yml | grep -E "^(title|url|baseurl|timezone)"
