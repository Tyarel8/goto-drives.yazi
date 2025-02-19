# goto-drives.yazi

A plugin for [yazi](https://github.com/sxyazi/yazi) to `cd` to the available windows drives from an fzf menu.

## Dependencies
- [fzf](https://github.com/junegunn/fzf)

## Installation

```sh
ya pack -a 'Tyarel8/goto-drives'
```

## Usage

Add this to your `keymap.toml`:

```toml
[manager]
prepend_keymap = [
  { on = [ "g", ":" ], run  = "plugin goto-drives", desc = "Go to drives" },
]
```
