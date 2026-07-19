# Kanilrós website

The source for [kanilros.is](https://kanilros.is), the website of Icelandic underground musician Kanilrós.

## Stack

- Jekyll 4.4 with local HTML layouts
- Plain CSS with no client-side JavaScript or external font requests
- Ruby 4.0.6 and Bundler
- GitHub Actions and GitHub Pages

The site lives in `docs/`, matching GitHub Pages conventions. Content is stored in Markdown and `docs/_data/albums.yml`.

## Local development

Install Ruby 4.0.6 with your preferred version manager, then run:

```bash
make install
make serve
```

The development server is available at <http://localhost:4000>.

## Validation

Run the same build, internal-link validation, and dependency audit used in CI:

```bash
make check
```

## Deployment

Pull requests build and validate the site. A successful push to `main` deploys the generated `docs/_site` directory to GitHub Pages. Dependabot checks Ruby gems and GitHub Actions each week.

See [OPTIMIZATION_GUIDE.md](./OPTIMIZATION_GUIDE.md) for pipeline and maintenance details.
