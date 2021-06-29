import json
from CLasses import MopidyConnection, DB, User, Song
import os
from werkzeug.utils import secure_filename
import eyed3
import threading

class Session:
    def __init__(self,sessionPin):
        self.sessionPin = sessionPin
        self.usersAll = []
        self.users = []
        self.queue = [1,2]
        self.currentSong = 1
        self.nextInsertPos = 0
        self.currentPlaylist = ''
        self.volume = 100
        self.mopidy = MopidyConnection.MopidyConnection()
        self.db = DB.DB()

    def insertUser(self, user):
        self.db.insertUser(user.deviceId, user.username, 0, user.token)
        self.users.append(user)

    def returnUsers(self):
        users = self.db.getUsers()
        self.usersAll = []
        for user in users:
            self.usersAll.append({
                'username': user[1],
                'banned': user[2]
            })
        return self.usersAll

    def getSongs(self):
        songs = self.db.getSongs()
        songsAll = []
        for song in songs:
            responseDic = self.buildSong(song,)
            songsAll.append(responseDic)
        return songsAll

    def getSpecSong(self,id):
        so = self.db.getSpecSong(id)
        for song in so:
            s = Song.Song(song[0], song[1], song[2], song[3], song[4], song[5], song[6], song[7], song[8]).__dict__
        return s

    def getCurrentSong(self):
        so = self.db.getSpecSong(self.currentSong)
        for song in so:
            s = Song.Song(song[0], song[1], song[2], song[3], song[4], song[5], song[6], song[7], song[8]).__dict__
        return s
    
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

    def kickAll(self):
        self.users = []

    def buildSong(self, song):
        addedby = self.db.getUser(song[1])
        interpretToSong = self.db.getInterpretToSong(song[0])
        interpret = self.db.getInterpret(interpretToSong[0][1])
        responseDic = Song.Song(song[0], addedby[0][1], song[2], song[3], song[4], song[5], song[6], song[7], song[8]).__dict__
        responseDic['artist'] = interpret[0][1]
        return responseDic


    #################### PLAYER CONTROLS ####################

    def replay(self):
        self.mopidy.replay()

    def skip(self):
        self.mopidy.skip()
        self.currentSong += 1

    def pause(self):
        self.mopidy.pause_resume()

    def mute(self):
        self.volume = 0
        self.mopidy.mute()

    def setvolume(self, volume):
        if volume < 0:
            volume = 0
        elif volume > 100:
            volume = 100

        self.mopidy.volume(volume)
        self.volume = volume


    #################### QUEUE ####################

    def returnQueue (self): 
        status = self.mopidy.status()
        queue = []
        if 'song' in status:
            mopidySongPos = int(status['song'])
            counter = 0
            for songID in self.queue:
                if counter >= mopidySongPos:
                    print(songID)
                    song = self.db.getSong(songID)
                    print(song)
                    queue.append(song)
                counter += 1
        return queue

    def songToQueue(self, songID):
        songURI = self.db.getSongURI(songID)
        print(songURI)
        self.nextInsertPos = self.mopidy.songToQueue(songURI, self.nextInsertPos)
        self.queue.insert(self.nextInsertPos-1, songID)
        return self.nextInsertPos-1

    def playQueue(self):
        self.mopdidy.play()

    def updateQueue(self):
        status = self.mopdidy.status()
        if 'song' in status:
            mopidySongPos = status['song']
            
    
    #################### PLAYLIST ####################

    def createPlaylist(self, playlistName, deviceID):
        playlistID = self.db.createPlaylist(playlistName, deviceID)
        if playlistID > 0:
            self.mopidy.createPlaylist(playlistName)
        return playlistID

    def addSongToPlaylist(self, songID, playlistID):
        success = self.db.insertSongToPlaylist(songID, playlistID)
        if success:
            self.db.incrementNextSongPos(playlistID)
            playlistName = self.db.getPlaylistName(playlistID)
            songURI = self.db.getSongURI(songID)
            self.mopidy.songToPlaylist(playlistName, songURI)
        return success

    def deleteSongFromPlaylist(self, songID, playlistID):
        self.db.deleteSongFromPlaylist(songID, playlistID)

    def playPlaylist(self, playlistID):
        playlistName = self.db.getPlaylistName(playlistID)
        self.mopidy.loadPlaylist(playlistName)
        self.mopidy.play()
        self.queue.clear()
        playlistSongs = self.db.getSongsFromPlaylist(playlistID)
        for song in playlistSongs:
            self.queue.append(song['songID'])

    def getPlaylists(self):
        return self.db.getPlaylists()

    def getSongsFromPlaylist(self, playlistID):
        return self.db.getSongsFromPlaylist(playlistID)


    #################### SONG ####################

    def addSong(self, file, deviceID):
        filename = secure_filename(file.filename)
        filepath = os.path.join('/home/john/Music/', filename)
        songID = self.db.addSong("file://" + filepath, deviceID)
        if songID > 0:
            file.save(filepath)
            audiofile=eyed3.load(filepath)
            try:
                self.db.addSongMetaData(songID, audiofile.tag.title, audiofile.tag.artist, audiofile.tag.album, audiofile.tag.genre.name, int(audiofile.info.time_secs))
            except:
                self.db.addSongMetaData(songID, "None", "None", "None", "None", 0)
        return songID

    def getSongs(self):
        return self.db.getSongs()