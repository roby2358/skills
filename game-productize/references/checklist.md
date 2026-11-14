# Ship checklist

Each item: id, tier (T1 / T2 / T3), what to check, and how the gap usually shows up.
Tiers are defaults; move one when the game's shape calls for it and say so.

## Contents

- MENU: title, menus, end screens
- SAVE: save and resume
- AUD: audio
- SET: settings
- ONB: onboarding and rules
- MOB: mobile sorry screen and window size
- INP: input
- ERR: errors and recovery
- LOAD: loading and performance
- A11Y: accessibility
- TXT: text and copy
- LOC: localization
- WEB: own-site hosting
- LEGAL: licenses, credits, provenance, AI disclosure
- PRIV: privacy and telemetry
- OPS: feedback, versioning, after launch
- PLAY: end-to-end play checks

## MENU: title, menus, end screens

| Id | Tier | Check |
|---|---|---|
| MENU-1 | T1 | **Title screen.** The game does not start mid-action on page load. Shows the name and one obvious way to begin. Doubles as the user gesture that unlocks audio. |
| MENU-2 | T1 | **End states exist and are reachable.** Win and lose each land on a screen that says what happened. No silent freeze, no `alert()`. |
| MENU-3 | T1 | **Restart without reloading the page.** New game from the end screen and from the pause menu, with all state reset (check for module-level leftovers: timers, listeners, RNG, selections). |
| MENU-4 | T2 | **Pause.** Esc or a visible button; real-time games stop the clock. Pause menu offers resume, settings, how to play, quit to title. |
| MENU-5 | T2 | **Continue vs New Game** on the title when a save exists; New Game confirms before overwriting. |
| MENU-6 | T2 | **End screen has a payoff.** A summary of the run (turns, score, what killed you), not only "You win". Offers play again. |
| MENU-7 | T2 | **Auto-pause on blur.** Tab hidden or window unfocused pauses real-time play and mutes or ducks audio (`visibilitychange`). |
| MENU-8 | T2 | **Credits reachable from the title.** See LEGAL. |
| MENU-9 | T3 | **Difficulty or mode select**, if the design supports it, with the default clearly marked. |
| MENU-10 | T3 | **Every menu is keyboard navigable** and Esc always backs out one level. |

## SAVE: save and resume

Skip to `n/a` only if a full session is a few minutes and nothing carries over.

| Id | Tier | Check |
|---|---|---|
| SAVE-1 | T1 | **Progress survives a reload.** Autosave at safe points (turn end, level end). Closing the tab mid-run does not lose more than the current turn or level. |
| SAVE-2 | T1 | **Storage failure is survivable.** Every storage read and write is in try/catch. With storage blocked (private window, third-party iframe on a portal) the game still plays and says saving is unavailable. |
| SAVE-3 | T1 | **Corrupt or foreign save does not brick the game.** Bad JSON or an unexpected shape falls back to a new game, not a blank page that persists across reloads. |
| SAVE-4 | T2 | **Save format is versioned.** A `version` field, and a decision per version bump: migrate or discard with a message. Shipping an update must not crash returning players. |
| SAVE-5 | T2 | **Storage keys are namespaced per game** (`gamename.save.v1`). Several games on one origin (own site, or a portal CDN) must not read each other's keys. |
| SAVE-6 | T2 | **Settings are saved separately from progress**, so New Game does not reset volume. |
| SAVE-7 | T2 | **Player can wipe their data.** A reset-progress control with a confirm. |
| SAVE-8 | T2 | **Seed is saved with the run** when the game uses seeded RNG, so resume is the same world and a bug report is reproducible. |
| SAVE-9 | T3 | **Export / import save** as text or file, for moving between browsers and for bug reports. |
| SAVE-10 | T3 | **Multi-tab safety.** Two tabs do not silently clobber each other's save. |

## AUD: audio

| Id | Tier | Check |
|---|---|---|
| AUD-1 | T1 | **No audio before a user gesture.** Browsers block it; the failure mode is a console error and silence for the whole session. Start or resume the audio context on the title-screen click. |
| AUD-2 | T1 | **Mute is one action away** during play, and it persists. |
| AUD-3 | T2 | **The game has sound at all.** Feedback sounds on the core actions (select, move, hit, fail, win, lose). Silence reads as unfinished. If silent by design, say so in SHIP.md. |
| AUD-4 | T2 | **Separate music and effects volume**, persisted. |
| AUD-5 | T2 | **Nothing is carried by sound alone.** Every audio cue has a visual one; many portal players have the tab muted. |
| AUD-6 | T2 | **Levels are balanced.** No effect that clips or is far louder than the rest; rapid repeats (many hits in one frame) do not stack into a blast. Needs a human ear: mark `unverified` if not listened to. |
| AUD-7 | T2 | **Music loops cleanly** and does not restart on every screen change. |
| AUD-8 | T3 | **Audio stops or ducks when paused** and on tab hide. |

