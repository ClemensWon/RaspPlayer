import json
from CLasses import MopidyConnection, DB

class Session:
    def __init__(self,sessionPin):
        self.sessionPin = sessionPin
        self.usersAll = []
        self.users = []
        self.queue = []
        self.currentSong = 1
        self.nextInsertPos = 0
        self.currentPlaylist = ''
        self.volume = 0
        self.mopidy = MopidyConnection.MopidyConnection()
        self.db = DB.DB()

    def insertUser(self, user):
        self.db.insertUser(user.deviceId, user.username, 0, user.token)
        self.users.append(user)

    def returnUsers(self):
        users = self.db.getUsers()
        self.usersAll = []
        for user in users:
            self.usersAll.append(user)
        return self.usersAll

    def getSongs(self):
        songs = self.db.getSongs()
        songsAll = {}
        for song in songs:
            songsAll[song[0]]=song[2]
        return songsAll

    def getSpecSong(self,id):
        song = self.db.getSpecSong(id)
        return song.fetchall()

    def getCurrentSong(self):
        song = self.db.getSpecSong(self.currentSong)
        return song.fetchall()
    
    def getBanned(self, deviceId):
        banned = self.db.getBanned(deviceId)
        return banned.fetchall()[0][0]

    def banUser(self, deviceId):
        self.db.banUser(deviceId)
        return

    def unbanUser(self, deviceId):
        self.db.unbanUser(deviceId)
        return

    def likeCurr(self):
        self.db.likeSong(self.currentSong)
        return

    def getToken(self, deviceId):
        token = self.db.getToken(deviceId)
        return token.fetchall()[0][0]

    def returnQueue (self): 
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

    def kickAll(self):
        self.users = []
