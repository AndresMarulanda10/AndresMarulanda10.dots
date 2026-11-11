#!/usr/bin/env bash
# Source only inert helpers/menu declarations; never execute the installer.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import pathlib
import subprocess
import tempfile

root = pathlib.Path.cwd()
source = (root / 'install.sh').read_text()
helpers = source[source.index('copy_config() {'):source.index('write_gitconfig_local() {')]
selection = source[source.index('should_run() {'):source.index('# ─── Header')]
menu = source[source.index('COMMON_OPTS=('):source.index('CHOICES=$(gum choose')]

def run(script):
    import re
    script = re.sub(r'^! (.+)$', r'if \1; then exit 1; fi', script, flags=re.M)
    subprocess.run(['bash', '-euo', 'pipefail', '-c', script], check=True)

for platform in ('MAC', 'LINUX', 'CODESPACES'):
    flags = '\n'.join(f'IS_{p}={str(p == platform).lower()}'
                      for p in ('MAC', 'LINUX', 'CODESPACES'))
    checks = '''
CHOICES='Todo — instalar todo'
should_run zsh
should_run git
! should_run 'VS Code'
! should_run nonexistent
'''
    if platform == 'CODESPACES':
        checks += '! should_run Brewfile\n! should_run ghostty\n! should_run aerospace\n'
    else:
        checks += 'should_run Brewfile\nshould_run Neovim\n'
        checks += 'should_run aerospace\n' if platform == 'MAC' else '! should_run aerospace\n'
    checks += '''
CHOICES='lazygit — config'
should_run lazygit
! should_run git
CHOICES='git — .gitconfig'
should_run git
! should_run zsh
'''
    run(flags + '\n' + selection + menu + checks)

brewfile = (root / 'Brewfile').read_text()
assert 'brew "anomalyco/tap/opencode-v2"' in brewfile
assert 'brew "mpv"' in brewfile and 'cask "moonlight"' in brewfile
assert not any(x in brewfile for x in ('realvnc', 'visual-studio-code', 'orca'))
run('''ruby - <<'RUBY'
def tap(*); end
def brew(*); end
def cask(*); abort 'Linux must not load casks'; end
module OS; def self.mac?; false; end; end
load 'Brewfile'
RUBY
''')
assert 'exit 1' in source[source.index('err "brew bundle falló'):source.index('# ─── zsh')]
bundle = source[source.index('if should_run "Brewfile"; then'):source.index('# ─── zsh')]
failed = subprocess.run(['bash', '-c',
    'should_run() { return 0; }; title() { :; }; gum() { return 1; }; '
    'err() { :; }; DOTFILES_DIR=unused; IS_LINUX=false;\n' + bundle
    + '\necho misleading-completion'], capture_output=True, text=True)
assert failed.returncode == 1 and 'misleading-completion' not in failed.stdout
assert 'editor     = nvim' in (root / 'git/.gitconfig').read_text()
assert 'tool = vscode' not in (root / 'git/.gitconfig').read_text()
assert 'export EDITOR="nvim"' in (root / 'zsh/.zshrc').read_text()
assert 'export VISUAL="nvim"' in (root / 'zsh/.zshrc').read_text()

if 'OpenCode theme' in source:
    theme = source[source.index('if should_run "OpenCode theme"; then'):]
    theme = theme[:theme.index('\nfi') + 3]
    with tempfile.TemporaryDirectory() as home:
        config = pathlib.Path(home) / '.config/opencode'
        config.mkdir(parents=True)
        for name in ('cli.json', 'opencode.json'):
            (config / name).write_text('private sentinel')
        run(f'HOME="{home}"\nDOTFILES_DIR="{root}"\n'
            'ok() { :; }; warn() { :; }; err() { return 1; }; title() { :; }\n'
            + helpers + 'should_run() { return 0; }\n' + theme)
        assert (config / 'themes/dracula-terminal.json').read_bytes() == (
            root / 'opencode/themes/dracula-terminal.json').read_bytes()
        assert sorted(p.name for p in config.iterdir()) == ['cli.json', 'opencode.json', 'themes']
        for name in ('cli.json', 'opencode.json'):
            assert (config / name).read_text() == 'private sentinel'
print('bootstrap contract: PASS')
PY
