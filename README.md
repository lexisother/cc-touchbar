# CCTouchBar

CCTouchBar is a CrossCode mod with a native module written in Objective-C++ designed exclusively for use on a MacBook with a touchbar.

Currently the module just shows a button on the touchbar when the game starts, and the button text gets updated whenever the player model changes. (e.g. when Lea's entity is created)

# NOTE: PASSING OF `--single-process` IN THE `chromium-flags` IS REQUIRED!!!

This is because the game window & code is typically a separate process from the one where all the native code runs. Since our module is native code, but we also need access to the game's window, we need to have both the window and the native stuff running in a single process. Passing `--single-process` will do this.

## Development

Requirements:

- https://github.com/rizsotto/Bear

```bash
cd path/to/crosscode/assets/mods
git clone https://github.com/lexisother/cc-touchbar
cd cc-touchbar
# below command will build the native module
npm i
```
