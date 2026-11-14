# Web portals

Read when any target is a portal. Portal rules, size limits, and form fields change;
**look up the portal's current upload docs at audit time** and cite what you found in
SHIP.md rather than trusting numbers from memory. What follows is the stable part: how
running inside someone else's page differs from running on your own.

Item ids use the `PORT` prefix and the same tiers as the main checklist.

## Running inside an iframe on another origin

| Id | Tier | Check |
|---|---|---|
| PORT-1 | T1 | **Upload shape.** A zip with `index.html` at the root, every path relative, no leading `/`, no reference to the author's own domain, filename case exact. Unzip it somewhere fresh and serve it from a subdirectory to prove it. |
| PORT-2 | T1 | **Storage may be blocked or partitioned.** In a third-party frame `localStorage` can throw, be empty every visit, or be shared with every other game on the portal's CDN origin. SAVE-2 and SAVE-5 become hard requirements: guarded access and per-game key prefixes. |
| PORT-3 | T1 | **Keyboard focus.** The frame gets no keys until clicked. The title screen's click-to-start handles it; also re-acquire focus on any canvas click and show a "click to resume" state when focus is lost. |
| PORT-4 | T1 | **Keys must not scroll the host page** (INP-1). Test on the real portal page, where the frame sits in a scrolling document. |
| PORT-5 | T1 | **Fits the frame.** The portal embeds at a fixed size you declare. Pick it deliberately, make the game fill exactly that with no scrollbars, and confirm nothing depends on `window` being the full screen. |
| PORT-6 | T2 | **Fullscreen works from inside the frame.** Enable the portal's fullscreen option and keep the in-game toggle (SET-2); verify the layout at fullscreen size. |
| PORT-7 | T2 | **Links leave the frame.** Every external link uses `target="_blank" rel="noopener"`; nothing navigates the frame itself away from the game. |
| PORT-8 | T2 | **Audio unlock** happens on the first click inside the frame (AUD-1); a click on the portal's own play button does not count. |
| PORT-9 | T2 | **No requests home.** The build works with no access to the author's site: no fetches to it, self-hosted fonts and libraries (LOAD-6). |
| PORT-10 | T2 | **Server games:** CORS and WebSocket origins allow the portal's game-hosting origin, which is usually a separate CDN domain from the portal's main site. |

## The portal page

| Id | Tier | Check |
|---|---|---|
| PORT-11 | T1 | **Device flags are honest.** Leave "mobile friendly" (or the equivalent) off for a desktop-only game, and keep the in-game sorry screen anyway; portal flags do not stop phone visitors arriving by link. |
| PORT-12 | T2 | **Listing is complete.** Title, short pitch (WEB-5), capsule image at the portal's required size, screenshots (WEB-4), genre and tags, input method, session length. |
| PORT-13 | T2 | **AI disclosure field is filled in** with the LEGAL-5 statement wherever the portal asks about generative AI. Answer yes, plainly, and say what was generated. |
| PORT-14 | T2 | **Controls are in the game**, with the portal description repeating them, not replacing them (ONB-3). |
| PORT-15 | T2 | **Content rating fields** match LEGAL-9. |
| PORT-16 | T2 | **Tested on the live draft page** before publishing: most portals allow a private or restricted draft. Run PLAY-3 there, in a normal window and a private one. |
| PORT-17 | T3 | **Clip or GIF** on the listing (WEB-8), and a first devlog or description post. |

## Choosing portals

- **Open upload** portals (itch.io, Newgrounds) take a zip and a listing; these fit a
  free, no-monetization game with no changes to the game.
- **Curated, SDK-based** portals (CrazyGames, Poki, and similar) require integrating
  their SDK, generally including their ad breaks, and pass a review. That conflicts with
  a no-monetization stance; flag it as a decision for the user rather than auditing
  against it by default.
- Record per portal in SHIP.md: URL of the listing, declared frame size, upload date,
  and the commit uploaded, so a patch (OPS-5) knows what is live where.
