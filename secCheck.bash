
#!/bin/bash

# Script to perform local security checks

function checks() {

	if [[ $2 != $3 ]]
	then

		echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2. The current value is: $3\e[0m"
		echo -e "Remediation:\n\n$4\n"

	else

		echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"

	fi
}
# Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')

# Check fo0r password max
checks "Password Max Days" "365" "${pmax}" "Edit /etc/login.defs and set:\nPASS_MAX_DAYS  ${pmax}\nto\nPASS_MAX_DAYS  365.\nThen save and quit."

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}" "Edit /etc/login.defs and set:\nPASS_MIN_DAYS  ${pmin}\nto\nPASS_MIN_DAYS  14.\nThen save and quit."

# Checks the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}" "Edit /etc/login.defs and set:\nPASS_WARN_AGE  ${pwarn}\nto\nPASS_WARN_AGE  7.\nThen save and quit."

# Checks the SSH UsePam Configuration
chkSSMPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSMPAM}" "Edit /etc/ssh/shhd_config and set:\nUsePAM  no\nto\nUsePAM  yes\nThen save and quit."

# Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do

	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}" "Edit the permissions of the ${eachDir} from ${chDir}\nto\ndrwx------ by doing:\nsudo chmod 700 /home/${eachDir}."

done

# Checks if IP Forwarding is disabled
ipfor=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* | awk -F= '{print $2}' | tr -d '[:space:]' | rev | cut -c 1)
checks "IP Forwarding" "0" "${ipfor}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward=${ipfor}\nto\nnet.ipv4.ip_forward=0.\nThen run: \n sysctl -w"

