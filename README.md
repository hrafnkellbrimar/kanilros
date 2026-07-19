# Kanilrós Website

Welcome to the repository for [kanilros.is](https://kanilros.is) - the official website of musician Kanilrós.

## Overview

This is a static website built with [Jekyll](https://jekyllrb.com/) and hosted on GitHub Pages. The site showcases the music, albums, and videos of Kanilrós (@hrafnkellbrimar).

## Technology Stack

- **Static Site Generator**: Jekyll 4.x (via github-pages gem)
- **Theme**: Minima
- **Styling**: SCSS
- **Deployment**: GitHub Pages (automatic on push to `main` branch)

## Project Structure

```
docs/
├── _data/               # Site data files (albums.yml)
├── _includes/           # Reusable components (meta-tags, navigation)
├── _layouts/            # Custom page layouts (albums, videos)
├── _posts/              # Blog posts
├── _sass/               # SCSS stylesheets
├── assets/              # Static assets (images, CSS)
├── _config.yml          # Site configuration
├── Gemfile              # Ruby dependencies
├── index.markdown       # Homepage
├── about.markdown       # About page
├── listen.markdown      # Albums page
└── watch.markdown       # Videos page
```

## Deployment & CI/CD

This project uses GitHub Actions for automated building and deployment.

### Workflows
- **Build and Deploy** (`.github/workflows/build-and-deploy.yml`): Builds and deploys to GitHub Pages on main branch
- **Code Quality** (`.github/workflows/code-quality.yml`): Validates HTML, checks for broken links, scans for vulnerabilities

See [OPTIMIZATION_GUIDE.md](./OPTIMIZATION_GUIDE.md) for detailed build pipeline information.

## Development Setup

### Prerequisites

- Ruby 2.7 or later
- Bundler (`gem install bundler`)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/hrafnkellbrimar/kanilros.git
cd kanilros
```

2. Install dependencies:
```bash
cd docs
bundle install
```

3. Start the development server:
```bash
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`

## Development Workflow

### Local Testing

```bash
cd docs
bundle exec jekyll build   # Build the static site
bundle exec jekyll serve   # Run local server with live reload
```

### Content Structure

- **Albums**: Define album data in `_data/albums.yml`, displayed via `_layouts/albums.html`
- **Videos**: Define video data in `_data/albums.yml`, displayed via `_layouts/videos.html`
- **Pages**: Create new pages as `.markdown` files with appropriate front matter

### Best Practices

- Use semantic HTML in layouts
- Include proper ARIA labels and roles for accessibility
- Responsive design: test on mobile, tablet, and desktop
- Optimize images before adding to assets
- Keep accessibility (a11y) in mind - test with screen readers

## SEO and Meta Tags

The site includes:
- Automatic meta tags via `jekyll-seo-tag` plugin
- Open Graph tags for social media sharing
- Twitter Card support
- Structured data recommendations

## Accessibility Features

- Skip-to-content link
- ARIA labels on interactive elements
- Responsive iframe embeds with proper aspect ratios
- High contrast mode support
- Reduced motion support for users with vestibular disorders
- Dark mode support

## Deployment

The site is automatically deployed to GitHub Pages when you push to the `main` branch. The build happens automatically via GitHub Actions.

### Custom Domain

The site uses the custom domain `kanilros.is`. The CNAME file is configured and DNS is managed separately.

## Performance Optimization

- CSS is minified in production
- Images should be optimized (consider using WebP with fallbacks)
- Lazy loading on embedded players
- CSS media queries for responsive design

## Maintenance

### Updating Dependencies

To update gems to the latest compatible versions:

```bash
cd docs
bundle update
```

This will update the `Gemfile.lock` file. Commit both files.

### Adding New Content

1. **New blog post**: Create file `_posts/YYYY-MM-DD-title.markdown`
2. **New page**: Create file `pagename.markdown` with front matter
3. **New album**: Add to `_data/albums.yml` and layouts will automatically display it

## Contributing

For changes to the website:

1. Create a feature branch
2. Make your changes locally and test with `bundle exec jekyll serve`
3. Commit with clear messages
4. Push and create a pull request

## Troubleshooting

### Bundle install fails

Ensure you have Ruby installed and Bundler updated:
```bash
gem update bundler
bundle install
```

### Jekyll won't start

Clear the cache and rebuild:
```bash
bundle exec jekyll clean
bundle exec jekyll serve
```

### Changes not appearing locally

The development server has live reload enabled. If changes don't appear:
1. Stop the server (Ctrl+C)
2. Run `bundle exec jekyll clean`
3. Restart the server

## License

The website content and design are part of Kanilrós's brand and artistic work.

## Contact

For inquiries about Kanilrós's music:
- Email: hrafnkellkanilros@gmail.com
- Twitter: [@kanilros](https://twitter.com/kanilros)
- Instagram: [@kanilros](https://instagram.com/kanilros)
- Facebook: [kanilros](https://facebook.com/kanilros)
