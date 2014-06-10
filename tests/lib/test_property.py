# Copyright (c) 2014 The Pycroft Authors. See the AUTHORS file.
# This file is part of the Pycroft project and licensed under the terms of
# the Apache License, Version 2.0. See the LICENSE file for details.
from tests import FixtureDataTestBase
from tests.lib.fixtures.property_fixtures import UserData, PropertyGroupData,\
    PropertyData, MembershipData, TrafficGroupData

from pycroft.lib.property import (
    create_membership, delete_membership,
    create_property_group, delete_property_group,
    create_traffic_group, delete_traffic_group,
    grant_property, deny_property, remove_property,
    _create_group, _delete_group
)

from pycroft.model.property import TrafficGroup, PropertyGroup, Property,\
    Membership, Group
from pycroft.model.user import User
from pycroft.model import session

from datetime import datetime, timedelta
from sqlalchemy import Column, ForeignKey
from sqlalchemy.types import Integer

class Test_010_PropertyGroup(FixtureDataTestBase):
    datasets = [PropertyGroupData]

    def test_0010_create_property_group(self):
        name = "dummy_property_group2"

        property_group = create_property_group(name=name)

        self.assertIsNotNone(PropertyGroup.q.get(property_group.id))

        db_property_group = PropertyGroup.q.get(property_group.id)

        self.assertEqual(db_property_group.name, name)

        session.session.delete(db_property_group)
        session.session.commit()

    def test_0020_delete_property_group(self):
        del_property_group = delete_property_group(
            PropertyGroupData.dummy_property_group1.id)

        self.assertIsNone(PropertyGroup.q.get(del_property_group.id))

    def test_0025_delete_wrong_property_group(self):
        self.assertRaises(ValueError, delete_property_group,
            PropertyGroupData.dummy_property_group1.id + 100)


class Test_020_TrafficGroup(FixtureDataTestBase):
    datasets = [TrafficGroupData]

    def test_0010_create_traffic_group(self):
        name = "dummy_traffic_group2"
        traffic_limit = 100000

        traffic_group = create_traffic_group(name=name,
            traffic_limit=traffic_limit)

        self.assertIsNotNone(TrafficGroup.q.get(traffic_group.id))

        db_traffic_group = TrafficGroup.q.get(traffic_group.id)

        self.assertEqual(db_traffic_group.name, name)
        self.assertEqual(db_traffic_group.traffic_limit, traffic_limit)

        session.session.delete(db_traffic_group)
        session.session.commit()

    def test_0020_delete_traffic_group(self):
        del_traffic_group = delete_traffic_group(
            TrafficGroupData.dummy_traffic_group1.id)

        self.assertIsNone(TrafficGroup.q.get(del_traffic_group.id))

    def test_0025_delete_wrong_traffic_group(self):
        self.assertRaises(ValueError, delete_traffic_group,
            TrafficGroupData.dummy_traffic_group1.id + 100)


class Test_030_Membership(FixtureDataTestBase):
    datasets = [MembershipData, PropertyGroupData, UserData]

    def test_0010_create_membership(self):
        start_date = datetime.utcnow()
        end_date = datetime.utcnow() + timedelta(hours=1)
        group = PropertyGroup.q.first()
        user = User.q.first()

        membership = create_membership(start_date=start_date, end_date=end_date,
            group=group, user=user)

        self.assertIsNotNone(Membership.q.get(membership.id))

        db_membership = Membership.q.get(membership.id)

        self.assertEqual(db_membership.start_date, start_date)
        self.assertEqual(db_membership.end_date, end_date)
        self.assertEqual(db_membership.group, group)
        self.assertEqual(db_membership.user, user)

        session.session.delete(db_membership)
        session.session.commit()

    def test_0020_delete_membership(self):
        del_membership = delete_membership(MembershipData.dummy_membership1.id)

        self.assertIsNone(Membership.q.get(del_membership.id))

    def test_0025_delete_wrong_membership(self):
        self.assertRaises(ValueError, delete_membership,
            MembershipData.dummy_membership1.id + 100)


class Test_040_Property(FixtureDataTestBase):
    datasets = [PropertyGroupData, PropertyData]

    def test_0010_grant_property(self):
        property_name = PropertyData.dummy_property1.name
        group_id = PropertyData.dummy_property1.property_group.id
        group = PropertyGroup.q.get(group_id)

        prop = grant_property(group, property_name)

        self.assertIsNotNone(Property.q.get(prop.id))

        db_property = Property.q.get(prop.id)

        self.assertEqual(db_property.name, property_name)
        self.assertEqual(db_property.property_group, group)
        self.assertTrue(db_property.granted)
        self.assertTrue(group.property_grants[property_name])

        session.session.delete(db_property)
        session.session.commit()

    def test_0020_deny_property(self):
        property_name = PropertyData.dummy_property1.name
        group_id = PropertyData.dummy_property1.property_group.id
        group = PropertyGroup.q.get(group_id)

        prop = deny_property(group, property_name)
        self.assertIsNotNone(Property.q.get(prop.id))

        db_property = Property.q.get(prop.id)

        self.assertEqual(db_property.name, property_name)
        self.assertEqual(db_property.property_group, group)
        self.assertFalse(db_property.granted)
        self.assertFalse(group.property_grants[property_name])

        session.session.delete(db_property)
        session.session.commit()

    def test_0030_remove_property(self):
        property_name = PropertyData.dummy_property1.name
        group_id = PropertyData.dummy_property1.property_group.id
        group = PropertyGroup.q.get(group_id)

        try:
            remove_property(group, property_name)
        except ValueError as e:
            self.fail(e.message)

    def test_0035_remove_wrong_property(self):
        property_name = PropertyData.dummy_property1.name
        group_id = PropertyData.dummy_property1.property_group.id
        group = PropertyGroup.q.get(group_id)
        empty_group_id = PropertyGroupData.dummy_property_group2.id
        empty_group = PropertyGroup.q.get(empty_group_id)

        self.assertRaises(ValueError, remove_property,
                          group, property_name + "_fail")
        self.assertRaises(ValueError, remove_property,
                          empty_group,
                          property_name)


class Test_050_MalformedGroup(FixtureDataTestBase):
    datasets = [UserData]

    class MalformedGroup(Group):
        id = Column(Integer, ForeignKey("group.id"), primary_key=True)
        __mapper_args__ = {'polymorphic_identity': 'malformed_group'}

    def test_0010_create_malformed_group(self):
        name = "malformed_group1"

        self.assertRaises(ValueError, _create_group,
            group_type='malformed_group',
            name=name, id=100)

    def test_0020_delete_malformed_group(self):
        malformed_group = Test_050_MalformedGroup.MalformedGroup(id=1000,
            name="malformed_group2")

        session.session.add(malformed_group)
        session.session.commit()

        self.assertRaises(ValueError, _delete_group, malformed_group.id)

        session.session.delete(malformed_group)
        session.session.commit()

