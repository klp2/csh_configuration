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
alias bgrep  ack
alias ga    git add
alias lgb git for-each-ref --sort=committerdate refs/heads/ --format=\'%\(committerdate:short\) %\(authorname\) %\(refname:short\)\'
alias gb    git branch
alias co    git checkout
alias gs    git status
alias gd    git diff
alias gc    git commit
alias gp    git push
alias t     tmux

# A righteous umask
umask 22

setenv  GOPATH ~/go
setenv  GOBIN  ${GOPATH}/bin

#mac osx really wants bash to be the default shell
setenv SHELL /bin/csh

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin ${GOBIN} /usr/local/go/bin)
source ~/csh_configuration/cshrc.local
set nobeep
set autolist

setenv	EDITOR	vi
setenv	PAGER	less
setenv  LESS	FSXR #for pretty git output
setenv	BLOCKSIZE	K
setenv	LSCOLORS	GxGxFxxxCxDxDxCxCxExEx

if ($?prompt) then
	# An interactive shell -- set some stuff up
    ## This prompt relies on using Stephen Reim's git-tools stuff, from https://github.com/cobber/git-tools. The git-prompt script needs to be in your PATH.  That requires perl to be installed, and requires the YAML module to be installed as well.  If you don't want any of those things, comment this one out, and uncomment the set prompt line just below it. 
    alias precmd 'set prompt = "%{\033[1;32m%}`whoami`%{\033[0m%}@%{\033[1;36m%}%M%{\033[0m%} %c03`git-prompt` \n%{\033[1;36m%}#%{\033[0m%} "'
    #set prompt = "%{\033[1;32m%}`whoami`%{\033[0m%}@%{\033[1;36m%}%M%{\033[0m%} %~ %{\033[0m%} \n%{\033[1;36m%}#%{\033[0m%} "
	set filec
	set history = 50000
	set savehist = (50000 merge)
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
        bindkey -v
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
		bindkey "^R" i-search-back
	endif
endif

# lazy add ssh keys
foreach key (`ls $HOME/.ssh/keys`)
    ssh-add $HOME/.ssh/keys/$key >& /dev/null
end

