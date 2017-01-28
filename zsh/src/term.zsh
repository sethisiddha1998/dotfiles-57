#  Title
#-----------------------------------------------
title() {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # try to use terminfo to set the title
        # if the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

title_precmd() {
  emulate -L zsh

  title '%~' '%n@%m: %~'
}
title_preexec() {
  emulate -L zsh
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local cmd=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  local line="${2:gs/%/%%}"

  title '$cmd' '%100>...>$line%<<'
}

add-zsh-hook precmd title_precmd
add-zsh-hook preexec title_preexec


#  Nortify done
#-----------------------------------------------
local notify_prev_command=""
local notify_prev_executed_at=""

notify_preexec() {
  notify_prev_command="$2"
  notify_prev_executed_at="$(date +'%Y/%m/%d %H:%M:%S')"
}

notify_precmd() {
  local code=$?

  [ $TTYIDLE -gt 30 ] || return
  [ $code -ne 130 ] && [ $code -ne 146 ] || return
  command -v 'envchain' > /dev/null 2>&1 || return

  ruby -r json -e '
    begin
      command, status, executed_at, elapsed_time = ARGV
      success = status.to_i.zero?

      {
        text: (success ? ":white_check_mark: Command finished: %s" : ":warning: Command failed: %s") % [command],
        attachments: [
          {
            color: success ? "good" : "danger",
            mrkdwn_in: ["fields"],
            fields: [
              {
                title: "directory",
                value: "`%s`" % [ENV["PWD"]],
                short: false
              },
              {
                title: "hostname",
                value: `hostname`,
                short: true
              },
              {
                title: "user",
                value: ENV["USER"],
                short: true
              },
              {
                title: "executed at",
                value: executed_at,
                short: true
              },
              {
                title: "elapsed time",
                value: "%d seconds" % [elapsed_time.to_i],
                short: true
              }
            ]
          }
        ]
      }.tap { |payload| puts payload.to_json }
    end
  ' \
  "$notify_prev_command" "$code" "$notify_prev_executed_at" "$TTYIDLE" \
    | ( envchain crst slack-notifier & disown ) >/dev/null 2>&1 3>&1
}

add-zsh-hook precmd notify_precmd
add-zsh-hook preexec notify_preexec