## SET: settings

| Id | Tier | Check |
|---|---|---|
| SET-1 | T2 | **A settings screen exists**, reachable from title and pause, and every setting persists. |
| SET-2 | T2 | **Fullscreen toggle**, with the layout holding up in fullscreen. On portals the frame is small and this is the main fix. |
| SET-3 | T2 | **Speed controls** where the game has animation or AI turns the player waits through: faster animations or skip. |
| SET-4 | T2 | **Reduced motion.** Screen shake and flashes can be turned off, and default off under `prefers-reduced-motion`. |
| SET-5 | T3 | **Key remapping**, or at least alternates (WASD and arrows). |
| SET-6 | T3 | **Colorblind-safe option** when color carries game state (teams, terrain, danger). |
| SET-7 | T3 | **UI scale / text size.** |

## ONB: onboarding and rules

| Id | Tier | Check |
|---|---|---|
| ONB-1 | T1 | **A stranger can make their first meaningful move unaided.** Play it cold: if the first minute needs knowledge only the author has, this fails. |
| ONB-2 | T1 | **The goal is stated** before or at the start: what winning is and what losing is. |
| ONB-3 | T2 | **Controls are shown in the game**, not only on the hosting page. Portal descriptions get separated from the game. |
| ONB-4 | T2 | **Rules reference on demand.** A how-to-play screen from title and pause that covers every mechanic, with the actual numbers. |
| ONB-5 | T2 | **Teach by doing, in order.** The first level or first turns introduce mechanics one at a time. A wall of text before play does not count. |
| ONB-6 | T2 | **Everything on the board can be inspected.** Hover or click a unit, tile, icon, or status and learn what it is and what it does. |
| ONB-7 | T2 | **Consequences are previewed.** Damage, movement range, and cost are shown before commit; irreversible actions confirm or can be undone. |
| ONB-8 | T2 | **Failure explains itself.** A rejected action says why ("not enough MP"), and a loss says what caused it. |
| ONB-9 | T2 | **Hints do not nag returning players.** First-run tips are remembered as seen and can be replayed. |
| ONB-10 | T3 | **A soft first loss.** The opening is hard to lose in the first couple of minutes. |

## MOB: mobile sorry screen and window size

Desktop-only is the default. The job is to tell phone visitors the truth quickly and
kindly, since portals and shared links send a lot of them.

| Id | Tier | Check |
|---|---|---|
| MOB-1 | T1 | **A sorry screen exists.** On a device that cannot play, the visitor sees a designed screen instead of a broken or microscopic game. |
| MOB-2 | T1 | **Detect by capability, not user agent.** Key on `matchMedia('(pointer: coarse)')` with `(hover: none)`, plus viewport size. Do not exclude touch laptops or a tablet with a mouse and keyboard attached. |
| MOB-3 | T1 | **There is a way past it.** A "try anyway" control; detection is never perfect and a hard block is worse than a rough experience. |
| MOB-4 | T2 | **The screen sells the game.** Name, a screenshot or short loop, one line on what it is, and "built for mouse and keyboard" stated plainly. No apology spiral. |
| MOB-5 | T2 | **It helps them come back on a computer.** Copy-link or share (Web Share API where present). |
| MOB-6 | T2 | **It appears before heavy loading.** Do not download the game's assets on a device that will not play it. |
| MOB-7 | T2 | **`<meta name="viewport">` is set** so the sorry screen itself is readable on a phone. |
| MOB-8 | T2 | **Desktop window too small.** Below the minimum playable size the game scales, scrolls sanely, or asks for a bigger window; it does not clip the HUD off screen. Check at 1280x720 and in a portal-sized frame. |
| MOB-9 | T2 | **Resize and zoom hold.** Resizing the window, browser zoom 80 to 150%, and high-DPI displays keep the canvas crisp and click coordinates correct. |
| MOB-10 | T3 | **The decision is recorded** in SHIP.md: desktop only on purpose, and what it would take to support touch. |

## INP: input

