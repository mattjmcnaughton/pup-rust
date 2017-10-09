#!/bin/bash

set -e

test::check_syntax() {
  ansible-playbook playbook.yml -i 'localhost' -e '{"dotfile": "~/.bashrc"}' --syntax-check
}

test::run_ansible() {
  ansible-playbook playbook.yml -i 'localhost' -e '{"dotfile": "~/.bashrc"}'
}

test::assert_output() {
  . ~/.bashrc

  for program_file in rustc cargo; do
    if ! which $program_file >/dev/null; then
      echo "$program_file is not installed"
      exit 1
    fi
  done

  if ! echo $PATH | grep -q "$HOME/.cargo/bin"; then
    echo "$HOME/.cargo/bin not found in $PATH"
    exit 1
  fi

  # Assert when we source ~/.bashrc again, we only write $GOPATH/bin to $PATH
  # once
  . ~/.bashrc

  if [ ":$PATH:" == *":$HOME/.cargo/bin:*:$HOME/.cargo/bin:"* ]; then
    echo "~/.cargo/bin written to $PATH to often"
    exit 1
  fi
}

test::check_syntax
test::run_ansible
test::assert_output
