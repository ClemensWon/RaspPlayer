import json
from CLasses import MopidyConnection, DB

class Session:
    def __init__(self,sessionPin):
        self.sessionPin = sessionPin
        self.users = []
        self.queue = []
        self.currentSong = 0
        self.nextInsertPos = 0
        self.currentPlaylist = ''
        self.volume = 0
        self.mopidy = MopidyConnection.MopidyConnection()

    def insertUser(self, user):
        self.db = DB.DB()
        self.db.insertUser(user.deviceId, user.username, 0, user.token)

    def returnUsers(self):
        self.db = DB.DB()
        users = self.db.getUsers()
        self.users = []
        for user in users:
            self.users.append(user[1])
        return self.users

    def getSongs(self):
        self.db = DB.DB()
        songs = self.db.getSongs()
        songsAll = {}
        for song in songs:
            songsAll[song[0]]=song[2]
        return songsAll

    def getSpecSong(self,id):
        self.db = DB.DB()
        song = self.db.getSpecSong(id)
        return song.fetchall()
    
    def getBanned(self, deviceId):
        self.db = DB.DB()
        banned = self.db.getBanned(deviceId)
        return banned.fetchall()[0][0]

    def getToken(self, deviceId):
        self.db = DB.DB()
        token = self.db.getToken(deviceId)
        return token.fetchall()[0][0]

    def returnQueue (self):
        self.db = DB.DB()
        queue = {}
        i = -1
        for song in self.queue:
            i=i+1
            queue['song@'+ str(i)] = song #ID
        return queue

    def setvolume(self, volume):
        if volume < 0:
            volume = 0
        elif volume > 100:
            volume = 100

        self.mopidy.volume(volume)
        self.volume = volume

    def mute(self):
        self.volume = 0
        self.mopidy.mute()

    def songToQueue(self, songID):
        #TODO: get songURI from DB
        self.nextInsertPos = self.mopidy.songToQueue(songURI, self.nextInsertPos)

    def replay(self):
        self.mopidy.replay()

    def skip(self):
        self.mopidy.skip()
        self.currentSong += 1

    def play(self):
        self.mopidy.loadPlaylist("all")
        self.mopidy.play()

    def pause(self):
        self.mopidy.pause_resume()
