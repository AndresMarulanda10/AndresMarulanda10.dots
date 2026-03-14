# ─── Monokai Pro palette ──────────────────────────────────────────────────────
# #FF6188 pink  | #FC9867 orange | #FFD866 yellow
# #A9DC76 green | #78DCE8 cyan   | #AB9DF2 purple
# #272822 bg    | #FCFCFA fg

MODE_INDICATOR="%F{#FF6188}❮❮❮%f"
local return_status="%F{#FF6188}%(?..⏎)%f "

# ─── Text styles ──────────────────────────────────────────────────────────────
ITALIC_ON=$'\e[3m'
ITALIC_OFF=$'\e[23m'

# ─── Git prompt ───────────────────────────────────────────────────────────────
ZSH_THEME_GIT_PROMPT_PREFIX=" %B${ITALIC_ON}%F{#78DCE8}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f${ITALIC_OFF}%b"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#FF6188} ⚡%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{#FC9867} !%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#A9DC76} ✓%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{#A9DC76} ✚%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{#78DCE8} ✹%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{#FF6188} ✖%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{#AB9DF2} ➜%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{#FFD866} ═%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{#FC9867} ✭%f"

# ─── Runtime version detection ────────────────────────────────────────────────
function runtime_info() {
    # Angular (tiene precedencia sobre Node)
    if [[ -f "angular.json" ]]; then
        local version=$(node -e "const p=require('./package.json');const v=p.dependencies?.['@angular/core']||p.devDependencies?.['@angular/core']||'?';console.log(v.replace(/[\^~]/,''))" 2>/dev/null)
        echo " %F{#FCFCFA}❄%f %B%F{#FF6188}Ⓐ ${version}%f%b %F{#AB9DF2}·%f"
        return
    fi

    # Node
    if [[ -f "package.json" ]]; then
        local version=$(node --version 2>/dev/null)
        echo " %F{#FCFCFA}❄%f %B%F{#A9DC76}⬡ ${version}%f%b %F{#AB9DF2}·%f"
        return
    fi

    # Java (Maven o Gradle)
    if [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        local version=$(java -version 2>&1 | head -1 | sed 's/.*version "\(.*\)".*/\1/')
        echo " %F{#FCFCFA}❄%f %B%F{#FFD866}☕ ${version}%f%b %F{#AB9DF2}·%f"
        return
    fi
}

# ─── Git time since commit ────────────────────────────────────────────────────
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%F{#A9DC76}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%F{#FFD866}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%F{#FF6188}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%F{#78DCE8}"

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
            echo "[%F{#78DCE8}~%f]"
        fi
    fi
}

# ─── Prompt ───────────────────────────────────────────────────────────────────
PROMPT='
%B%F{#FFD866}AndresMarulanda10%f%b ${ITALIC_ON}%F{#FC9867}%(5~|%-1~/…/%3~|%4~)%f${ITALIC_OFF}$(runtime_info)$(git_prompt_info)
%F{#FF6188}❯%f '

RPROMPT='${return_status}$(git_time_since_commit)$(git_prompt_status)%f'
