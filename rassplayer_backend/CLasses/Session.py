import json
from CLasses import MopidyConnection

class Session:
    def __init__(this,sessionPin):
        this.sessionPin = sessionPin
        this.users = []
        this.queue = []
        this.currentSong = 0
        this.nextInsertPos = 0
        this.currentPlaylist = ''
        this.volume = 0
        this.mopidy = MopidyConnection.MopidyConnection()

    def returnUsers(this):
        users = {}
        i = -1
        for user in this.users:
            i=i+1
            users['user'+ str(i)] = user.username
        return users

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
        self.mopidy.loadPlaylist("Kalimba")
        self.mopidy.play()

    def pause(self):
        self.mopidy.pause_resume()