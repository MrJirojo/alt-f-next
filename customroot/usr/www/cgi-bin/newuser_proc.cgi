#!/bin/sh

. common.sh
check_cookie
read_args

#debug # dont forget to comment/uncomment "enddebug" in script

if test "$submit" = "Submit" -o "$chpass" = "ChangePass"; then
	uname="$(httpd -d "$uname")"
	nick="$(httpd -d "$nick")"

	if test "$submit" = "Submit"; then
		ouname="$(awk -F: -v ouname="$uname" '$5 == ouname {print $5}' /etc/passwd)"
		onick="$(awk -F: -v onick="$nick" '$1 == onick {print $1}' /etc/passwd)"
		snick="$(echo $nick | tr -d ' ')"

		if test -z "$uname" -o -n "$ouname"; then
			msg "The user name can't be empty or a user with that name already exists"
		elif test -z "$nick" -o -n "$onick" -o "$nick" != "$snick"; then 
			msg "The nickname cant be empty, have spaces, or a user with same nickname already exists"
		elif test -z "$uid" -o "$(awk -F: '$3 == "'$uid'" {print $3}' /etc/passwd)"; then
			msg "A user with that user id already exists"
		elif test -z "$pass" -o "$pass" != "$passa"; then
			msg "Password can't be empty or does not match"
		fi
		#uname=$(echo "$uname" | tr ' ' '_')
		#adduser -D -G users -u $uid -g "$uname" -h "/home/$nick" $nick > /dev/null 2>&1
		adduser -D -G users -u $uid -g "$uname" -h "/home/$uname" $nick > /dev/null 2>&1
	fi

	if test -z "$pass" -o "$pass" != "$passa"; then
		msg "Password can't be empty or does not match"
	fi

	echo "$nick:$pass" | chpasswd > /dev/null 2>&1
	gotopage /cgi-bin/usersgroups.cgi

elif test "$cancel" = "Cancel"; then
	gotopage /cgi-bin/usersgroups.cgi

elif test "$create_dir" = "CreateDir"; then
	if test "$part" = "none"; then
        	msg "You must select a partition"
	fi

	part=$(httpd -d $part)
#	mp=$(cat /proc/mounts | grep $part | cut -d" " -f2)
	mp="$(awk -v part=$part '$1 == part {print $2}' /proc/mounts)"
	mkdir -p "$mp"/Users
	ln -sf "$mp"/Users /home
	gotopage /cgi-bin/newuser.cgi
fi

#enddebug

