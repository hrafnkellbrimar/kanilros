# Build and maintenance guide

## Pipeline

`.github/workflows/build-and-deploy.yml` is the single source of truth for validation and deployment. It runs on pull requests, pushes to `main`, manual dispatches, and a weekly schedule.

Every run:

1. Installs the Ruby version from `.ruby-version` and the locked gems.
2. Builds Jekyll with production settings and strict front matter.
3. Validates generated HTML and internal links with HTMLProofer.
4. Audits locked gems against the Ruby advisory database.

Only a push to `main` uploads and deploys the Pages artifact. The deploy job receives `pages: write` and `id-token: write`; other jobs retain read-only repository access.

## Dependency policy

- `Gemfile.lock` makes local and CI builds reproducible.
- Dependabot proposes weekly Bundler and GitHub Actions updates.
- Runtime gems use compatible-version constraints; the lockfile records exact versions.
- GitHub Actions use current stable major tags so Dependabot can surface new majors.

Run `make update` to refresh gems manually, then run `make check` before merging the lockfile change.

## Performance

The production site uses generated HTML and one plain CSS file. It has no client-side JavaScript, web-font downloads, theme runtime, or image pipeline. Third-party audio and video players load lazily.

GitHub Pages does not support custom response headers. The optional `netlify.toml` contains security and cache headers for a Netlify deployment; equivalent headers require a CDN or proxy when GitHub Pages remains the origin.

## Content updates

- Add or edit releases in `docs/_data/albums.yml`.
- Add long-form release pages in `docs/_posts/`.
- Edit page copy in `docs/*.markdown`.
- Keep embeds behind the shared `docs/_includes/soundcloud-player.html` include.

## Local commands

```bash
make serve   # development server with live reload
make build   # strict production build
make check   # build, HTML validation, dependency audit
make clean   # remove generated Jekyll files
```
