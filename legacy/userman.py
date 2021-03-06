# Copyright (c) 2015 The Pycroft Authors. See the AUTHORS file.
# This file is part of the Pycroft project and licensed under the terms of
# the Apache License, Version 2.0. See the LICENSE file for details.
from sqlalchemy import create_engine

from sqlalchemy.orm import sessionmaker, scoped_session

from conn import conn_opts
import userman_model as model

name = "userman"

engine = create_engine(conn_opts['userman'], client_encoding='latin1')
session = scoped_session(sessionmaker(bind=engine))

relevant_tables = [model.FinanzKonten,
                   model.BkBuchung,
                   model.BankKonto,
                   model.FinanzBuchungen,
                   #model.Log,
                   model.FinanzKontoTyp]


