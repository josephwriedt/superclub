# Superclub

An experimental browser-based recreation of the [Superclub](https://superclubgame.com/) football management board game, built in Elm to explore functional programming and front-end development. The repository includes a copy of the [game rules](superclub-rules.pdf).

## Getting started

The checked-in `elm.js` lets you open `index.html` in a browser without installing a build tool. It may not reflect the latest Elm source, so rebuild it after making changes.

To build from source, install [Elm 0.19.1](https://guide.elm-lang.org/install/elm.html), then run from the repository root:

```sh
./make.sh
```

This runs `elm make src/Main.elm --output elm.js`. Elm may need network access to download packages listed in `elm.json` on the first build. Open `index.html` in a browser after the build; it loads `elm.js` and mounts the application in `#superclub`. Alternatively, serve the repository root with a static server, for example `python3 -m http.server 8000`, and visit `http://localhost:8000/`.

## Current state

This is a prototype, not a complete playable game. It initializes a sample club, displays a draft card and a club squad, and supports dragging cards onto squad slots to swap players. State lives in memory and resets on reload. The model also contains phase transitions, random player draws, and draft reshuffling, but the current view does not expose controls for advancing phases or reshuffling. Offseason finance and player improvement helpers exist, while the full offseason and season flows are not wired into the UI.

## Project structure

- `index.html` loads the compiled application and provides the mount point; `elm.js` is the generated JavaScript bundle.
- `src/Main.elm` connects the Elm `Browser.element` application.
- `src/Model.elm`, `src/Msg.elm`, and `src/Update.elm` define application state, events, and state transitions. Random operations return Elm commands; drag-and-drop events update the squad.
- `src/Init.elm` contains the sample club and player deck. `src/Club.elm` and `src/Player.elm` define club and player data and operations.
- `src/GamePhase.elm` defines phase ordering; `src/Offseason.elm` contains offseason helpers.
- `src/View.elm`, `src/PlayerDisplay.elm`, and `src/Gamestyle.elm` render and style the interface using `elm-css`.
- `tests/Example.elm` contains older example tests, and `elm.json` pins application and test dependencies.

## Development and tests

Edit the files in `src/`, run `./make.sh`, and reload the page. The build overwrites the tracked `elm.js` bundle. To check compilation without changing it, run:

```sh
elm make src/Main.elm --output /tmp/superclub-check.js
```

The example tests are stale: they reference definitions formerly exposed by `Main` that have since moved or no longer exist. They need to be updated before they can serve as a working test suite. With a compatible [elm-test](https://github.com/elm-explorations/test) installed and the tests updated, run `elm-test` from the repository root.
