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

- `fzf` — only needed for the interactive selection mode (no arguments)

## Installation

Two things are needed for `try` to work: the script must be on your `$PATH`, and
a `try` shell function must wrap it. The wrapper exists because `try.sh` only
prints the target directory — the actual `cd` is performed by the function in
your interactive shell, otherwise you'd end up in a subshell that exits
immediately.

### 1. Put `try.sh` on your `$PATH`

Clone the repository and copy the script into your `$PATH`:

```sh
git clone https://github.com/you/try.git
cp try/try.sh ~/.local/bin/try
chmod +x ~/.local/bin/try
```

Or add the current directory to your `$PATH`:

```sh
export PATH="$PWD/try:$PATH"
```

### 2. Add the `try` function

Add the following function to your shell configuration (`~/.bashrc`,
`~/.zshrc`, or wherever your shell reads it):

```sh
try() {
  cd "$(bash try.sh ${@})"
}
```

After that, reload your shell config (`source ~/.bashrc`) and you're ready to
go.

## Usage

```
Usage: try [name]
```

| Argument        | Description                                             |
| --------------- | ------------------------------------------------------- |
| `--help`, `-h`  | Show the help message and exit                        |
| `<name>`        | Create and enter `~/try/YYYY-MM-<name>`                 |

If no argument is given, you'll see an interactive list of existing directories
in `fzf` and can pick the one you want.

### Examples

```sh
# Create and enter ~/try/2026-11/test-api
try test-api

# Pick an existing directory from the fzf list
try
```

## Environment Variables

| Variable  | Default | Description                                                |
| --------- | ------- | ---------------------------------------------------------- |
| `TRY_DIR` | `~/try` | The root directory where all experiments are stored        |

## License

Distributed under the terms of the [WTFPL](LICENSE). Do whatever you want. 🚀
