# Ruby Version Compatibility Guide

## Current Setup

The Kanilrós website uses:
- **Deployment**: GitHub Pages with Ruby 2.7 (via GitHub Actions)
- **Local Development**: Requires Ruby 2.7 or compatible version

## Problem: Ruby 4.x Not Supported

GitHub Pages uses `github-pages` gem v228, which has dependencies that only support Ruby 2.7.x and 3.x. Ruby 4.0+ is not compatible with these older dependencies.

```
github-pages 228
  └── jekyll 3.9.0 (requires Ruby < 4.0)
      └── nokogiri (requires Ruby < 4.0)
```

## Solutions

### ✅ Option 1: Use Docker (Recommended)

Docker allows you to run Jekyll with the correct Ruby version without changing your system Ruby.

**Prerequisites**: Docker Desktop installed

**Commands**:
```bash
# Start development server with live reload
docker-compose up jekyll

# Build only (no server)
docker-compose run --rm build

# Using make shortcut
make serve-docker
```

The site will be available at `http://localhost:4000`

**Advantages**:
- Works regardless of local Ruby version
- Matches GitHub Pages environment exactly
- No system changes needed
- Fast rebuilds with caching

### ✅ Option 2: Install Ruby 2.7 Locally

Use a Ruby version manager like `rbenv` or `asdf`.

**With rbenv**:
```bash
# Install rbenv if not already installed
brew install rbenv

# Install Ruby 2.7
rbenv install 2.7.8

# Set local Ruby version
cd /Users/kanilros/Code/kanilros
rbenv local 2.7.8

# Verify
ruby --version  # Should show 2.7.8

# Install dependencies
cd docs
bundle install

# Run Jekyll
bundle exec jekyll serve
```

**With asdf**:
```bash
asdf plugin add ruby
asdf install ruby 2.7.8
asdf local ruby 2.7.8
cd docs && bundle install
```

### ⚠️ Option 3: Upgrade Dependencies (Advanced)

Update `Gemfile` to use a newer github-pages version that supports Ruby 4.x:

```gemfile
gem "github-pages"  # Remove version constraint
```

However, this may cause compatibility issues with GitHub Pages deployment. Not recommended.

## Recommended Workflow

1. **For Deployment**: Push to GitHub, GitHub Actions handles the build with Ruby 2.7
2. **For Local Preview**: Use Docker (`docker-compose up jekyll`)
3. **Why**: 
   - No local Ruby version conflicts
   - Exact environment match for deployment
   - Easy for team collaboration

## Quick Start with Docker

```bash
cd /Users/kanilros/Code/kanilros

# First time
docker-compose up jekyll

# Visit http://localhost:4000

# Ctrl+C to stop

# Next time, just run the same command
```

## Troubleshooting

### "docker: command not found"
Install Docker Desktop from https://www.docker.com/products/docker-desktop

### Port 4000 already in use
```bash
# Use a different port
docker-compose run -p 5000:4000 jekyll
```

### Bundle cache issues
```bash
# Clear Docker volumes
docker-compose down -v
docker-compose up jekyll  # Fresh start
```

### Build fails in Docker
```bash
# Check logs
docker-compose logs jekyll

# Rebuild image
docker-compose build --no-cache jekyll
docker-compose up jekyll
```

## GitHub Actions Build

GitHub Actions automatically builds with Ruby 2.7 on every push to `main`. No local action needed—just push and the site deploys automatically.

**Monitor builds**: https://github.com/hrafnkellbrimar/kanilros/actions

## Reference

- [Ruby 2.7 Docker Image](https://hub.docker.com/_/ruby)
- [Jekyll Docker Image](https://hub.docker.com/r/jekyll/jekyll)
- [rbenv Documentation](https://github.com/rbenv/rbenv)
- [GitHub Pages Ruby Support](https://pages.github.com/versions/)

## Summary

| Task | Solution | Time |
|------|----------|------|
| Deploy to live site | Push to main (GitHub Actions) | Automatic |
| Local preview | Docker: `docker-compose up jekyll` | 1 minute |
| Edit content | Any text editor | Instant |
| Test build locally | `make build` or docker-compose | 30-60s |
