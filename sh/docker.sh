#!/bin/bash

# Docekr
-docker-ip() {
	# Получить	 ip адрес   указанного 	 контейнера
	# -docker-ip имя_контейнера
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $NAME_PROJ
}

__docker-create-filename() {
	# Взять название проекта из файла
	if [[ -r .name_docker_container ]]; then
		NAME_PROJ=$(cat .name_docker_container)
		echo "$NAME_PROJ"
		return 0
	fi
	NAME_PROJ="$1"
	__write-file "$NAME_PROJ" .name_docker_container
	echo "$NAME_PROJ"
}
-docker-build() {
	# Создать образ проекта(Нужно находиться на одном уровне с `Dockerfile`)
	# -docker-build [имя_для_контейнера]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	WORK_DIR="/usr/src/$NAME_PROJ"
	image_name="img_$NAME_PROJ"
	sudo docker build --build-arg WORK_DIR=$WORK_DIR --build-arg NAME_PROJ=$NAME_PROJ -t $image_name .
}
-docker-run() {
	# Создать и запустить контейнер с проектом
	# -docker-run [имя_контейнра] [--rm (удалить при выходе контейенр)]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	container_name="$NAME_PROJ"
	image_name="img_$NAME_PROJ"
	sudo docker run --rm -ti --name $container_name $image_name $@
	#-v $(my_path)/deploy:$(WORK_DIR)/deploy -p $(EXTERNAL_WEB_PORT):$(EXTERNAL_WEB_PORT)
}
-docker-start() {
	#  Запустить существубщий контенер
	# [-a (войти в контейнер)]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker container start $NAME_PROJ
}
-docker-stop() {
	#  Остановить существубщий контенер
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker container stop $NAME_PROJ
}
-docker-exec() {
	# Войти в контейнер
	# -docker-exec [имя_контейнера]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker exec -ti $NAME_PROJ /bin/sh
}
-dshc() {
	# Посмотреть контейнеры
	# docker-show-container
	if [[ $1 == '-w' ]]; then
		watch -d -n 2 sudo docker ps -a
	else
		sudo docker ps -a
	fi

}
-dshi() {
	# Посмотреть образы
	# docker-show-image
	if [[ $1 == '-w' ]]; then
		sudo watch -d -n 2 sudo docker images
	else
		sudo docker images
	fi
}
-dcp() {
	# Отчитстить контейнеры
	sudo docker container prune
}
-dip() {
	# Отчитстить образы
	sudo docker container prune
}

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

####
# Работа с оброзом
###

dk-build() {
	# Собрать образ
	# $1 Имя для оброза
	# $2 Путь к папке в которой расположен Dockergile

	# Собрать образ
	q1="sudo docker build -t $1 $2"
	echo $q1
	eval $q1
	# Путь куда сохранятсья настройки созданого образа
	conf_docker_image="conf_docker_image.json"
	# Создать файл с конфигурациями образа
	q2="sudo docker inspect $1 > $conf_docker_image"
	echo $q2
	eval $q2
}

dk-run() {
	# Запустить контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container="conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	container_id=$(sudo docker run -it --rm --detach $1 $@)
	# Создать файл с конфигурациями образа
	q2="sudo docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}
