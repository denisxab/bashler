#!/bin/bash

alias vg="vagrant"

vg_dk_provision() {
    # Выволнить provision для docker
    # $1 Путь к файлу playbook.yml

    ext="/vagrant/playbook.yml"
    if [ -n "$1" ]; then
        ext="$1"
    fi
    # Собрать образ
    q1="vagrant docker-exec -it -- ansible-playbook $ext;"
    echo $q1
    eval $q1
}

vg_dk_up(){
    # Зарустить ВО на оснвоние провайдера Docker

    vagrant up --provider=docker
}

vg_dk_up_provision(){
    # Зарустить ВО на оснвоние провайдера Docker и запустить provision
    # $1 Путь к файлу playbook.yml

    vg_dk_up && vg_dk_provision $1
}


vg_dk_enter() {
    # Войти в контейнер
    vagrant docker-exec -it -- /bin/bash
}

######
#
# Пример Vagrantfile для docker
# 
# Vagrant.configure("2") do |config|
#   config.vm.define "docker"  do |vm|
#     vm.vm.provider "docker" do |d|
#       d.build_dir = "."
#       d.name = 'vg_test'
#       d.cmd = ['tail', '-f', '/dev/null']
#     end
#   end
# end
#
######
#
# Пример Dockerfile для Vagrant
# 
# FROM python:3.11
# 
# RUN apt-get update && \
#     apt-get install -y sudo && \
#     apt-get install -y ansible 

