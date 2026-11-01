# EV Poll Scanner

A sports analytics workspace for organizing matchups, poll estimates, and measuring forecast accuracy.

## Current status

This repository contains a responsive static dashboard prototype. Matchups and poll counts are illustrative demo data, not live feeds.

## Stack direction

- Frontend: Next.js planned; current prototype uses plain HTML, CSS, and JavaScript.
- Database: Supabase planned.
- Hosting: Vercel planned.
- Data integrations: authorized APIs and data exports only.

## Preview

Open index.html locally or enable GitHub Pages. The sport filter works with the included sample matchups.

## Planned milestones

1. Replace sample fixtures with a permitted public sports schedule/results source.
2. Add a poll import workflow for data you are authorized to access.
3. Store poll estimates and final results in Supabase.
4. Add calibration, accuracy-over-time, and sport-by-sport analytics.
5. Add secure server-side integration settings.

## Security and data integrity

Never commit API keys, access tokens, service-role keys, or other secrets. Store credentials in deployment environment variables and access them only from server-side code. Never label sample or manually imported data as live; record source and retrieval time for every imported record.
