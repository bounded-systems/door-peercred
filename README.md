# door-peercred — SO_PEERCRED helper for launcherd

A tiny, dependency-free Rust binary that reads `SO_PEERCRED` off a unix socket and injects the
caller's **UID/GID/PID** into requests. The [claude-box](https://github.com/bounded-systems/claude-box)
launcher (launcherd) uses it to identify in-box callers by UID — so authority is anchored to *who is
calling*, not a forgeable token.

It is a **launcherd helper, not a door** (it holds no capability of its own). Linux-only
(`SO_PEERCRED`).

## Build

```sh
nix build .#peercred         # via nix (what claude-box uses)
cargo build --release        # or directly
```

claude-box pins this repo as an input and builds the binary from a vendored mirror — the same
pinned-source pattern as `guest-room` / `door-kit`. There is no published artifact (the binary is
built from source by each consumer).

_Extracted from claude-box `peercred/` — decomposition epic `prx-ii01`, card 3._
