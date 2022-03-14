#!/bin/bash

## S = система
s-watch(){
	# Обновление команды через определенный период времяни
	watch -d -n $@
}
# systemctl
s-sys-is-enable(){
	sudo systemctl is-enabled $1
}
s-sys-r(){
	sudo systemctl restart $1
}
s-sys-s(){
	sudo systemctl status $1
}
s-sys-start(){
	sudo systemctl start $1
}
s-sys-stop(){
	sudo systemctl stop $1
}
