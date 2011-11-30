# -*- coding: utf-8 -*-
"""
    pycroft.model.finance
    ~~~~~~~~~~~~~~

    This module contains the classes FinanceAccount, ...

    :copyright: (c) 2011 by AG DSN.
"""
from base import ModelBase
from sqlalchemy import ForeignKey
from sqlalchemy import Table, Column
from sqlalchemy.orm import relationship, backref
from sqlalchemy.types import Integer, Text, DateTime
from sqlalchemy.types import String


class FinanceAccountType(ModelBase):
    name = Column(String(255))
    description = Column(String(255))

class FinanceAccount(ModelBase):
    name = Column(String(127))

class Journal(ModelBase):
    account = Column(String(255))
    bank = Column(String(255))
    hbci_url = Column(String(255))
    last_update = Column(DateTime())

class JournalEntry(ModelBase):
    message = Column(Text())
    journal_id = Column(Integer(), ForeignKey("journal.id"))
    other_account = Column(String(255))
    other_bank = Column(String(255))
    other_person = Column(String(255))
    original_message = Column(Text())
    timestamp = Column(DateTime())

class Transaction(ModelBase):
    message = Column(Text())
    journal_entry_id = Column(Integer(), ForeignKey("journalentry.id"))
    journal_entry = relationship("JournalEntry", backref=backref("transaction"))
	
class Split(ModelBase):
    amount = Column(Integer())
    from_account = Column(Integer(), ForeignKey("financeaccount.id"))
    to_account = Column(Integer(), ForeignKey("financeaccount.id"))
    transaction_id = Column(Integer(), ForeignKey("transaction.id"))
    transaction = relationship("Transaction", backref=backref("splits"))
