# goto-drives.yazi

> [!IMPORTANT]
> Since the Windows drives view this plugin is obsolete (https://github.com/sxyazi/yazi/pull/4412).
> You can drop it and bind the drives view directly instead:
>
> ```toml
> { on = [ "g", ":" ], run = "cd place://host//", desc = "Go to drives" }
> ```

A plugin for [yazi](https://github.com/sxyazi/yazi) to `cd` to the available windows drives from an fzf menu.

## Dependencies
- [fzf](https://github.com/junegunn/fzf)

## Installation

```sh
ya pkg add 'Tyarel8/goto-drives'
```

## Usage

Add this to your `keymap.toml`:

```toml
[manager]
prepend_keymap = [
  { on = [ "g", ":" ], run  = "plugin goto-drives", desc = "Go to drives" },
]
```
