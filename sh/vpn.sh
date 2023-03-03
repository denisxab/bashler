#!/bin/bash

export Wireguard_VPN_CONF="wg0"

###
# WireGuard
#
vpn-on() {
    # Включить VPN
    sudo wg-quick up $Wireguard_VPN_CONF
}
vpn-off() {
    # Выключить VPN
    sudo wg-quick down $Wireguard_VPN_CONF
}
vpn-info() {
    # Информация о подключение к VPN
    sudo wg show
}
###
# OpenVpn
#
open-vpn-on() {
    printf 'OpenVpn включен\n'
    # Включить OpenVpn
    sudo openvpn /etc/openvpn/client/client.ovpn
}
