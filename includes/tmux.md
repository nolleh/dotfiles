# env

## install

```
brew install tmux
```

```
sudo apt-get install tmux
```

## run

```
tmux
```

## apply config

looks like if .conf file is not located in home directory, 
it not applied to after reboot.
so put it home dir.

```
tmux source-file ~/.tmux.conf
```

## tpm

tmux plugin manager.
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

in tmux.conf
```bash
run '~/.tmux/plugins/tpm/tpm'
```

# ShortCut

## Session

create session with number

```
tmux
```

create session with name

```
tmux new -s <session-name>
```

change session name - `[Ctrl] + b, $`

detach from session - `[Ctrl] + b, d`

attach to session - `tmux attach -t {number or name}`

list tmux sessions

```
tmux ls
```

kill tmux session

```
tmux kill-session -t {name}
```

## window

create window - `[Ctrl] + b, c`

terminate window - `[Ctrl] + b, &`, `[Ctrl] + d`

list window - `[Ctrl] + b, w`

## pane

create vertical pane - `[Ctrl] + b, %`

create horizontal pane - `[Ctrl] + b, "`

move pane with pane number - `[Ctrl] + b, q`

move pane with arrow key - `[Ctrl] + b, <arrow key>`

terminate pane - `[Ctrl] + d`, `[Ctrl] + b, x`

pane zoom - `[Ctrl] +b, z`

change pane layout - `[Ctrl] + b, spacebar`
