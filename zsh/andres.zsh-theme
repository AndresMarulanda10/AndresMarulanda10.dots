# ─── Gruvbox palette ──────────────────────────────────────────────────────────
# #fb4934 red   | #fe8019 orange | #fabd2f yellow
# #b8bb26 green | #8ec07c aqua   | #83a598 blue | #d3869b purple
# #282828 bg    | #ebdbb2 fg

MODE_INDICATOR="%F{#fb4934}❮❮❮%f"
local return_status="%F{#fb4934}%(?..⏎)%f "

# ─── Text styles ──────────────────────────────────────────────────────────────
ITALIC_ON=$'\e[3m'
ITALIC_OFF=$'\e[23m'

# ─── Git prompt ───────────────────────────────────────────────────────────────
ZSH_THEME_GIT_PROMPT_PREFIX=" %B${ITALIC_ON}%F{#83a598}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f${ITALIC_OFF}%b"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#fb4934} ⚡%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{#fe8019} !%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#b8bb26} ✓%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{#b8bb26} ✚%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{#8ec07c} ✹%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{#fb4934} ✖%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{#d3869b} ➜%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{#fabd2f} ═%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{#fe8019} ✭%f"

# ─── Runtime version detection ────────────────────────────────────────────────
function runtime_info() {
    # Angular (tiene precedencia sobre Node)
    if [[ -f "angular.json" ]]; then
        local version=$(node -e "const p=require('./package.json');const v=p.dependencies?.['@angular/core']||p.devDependencies?.['@angular/core']||'?';console.log(v.replace(/[\^~]/,''))" 2>/dev/null)
        echo " %F{#ebdbb2}❄%f %B%F{#fb4934}Ⓐ ${version}%f%b %F{#d3869b}·%f"
        return
    fi

    # Node
    if [[ -f "package.json" ]]; then
        local version=$(node --version 2>/dev/null)
        echo " %F{#ebdbb2}❄%f %B%F{#b8bb26}⬡ ${version}%f%b %F{#d3869b}·%f"
        return
    fi

    # Java (Maven o Gradle)
    if [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        local version=$(java -version 2>&1 | head -1 | sed 's/.*version "\(.*\)".*/\1/')
        echo " %F{#ebdbb2}❄%f %B%F{#fabd2f}☕ ${version}%f%b %F{#d3869b}·%f"
        return
    fi
}

# ─── Git time since commit ────────────────────────────────────────────────────
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%F{#b8bb26}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%F{#fabd2f}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%F{#fb4934}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%F{#83a598}"

function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            last_commit=$(git log --pretty=format:'%at' -1 2>/dev/null)
            now=$(date +%s)
            seconds_since_last_commit=$((now - last_commit))
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit / 3600))
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))
            if [[ -n $(git status -s 2>/dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi
            if [ "$HOURS" -gt 24 ]; then
                echo "[$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%f]"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "[$COLOR${HOURS}h${SUB_MINUTES}m%f]"
            else
                echo "[$COLOR${MINUTES}m%f]"
            fi
        else
            echo "[%F{#83a598}~%f]"
        fi
    fi
}

# ─── Prompt ───────────────────────────────────────────────────────────────────
# precmd vacío evita que zsh imprima el número de línea antes del prompt multilinea
precmd() { print -n "" }

PROMPT_USER_LABEL="andresmarulanda"

PROMPT=$'\n%B%F{#fabd2f}'"${PROMPT_USER_LABEL}"$'%f%b %{\e[3m%}%F{#fe8019}%(5~|%-1~/\u2026/%3~|%4~)%f%{\e[23m%}$(runtime_info)$(git_prompt_info)\n%F{#fb4934}\u276f%f '

RPROMPT='${return_status}$(git_time_since_commit)$(git_prompt_status)%f'
