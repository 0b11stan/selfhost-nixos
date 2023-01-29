$gnused/bin/sed 's/\(.*\)/iptables -A DOCKER-USER -s \1 -j DROP/' $src > $out
$coreutils/bin/chmod +x $out
