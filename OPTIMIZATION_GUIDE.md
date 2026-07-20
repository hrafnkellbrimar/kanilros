# Build and maintenance guide

## Pipeline

`.github/workflows/build-and-deploy.yml` is the single source of truth for validation and deployment. It runs on pull requests, pushes to `main`, manual dispatches, and a weekly schedule.

Every run:

1. Installs the Ruby version from `.ruby-version` and the locked gems.
2. Builds Jekyll with production settings and strict front matter.
3. Validates metadata, image alternatives, and JSON-LD entities.
4. Validates generated HTML and internal links with HTMLProofer.
5. Audits locked gems against the Ruby advisory database.

Only a push to `main` uploads and deploys the Pages artifact. The deploy job receives `pages: write` and `id-token: write`; other jobs retain read-only repository access.

## Dependency policy

- `Gemfile.lock` makes local and CI builds reproducible.
- Dependabot proposes weekly Bundler and GitHub Actions updates.
- Runtime gems use compatible-version constraints; the lockfile records exact versions.
- GitHub Actions are pinned to full commit SHAs, with major-version comments so
  Dependabot can still surface updates without introducing mutable references.

Run `make update` to refresh gems manually, then run `make check` before merging the lockfile change.

## Hosting and performance

GitHub Pages is the sole deployment target. The repository's Actions workflow
builds and validates the site, then deploys the generated artifact after a push
to `main`. Keeping one deployment path avoids configuration drift and makes the
workflow that CI validates the same workflow that publishes production.

Netlify would be worth reconsidering if deploy previews, edge redirects, or
custom response headers become requirements. Until then, its additional build
configuration and hosting surface do not benefit this static site.

The production site uses generated HTML and one plain CSS file. It has no
client-side JavaScript, web-font downloads, theme runtime, or image pipeline.
Canonical album artwork is served by Apple Music's image CDN, while third-party
audio and video players load lazily.

## Content updates

- Add or edit releases in `docs/_data/albums.yml`.
- Add long-form release pages in `docs/_posts/`.
- Edit page copy in `docs/*.markdown`.
- Keep Spotify embeds behind the shared `docs/_includes/spotify-player.html` include.

## Search and AI discoverability

- `jekyll-seo-tag` generates page titles, descriptions, canonical URLs, and social previews.
- `docs/_includes/structured-data.html` describes Kanilrós and the five albums with `MusicGroup` and `MusicAlbum` JSON-LD.
- `docs/robots.txt` allows standard crawlers, OAI-SearchBot, and user-initiated ChatGPT fetches; the sitemap remains the canonical URL inventory.
- Every album has visible descriptive copy, artwork, release details, streaming links, and a dedicated canonical page.
- `docs/scripts/validate-site.rb` prevents missing metadata, malformed JSON-LD, and image accessibility regressions in CI.

When adding an album, update `docs/_data/albums.yml` and add a matching post with `layout: release`, `album_id`, a unique description, and social-preview artwork.

## Local commands

```bash
make serve   # development server with live reload
make build   # strict production build
make check-actions # action-pin policy and regression tests
make check   # build, SEO/HTML validation, dependency audit
make clean   # remove generated Jekyll files
```
