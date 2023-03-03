#!/bin/bash

alias dk="docker"

####
# Работа с оброзом
###

dk-build() {
	# Собрать образ
	# $1 Имя для оброза
	# $2 Путь к папке в которой расположен Dockergile
	# $@ Остальные аргументы

	# Собрать образ
	q1="docker build -t $1 $2 ${@:3}"
	echo $q1
	eval $q1
	# Путь куда сохранятсья настройки созданого образа
	conf_docker_image=".conf_docker_image.json"
	# Создать файл с конфигурациями образа
	q2="docker inspect $1 > $2/$conf_docker_image"
	echo $q2
	eval $q2
}
dk-images() {
	# Посмотреть образы
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		sudo watch -d -n 2 docker images
	else
		docker images
	fi
}
dk-imag-rm() {
	# Удалить указанный образ
	# $1 - Имя оброза
	docker image rm $1
}

####
# Работа с контейнером
###

dk-run() {
	# Создать и запустить контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container=".conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	q1="docker run -it ${@:2} --rm -d $1"
	echo $q1
	container_id=$(eval $q1)
	# Создать файл с конфигурациями образа
	q2="docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}
dk-create() {
	# Создать контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container=".conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	container_id=$(docker create -it $1 ${@:2})
	# Создать файл с конфигурациями образа
	q2="docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}
dk-attach() {
	# Подключиться выводу консоли контейнера
	# $1 Имя контейнера

	q1="docker container attach $1 ${@:2}"
	echo $q1
	eval $q1
}
dk-sh() {
	# Войти в запущеннй контейнер
	# $1 Имя контейнера
	docker exec -ti $1 /bin/sh
}
dk-start() {
	# Запустить существубщий контенер
	# $1 Имя контейнера
	docker container start $1
}
dk-stop() {
	# Остановить существубщий контенер
	# $1 Имя контейнера
	docker container stop $1
}
dk-restart() {
	# Перезапустить существубщий контенер
	# $1 Имя контейнера
	docker container restart $1
}
dk-ps() {
	# Посмотреть контейнеры
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		watch -d -n 2 docker ps -a
	else
		docker ps -a
	fi
}
dk-info-ip() {
	# Получить ip адрес указанного контейнера
	# $1 Имя контейнера
	docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

###
# Общее
###
dk-prune() {
	# Отчитстить контейнеры
	docker container prune
	# Отчитстить образы
	docker container prune
}

#################################
# Docker-compose
#################################
alias dkp="docker-compose"

dkp-init() {
	# Создать файл `docker-compose.yml` в текущем пути
	touch docker-compose.yml
}

# -docker-compose-select-envfile() {
# 	# Сохранить путь к env файлу
# 	# -docker-compose-select-env-file ./file/__env.env
# 	__write-file $1 .env_path
# }
# -docker-compose-build() {
# 	# Запустить образы контейнеров
# 	if [[ -r .env_path ]]; then
# 		docker-compose --env-file $(cat .env_path) build
# 	fi
# 	docker-compose build
# }
# -docker-compose-up() {
# 	# Запустить контейнеры а после окончанию отчистить удалить их
# 	if [[ -r .env_path ]]; then
# 		docker-compose --env-file $(cat .env_path) up && docker-compose --env-file $(cat .env_path) rm -fsv
# 	fi
# 	docker-compose up && docker-compose rm -fsv
# }
# -docker-compose-rm() {
# 	# Удалить ненужные контейнеры
# 	if [[ -r .env_path ]]; then
# 		docker-compose --env-file $(cat .env_path) rm -fsv
# 	fi
# 	docker-compose rm -fsv
# }
