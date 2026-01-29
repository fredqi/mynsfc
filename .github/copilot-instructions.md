# mynsfc Development Rules

## 1. The "One Source" Architecture (.dtx)
- **Single Source of Truth**: `mynsfc.dtx` contains implementation (`<class>`), definitions (`<definitions>`), docs (`<driver>`), and examples (`<example>`, `<examplebib>`).
- **Forbidden Edits**: NEVER edit `.cls`, `.def`, or `examples/*` files. They are overwritten by `make`.
- **Git**: Track ONLY `.dtx`, `.ins`, `Makefile`, `README.md`. Ignore all generated files.

## 2. Build & Release (Makefile)
- `make`: Compile docs & generate all files (uses `docstrip` + `xelatex`).
- `make distclean`: Remove ALL generated files (reset to source).
- `make zip`: Create CTAN-compliant zip.
  - **Rules**: Flat layout. Includes logic source (`.dtx`, `.ins`), docs (`.pdf`, `README.md`), and generated example source (`.tex`, `.bib`) and PDF. Excludes derived binaries (`.cls`, `.def`).

## 3. Implementation Patterns
- **Guards**: Wrap code in `%<*guard> ... %</guard>`.
- **XeLaTeX**: Strictly use `xelatex` and `ctex`. Handle `AutoFakeBold`.
- **Magic Sections**: Use `\nsfcpart` / `\nsfcsection` (auto-generated headers from `mynsfc.def`) instead of manual numbering.
- **BibLaTeX**: Use `author+an = {2=self; 2:family=corr}` in `.bib` for bold/corresponding authors.

## 4. Syntax Example
```latex
%<*class>
  \ProvidesClass{mynsfc}[...]
%</class>
%<*example>
  \documentclass{mynsfc} % No % prefix needed inside macrocode environments
%</example>
```

## 5. Development Tasks (Prompts)

### Adding a Class Option
1. Add option with `kvoptions` in `<class>` guard.
2. Implement logic.
3. Document in `<driver>` section.
4. Add usage test in `<example>` guard.
5. Add `\changes` entry.

### Preparing Release
1. Update version/date in `\ProvidesClass` and `\ProvidesFile`.
2. Add `\changes` entry for today.
3. Run `make distclean && make zip`.
4. **Audit**: CTAN zip must contain `.dtx`, `.ins`, `README.md`, `.pdf` (docs), and Flattened example files. NO `.cls`/`.def` binaries.

