# -*- coding: utf-8 -*-
"""
    pycroft.helpers.user_helper
    ~~~~~~~~~~~~~~

    This package contains the class UserHelper with the following helpers:
    - generate password with given length
    - generate hostname from IP
    - return regex value specified for input type
    - get free IP from available subnets

    :copyright: (c) 2011 by AG DSN.
"""

import random, ipaddr
from pycroft.model import hosts, session


class UserHelper:

    class SubnetFullException(Exception):
        pass


    def generatePassword(self, length):
        allowedLetters = "abcdefghijklmnopqrstuvwxyz!$%&()=.,"\
                         ":;-_#+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        passwordLength = length
        password = ""
        for i in range(passwordLength):
            password += allowedLetters[random.choice(range(len
                (allowedLetters)))]
        return password


    def generateHostname(self, ip_address, hostname):
        if hostname == "":
            return "whdd" + ip_address[-3, -1]
        return hostname


    def getRegex(self, type):
        regexName = "^(([a-z]{1,5}|[A-Z][a-z0-9]+)\\s)*([A-Z][a-z0-9]+)((-|\\s)"\
                    "[A-Z][a-z0-9]+|\\s[a-z]{1,5})*$"
        regexLogin = "^[a-z][a-z0-9_]{1,20}[a-z0-9]$"
        regexMac = "^[a-f0-9]{2}(:[a-f0-9]{2}){5}$"
        regexRoom = "^[0-9]{1,6}$"

        if type == "name":
            return regexName
        if type == "login":
            return regexLogin
        if type == "mac":
            return regexMac
        if type == "room":
            return regexRoom


    def getFreeIP(self, subnets):
        possible_hosts = []

        for subnet in subnets:
            for ip in ipaddr.IPv4Network(subnet).iterhosts():
                possible_hosts.append(ip)

        reserved_hosts = []

        reserved_hosts_string = session.session.query(hosts.NetDevice.ipv4).all()

        for ip in reserved_hosts_string:
            reserved_hosts.append(ipaddr.IPv4Address(ip.ipv4))

        for ip in reserved_hosts:
            if ip in possible_hosts:
                possible_hosts.remove(ip)

        if possible_hosts:
            return possible_hosts[0].compressed

        raise self.SubnetFullException()