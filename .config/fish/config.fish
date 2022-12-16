source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)


set -gx PATH $HOME/.local/bin/ $HOME/.pyenv/bin/ $HOME/.luarocks/bin/ $HOME/.fzf/bin/ $HOME/.yarn/bin $PATH

if test -e /snap/bin/microk8s
  alias kubectl="microk8s kubectl"
  alias k="kubectl"
  kubectl completion fish | source
  complete -c k -w kubectl
end