| Id | Tier | Check |
|---|---|---|
| INP-1 | T1 | **Game keys do not scroll the page.** Arrows, space, and Tab `preventDefault` while playing; critical inside a portal iframe. |
| INP-2 | T1 | **Right-click and drag behave.** If right-click is a game action, the context menu is suppressed on the canvas only; dragging does not select page text or start an image drag. |
| INP-3 | T2 | **Focus loss is handled.** Keys held when the window blurs do not stick; clicking back in resumes input. |
| INP-4 | T2 | **Every action is visible on screen.** Keyboard shortcuts are accelerators for buttons, not the only path, and each shortcut is shown next to its button. |
| INP-5 | T2 | **Browser shortcuts are not hijacked** (Ctrl+R, Ctrl+W, F5, F12 keep working). |
| INP-6 | T2 | **Double input is safe.** Double-click, key repeat, or clicking during an animation cannot fire an action twice or act out of turn. |
| INP-7 | T2 | **Trackpad works.** Pan and zoom do not require a mouse wheel or middle button. |
| INP-8 | T3 | **Fully playable from the keyboard.** |

## ERR: errors and recovery

| Id | Tier | Check |
|---|---|---|
| ERR-1 | T1 | **Clean console on a normal run.** No uncaught errors or 404s from title to end screen. |
| ERR-2 | T1 | **No soft-locks.** No reachable state where the player has no legal action and no way to end: check no-moves-left, all-units-dead, and empty-map cases. |
| ERR-3 | T2 | **A crash is visible and recoverable.** `window.onerror` and `unhandledrejection` show a "something broke" screen with reload and, if the save might be the cause, start-fresh. Not a frozen canvas. |
| ERR-4 | T2 | **Debug affordances are off.** Cheat keys, debug overlays, `console.log` spam, and test seeds are removed or behind a flag that is off in the shipped build. |
| ERR-5 | T2 | **`<noscript>` and unsupported-browser message.** |
| ERR-6 | T2 | **Server games: disconnect is handled.** Lost connection shows a state, retries, and resumes or explains; a stale client after a deploy is told to reload. |
| ERR-7 | T3 | **Long-session stability.** An hour of play does not leak memory, listeners, or timers; restart many times and watch. |

## LOAD: loading and performance

| Id | Tier | Check |
|---|---|---|
| LOAD-1 | T1 | **Works from a clean cache on a real host**, not only `file://` or localhost. All paths are relative and case matches exactly (hosts are case-sensitive; a dev machine may not be). |
| LOAD-2 | T2 | **Something appears immediately.** A loading state for any wait over about a second; no blank white page. |
| LOAD-3 | T2 | **Updates reach players.** Cache-busting (hashed or versioned filenames, or sane cache headers) so a returning player does not run new HTML against old JS. |
| LOAD-4 | T2 | **Holds frame rate on a modest laptop.** Check the largest map and the busiest moment with integrated graphics or 4x CPU throttle. Redraw only when something changed where the game is turn-based. |
| LOAD-5 | T2 | **Does not spin when idle or hidden.** No full-rate render loop on a static screen or a background tab. |
| LOAD-6 | T2 | **No runtime dependency on third-party hosts.** Fonts and libraries are self-hosted, so the game works on a portal CDN, offline-ish, and makes no third-party requests (see PRIV). |
| LOAD-7 | T3 | **Payload is reasonable.** Images and audio compressed; total size noted in SHIP.md. |
| LOAD-8 | T3 | **Browser matrix.** Current Chrome, Firefox, and Safari each played once. Mark the ones not tried `unverified`. |

## A11Y: accessibility

| Id | Tier | Check |
|---|---|---|
| A11Y-1 | T2 | **Text is readable.** Body text around 14px or larger at 1280x720 and contrast of at least 4.5:1 against its background. |
| A11Y-2 | T2 | **Color is never the only signal.** Teams, danger, and selection also differ by shape, icon, pattern, or label. |
| A11Y-3 | T2 | **No rapid full-screen flashing**; shake and flashes respect SET-4. |
| A11Y-4 | T2 | **No reaction-time gate without need.** Timers the design does not depend on can be relaxed or paused. |
| A11Y-5 | T3 | **DOM UI is labeled and focus-visible**: buttons are `<button>`, images have alt text, focus rings are not removed. |
| A11Y-6 | T3 | **Simulated colorblind pass** (deuteranopia, protanopia) on a busy screen. |

## TXT: text and copy

