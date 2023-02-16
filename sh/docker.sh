#!/bin/bash

####
# Работа с оброзом
###

dk-build() {
	# Собрать образ
	# $1 Имя для оброза
	# $2 Путь к папке в которой расположен Dockergile
	# $@ Остальные аргументы

	# Собрать образ
	q1="sudo docker build -t $1 $2 ${@:3}"
	echo $q1
	eval $q1
	# Путь куда сохранятсья настройки созданого образа
	conf_docker_image="conf_docker_image.json"
	# Создать файл с конфигурациями образа
	q2="sudo docker inspect $1 > $2/$conf_docker_image"
	echo $q2
	eval $q2
}
dk-images() {
	# Посмотреть образы
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		sudo watch -d -n 2 sudo docker images
	else
		sudo docker images
	fi
}

####
# Работа с контейнером
###

dk-run() {
	# Запустить контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container="conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	container_id=$(sudo docker run -it --rm --detach $1 ${@:2})
	# Создать файл с конфигурациями образа
	q2="sudo docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}

dk-sh() {
	# Войти в запущеннй контейнер
	# $1 Имя контейнера
	sudo docker exec -ti $1 /bin/sh
}

dk-start() {
	# Запустить существубщий контенер
	# $1 Имя контейнера
	sudo docker container start $1
}
dk-stop() {
	# Остановить существубщий контенер
	# $1 Имя контейнера
	sudo docker container stop $1
}

dk-ps() {
	# Посмотреть контейнеры
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		watch -d -n 2 sudo docker ps -a
	else
		sudo docker ps -a
	fi
}

dk-info-ip() {
	# Получить ip адрес указанного контейнера
	# $1 Имя контейнера
	sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

###
# Общее
###
dk-prune() {
	# Отчитстить контейнеры
	sudo docker container prune
	# Отчитстить образы
	sudo docker container prune
}

#################################
#################################
#################################

-docker-compose-select-envfile() {
	# Сохранить путь к env файлу
	# -docker-compose-select-env-file ./file/__env.env
	__write-file $1 .env_path
}
-docker-compose-build() {
	# Запустить образы контейнеров
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) build
	fi
	sudo docker-compose build
}
-docker-compose-up() {
	# Запустить контейнеры а после окончанию отчистить удалить их
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) up && sudo docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	sudo docker-compose up && sudo docker-compose rm -fsv
}
-docker-compose-rm() {
	# Удалить ненужные контейнеры
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	sudo docker-compose rm -fsv
}
