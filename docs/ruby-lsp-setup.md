# Ruby LSP + Sorbet Setup

Both LSPs run from a separate Ruby environment so the project's own Gemfile is untouched.

## 1. Create the LSP Environment

```bash
cd ~/path/to/<ruby-project>
mkdir -p .vscode/ruby-lsp-env
cd .vscode/ruby-lsp-env
```

Create `.tool-versions`:
```
ruby 3.2.2
```

Create `Gemfile`:
```ruby
source "https://rubygems.org"

gem "ruby-lsp"
gem "debug"
gem "rubocop", ">= 1.4.0"
gem "rubocop-performance"
gem "rubocop-rails"
gem "sorbet"
gem "sorbet-runtime"
```

Install Ruby and gems:

```bash
# asdf
asdf install ruby 3.2.2
bundle install

# mise
mise use ruby@3.2.2
bundle install

# rbenv
rbenv install 3.2.2
rbenv local 3.2.2
bundle install
```

## 2. RuboCop Config

If your project's `.rubocop.yml` uses deprecated cop names or the old `require:` syntax, ruby-lsp will error. Create a corrected copy at `.vscode/ruby-lsp-env/.rubocop.yml` with the fixes applied. The nvim config passes `RUBOCOP_OPTS` to point ruby-lsp at this copy instead of the project root's config.

## 3. Sorbet Config

```bash
cd ~/path/to/<ruby-project>
mkdir -p sorbet/rbi
```

Create `sorbet/config`:
```
--dir
.
--ignore=/vendor/
--ignore=/tmp/
--ignore=/log/
--ignore=/node_modules/
```

Sorbet is launched with `--typed true` via the nvim config so it provides method-level navigation without needing `# typed:` sigils in files.

## 4. RBI Stubs for Gem Parent Classes

Without stubs, Sorbet can't resolve classes that inherit from gems (ActiveRecord::Base, etc.). Create `sorbet/rbi/missing_classes.rbi` with stub declarations:

```ruby
module ActiveRecord
  class Base; end
end

module Draper
  class Decorator; end
end
# ... etc
```

To find which classes need stubs:
```bash
grep -rh "^class .* < " app/ lib/ | sed 's/.*< //' | sort -u
```

Exclude any that are already defined in the project itself.

## How the LSPs Work Together

| Keybind | Primary | Fallback | Notes |
|---------|---------|----------|-------|
| `grd` | Sorbet (methods) | ctags (classes/modules) | ctags via vim-gutentags |
| `grr` | Sorbet (methods) | ripgrep (full qualified name) | via fzf-lua |

- **ruby-lsp** — rubocop diagnostics, formatting, completion
- **Sorbet** — method-level go-to-definition and find-references
- **vim-gutentags** — class/module go-to-definition (ctags fallback)
