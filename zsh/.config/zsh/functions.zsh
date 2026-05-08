# Java version switcher
function use-java8() {
    export JAVA_HOME="$JAVA8_HOME"
    export PATH="$JAVA_HOME/bin:$(echo $PATH | tr ':' '\n' | grep -v '/jdk' | tr '\n' ':')"
    java -version
}

function use-java17() {
    export JAVA_HOME="$JAVA17_HOME"
    export PATH="$JAVA_HOME/bin:$(echo $PATH | tr ':' '\n' | grep -v '/jdk' | tr '\n' ':')"
    java -version
}

# Thrift version switcher
function use-thrift2() {
    export PATH="$THRIFT2_HOME/bin:$(echo $PATH | tr ':' '\n' | grep -v '/thrift' | tr '\n' ':')"
    thrift --version
}

function use-thrift3() {
    export PATH="$THRIFT3_HOME/bin:$(echo $PATH | tr ':' '\n' | grep -v '/thrift' | tr '\n' ':')"
    thrift --version
}


# Yazi shell wrapper (cd on exit)
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Zoxide fuzzy search
function zx() {
    local query="${*}"
    local dir
    dir=$(zoxide query --list --score | \
        fzf --filter="$query" --no-sort | \
        fzf \
            --prompt="zoxide > " \
            --nth=2.. \
            --ansi \
            --height=60% \
            --info=inline \
            --border=rounded \
            --layout=reverse \
            --preview-window=down:40%:wrap \
            --preview='ls -F -C -G {2..}' \
            --bind 'ctrl-z:ignore,btab:up,tab:down,enter:become:echo {2..}' \
            --cycle \
            --keep-right \
            --tabstop=1
    )
    [[ -n "$dir" ]] && cd "$dir"
}
