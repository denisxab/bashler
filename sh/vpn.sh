#!/bin/bash

export Wireguard_VPN_CONF="wg0"

-vpn-on() {
    # Включить VPN
    sudo wg-quick up $Wireguard_VPN_CONF
}
-vpn-off() {
    # Выключить VPN
    sudo wg-quick down $Wireguard_VPN_CONF
}
-vpn-info() {
    # Информация о подключение к VPN
    sudo wg show
}
