if status is-interactive
    fish_config theme choose "Dracula Official"
	# Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "/home/r11/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