| Id | Tier | Check |
|---|---|---|
| TXT-1 | T1 | **No placeholder text.** Search for TODO, lorem, "test", "foo", untitled, and default `<title>`. |
| TXT-2 | T2 | **One name for each thing.** The same unit, resource, or action has the same word in the UI, the rules screen, and the tooltips. |
| TXT-3 | T2 | **Proofread.** Spelling and grammar on every screen, including rare ones (errors, end states). |
| TXT-4 | T2 | **Numbers in the rules match the code.** Check the how-to-play text against the constants. |

## LOC: localization

Browser-game audiences are heavily non-English, and with AI doing the translating the
cost is mostly in whether the code is ready for it. So the audit splits **ready** (T2,
cheap now, expensive to retrofit) from **translated** (T3, a per-game choice).
English-only is a valid decision; an unrecorded one is not.

| Id | Tier | Check |
|---|---|---|
| LOC-1 | T2 | **The language decision is recorded** in SHIP.md: which languages ship, and which are deferred. |
| LOC-2 | T2 | **Strings live in one table keyed by id**, not scattered as literals through UI code. Includes tooltips, errors, end screens, the sorry screen, and unit and item names from the artifacts data. |
| LOC-3 | T2 | **Sentences are not built by concatenation.** Use whole-sentence templates with named slots (`"{unit} takes {n} damage"`); word order differs by language, so `name + " takes " + n` cannot be translated. |
| LOC-4 | T2 | **No text baked into images** or drawn into art. Logos excepted. |
| LOC-5 | T2 | **Layout survives longer text.** Assume strings grow by a third. Buttons and panels size to content; canvas text is measured and wrapped, not placed at hardcoded widths. Test by padding every string. |
| LOC-6 | T2 | **`<html lang>` is set** and matches the language shown. |
| LOC-7 | T3 | **Language picker in settings**, defaulting from `navigator.languages`, persisted, switchable without losing the run. Each language is listed under its own name ("Deutsch", not "German"). |
| LOC-8 | T3 | **Plurals and numbers use `Intl`** (`Intl.PluralRules`, `Intl.NumberFormat`), not `n === 1 ? "" : "s"`. |
| LOC-9 | T3 | **Fonts cover the glyphs.** The shipped font has every character each language needs (accents, Cyrillic, CJK), or a deliberate fallback stack; no tofu boxes, and canvas text uses the same stack. |
| LOC-10 | T3 | **Translations are consistent with the glossary.** Each game term (TXT-2) has one translation per language, used everywhere. Keep the glossary with the string table and give it to the translator, human or model. |
| LOC-11 | T3 | **Translation quality is checked.** AI translation is fine and is credited like everything else (LEGAL-5). A fluent reader's pass is `unverified` until the user confirms one happened. |
| LOC-12 | T3 | **Missing strings fall back to English**, visibly in dev and silently in the shipped build; a new string added in a patch never renders as a raw key. |
| LOC-13 | T3 | **The wrapper is translated too.** Page title, meta description, link-preview text, and portal listings in each shipped language where the portal supports it. |
| LOC-14 | T3 | **Right-to-left** only if an RTL language is chosen; otherwise `n/a`. |

## WEB: own-site hosting

| Id | Tier | Check |
|---|---|---|
| WEB-1 | T1 | **Served over HTTPS at a stable URL** the user is willing to keep. |
| WEB-2 | T2 | **`<title>`, meta description, and favicon** are set and specific to the game. |
| WEB-3 | T2 | **Link previews work.** `og:title`, `og:description`, `og:image` (1200x630), `og:url`, and `twitter:card`. Paste the URL into a chat app and look. |
| WEB-4 | T2 | **A capsule image and three or more screenshots exist**, taken from real play. Portals and the site index both need them. |
| WEB-5 | T2 | **One-paragraph pitch** written: what it is, what you do, how long a session is. Reused on the page, the portals, and the link preview. |
| WEB-6 | T2 | **A way back.** Link to the author's other games or site index, opening outside the game frame. |
| WEB-7 | T2 | **Embedding policy is deliberate.** Decide whether other sites may iframe the game and set `Content-Security-Policy: frame-ancestors` to match. |
| WEB-8 | T3 | **A short gameplay clip or GIF** for the page and for posts. |
| WEB-9 | T3 | **404 and old-URL handling** if the game ever moved. |

## LEGAL: licenses, credits, provenance, AI disclosure

