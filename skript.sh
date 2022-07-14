#!bin/bash/
source cfg.sh
logg="${0}_$time.log"
mkdir -p log
echo "$(ctime) Skrypt has been started!"|tee -a log/$logg
while true
do
echo "Prosze podac login uzytkownika:"
read login
x=${#login}
if ((x > 30 || x == 0))
then
	echo "$(ctime) Uncorrect length of login"|tee -a log/$logg
	continue	
fi
if [[ "$login" =~ ^[0-9].* ]]
then
	echo "$(ctime) Login can't begin from the number"|tee -a log/$logg
	continue
fi
if [[ "$login" =~ .*":".* ]]
then
	echo "$(ctime) Unexpected : symbol in login"|tee -a log/$logg
	continue
fi
y=`cut -f1 -d: /etc/passwd|egrep -c "^"$login"$"`
if ((y != 0))
then
	echo "$(ctime) Such a login already exists"|tee -a log/$logg
	continue
fi
break
done
k=999
while true
do
	((k++))
	zx=`cut -f3 -d: /etc/passwd|grep -c $k`
	if (( zx!=0 ))
	then 
		continue
	else
		break
fi
done
uid=$k
gid=113
echo "$(ctime) Login,GID,UID are successfuly taken!"|tee -a log/$logg
while true
do
echo "Prosze podac imie i nazwisko uzytkownika:"
read name
echo "Prosze podac numer pokoju lub adres:"
read room
echo "Prosze podac numer do pracy:"
read wnum
echo "Prosze podac numer domowy:"
read hnum
echo "Prosze podac inna kontaktna informacje:"
read elsei
finfo="$name,$room,$wnum,$hnum,$elsei"
x=${#finfo}
if ((x > 260))
then
	echo "$(ctime) Your personal info is too long, try again!"|tee -a log/$logg
	continue
fi
break
done
echo "$(ctime) All informatin is successfuly taken!"|tee -a log/$logg
echo "$login:x:$uid:$gid:$finfo:/$home$login:$bash" >> $pass
echo "$(ctime) User has been added to the /etc/passwd"|tee -a log/$logg
mkdir $home$login
cp -r $skel/. $home$login
echo "$(ctime) Home folder is created, Skel was copied already!"|tee -a log/$logg
#chown $login:$gid $home$login
echo "$(ctime) Chown is done"|tee -a log/$logg
#chmod $home$login d(rwx---r-x)
echo "$(ctime) Chmod is done"|tee -a log/$logg
echo "$login:::0:99999:7:::" >> $shadow
echo "$(ctime) User was added to the /etc/shadow"|tee -a log/$logg
#passwd $login
echo "$(ctime) Password was taken!"|tee -a log/$logg
#pwck -r|tee -a log/$logg
echo "$(ctime) User was successfuly added, script is done. END"|tee -a log/$logg
