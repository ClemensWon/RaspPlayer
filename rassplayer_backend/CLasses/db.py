from flask import Flask,jsonify
from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.ext.declarative import *

engine = create_engine("mysql+pymysql://root:root@localhost:8008/raspplayer")
session = sessionmaker(bind=engine)()
Base = declarative_base()

##Song

association_interpretToSong = Table('interpretToSong', Base.metadata,
Column('songID', Integer, ForeignKey('song.songID')),
Column('interpretID', Integer, ForeignKey('interpret.interpretID'))
)

class Song(Base):
    __tablename__ = "song"
    songID = Column(Integer, primary_key=True)
    songName = Column(String)
    genre = Column(String)
    interprets = relationship("Interpret", secondary=association_interpretToSong, back_populates="songs")

    def __init__(self,songName, genre):
        self.songName = songName
        self.genre = genre

class Interpret(Base):
    __tablename__ = "interpret"
    interpretID = Column(Integer, primary_key=True)
    interpretName = Column(String)
    songs = relationship("Song", secondary=association_interpretToSong , back_populates="interprets")

    def __init__(self,interpretName):
        self.interpretName = interpretName

'''
song = Song("TEST2","TEST2")
interpret = Interpret("TEST12")
song.interprets.append(interpret)
session.add(song)
session.commit()
'''