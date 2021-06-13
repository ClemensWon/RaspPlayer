from mpd import MPDClient

class MopidyConnection:
    def __init__(self):
        self.client = MPDClient()
        self.client.timeout = 10
        self.client.idletimeout = None

    def loadPlaylist(self, playlist):
        self.client.connect("localhost", 6600)
        self.client.clear()
        self.client.load(playlist)
        self.client.disconnect()

    def play(self):
        self.client.connect("localhost", 6600)
        self.client.play()
        self.client.disconnect()
    
    def pause_resume(self):
        self.client.connect("localhost", 6600)
        self.client.pause()
        self.client.disconnect()
    
    def skip(self):
        self.client.connect("localhost", 6600)
        self.client.next()
        self.client.disconnect()

    def replay(self):
        self.client.connect("localhost", 6600)
        self.client.play()
        self.client.disconnect()

    def volume(self, volume):        
        self.client.connect("localhost", 6600)
        self.client.setvol(volume)
        self.client.disconnect()

    def mute(self):
        self.client.connect("localhost", 6600)
        self.client.setvol(0)
        self.client.disconnect()

    def createPlaylist(self, name):
        self.client.connect("localhost", 6600)
        self.client.playlistadd(name, "file:///home/john/Music/Kalimba.mp3")
        self.client.playlistclear(name)
        self.client.disconnect()

    def songToPlaylist(self, name, songURI):
        self.client.connect("localhost", 6600)
        self.client.playlistadd(name, songURI)
        self.client.disconnect()

    def songToQueue(self, songURI, SessionNextInsertPos):
        self.client.connect("localhost", 6600)
        returnValue = 0
        id = self.client.addid(songURI)
        status = self.client.status()["nextsong"]
        if "nextsong" in status:
            nextInsertPos = status["nextsong"]
            if nextInsertPos < SessionNextInsertPos:
                nextInsertPos = SessionNextInsertPos
            self.client.moveid(id, nextInsertPos)
            returnValue = nextInsertPos+1
        self.client.disconnect()
        return returnValue
