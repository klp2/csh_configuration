## Kevin Phair's .cshrc.  Prompt originally stolen from Boris Kochergin
## and modified to be more pleasant on my eyes.
## other bits and pieces stolen may have been stolen from random conversations
## or places on the intarwebs, usually with no attribution

alias h		history 25
alias j		jobs -l
alias ls	ls -FG
alias la	ls -a
alias lf	ls -FA
alias ll	ls -l
alias nano	nano -Swx
alias pico	nano -Swx


# A righteous umask
umask 22

setenv  GOROOT /usr/local/go

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin ${GOROOT}/bin)
set nobeep
set autolist

setenv	EDITOR	vi
setenv	PAGER	more
setenv	BLOCKSIZE	K
setenv	LSCOLORS	GxGxFxxxCxDxDxCxCxExEx
setenv  GOPATH $HOME/gocode

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set prompt = "%{\033[1;32m%}`whoami`%{\033[0m%}@%{\033[1;36m%}%M%{\033[0m%} %/ %{\033[1;36m%}#%{\033[0m%} "
	set filec
	set history = 1000
	set savehist = 1000
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
		bindkey "^R" i-search-back
	endif
endif
source ~/perl5/perlbrew/etc/cshrc