# Checks if ICMP redircts are disabled
ICMPre=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf /etc/sysctl.d/* | awk -F= '{print $2}' | tr -d '[:space:]' | rev | cut -c 1)
checks "ICMP Redirect" "0" "${ICMPre}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.accept_redirects=${ICMPre}\nto\nnet.ipv4.conf.all.accept_redirects=0.\nThen run: \n sysctl -w"
ICMPde=$(egrep -i "net\.ipv4\.conf\.all\.secure_redirects" /etc/sysctl.conf /etc/sysctl.d/* | awk -F= '{print $2}' | tr -d '[:space:]' | rev | cut -c 1)
checks "ICMP Request (from Default Gateway)" "1" "${ICMPde}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.secure.redirects=${ICMPde}\nto\nnet.ipv4.conf.all.secure_redirects=1.\nThen run: \n sysctl -w"


# Checks /etc/passwd and /etc/passwd- permissions are configured
pass=$(stat -c "%a %u %g" /etc/passwd)
checks "/etc/passwd permission" "644 0 0" "${pass}" "Edit /etc/passwd permissions from ${pass} to 644 0 0.\nDo a:\nsudo chmod 644 /etc/passwd\nand\nsudo chown 0:0 /etc/passwd."
pass-=$(stat -c "%a %u %g" /etc/passwd-)
checks "/etc/passwd- permission" "644 0 0" "${pass-}" "Edit /etc/passwd- permissions from ${pass-} to 644 0 0.\nDo a:\nsudo chmod 644 /etc/passwd-\nand\nsudo chown 0:0 /etc/passwd-."


# Checks for /etc/cron* files
crontab=$(stat -c "%a %u %g" /etc/crontab)
checks "/etc/crontab" "600 0 0" "${crontab}" "Edit /etc/crontab permissions from ${crontab} to 600 0 0.\nDo a:\nsudo chmod 600 /etc/passwd\nand\nsudo chown 0:0 /etc/crontab."
cronhr=$(stat -c "%a %u %g" /etc/cron.hourly)
checks "/etc/cron.hourly" "700 0 0" "${cronhr}" "Edit /etc/cron.hourly permissions from ${cronhr} to 700 0 0.\nDo a:\nsudo chmod 700 0 0 /etc/cron.hourly\nand\nsudo chown 0:0 /etc/cron.hourly."
crond=$(stat -c "%a %u %g" /etc/cron.daily)
checks "/etc/crontab.daily" "700 0 0" "${crond}" "Edit /etc/cron.daily permissions from ${crond} to 700 0 0.\nDo a:\nsudo chmod 700 0 0 /etc/cron.daily\nand\nsudo chown 0:0 /etc/cron.daily."
cronw=$(stat -c "%a %u %g" /etc/cron.weekly)
checks "/etc/crontab.weekly" "700 0 0" "${cronw}" "Edit /etc/cron.weekly permissions from ${cronw} to 700 0 0.\nDo a:\nsudo chmod 700 0 0 /etc/cron.weekly\nand\nsudo chown 0:0 /etc/cron.weekly."
cronm=$(stat -c "%a %u %g" /etc/cron.monthly)
checks "/etc/cron.monthly" "700 0 0" "${cronm}" "Edit /etc/cron.monthly permissions from ${cronm} to 700 0 0.\nDo a:\nsudo chmod 700 0 0 /etc/cron.monthly\nand\nsudo chown 0:0 /etc/cron.monthly."

# Checks for /etc/*shadow* permissions are configured
shadow=$(stat -c "%a %u %g" /etc/shadow)
checks "/etc/shadow" "640 0 42" "${shadow}" "Edit /etc/shadow permissions from ${shadow} to 640 0 42.\nDo a:\nsudo chmod 640 0 42 /etc/shadow\nand\nsudo chown 0:42 /etc/shadow."
gshadow=$(stat -c "%a %u %g" /etc/gshadow)
checks "/etc/gshadow" "640 0 42" "${gshadow}" "Edit /etc/gshadow permissions from ${gshadow} to 640 0 42.\nDo a:\nsudo chmod 640 0 42 /etc/gshadow\nand\nsudo chown 0:42 /etc/gshadow."
shadow-=$(stat -c "%a %u %g" /etc/shadow-)
checks "/etc/shadow-" "640 0 42" "${shadow-}" "Edit /etc/shadow- permissions from ${shadow-} to 640 0 42.\nDo a:\nsudo chmod 640 0 42 /etc/shadow-\nand\nsudo chown 0:42 /etc/shadow-."
gshadow-=$(stat -c "%a %u %g" /etc/gshadow-)
checks "/etc/gshadow-" "640 0 42" "${gshadow-}" "Edit /etc/gshadow- permissions from ${gshadow-} to 640 0 42.\nDo a:\nsudo chmod 640 0 42 /etc/gshadow-\nand\nsudo chown 0:42 /etc/gshadow-."


# Checks for /etc/group* permissions are configured
group=$(stat -c "%a %u %g" /etc/group)
checks "/etc/group" "644 0 0" "${group}" "Edit /etc/group permissions from ${group} to 640 0 0.\nDo a:\nsudo chmod 644 0 0 /etc/group\nand\nsudo chown 0:0 /etc/group."
group-=$(stat -c "%a %u %g" /etc/group-)
checks "/etc/group-" "644 0 0" "${group-}" "Edit /etc/group- permissions from ${group-} to 640 0 0.\nDo a:\nsudo chmod 644 0 0 /etc/group-\nand\nsudo chown 0:0 /etc/group-."


# Ensures no legacy "+" entries exists
passl=$(egrep -i '^\+:' /etc/passwd)
checks "/etc/passwd" "" "${passl}" "Remove the user ${passl} and any other users that have legacy entries."
shadowl=$(egrep -i '^\+:' /etc/shadow)
checks "/etc/shadow" "" "${shadowl}" "Remove the user ${shadowl} and any other users that have legacy entries."
groupl=$(egrep -i '^\+:' /etc/group)
checks "/etc/group" "" "${groupl}" "Remove the user ${groupl} and any other users that have legacy entries."

# Checks to see if root is the only UID with 0
checkUID=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
if "${checkUID}" != "root"; then
	echo -e "\e[1;31m${checkUID} should NOT have UID of 0.\e[0m"
	echo -e "Remediation:\nUser ${checkUID} should be removed."
else
	echo -e "\e[1;32m${checkUID} should have UID of 0.\e[0m"
fi
