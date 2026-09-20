# bend-init: a proven Bend project in one command.

import Base

def Dir.make(path: String) ->
  IO(Result<&1, &1, U32 & String, Unit>):
  import "./effs/dir_make.c"
  import "./effs/dir_make.js"

def starter.main() -> String:
  "# Your first Bend program. Run it with: bend main.bend\n" ++
  "\n" ++
  "import Base\n" ++
  "\n" ++
  "def main() -> IO(Unit):\n" ++
  "  IO.print(\"Hello, Bend!\")\n"

def starter.laws() -> String:
  "# The human-owned rules this project must keep.\n" ++
  "\n" ++
  "import Base\n" ++
  "import ./main.bend as App\n" ++
  "\n" ++
  "# LAW: main prints the starter greeting.\n" ++
  "law prints_greeting:\n" ++
  "  {App.main() == IO.print(\"Hello, Bend!\") : IO(Unit)}\n"

def starter.proof() -> String:
  "# The machine-checked proof of every claim in LAWS.bend.\n" ++
  "\n" ++
  "import Base\n" ++
  "import ./main.bend as App\n" ++
  "import ./LAWS.bend as Laws\n" ++
  "\n" ++
  "def Laws.prints_greeting():\n" ++
  "  {==}\n"

def starter.agents() -> String:
  "# Working with Bend\n" ++
  "\n" ++
  "When using Bend:\n" ++
  "- run `bend guide` to learn the language\n" ++
  "- use `LAWS.bend` for important rules\n" ++
  "- run `bend PROOF.bend` before committing\n" ++
  "- parallelize the code whenever possible\n"

def starter.readme() -> String:
  "# Hello, Bend\n" ++
  "\n" ++
  "A tiny law-backed Bend 2 project.\n" ++
  "\n" ++
  "## Start\n" ++
  "\n" ++
  "```sh\n" ++
  "bend main.bend       # check and run\n" ++
  "bend PROOF.bend      # verify every law\n" ++
  "bend main.bend -o app\n" ++
  "./app\n" ++
  "```\n" ++
  "\n" ++
  "`main.bend` is the program. `LAWS.bend` holds human-owned rules.\n" ++
  "`PROOF.bend` proves those rules. `AGENTS.md` guides coding agents.\n" ++
  "\n" ++
  "Run `bend guide` for the language and `bend base <name>` for APIs.\n"

def write.done(w: File & Result<&1, &1, U32 & String, Unit>) -> IO(Unit):
  (file, result) = w
  do IO<Unit>:
    Unit <- File.close(file)
    IO.pass(Unit, result)

def write(path: String, data: String) -> IO(Unit):
  do IO<Unit>:
    file : File <- IO.try(File, File.open(path, "w"))
    result : File & Result<&1, &1, U32 & String, Unit> <-
      File.write(file, data)
    write.done(result)

def generate(+name: String) -> IO(Unit):
  do IO<Unit>:
    Unit <- IO.try(Unit, Dir.make(name))
    Unit <- write(name ++ "/main.bend", starter.main())
    Unit <- write(name ++ "/LAWS.bend", starter.laws())
    Unit <- write(name ++ "/PROOF.bend", starter.proof())
    Unit <- write(name ++ "/AGENTS.md", starter.agents())
    Unit <- write(name ++ "/README.md", starter.readme())
    IO.print("Created " ++ name ++ ". Next: cd " ++ name ++ " && bend main.bend")

def invalid_name(+name: String) -> Bool:
  String.is_empty(name) || String.eq(name, ".") || String.eq(name, "..") ||
  String.contains(name, "/") || String.contains(name, "\\")

def create.go(name: String, invalid: Bool) -> IO(Unit):
  match invalid:
    case True{}:
      IO.die(Unit, 2, "Project name must be one directory name.")
    case False{}:
      generate(name)

def create(+name: String) -> IO(Unit):
  create.go(name, invalid_name(name))

def help() -> IO(Unit):
  IO.print(
    "bend-init creates a tiny law-backed Bend project.\n\n" ++
    "Usage: bend main.bend <project-name>\n\n" ++
    "Then run:\n" ++
    "  cd <project-name>\n" ++
    "  bend main.bend   # check and run\n" ++
    "  bend PROOF.bend  # verify the law")

def one_arg.go(name: String, wants_help: Bool) -> IO(Unit):
  match wants_help:
    case True{}:
      help()
    case False{}:
      create(name)

def one_arg(+name: String) -> IO(Unit):
  one_arg.go(name, String.eq(name, "-h") || String.eq(name, "--help"))

def with_args(args: List<String>) -> IO(Unit):
  match args:
    case Nil{}:
      help()
    case Con{name, Nil{}}:
      one_arg(name)
    case _:
      IO.die(Unit, 2, "Usage: bend main.bend <project-name>")

def main() -> IO(Unit):
  do IO<Unit>:
    args : List<String> <- IO.args()
    with_args(args)
