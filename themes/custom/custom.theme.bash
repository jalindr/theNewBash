#!/usr/bin/env bash

green="\033[1;32m"

# ----------------------------------------------------------------- COLOR CONF
D_DEFAULT_COLOR="${normal}"
D_INTERMEDIATE_COLOR="${white}"
D_USER_COLOR="${purple}"
D_SUPERUSER_COLOR="${red}"
D_MACHINE_COLOR="${cyan}"
D_DIR_COLOR="${green}"
D_SCM_COLOR="${yellow}"
D_BRANCH_COLOR="${yellow}"
D_CHANGES_COLOR="${white}"
D_CMDFAIL_COLOR="${red}"
D_VIMSHELL_COLOR="${cyan}"

# ------------------------------------------------------------------ FUNCTIONS
case $TERM in
  xterm*)
      TITLEBAR="\033]0;\w\007"
      ;;
  *)
      TITLEBAR=""
      ;;
esac

is_vim_shell() {
  if [ ! -z "$VIMRUNTIME" ];
  then
    echo "${D_INTERMEDIATE_COLOR}on ${D_VIMSHELL_COLOR}\
vim shell${D_DEFAULT_COLOR} "
  fi
}

mitsuhikos_lastcommandfailed() {
  code=$?
  if [ $code != 0 ];
  then
    echo "${D_INTERMEDIATE_COLOR}exited ${D_CMDFAIL_COLOR}\
$code ${D_DEFAULT_COLOR}"
  fi
}

# vcprompt for scm instead of bash_it default
demula_vcprompt() {
  if [ ! -z "$VCPROMPT_EXECUTABLE" ];
  then
    local D_VCPROMPT_FORMAT="on ${D_SCM_COLOR}%s${D_INTERMEDIATE_COLOR}:\
${D_BRANCH_COLOR}%b %r ${D_CHANGES_COLOR}%m%u ${D_DEFAULT_COLOR}"
    $VCPROMPT_EXECUTABLE -f "$D_VCPROMPT_FORMAT"
  fi
}

# -------------------------------------------------------------- PROMPT OUTPUT
prompt() {
  local SAVE_CURSOR='\033[s'
  local RESTORE_CURSOR='\033[u'
  local MOVE_CURSOR_RIGHTMOST='\033[500C'
  local MOVE_CURSOR_5_LEFT='\033[5D'


  # this is for the fancy terminal.... change the first » to $(battery_charge) display battery status

    PS1="${TITLEBAR}
${SAVE_CURSOR}${MOVE_CURSOR_RIGHTMOST}${MOVE_CURSOR_5_LEFT}\
${D_DIR_COLOR}» ${RESTORE_CURSOR}\
${D_USER_COLOR}\u ${D_INTERMEDIATE_COLOR}\
» ${D_MACHINE_COLOR}\h ${D_INTERMEDIATE_COLOR}\
: ${D_DIR_COLOR}\w ${D_INTERMEDIATE_COLOR}\
$(mitsuhikos_lastcommandfailed)\
$(demula_vcprompt)\
$(is_vim_shell)
${D_INTERMEDIATE_COLOR}$ ${D_DEFAULT_COLOR}"

  PS2="${D_INTERMEDIATE_COLOR}$ ${D_DEFAULT_COLOR}"
}

# Runs prompt (this bypasses bash_it $PROMPT setting)
PROMPT_COMMAND=prompt

