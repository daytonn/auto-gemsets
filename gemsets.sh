function create_or_switch_gemset() {
  if [ ! -d "${GEMSET_PATH}" ]; then
    mkdir -p "${GEMSET_PATH}"
  fi

  switch_gemset
}

function switch_gemset() {
  export GEM_PATH="${GEMSET_PATH}"
  export GEM_HOME="${GEMSET_PATH}"
  export GEM_ROOT="${GEMSET_PATH}"
  echo "Now using ${GEMSET} gemset via ${GEMFILE}"
  break
}

function chruby_gemset() {
  local dir="$PWD"
  local version_file

  until [[ -z "$dir" ]]; do
    gemfile="$dir/Gemfile"
    IFS='/' read -a gemfile_path_parts <<< "$gemfile"

    gemset="${gemfile_path_parts[${#gemfile_path_parts[@]}-2]}"

    if   [[ "${GEMSET_ROOT}/$gemset" == "$GEMSET_PATH" ]]; then return
    elif [[ -f "$gemfile" ]]; then
      export GEMSET_PATH="${GEMSET_ROOT}/$gemset"
      export GEMSET="${gemset}"
      export GEMFILE="${gemfile}"
      create_or_switch_gemset
    fi

    dir="${dir%/*}"
  done
}

function gemplode() {

  if [ ! -z "$1" ]; then
    echo "${GEMSET_ROOT}/${1}"
    if [ -d "${GEMSET_ROOT}/${1}" ]; then
      echo "Are you sure you want to delete the ${1} gemset? y/n"
      read response

      if [ "$response" == "y" ]; then
        rm -Rf ${GEMSET_ROOT}/${1}
        chruby_reset
      else
        echo "No gemset removed"
      fi
    else
      echo "No gemset named ${1}"
    fi

  else
    echo "Usage:"
    echo "gemplode (gemset)"
  fi
}

function gemset() {
  if [ -z "$1" ]; then
    echo "${GEMSET}"
  else
    case "$1" in
      "destroy" )
        if [ ! -z "$2" ]; then
          gemplode $2
        else
          echo "Usage:"
          echo "gemset destroy (gemset)"
        fi
      ;;
      "list" )
        ls -l "${GEMSET_ROOT}"
      ;;
    esac
  fi
}

if [ ! -n "$GEMSET_ROOT" ]; then
  export GEMSET_ROOT="${HOME}/.gemsets"
fi

if [[ -n "$ZSH_VERSION" ]]; then
  precmd_functions+=("chruby_gemset")
else
  if [[ -n "$PROMPT_COMMAND" ]]; then
    if [[ ! "$PROMPT_COMMAND" == *chruby_gemset* ]]; then
      PROMPT_COMMAND="$PROMPT_COMMAND; chruby_gemset"
    fi
  else
    PROMPT_COMMAND="chruby_gemset"
  fi
fi