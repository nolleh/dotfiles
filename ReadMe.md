# user set

## Linux

```bash
sudo useradd -m nolleh
```

## Mac

```bash
sudo sysadminctl -addUser nolleh
```

actually, it adds mac's user.
not only terminal, but also mac user...
it actually not I want to, but had no choice, as far I know

# shell set

## install zsh

### Linux

```bash
apk add zsh
# for chsh
apk add shadow
chsh -s $(which zsh)
apk add zsh-vcs
```

### Mac

```bash
chsh -s $(which zsh)
```

if you have password trouble in chsh, modify

`etc/pam.d/chsh`

```bash
auth sufficient pam_shells.so
```

## install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

apply agnoster

```bash
ZSH_THEME="agnoster"
```

modify as below to change color for current dir.

`~/.oh-my-zsh/themes/agnoster.zsh-theme`

```bash
prompt_dir() {
	prompt_segment 39d $CURRENT_FG '%~'
}
```

## install powerline font

```bash
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

or

```bash
./font.sh
```

## nerd font
https://www.nerdfonts.com/font-downloads

or 

curl -fLo "<FONT NAME> Nerd Font Complete.otf" \
https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/<FONT_PATH>/complete/<FONT_NAME>%20Nerd%20Font%20Complete.otf

and 

unzip to ~/.fonts

```bash
unzip <font> -d ~/.fonts
```

fc-cache -fv

## syntax highlighting in command line

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

## auto suggestions in command line

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git
echo "source ${(q-)PWD}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

## Trouble Shoots

uncomment in .zshrc, if you have broken charactor issue.

```bash
export LANG=en_US.UTF-8
```

## tmux

[tmux](includes/tmux.md)


## NvChad

```zsh
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
```
