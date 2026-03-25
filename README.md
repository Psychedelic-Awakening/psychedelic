# Psychedelic Site Rebuild

This repository is for rebuilding the Psychedelic Institute website from archived recovery bundles.

## Current layout

- `archive/recovery/`: raw recovered page bundles for the original site and funnel steps
- `app/`: Astro rebuild app
- `recover-site.sh`: helper script used to recover page HTML, assets, links, and text

## Archived bundles

- `psychedelic-institute-recovery`: home page
- `membership-recovery`: membership and donation page
- `guardian-recovery`: guardian application form
- `tyg-recovery`: thank-you page

The archived recovery output is reference material, not a maintainable application source.

## Rebuild app

Run the site locally from `app/`:

- `pnpm dev`
- `pnpm build`
- `pnpm preview`
