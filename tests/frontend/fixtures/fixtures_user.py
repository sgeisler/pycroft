#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
from fixture import DataSet

from pycroft.helpers.user import hash_password
from fixtures_dormitory import RoomData


class BaseUser():
    """Data every user model needs"""
    name = "John Die"
    passwd_hash = hash_password("password")
    registration_date = datetime.datetime.now()
    room = RoomData.dummy_room1  # yes, they all live in the same room


class UserData(DataSet):
    class user1_admin(BaseUser):
        # Normal admin
        login = "admin"

    class user2_finance(BaseUser):
        # Admin with permission to view Finance
        login = "finanzer"