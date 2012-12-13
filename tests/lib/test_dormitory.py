__author__ = 'l3nkz'

from tests import FixtureDataTestBase
from tests.lib.fixtures.dormitory_fixtures import DormitoryData, RoomData

from pycroft.model.dormitory import Dormitory, Room
from pycroft.lib.dormitory import create_dormitory, create_room, \
    delete_dormitory, delete_room
from pycroft.model import session

class Test_010_Dormitory(FixtureDataTestBase):
    datasets = [DormitoryData]

    def test_0010_create_dormitory(self):
        new_dormitory = create_dormitory(number="101", short_name="wu101",
            street="wundstrasse")

        self.assertIsNotNone(Dormitory.q.get(new_dormitory.id))

        db_dormitory = Dormitory.q.get(new_dormitory.id)

        self.assertEqual(db_dormitory.number, "101")
        self.assertEqual(db_dormitory.short_name, "wu101")
        self.assertEqual(db_dormitory.street, "wundstrasse")

        session.session.delete(db_dormitory)
        session.session.commit()

    def test_0020_delete_dormitory(self):
        del_dormitory = delete_dormitory(DormitoryData.dummy_dormitory1.id)

        self.assertIsNone(Dormitory.q.get(del_dormitory.id))


class Test_020_Room(FixtureDataTestBase):
    datasets = [RoomData]

    def test_0010_create_room(self):
        new_room = create_room(number="102", level=0, inhabitable=True,
            dormitory_id=DormitoryData.dummy_dormitory1.id)

        self.assertIsNotNone(Room.q.get(new_room.id))

        db_room = Room.q.get(new_room.id)

        self.assertEqual(db_room.number, "102")
        self.assertEqual(db_room.level, 0)
        self.assertEqual(db_room.inhabitable, True)
        self.assertEqual(db_room.dormitory_id, DormitoryData.dummy_dormitory1.id)

        session.session.delete(db_room)
        session.session.commit()

    def test_0020_delete_room(self):
        del_room = delete_room(RoomData.dummy_room1.id)

        self.assertIsNone(Room.q.get(del_room.id))