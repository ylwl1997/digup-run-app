# Building Digup Run

Derived from ARahim3/DigUp (MIT). Digup Run is not an official DigUp product.

This Linux CI box cannot produce a signed Mac `.app`; use an Apple Silicon Mac
with Xcode for Mac builds. Windows/Linux packaging scripts are documented below
and mirrored in `docs/ci/*.skeleton`.

## Mac (preferred)

**Requirements:** Apple Silicon Mac, macOS 14+, Xcode 26+ (Swift 6.2 toolchain as upstream).

```sh
# Dev / local signed build → build.noindex/DigupRun.app
./build.sh

# Release: Developer ID + notarization → DMG
SIGN_ID="Developer ID Application: Your Name (TEAMID)" \
NOTARY_PROFILE=DigupRun \
  scripts/release.sh
```

Notes:

- Bundle ID: `com.ylwl1997.diguprun` (`Resources/Info.plist`).
- Sparkle feed URL points at this fork’s `appcast.xml`. Replace `SUPublicEDKey`
  with a key you control before shipping updates (upstream DigUp key will not
  verify Digup Run builds).
- App icons: regenerate `Resources/AppIcon.icns` on macOS from
  `Resources/AppIcon-source.png` / `Resources/AppIcon/appicon.svg` via
  `iconutil` (see `Resources/AppIcon/README.md`). Tray SVGs/PNGs use the
  digup.run teal mark.

## Windows

**Requirements:** Windows x64, Swift 6.4+, Rust, Node (Tauri 2).

```sh
scripts/fetch-vendor.sh
scripts/build-llama.sh
scripts/package-windows.sh
```

Installer lands under `shell/src-tauri/target/release/bundle/nsis/`.
Product name **Digup Run**, binary **DigupRun.exe**, identifier
`com.ylwl1997.diguprun`.

## Linux

**Requirements:** Ubuntu 22.04+ recommended, Swift 6.4+, Rust, Node, Vulkan SDK
(optional for GPU backend).

```sh
scripts/fetch-vendor.sh
scripts/build-llama.sh
scripts/package-linux.sh
```

Outputs `.deb` (package name **`digup-run`**) and AppImage under
`shell/src-tauri/target/release/bundle/{deb,appimage}/`.

## CI / Releases skeleton

Active `.github/workflows` were not committed (GitHub OAuth token lacks
`workflow` scope). Copy and adapt:

- `docs/ci/packages.yml.skeleton` — Windows + Linux package build / smoke
- `docs/ci/homebrew.yml.skeleton` — optional Homebrew cask bump (retarget to
  Digup Run / digup-run)

Publish artifacts to **GitHub Releases** on `ylwl1997/digup-run-app`. The
product site https://digup.run links to those Releases only (no binaries hosted
on the site).

## Helper CLI

The SwiftPM product `digup` (helper CLI) keeps its historical executable name
for engine compatibility. User-facing packages and display name are Digup Run /
digup-run.
