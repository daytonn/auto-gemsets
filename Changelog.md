#Changelog

## Version 0.3.0
  - No longer setting the auto_gemsets.sh file as executable
  - Change `default-gemsets` to `default-gems`

## Version 0.2.1
  - add `init` command

## Version 0.2.0
  - init command to copy script to /usr/local/share/auto_gemsets
  - utility to install gems in the default gemset from anywhere
  - utility to remove gems from the default gemset from anywhere

## Version 0.1.7
  - Fixed a bug where calling gemset with -v would error
  - Set appropriate gem bin directories in PATH
  - Namespace functions to avoid collisions

## Version 0.1.6
 - Fix bug where bin directories were duplicated in PATH

## Verson 0.1.5
  - Add GEM bin directories to PATH
  - Show default instead of default gemset path

## Version 0.1.4
  - Change HELP file from plain text to Markdown

## Version 0.1.3
  - Refactor auto_gemset.sh script
  - Set gemset on initilization

## Version 0.1.2
  - Refactor from chruby script proof of concept to auto_gemset script
  - Format `gemset list` output
  - Add `edit` command

## Version 0.1.0
  - First release
  - Gemified version of a chruby script