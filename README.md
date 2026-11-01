# try

> Quick experimental directories, zero friction.

[![License: WTFPL](https://img.shields.io/badge/License-WTFPL-yellow.svg)](LICENSE)

`try` is a tiny shell utility that makes it effortless to create and jump into
scratch directories for experiments and play. No more manual
`mkdir && cd` and no more forgotten empty folders piling up in your home
directory.

---

## Features

- 📁 Creates an experiment directory by name and drops you right into it.
- 🕘 Directories are auto-named with a month prefix: `~/try/2026-11-my-exp`.
- 🔍 Run it with no arguments to pick an existing directory from an interactive `fzf` list.
- 🧹 All experiments live in one place (`TRY_DIR`), so it's easy to navigate and tidy up.

## Requirements

- A POSIX shell (`sh`, `bash`, `zsh`, …).
- Standard utilities: `date`, `find`, `mkdir`, `sed`.
- `fzf` — only needed for the interactive selection mode (no arguments).

## Installation

Two things are needed for `try` to work: the script must be on your `$PATH`, and
a `try` shell function must wrap it. The wrapper exists because `try.sh` only
prints the target directory — the actual `cd` is performed by the function in
your interactive shell, otherwise you'd end up in a subshell that exits
immediately.

### 1. Put `try.sh` on your `$PATH`

Clone the repository and copy the script into your `$PATH`:

```sh
git clone https://github.com/agrrh/try.git
mkdir -p ~/.local/bin
cp try/try.sh ~/.local/bin/try.sh
chmod +x ~/.local/bin/try.sh
```

Make sure `~/.local/bin` is on your `$PATH` (add this line to your shell
configuration if it isn't):

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Alternatively, symlink the script from the clone so updates are picked up
automatically:

```sh
ln -sf "$PWD/try/try.sh" ~/.local/bin/try.sh
```

### 2. Add the `try` function

Add the following function to your shell configuration (`~/.bashrc`,
`~/.zshrc`, or wherever your shell reads it):

```sh
try() {
  local target
  target="$(try.sh "$@")" || return
  if [ -n "$target" ]; then
    cd "$target" || return
  fi
}
```

The executable is named `try.sh` while the function is named `try`, so the
wrapper can call `try.sh` directly without recursing into itself. The script
prints the target path on stdout (help, warnings, and errors go to stderr), so
the wrapper can safely `cd` into it.

After that, reload your shell config (`source ~/.bashrc`) and you're ready to
go.

## Usage

```
Usage: try [name]
```

| Argument        | Description                                             |
| --------------- | ------------------------------------------------------- |
| `--help`, `-h`  | Show the help message and exit                          |
| `<name>`        | Create and enter `~/try/YYYY-MM-<name>`                 |
| *(no argument)* | Pick an existing directory from the interactive `fzf` list |

If no argument is given, you'll see an interactive list of existing directories
in `fzf` and can pick the one you want. Passing more than one argument is an
error.

### Examples

```sh
# Create and enter ~/try/2026-11-test-api
try test-api

# Pick an existing directory from the fzf list
try
```

## Environment Variables

| Variable  | Default | Description                                                |
| --------- | ------- | ---------------------------------------------------------- |
| `TRY_DIR` | `~/try` | The root directory where all experiments are stored        |

`TRY_DIR` is expanded by your shell, so write `TRY_DIR=~/experiments` without
quotes if you want `~` to expand.

## License

Distributed under the terms of the [WTFPL](LICENSE). Do whatever you want. 🚀
