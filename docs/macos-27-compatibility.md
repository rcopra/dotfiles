# macOS 27 compatibility audit

Last checked: 2026-09-15

## Short answer

No application central to this dotfiles workflow is confirmed to lose support on
macOS 27. The Mac itself is supported, and Homebrew, Karabiner-Elements, OmniWM,
and Ghostty all have explicit macOS 27 support or compatibility statements.

There are three concrete things to address:

1. The installed Xcode Command Line Tools 16.4 are too old for macOS 27 and need
   to be replaced with Command Line Tools 27 after the upgrade.
2. `SensibleSideButtons`, `SynologyAssistant`, and the installed VLC build are
   Intel-only. They can still run on macOS 27 through Rosetta, but Rosetta is not
   automatically restored during the OS upgrade.
3. Three legacy Google updater LaunchAgent plists on this Mac carry the
   quarantine attribute. macOS 27 no longer loads quarantined `launchd` plists,
   so Chrome's updater needs to be checked after upgrading.

AFP is no longer supported, but it does not affect the current backup: the
configured Time Machine destination uses SMB, and no AFP mounts were active
when checked.

The Intel-only applications become a hard incompatibility with macOS 28, not
macOS 27 (except for Apple's limited legacy-game support).

## Scope and local evidence

This audit used:

- the applications and command-line tools named in this repository;
- application rules in `home/dot_config/omniwm/settings.toml`;
- a read-only inventory of `/Applications` and Homebrew;
- each app bundle's version, minimum OS, and executable architectures;
- the installed developer-tool and Rosetta package metadata; and
- quarantine attributes on user and system LaunchAgent/LaunchDaemon plists.

The machine inspected is a MacBook Pro 14-inch (2021), identifier
`MacBookPro18,3`, with an M1 Pro, currently running macOS 26.5.2. Apple lists
every Apple-silicon MacBook Pro from 2020 onward as compatible with macOS 27
Golden Gate, which Apple released on September 14, 2026
([Apple macOS 27 overview](https://www.apple.com/os/macos/)).

The OmniWM rules also mention Codex, Commander One, Dia, Outlook, and Zen, but
those bundles were not present in `/Applications` when checked. Their entries
below mean "the configured workflow remains viable," not "this app is
currently installed."

## Confirmed unsupported or requiring replacement

### Xcode Command Line Tools 16.4

This Mac has Command Line Tools 16.4 and no full Xcode installation. Homebrew
7.0.1 treats 27.0 as the minimum matching developer-tool version on macOS 27,
and recommends Xcode/CLT 27 there
([Homebrew's version mapping](https://github.com/Homebrew/brew/blob/7.0.1/Library/Homebrew/os/mac/xcode.rb)).
Apple's compatibility matrix likewise lists Xcode 27, rather than older Xcode
releases, for macOS 27
([Xcode system requirements](https://developer.apple.com/xcode/system-requirements)).

This does not mean the installed Homebrew packages disappear. It means builds,
upgrades, and tools that call the compiler may fail or be unsupported until the
matching Command Line Tools are installed. After upgrading macOS, run
`xcode-select --install`, then `brew doctor`.

### AFP workflows

Apple says AFP is unsupported in macOS 27 and later, including AFP Time Machine
and transfers to older Macs, AirPort Extreme, or Time Capsule. SMB Time Machine
remains supported
([Apple's AFP compatibility notice](https://support.apple.com/en-us/102423)).
The current Time Machine destination uses SMB, and no AFP mounts were active
when checked, so this removal does not affect the current backup. Continue to
use `smb://`, rather than `afp://`, for any new NAS connections.

## Compatible or explicitly covered

| Software | Local/configured state | macOS 27 assessment |
| --- | --- | --- |
| Homebrew and the CLI stack | Homebrew 7.0.1; the shell, tmux, Neovim, Node 24, PostgreSQL, fzf, eza, zoxide, direnv, and related tools are Homebrew-managed | Supported after updating CLT. Homebrew classifies Apple-silicon macOS 27 as Tier 1 ([Homebrew support tiers](https://docs.brew.sh/Support-Tiers)). Golden Gate bottle migration is active, with no high-profile failed formulae listed when checked ([official tracking issue](https://github.com/Homebrew/homebrew-core/issues/303311)). |
| Karabiner-Elements | 16.3.0, Universal | Explicitly supports macOS 27 on Apple silicon ([official repository](https://github.com/pqrs-org/Karabiner-Elements)). It still requires its background service, Accessibility permission, and DriverKit system extension ([required settings](https://karabiner-elements.pqrs.org/docs/manual/misc/required-macos-settings/)). |
| OmniWM | 0.6.10, Apple silicon | Explicitly requires macOS 26+ on Apple silicon and documents macOS 27-only features ([official repository](https://github.com/BarutSRB/OmniWM)). |
| Ghostty | 1.3.1, Universal | Its macOS 27 tracker says Ghostty works, with only possible minor visual glitches ([official tracker](https://github.com/ghostty-org/ghostty/issues/13001)); 1.3.1 requires macOS 13+ ([download page](https://ghostty.org/download)). |
| Chrome | 152.0.7977.65, Universal | Chrome itself is covered by Google's macOS 13-or-later requirement ([Chrome requirements](https://support.google.com/chrome/answer/95346)). Check its updater separately because of the quarantined plists described below. |
| Firefox | 155.0.1, Universal | Firefox 155 supports macOS 10.15 or later and both Intel and Apple-silicon processors ([Firefox 155 requirements](https://www.firefox.com/en-US/firefox/155.0/system-requirements/)). |
| Discord | 0.0.411, Universal | Covered by Discord's current macOS 12-or-later requirement; its unsupported list concerns beta operating systems, and macOS 27 is now released ([Discord requirements](https://support.discord.com/hc/en-us/articles/213491697-What-are-the-OS-system-requirements-for-Discord)). |
| Slack | 4.51.185, Apple silicon | Covered by Slack's macOS 13+ and app 4.44+ requirements ([Slack requirements](https://slack.com/help/articles/115002037526-System-requirements-for-using-Slack)). |
| Spotify | 1.2.66.447, Apple silicon | Covered by Spotify's macOS 13-or-later requirement ([Spotify supported devices](https://support.spotify.com/au/article/supported-devices-for-spotify/)). |
| Obsidian | 1.9.14, Universal | Obsidian provides a Universal macOS build ([installation guide](https://obsidian.md/help/install)). No macOS 27-specific statement was found, but this build does not depend on Rosetta. |
| Dia | Configured, not installed | Requires macOS 14+ and M1 or later; its September 9 release fixed a Golden Gate-specific window-animation bug, showing active macOS 27 work ([requirements](https://www.diabrowser.com/), [changelog](https://www.diabrowser.com/changelog/mac)). |
| Codex/ChatGPT desktop app | Configured, not installed | Official OpenAI documentation provides an Apple-silicon macOS build, which this M1 Pro can run. The official page does not publish a macOS 27-specific support statement ([OpenAI desktop-app documentation](https://learn.chatgpt.com/docs/app)). |
| Commander One | Configured, not installed | The vendor describes the current release as compatible with macOS 10.13 and later, which covers 27 but is not a release-specific certification ([Commander One requirements](https://mac.eltima.com/ftp-manager.html)). |
| Outlook/Microsoft 365 | Configured, not installed | Microsoft supports the newest three macOS major versions as each new version becomes generally available, so the current Microsoft 365/Outlook line covers macOS 27 ([Microsoft support policy](https://support.microsoft.com/en-us/office/lifecycle/officeinstall/upgrade-macos-to-continue-receiving-microsoft-365-and-office-for-mac-updates)). |
| Zen Browser | Configured, not installed | No formal macOS 27 support statement was found. The current project shipped a macOS release on September 5 and has already resolved a macOS 27-specific UI issue, so this is active but not formally declared support ([current releases](https://github.com/zen-browser/desktop/releases), [resolved macOS 27 issue](https://github.com/zen-browser/desktop/issues/14546)). |

## Risks and support not yet declared

### Rosetta is removed during the upgrade, but remains available on 27

Apple's final macOS 27 release notes say an existing Rosetta installation is not
automatically restored after upgrading. Opening an Intel-only app triggers the
Rosetta installation prompt. Apple also says macOS 27 is the final general
release for Intel Mac applications; macOS 28 retains only narrower legacy-game
translation
([macOS 27 release notes](https://developer.apple.com/documentation/macos-release-notes/macos-27-release-notes),
[Apple's Rosetta support article](https://support.apple.com/en-us/102527)).

The local application scan found three Intel-only top-level apps:

- **SensibleSideButtons 1.0.6** — highest risk. The vendor still offers only
  1.0.6 and claims macOS 10.10+, but makes no macOS 27 or Apple-silicon support
  statement ([official site](https://sensible-side-buttons.archagon.net/)). It
  should continue through Rosetta on 27; plan to replace it before macOS 28.
- **Synology Assistant** — Intel-only locally, although Synology states that the
  current Assistant supports macOS 12.4 or later
  ([Synology specifications](https://www.synology.com/en-global/dsm/7.4/software_spec/utilities_mobile)).
  Update it before upgrading and expect it to request Rosetta if Synology still
  distributes an Intel build.
- **VLC 3.0.21** — this is the Intel build even though VideoLAN publishes native
  Apple-silicon and Universal packages. Replace it with the current Universal
  3.0.23 build before upgrading
  ([VideoLAN's official macOS download](https://www.videolan.org/vlc/download-macosx.html)).

Rosetta is installed today (`com.apple.pkg.RosettaUpdateAuto`), so the risk is
the upgrade removing it, not an already-missing dependency.

The installed Steam client is Universal, but local game executables for
Blasphemous, Celeste, Cobalt Core, GRIS, Slay the Spire, and The Curse of Monkey
Island/ScummVM are Intel-only. They remain covered by Rosetta on macOS 27.
Balatro, Darkwood, and Papers, Please have Universal executables. Apple has not
specified which individual games will qualify for the narrower legacy-game
translation support after macOS 27, so do not treat these as macOS 28-safe yet.

Autodesk Fusion itself is native on Apple silicon, but Autodesk says some
commands still require Rosetta. Reinstalling Rosetta after the OS upgrade is
therefore relevant even if none of the three Intel-only top-level apps is used
([Fusion system requirements](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/System-requirements-for-Autodesk-Fusion-360.html)).

### Chrome updater LaunchAgents

The following files currently have a `com.apple.quarantine` extended attribute:

```text
~/Library/LaunchAgents/com.google.GoogleUpdater.wake.plist
~/Library/LaunchAgents/com.google.keystone.agent.plist
~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
```

Apple says macOS 27 no longer loads quarantined `launchd` property lists
([macOS 27 release notes](https://developer.apple.com/documentation/macos-release-notes/macos-27-release-notes)).
Chrome itself is native and should launch; the uncertain part is whether its
current updater still needs these legacy agents. After upgrading, use Chrome's
**About Google Chrome** page to confirm that it can check for and install an
update. Reinstalling current Chrome is preferable to manually preserving an old
Keystone updater if that check fails.

### Hammerspoon

Hammerspoon 1.1.1 is Universal and its official release requires macOS 13+, but
the project has not published a macOS 27-specific support statement
([1.1.1 release](https://github.com/Hammerspoon/hammerspoon/releases/tag/1.1.1)).
The local configuration uses mainstream hotkey, application, task, IPC, and
path-watcher APIs rather than private window-management APIs. This is a low but
not zero compatibility risk; verify the Hyper application launchers and
Option-Return after the upgrade.

### Ghostty local-network SSH

Ghostty is compatible with macOS 27, but a report against Ghostty 1.3.1 on a
macOS 27 prerelease described SSH failures to local-network hosts while public
hosts still worked. The project response attributed this to the OS beta rather
than Ghostty, and final-release status was not confirmed in that discussion
([project discussion](https://github.com/ghostty-org/ghostty/discussions/13438)).
Because this setup relies heavily on Ghostty, test one LAN SSH connection after
upgrading; this is a regression check, not a known loss of app support.

### Zed

Zed is a native Apple-silicon build locally, but its current support table stops
at macOS 26 and does not yet declare macOS 27 support
([Zed installation requirements](https://zed.dev/docs/installation)). That is
an unknown/not-yet-declared status, not evidence that it is incompatible.

### Permissions for input and window tools

Karabiner-Elements and OmniWM explicitly support macOS 27, but both depend on
privacy/security permissions. OmniWM requires Accessibility and Input
Monitoring and optionally Screen Recording
([OmniWM requirements](https://github.com/BarutSRB/OmniWM)); Karabiner additionally
uses a DriverKit system extension
([Karabiner required settings](https://karabiner-elements.pqrs.org/docs/manual/misc/required-macos-settings/)).
If keyboard or window controls stop working after the OS upgrade, check those
permissions before treating it as an app-support failure.

## Other macOS 27 removals checked

- No Xcode application is installed; if Xcode 26 or older exists elsewhere, it
  is unsupported on macOS 27 and should be replaced by Xcode 27
  ([Xcode requirements](https://developer.apple.com/xcode/system-requirements)).
- No AFP references, AirPort Utility workflow, `ImageCreator` use, or managed
  custom launch agent appears in this repository. AirPort Utility is absent on
  clean installs and not guaranteed to function after an in-place upgrade;
  Apple's `ImageCreator` service has been discontinued
  ([macOS 27 release notes](https://developer.apple.com/documentation/macos-release-notes/macos-27-release-notes),
  [`ImageCreator` discontinuation](https://developer.apple.com/news/?id=dz9wvq0r)).
- No executable user plug-ins were found in the common Audio, Color Picker,
  Quick Look, or Spotlight plug-in locations Apple asks users to inspect. Apple
  warns that Intel-only plug-ins can be missed by the system's Intel-software
  list and stop working in macOS 28
  ([macOS 27 release notes](https://developer.apple.com/documentation/macos-release-notes/macos-27-release-notes)).

## Upgrade checklist

Before upgrading:

1. Make a current backup. The existing Time Machine destination already uses
   SMB; keep any additional Synology/NAS connections on SMB rather than AFP.
2. Update all applications. Replace the Intel VLC build with the Universal
   build; update Synology Assistant; decide whether SensibleSideButtons is still
   needed.
3. Run `brew update` and `brew upgrade` while still on macOS 26.

After upgrading:

1. Run `xcode-select --install`, then `brew doctor` and a representative build.
2. Launch an Intel-only app and accept macOS's Rosetta installation prompt.
3. Open **About Google Chrome** and verify that its update check completes.
4. Verify Karabiner's Hyper-3 chord, OmniWM focus/move keys, Hammerspoon's app
   launchers, a Ghostty LAN SSH connection, tmux, and Neovim split handoff.
5. If input or window controls fail, re-check Accessibility, Input Monitoring,
   Screen Recording, background-item, and Driver Extension permissions.
