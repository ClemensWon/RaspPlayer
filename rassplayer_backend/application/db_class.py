from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine("mysql+pymysql://johnlennon:woodstock69@localhost:8008/raspplayer")
session = sessionmaker(bind=engine)()
base = declarative_base()