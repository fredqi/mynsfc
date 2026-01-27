# mynsfc - NSFC Proposal LaTeX Class

## Project Overview
This is a **LaTeX package development project** using the documented source (.dtx) format. The package provides a XeLaTeX document class (`mynsfc.cls`) for writing NSFC (National Natural Science Foundation of China) grant proposals with specific formatting requirements.

**Architecture**: Single `.dtx` file contains documentation, class implementation, and example content. The docstrip system extracts separate files during build.

## Build System & Critical Workflows

### Building the Package
```bash
make                    # Build mynsfc.pdf documentation and examples
make clean             # Remove temporary build artifacts  
make distclean         # Full clean including PDFs and generated .cls/.def/.ins
make zip               # Create CTAN-ready package (mynsfc-VERSION.zip)
```

**Key Build Steps** (see [Makefile](Makefile)):
1. `tex mynsfc.dtx` extracts `.cls`, `.def`, `.ins`, and example files
2. `xelatex $(LATEXFLAGS)` compiles documentation (LATEXFLAGS = `-shell-escape -recorder -interaction=batchmode`)
3. `biber` for bibliography processing
4. `makeindex` for glossary/index generation if `.glo`/`.idx` exist
5. Multiple `xelatex` passes for cross-references

**Generated Files from `.dtx`**:
- `mynsfc.cls` - The document class
- `mynsfc.def` - Customizable string definitions (Part/Section titles)
- `mynsfc.ins` - Installation script
- `examples/my-proposal.tex` - Example document
- `examples/my-proposal.bib` - Example bibliography

### Installation
```bash
make inst              # Install to user's TeX tree (TEXMFHOME)
make install           # Install to system TeX tree (requires sudo)
```

**TDS Structure**: Installation follows TeX Directory Structure:
- `tex/latex/mynsfc/` - Runtime files (.cls, .def)
- `source/latex/mynsfc/` - Source files (.dtx, .ins)
- `doc/latex/mynsfc/` - Documentation (.pdf, examples)

### CTAN Packaging
```bash
make zip               # Creates mynsfc-VERSION.zip with TDS archive
```
The zip file contains both a flat directory and `mynsfc.tds.zip` for direct installation.

## LaTeX .dtx Development Patterns

### File Structure Guards
The `.dtx` uses conditional guards to multiplex content:
- `%<*class>` ... `%</class>` - Class implementation code
- `%<*definitions>` ... `%</definitions>` - Customizable strings (mynsfc.def)
- `%<*driver>` ... `%</driver>` - Documentation driver
- `%<*example>` ... `%</example>` - Example proposal document
- `%<*examplebib>` ... `%</examplebib>` - Example bibliography
- `%<*install>` ... `%</install>` - Installation batch file

**When editing**: Always maintain guards. Code outside guards won't be extracted.

### Documentation Format
- Uses `\changes{version}{date}{description}` for changelog entries
- Documentation sections use standard LaTeX syntax between guards
- Macro definitions documented with `\begin{macro}` ... `\end{macro}` environments
- Version info in `\ProvidesFile` and `\ProvidesClass` commands (used by `ltxfileinfo`)

### Makefile Conventions
- Uses GNU Make functions (`addprefix`, `define`/`endef` macros) for DRY code
- `LATEXFLAGS` variable centralizes compiler options
- Parent Makefile exports variables to sub-makes via `export`
- Avoid Bash-specific syntax (e.g., `{a,b,c}` brace expansion) for portability
- Use `$(RM)` instead of `rm -f` for cross-platform compatibility

## Package-Specific Conventions

### XeLaTeX Requirement
**Critical**: This package requires XeLaTeX (not pdfLaTeX). Uses CJK fonts and CTex framework for Chinese typesetting.
- Main class loads: `\LoadClass[a4paper,UTF8,fontset=none,zihao=-4]{ctexart}`
- Font setup: SimSun/SimHei/KaiTi/FangSong with `AutoFakeBold` for missing bold variants

### Magic Commands (v2.00+)
The package provides automatic section generation commands:
- `\nsfcpart` - Auto-generates Part title from `mynsfc.def` definitions
- `\nsfcsection` - Auto-generates Section title within current Part
- Titles are stored with Roman numeral keys: `\mynsfc@part@I@title`, `\mynsfc@section@III@II@title`, etc.

### Bibliography System
Uses `biblatex` with special author highlighting features:
- Supports highlighting specific authors in bold (e.g., proposal author)
- Supports corresponding author markers with `author+an` annotations
- Uses `\newrefsegment` for multiple reference sections in same document

**Example biblatex configuration pattern**:
```latex
author+an = {2=self;2:family=corr}  % Mark 2nd author as self and corresponding
```

### Document Structure Specifics
- **Custom `\part` macro**: Takes two arguments `\part{title}{subtitle}`
- **Part numbering**: Chinese numerals with parentheses format "（一）"
- **Section reset**: Sections restart numbering at each `\part`
- **Color theming**: HTML hex color codes via `toccolor` option
- **Empty subtitle handling**: Uses `\protected@edef` expansion to detect empty subtitles

## Example Usage Pattern

See [examples/my-proposal.tex](examples/my-proposal.tex):
```latex
\documentclass{mynsfc}
\addbibresource{my-proposal.bib}
\begin{document}
\maketitle
\nsfcpart\label{part:background}      % （一）立项依据
\nsfcpart\label{part:research}        % （二）研究内容
\nsfcpart\label{part:foundations}     % （三）研究基础
\nsfcsection\label{sec:feasibility}   % 1. 研究基础与可行性分析
\nsfcsection\label{sec:conditions}    % 2. 工作条件
% ...
\end{document}
```

## Dependencies & Requirements

**TeX Packages Used**:
- `ctexart` (base class) - CTeX framework for Chinese
- `kvoptions` - Key-value option processing  
- `biblatex` with `biber` backend and IEEE style
- `geometry` - Page margins
- `caption`, `subcaption` - Figure/table captions
- `metalogo` - For `\XeLaTeX`, `\LuaLaTeX` logos
- `hyperref` - PDF hyperlinks

**System Requirements**:
- XeLaTeX compiler (TeX Live 2020+)
- Biber (not BibTeX)
- SimSun/SimHei/KaiTi/FangSong fonts (or use `fontset=fandol` for Fandol fonts)

## Critical Files

- [mynsfc.dtx](mynsfc.dtx) - Single source of truth for everything
- [Makefile](Makefile) - Build orchestration (reads version from .dtx via `ltxfileinfo`)
- [examples/](examples/) - Working proposal template demonstrating all features

## Testing Changes

After modifying `.dtx`:
1. `make distclean` to ensure clean build
2. `make` to regenerate all files and test documentation build
3. `make -C examples` to verify example compiles correctly
4. Check both PDF outputs for formatting correctness
5. `make zip` to verify CTAN package structure

## Common Issues & Solutions

### Font Warnings
- "Font shape undefined" warnings for bold KaiTi are expected (uses medium weight fallback)
- Use `\textmd{\heiti ...}` to get non-bold Heiti in bold contexts

### Shell Compatibility
- Makefile uses `SHELL = bash` but avoids Bash-specific syntax where possible
- Brace expansion `{a,b,c}` works only because `SHELL = bash` is set
- For maximum portability, explicit file lists are preferred