| Id | Tier | Check |
|---|---|---|
| LEGAL-1 | T1 | **Provenance inventory is complete.** Every image, sound, music track, font, icon set, and library is listed in SHIP.md with its source and license or tool terms. Anything of unknown origin is a T1 blocker until traced or replaced. |
| LEGAL-2 | T1 | **Third-party licenses are honored.** Attribution text included where required (MIT/BSD notices, OFL for fonts, CC-BY credits); nothing non-commercial-only or no-redistribution is shipped. |
| LEGAL-3 | T1 | **AI tool terms permit publishing.** For each generative tool used for art, audio, or text, the plan it was used under allows public distribution of outputs. Note the tool and plan in the inventory. |
| LEGAL-4 | T2 | **Credits screen exists in the game.** Author, tools, third-party assets and libraries, with links. |
| LEGAL-5 | T2 | **AI disclosure is written, enthusiastic, and accurate.** Name the models and tools and what each made (code, art, sound, writing). Tone: proud of the method, no hedging, no apology, no overclaiming human authorship. Use the same statement in the credits and on portal disclosure fields. |
| LEGAL-6 | T2 | **The name is clear.** A quick search of the title on the target portals and the web shows no existing game or trademark it collides with. |
| LEGAL-7 | T2 | **Not a clone.** No names, characters, art, music, or levels lifted from an existing game. |
| LEGAL-8 | T2 | **The repo's own license is decided** if the source is public: LICENSE file or an explicit "all rights reserved". |
| LEGAL-9 | T3 | **Content notes** where the theme warrants (violence, flashing), for portal rating fields. |

Example disclosure, to adapt rather than copy:

> Built with AI, start to finish, and that is the point. Code and design were made in
> conversation with Claude; art by <tool>; sound by <tool>. One human steering, a lot of
> machines building. Fonts and libraries are credited below.

## PRIV: privacy and telemetry

Telemetry is decided per game. Present the choice with its tradeoff:

| Option | You learn | You owe |
|---|---|---|
| None | Nothing unless players write in | Only to verify there is truly nothing |
| Error reporting only | Crashes in the wild, with stack and version | A one-line notice; no personal data, no IPs stored |
| Cookieless counts plus game events | Visits, and where players stop (reached level 2, finished) | A short privacy note; keep events anonymous and few |

| Id | Tier | Check |
|---|---|---|
| PRIV-1 | T1 | **The decision is recorded** in SHIP.md. |
| PRIV-2 | T1 | **No accidental tracking.** The network tab on a full run shows no third-party requests the decision does not cover: font CDNs, script CDNs, embedded widgets. |
| PRIV-3 | T2 | **What is stored is stated.** One or two plain sentences in credits or about: what the game keeps in the browser, and what if anything leaves it. |
| PRIV-4 | T2 | **If telemetry is on:** no cookies, no identifiers, no free-text from the player, and it fails silently when blocked. |
| PRIV-5 | T2 | **Server games:** what the server stores per player, how long, and how a player gets it removed. |

## OPS: feedback, versioning, after launch

| Id | Tier | Check |
|---|---|---|
| OPS-1 | T2 | **A feedback channel is reachable from the game.** A link (portal comments, an issue tracker, a form). Avoid publishing a personal email address in plain text. |
| OPS-2 | T2 | **A version is visible** on the title or credits screen, and tied to the commit that was shipped. |
| OPS-3 | T2 | **Bug reports carry context.** Version and seed are shown somewhere a player can copy them. |
| OPS-4 | T2 | **The shipped commit is tagged** and the deploy is repeatable from it. Record the deploy steps for each target. |
| OPS-5 | T2 | **A patch path is known.** How an update reaches each target, and what happens to in-progress saves (ties to SAVE-4). |
| OPS-6 | T3 | **A changelog** players can see. |
| OPS-7 | T3 | **A launch post is drafted**: pitch, clip, link, where it will be shared. |

## PLAY: end-to-end play checks

Do these by playing the shipped build, not by reading code.

| Id | Tier | Check |
|---|---|---|
| PLAY-1 | T1 | **Played start to finish at least once** on the build being shipped, to a win and to a loss. |
| PLAY-2 | T1 | **The game is winnable** from a fresh start without author knowledge, on the default settings. |
| PLAY-3 | T2 | **Cold-open test.** Clear storage, load the public URL, and play five minutes as a stranger. Note every moment of "what do I do now". |
| PLAY-4 | T2 | **Reload at awkward moments**: mid-animation, mid-enemy-turn, on the end screen, during a modal. Resume is sane each time. |
| PLAY-5 | T2 | **Someone other than the author has played it** without help. Always `unverified` until the user confirms; it finds more than every other check combined. |
| PLAY-6 | T3 | **Difficulty curve checked** across several seeds or runs; no unwinnable seeds. |
