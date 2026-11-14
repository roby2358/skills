# Web portals

Read when any target is a portal. Portal rules, size limits, and form fields change;
**look up the portal's current upload docs at audit time** and cite what you found in
SHIP.md rather than trusting numbers from memory. What follows is the stable part: how
running inside someone else's page differs from running on your own.

Item ids use the `PORT` prefix and the same tiers as the main checklist.

## Checklist items that get stricter in a portal frame

The game runs in an iframe served from the portal's CDN origin, which is usually shared
by every game on the portal and is third-party to the page around it. No new ids here:
re-check these items against the portal build and apply the changes noted.

- **SAVE-2 and SAVE-5 become T1.** Browsers partition a third-party frame's storage by
  the top-level site, and stricter privacy settings block it outright. Expect
  `localStorage` to throw, to come back empty, or to be shared with other games on the
  same CDN origin. Saves never carry between the portal copy and the own-site copy.
- **INP-1.** The frame sits in a scrolling page, so an unhandled arrow key or space
  scrolls the game out of view.
- **AUD-1.** Unlock audio on a click inside the frame. The portal's own launch button
  may not pass activation to the frame; do not rely on it.
- **LOAD-6.** The build must work with no access to the author's site: no fetches home,
  no absolute URLs to it.
- **ONB-3.** Controls live in the game; the portal description repeats them.

## In the frame

| Id | Tier | Check |
|---|---|---|
| PORT-1 | T1 | **Upload shape.** A zip with `index.html` at the root, every path relative, no leading `/`, filename case exact, and only the build inside (WEB-2). Unzip it somewhere fresh and serve it from a subdirectory to prove it. |
| PORT-2 | T1 | **Keyboard focus.** The frame gets no keys until clicked. The title screen's click-to-start handles it; also re-acquire focus on any canvas click and show a "click to resume" state when focus is lost. |
| PORT-3 | T1 | **Fits the frame.** The portal embeds at a size you declare. Pick it deliberately, make the game fill exactly that with no scrollbars, and confirm nothing assumes `window` is the full screen. |
| PORT-4 | T2 | **Fullscreen works from inside the frame.** Enable the portal's fullscreen option and keep the in-game toggle (SET-2); verify the layout at fullscreen size. |
| PORT-5 | T2 | **Links leave the frame.** Every external link uses `target="_blank" rel="noopener"`; nothing navigates the frame itself away from the game. |
| PORT-6 | T2 | **Server games:** CORS and WebSocket origin checks allow the portal's game-hosting origin, which is usually a separate CDN domain from the portal's main site. |

## The portal page

| Id | Tier | Check |
|---|---|---|
| PORT-7 | T1 | **Device flags are honest.** Leave "mobile friendly" (or the equivalent) off for a desktop-only game, and keep the in-game sorry screen anyway; portal flags do not stop phone visitors arriving by link. |
| PORT-8 | T2 | **Listing is complete.** Title, short pitch (WEB-6), capsule image at the portal's required size and screenshots (WEB-5), genre and tags, input method, session length, and content rating (LEGAL-8). |
| PORT-9 | T2 | **AI disclosure field is filled in** with the LEGAL-5 statement wherever the portal asks about generative AI. Answer yes, plainly, and say what was generated. |
| PORT-10 | T2 | **Tested on the live draft page** before publishing; most portals allow a private or restricted draft. From a clean profile (LOAD-1), in a normal window and a private one, play through and re-check the items in the first section. |

## Choosing portals

- **Open upload** portals (itch.io, Newgrounds) take a zip and a listing; these fit a
  free, no-monetization game with no changes to the game.
- **Curated, SDK-based** portals (CrazyGames, Poki, and similar) require integrating
  their SDK, generally including their ad breaks, and pass a review. That conflicts with
  a no-monetization stance; flag it as a decision for the user rather than auditing
  against it by default.
- Record each portal in SHIP.md's Targets table (listing URL, declared frame size,
  commit uploaded, date) so a patch (OPS-4) knows what is live where.
