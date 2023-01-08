set dotenv-load

django_key := `echo $DJANGO_SECRET_KEY`
ssh_target := `echo $SSH_USERNAME@$REMOTE_IP`
ssh_exec := "ssh -t " + ssh_target

apply:
	scp -r ./src/* {{ssh_target}}:/etc/nixos
	{{ssh_exec}} sudo DJANGO_SECRET_KEY={{django_key}} nixos-rebuild switch

init:
	scp -r ./src/init.sh {{ssh_target}}:/home/$SSH_USERNAME/init.sh
	{{ssh_exec}} chmod +x /home/$SSH_USERNAME/init.sh
	{{ssh_exec}} /home/$SSH_USERNAME/init.sh
	{{ssh_exec}} rm /home/$SSH_USERNAME/init.sh

# vim: set ft=make :
