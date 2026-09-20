# bend-init

Go from an empty directory to a law-backed Bend 2 project in one command.

## Quick start

Install [Bend](https://bend-lang.com), then:

```sh
git clone --depth 1 https://github.com/gouveags/bend-init.git
bend bend-init/main.bend hello-bend
cd hello-bend
bend main.bend
bend PROOF.bend
```

The generated project contains:

- `main.bend` — a runnable hello world
- `LAWS.bend` — its human-owned rule
- `PROOF.bend` — a machine-checked proof
- `AGENTS.md` — concise instructions for coding agents
- `README.md` — the essential commands and file map

`bend-init` only accepts a single directory name and refuses to overwrite an
existing directory.

## Bend Hub

The generator is published immutably as
[`0x1e0cc3677d46304c29af14dfd5553385`](https://hub.bend-lang.com/0x1e0cc3677d46304c29af14dfd5553385).
To run that package, make a tiny `init.bend` entry point:

```bend
import Base
import 0x1e0cc3677d46304c29af14dfd5553385/main.bend as Init

def main() -> IO(Unit):
  Init.main()
```

Then run `bend init.bend hello-bend`.

## License

[MIT](LICENSE)
