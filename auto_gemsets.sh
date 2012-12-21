function create_gemset_if_missing() {
  if [ ! -d "${GEMSET_ROOT}/${GEMSET}" ]; then
    mkdir -p "${GEMSET_ROOT}/${GEMSET}" && echo "${GEMSET} created. run gem install bundler"
  fi
}

function auto_gemsets() {
  local dir="$PWD"
  local version_file

  until [[ -z "$dir" ]]; do
    gemfile="$dir/Gemfile"
    IFS='/' read -a gemfile_path_parts <<< "$gemfile"
    gemset="${gemfile_path_parts[${#gemfile_path_parts[@]}-2]}"

    if   [[ "${GEM_PATH//:$DEFAULT_GEMSET}" == "${GEMSET_ROOT}/$gemset" ]]; then return
    elif [[ -f "$gemfile" ]]; then
      export GEM_HOME="${GEMSET_ROOT}/$gemset"
      export GEM_ROOT="${GEMSET_ROOT}/$gemset" # chruby specific
      export GEM_PATH="${GEM_HOME}:${DEFAULT_GEMSET}"
      export GEMSET="${gemset}"
      export GEMFILE="${gemfile}"
      create_gemset_if_missing && list_gemset
      break
    elif [[ ! -f "$gemfile" ]]; then
      set_default_gemset
    fi

    dir="${dir%/*}"
  done
}

function set_default_gemset() {
  if [ ! -z "${DEFAULT_GEMSET}" ]; then
    if [ ! "$GEM_PATH" == "${DEFAULT_GEMSET}" ]; then
      export GEM_HOME="${DEFAULT_GEMSET}"
      export GEM_ROOT="${DEFAULT_GEMSET}"
      export GEM_PATH="${DEFAULT_GEMSET}"
      export GEMSET="daytonn*"
      export GEMFILE="*default"
      if [ -z "$GEMSET_PRELOAD" ]; then
        list_gemset
      fi
    fi
  fi
}

function list_gemset() {
  echo "Now using ${GEMSET} gemset via ${GEMFILE}"
}

if [ ! -n "$GEMSET_ROOT" ]; then
  export GEMSET_ROOT="${HOME}/.gemsets"
fi

if [[ -n "$ZSH_VERSION" ]]; then
  precmd_functions+=("auto_gemsets")
else
  if [[ -n "$PROMPT_COMMAND" ]]; then
    if [[ ! "$PROMPT_COMMAND" == *auto_gemsets* ]]; then
      PROMPT_COMMAND="$PROMPT_COMMAND; auto_gemsets"
    fi
  else
    PROMPT_COMMAND="auto_gemsets"
  fi
fi

function init() {
  # Set default on load
  GEMSET_PRELOAD="true"
  set_default_gemset
  unset GEMSET_PRELOAD
}

init