## more auto-complete stuff stolen from http://www.wonkity.com/~wblock/csh/completions

  # word/pattern/list
  # c/pat/rep/ complete current word beginning with pat
  # C/pat/rep/ complete current word including all of pat
  # n/pat/rep/ complete next word beginning with pat
  # N/pat/rep/ complete next word including all of pat
  # p/pat/rep/ complete word p, where p is the word number

  set noglob
  if ( ! $?hosts ) set hosts
  foreach f ("$HOME/.hosts" /usr/local/etc/csh.hosts "$HOME/.rhosts" /etc/hosts.equiv)
    if ( -r "$f" ) then
      set hosts = ($hosts `grep -v "+" "$f" | grep -E -v "^#" | tr -s " " "       " | cut -f 1`)
    endif
  end
  if ( -r "$HOME/.ssh/config" ) then
    set hosts = ($hosts `grep ^Host "$HOME/.ssh/config" | cut -d ' ' -f 2`)
  endif
  if ( -r "$HOME/.ssh/known_hosts" ) then
    #set hosts = ($hosts `cut -w -f1 "$HOME/.ssh/known_hosts" | cut -d, -f 1`)
    set hosts = ($hosts `less $HOME/.ssh/known_hosts | awk '{print $1}' | cut -d, -f 1`)
  endif
  set hosts=(`echo $hosts | tr -d '[]' | sort | uniq`)
  unset f
  unset noglob

  complete cd		'p/1/d/'

  complete chown	'p/1/u/'

  complete dd		'c/if=/f/' 'c/of=/f/' \
			'c/conv=*,/(ascii block ebcdic lcase pareven noerror notrunc osync sparse swab sync unblock)/,' \
			'c/conv=/(ascii block ebcdic lcase pareven noerror notrunc osync sparse swab sync unblock)/,' \
			'p/*/(bs cbs count files fillcahr ibs if iseek obs of oseek seek skip conv)/='

  alias __jails 'jls -d name'

  complete ezjail-admin	'p/1/(install create console list start stop restart startcrypto stopcrypto config delete \
  			  archive restore snapshot update)/' \
  			'n/archive/`__jails`/' \
  			'n/console/`__jails`/' \
  			'n/delete/`__jails`/' \
  			'n/restore/`__jails`/' \
  			'n/restart/`__jails`/' \
  			'n/snapshot/`__jails`/' \
  			'n/start/`__jails`/' \
  			'n/stop/`__jails`/'

  complete fg		'c/%/j/'

  complete find		'n/-fstype/"(nfs 4.2)"/' 'n/-name/f/' \
			'n/-type/(c b d f p l s)/' \
			'n/-user/u/ n/-group/g/' \
			'n/-exec/c/' 'n/-ok/c/' \
			'n/-cpio/f/' \
			'n/-ncpio/f/' \
			'n/-newer/f/' \
			'c/-/(fstype name perm prune type user nouser group nogroup size inum atime mtime ctime exec \
			  ok print ls cpio ncpio newer xdev depth daystart follow maxdepth mindepth noleaf version \
			  anewer cnewer amin cmin mmin true false uid gid ilname iname ipath iregex links lname empty path \
			  regex used xtype fprint fprint0 fprintf print0 printf not a and o or)/' \
			'n/*/d/'

  complete gpart	'p/1/(add backup bootcode commit create delete destroy modify recover resize restore set show undo unset)/' \
			'n/add/x:-t type [-a alignment] [-b start] [-s size] [-i index] [-l label] -f flags geom/' \
			'n/backup/x:geom/' \
			'n/bootcode/x:[-b bootcode] [-p partcode -i index] [-f flags] geom/' \
			'n/commit/x:geom/' \
			'n/create/x:-s scheme [-n entries] [-f flags] provider/' \
			'n/delete/x:-i index [-f flags] geom/' \
			'n/destroy/x:[-F] [-f flags] geom/' \
			'n/modify/x:-i index [-l label] [-t type] [-f flags] geom/' \
			'n/recover/x:[-f flags] geom/' \
			'n/resize/x:-i index [-a alignment] [-s size] [-f flags] geom/' \
			'n/restore/x:[-lF] [-f flags] provider [...]/' \
			'n/set/x:-a attrib -i index [-f flags] geom/' \
			'n/show/x:[-l | -r] [-p] [geom ...]/' \
			'n/undo/x:geom/' \
			'n/unset/x:-a attrib -i index [-f flags] geom/'

  complete gpg		'c/--/(sign clearsign encrypt decrypt verify verify-files encrypt-files decrypt-files list-keys \
  			  list-public-keys list-secret-keys delete-key fingerprint check-sigs delete-secret-key export \
  			  send-keys recv-keys search-keys fetch-keys gen-key edit-key sign-key keyserver armor)/'

  complete grep		'c/-*A/x:<#_lines_after>/' \
			'c/-*B/x:<#_lines_before>/' \
			'c/--/(extended-regexp fixed-regexp basic-regexp regexp file ignore-case word-regexp line-regexp \
			  no-messages revert-match version help byte-offset line-number with-filename no-filename quiet silent \
			  text directories recursive files-without-match files-with-matches count before-context after-context \
			  context binary unix-byte-offsets)/' \
			'c/-/(A a B b C c d E e F f G H h i L l n q r s U u V v w x)/' \
			'p/1/x:<limited_regular_expression>/ N/-*e/f/' \
			'n/-*e/x:<limited_regular_expression>/' \
			'n/-*f/f/' \
			'n/*/f/'

  complete ifconfig	'p@1@`ifconfig -l`@' \
			'n/*/(range phase link netmask mtu vlandev vlan metric mediaopt down delete broadcast arp debug)/'

  complete kldload	'n@*@`ls -1 /boot/modules/ /boot/kernel/ | awk -F/ \$NF\ \~\ \".ko\"\ \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\}`@'

  complete kldunload	'n@*@`kldstat | awk \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\} | grep -v Name`@'

  complete kldreload	'n@*@`kldstat | awk \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\} | grep -v Name`@'

  complete kill		'c/-/S/' \
			'c/%/j/' \
			'n/*/`ps -ax | awk '"'"'{print $1}'"'"'`/'

  complete killall	'c/-/S/' \
			'c/%/j/' \
			'n/*/`ps -axc | awk '"'"'{print $5}'"'"'`/'

  alias __manpages	'man -k . | perl -0777e '\''$in = <STDIN>; $in =~ s/\s+-\s+.*?\n/\n/g; $in =~ s/,\s+/\n/g; $in =~ s/\s+/\n/g; $in =~ s/\(\d\)//g; @out = split /\n/, $in; %hash = map {$_, 1} @out; @uniq = keys %hash; @uniq = grep {\\!/^\./} @uniq; print join ("\n", @uniq);'\'''
  alias __manpagesfiles	'man -k . | perl -0777e '\''$in = <STDIN>; $in =~ s/\s+-\s+.*?\n/\n/g; $in =~ s/,\s+/\n/g; $in =~ s/\s+/\n/g; $in =~ s/\(\d\)//g; @out = split /\n/, $in; %hash = map {$_, 1} @out; @uniq = keys %hash; @uniq = grep {\\!/^\./} @uniq; push @uniq, `find ./ -maxdepth 1 -type f \\( -name "*.[0-9]" -o -name "*.[0-9].gz" \\)`; print join ("\n", @uniq);'\'''

  complete man		'C/*/`__manpagesfiles`/'

  complete make		'C/F/(FORMATS= FORMATS=html FORMATS=html-split FORMATS=pdf)/' \
  			'p/1/`make -V .ALLTARGETS`/' \
			'n/-V/`make -Ndg1 |& grep = | sort | uniq`/'

  complete netstat	'n/-I/`ifconfig -l`/'

  complete ping		'p/1/$hosts/'

  set pkgcmds=(help add annotate audit autoremove backup check clean convert create delete fetch info install lock plugins \
  			query register repo rquery search set shell shlib stats unlock update updating upgrade version which)

  alias __pkgs	'pkg info -q'
  # aliases that show lists of possible completions including both package names and options
  alias __pkg-check-opts	'__pkgs | xargs echo -B -d -s -r -y -v -n -a -i g x'
  alias __pkg-del-opts		'__pkgs | xargs echo -a -D -f -g -i -n -q -R -x -y'
  alias __pkg-info-opts		'__pkgs | xargs echo -a -A -f -R -e -D -g -i -x -d -r -k -l -b -B -s -q -O -E -o -p -F'
  alias __pkg-which-opts	'__pkgs | xargs echo -q -o -g'

  complete pkg		'p/1/$pkgcmds/' \
  			'n/check/`__pkg-check-opts`/' \
  			'N/check/`__pkgs`/' \
  			'n/delete/`__pkg-del-opts`/' \
  			'N/delete/`__pkgs`/' \
  			'n/help/$pkgcmds/' \
  			'n/info/`__pkg-info-opts`/' \
  			'N/info/`__pkgs`/' \
  			'n/which/`__pkg-which-opts`/' \
  			'N/which/`__pkgs`/'

  complete pkill	'c/-/S/' \
			'n@*@`ps -axc -o command="" | sort | uniq`@'

  complete portmaster	'c/--/(always-fetch check-depends check-port-dbdir clean-distfiles clean-packages delete-build-only \
			  delete-packages force-config help index index-first index-only list-origins local-packagedir \
			  no-confirm no-index-fetch no-term-title packages packages-build packages-if-newer packages-local \
			  packages-only show-work update-if-newer version)/' \
			'c/-/(a b B C d D e f F g G h H i l L m n o p r R s t u v w x)/' \
			'n/*/`__pkgs`/'

  complete rsync	"c,*:/,F:/," \
			"c,*:,F:$HOME," \
			'c/*@/$hosts/:/'

  complete scp		"c,*:/,F:/," \
			"c,*:,F:$HOME," \
			'c/*@/$hosts/:/'

  complete service	'c/-/(e l r v)/' \
			'p/1/`service -l`/' \
			'n/*/(start stop reload restart status rcvar onestart onestop)/'

  complete ssh		'p/1/$hosts/' \
			'c/-/(l n)/' \
			'n/-l/u/ N/-l/c/ n/-/c/ p/2/c/ p/*/f/'

  complete svn		'C@file:///@`'"${HOME}/etc/tcsh/complete.d/svn"'`@@' \
			'n@ls@(file:/// svn+ssh:// svn://)@@' \
			'n@help@(add blame cat checkout cleanup commit copy delete export help import info list ls lock log merge mkdir move propdel \
			  propedit propget proplist propset resolved revert status switch unlock update)@' 'p@1@(add blame cat checkout cleanup commit \
			  copy delete export help import info list ls lock log merge mkdir move propdel propedit propget proplist propset resolved \
			  revert status switch unlock update)@'

  complete sysctl	'n/*/`sysctl -Na`/'

  complete tmux		'n/*/(attach detach has kill-server kill-session lsc lscm ls lockc locks new refresh rename showmsgs source start suspendc switchc)/'

  complete xpdf		'n/*/f:*.{[pP][dD][fF]}/'

  complete which	'C/*/c/'

  complete zfs		'p/1/(clone create destroy get inherit list mount promote receive rename rollback send set share snapshot unmount unshare)/' \
			'n/clone/x:[-p] [-o property=value] ... snapshot filesystem|volume/' \
			'n/create/x:[-p] [-o property=value] ... filesystem \
[-ps] [-b blocksize] [-o property=value] ... -V size volume/' \
			'n/destroy/x:[-fnpRrv] filesystem|volume \
[-dnpRrv] snapshot[%snapname][,...]/' \
			'n/get/x:[-r|-d depth] [-Hp] [-o all | field[,...]] [-t type[,...]] [-s source[,...]] all | property[,...] filesystem|volume|snapshot/' \
			'n/inherit/x:[-rS] property filesystem|volume|snapshot/' \
			'n/list/x:[-r|-d depth] [-H] [-o property[,...]] [-t type[,...]] [-s property] ... [-S property] ... filesystem|volume|snapshot/' \
			'n/mount/x:[-vO] [-o property[,...]] -a | filesystem/' \
			'n/promote/x:clone-filesystem/' \
			'n/receive/x:[-vnFu] filesystem|volume|snapshot \
[-vnFu] [-d | -e] filesystem/' \
			'n/rename/x:-r snapshot snapshot \
-u [-p] filesystem filesystem/' \
			'n/rollback/x:[-rRf] snapshot/' \
			'n/send/x:[-DnPpRv] [-i snapshot | -I snapshot] snapshot/' \
			'n/set/x:property=value filesystem|volume|snapshot/' \
			'n/share/x:-a | filesystem/' \
			'n/snapshot/x:[-r] [-o property=value] ... filesystem@snapname|volume@snapname/' \
			'n/unmount/x:[-f] -a | filesystem|mountpoint/' \
			'n/unshare/x:-a | filesystem|mountpoint/'

#  complete zpool	''

  if ( -f /etc/printcap ) then
    set printers=(`sed -n -e "/^[^ 	#].*:/s/:.*//p" /etc/printcap`)
    complete lpr	'c/-P/$printers/'
    complete lpq	'c/-P/$printers/'
    complete lprm	'c/-P/$printers/'
  endif

## end of auto-completiong stuff stolen from http://www.wonkity.com/~wblock/csh/completions
