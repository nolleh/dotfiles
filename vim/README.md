# 1.VIM INITIAL ENVIRONMENT

## vimrc

1. put .vimrc files to home dir, `~`
2. put to colors(jellybeans.vim) to `~/.vim/`

# 2.APPENDIX

## 2-1. ShortCut

easy to forget shortcut's list.

### Split

#### basic

```bash
:vsp {file-name}
```

includes specifying file name,

```bash
:10sp ~/.zshrc
```

```bash
:sp
```

interchange position splited window

```bash
Ctrl + w + r
```

rotate split window

- to vertical

```bash
Ctrl + w + H
```

- to horizontal

```bash
Ctrl + w + J
```

#### focusing

Ctrl + w + {direction}

the {direction} is, one of `h,j,k,l`

#### Resizing

- vertical split size
  Ctrl + w + > (bigger)
  Ctrl + w + < (smaller)

```bash
:vertical resize {N}
```

- horizontal split size

'Ctrl' + 'w' + '+' (bigger)
'Ctrl' + 'w' + '-' (smaller)

```bash
:resize {N}
```

### Mode

- getting in to explorer mode

```bash
:Sexplore
```

```bash
:Vexplore
```

### File Manage

- create directory
  in file explore mode, 'd' for directory, '%' for file.

-

### Viewer

- font size
  'cmd' + '+' or 'cmd' + 'shift' + '+'

- move cursor
  n + {direction}

the {direction} is, one of `h,j,k,l`

- move cursor to line's edge
  end of line, g + \_
  start of line, g + ^

### Edit

- enter insert mode to after last charactor.
  `a`

- copy vim's text to outside clipboard
  `"+y`

- search with selection

1. first yank (select -> y)
2. `/, [Ctrl] + r, "`

## 2-2. NerdTree

- go to workspace as upper directory
  `u`

- go to workspace as currenct directory
  `C`

- refresh
  `r`

- open file with to new window
  `i`

- open file to new tabs
  `t`

- browse command
  `m`

- toggle showing hiddenfiles
  `shift + i`

## 2-3. Markdown Preview

## 2-4. git difftool

### command

```bash
git difftool -y -t vimdiff
```

### shortcut

##### folder

in (+, -) row, press

open
`zo`

fold
`zc`

for all folder, press

open
`zr`

fold
`zm`

#### go to modified

next
`]c`

previos
`[c`

#### refresh

`:diffupdate`

#### apply left or right (put/optain)

apply origin (put from remote file)
`dp`

apply local (obtain from local file)
`do`
