# Deploy To Cloudflare Pages

This repository is a monorepo-like layout for Cloudflare Pages because the deployable Astro app lives in `app/`.

## Recommended setup

Create a Cloudflare Pages project from the Git repository and use these settings:

- Framework preset: `Astro`
- Production branch: `main`
- Root directory: `app`
- Build command: `pnpm build`
- Build output directory: `dist`

## Environment variables

Optional:

- `PUBLIC_GUARDIAN_FORM_ENDPOINT`
  - External endpoint for guardian application submissions.
  - If omitted, the guardian form still works as a local preview flow and redirects to `/ty-g/`.

Recommended:

- `PNPM_VERSION=9.15.9`
  - Explicitly pins pnpm for Cloudflare Pages builds.

## Why these settings

- The repository root is not the app root.
- The Astro app already builds statically to `app/dist`.
- Cloudflare Pages supports monorepo deployments by setting a root directory.

## First deploy flow

1. Push `main` to GitHub.
2. In Cloudflare, go to Workers & Pages.
3. Create a Pages project from the GitHub repository.
4. Set the root directory to `app`.
5. Confirm the build command and output directory.
6. Add any environment variables before the first production deploy if needed.
7. Deploy and use the generated `*.pages.dev` URL as the owner preview link.

## After the preview is approved

Replace placeholder content and wire the real guardian intake endpoint.
