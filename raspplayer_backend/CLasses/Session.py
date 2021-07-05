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
        self.muted = []
        self.users = []
        self.queue = []
        self.skipList = []
        self.skipPercentage = 0.5
        self.currentSong = 1
        self.nextInsertPos = 0
        self.lastSongPos = 0
        self.queueStarted = False
        self.currentPlaylist = ''
        self.volume = 100
        self.mopidy = MopidyConnection.MopidyConnection()
        self.db = DB.DB()

    def clearQueue(self):
        self.mopidy.clearQueue()

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

    #restarts the currently playing song
    def replay(self):
        self.mopidy.replay()

    #skips the currently playing song, if a certain percentage of skipvotes is met
    def skip(self):
        print()
        if (float(len(self.skipList))/float(len(self.users))) >= self.skipPercentage:
            self.mopidy.skip()
            self.skipList = []

    #pauses/resumes the currentlx playing song
    def pause(self):
        self.mopidy.pause_resume()

    #mutes the player
    def mute(self):
        self.volume = 0
        self.mopidy.mute()

    #sets the playervolume (range: 0-100)
    def setvolume(self, volume):
        if volume < 0:
            volume = 0
        elif volume > 100:
            volume = 100

        self.mopidy.volume(volume)
        self.volume = volume


    #################### QUEUE ####################

    #returns all the songs from the queue
    def returnQueue (self):
        status = self.mopidy.status()
        if 'song' in status:
            mopidySongPos = int(status['song'])
            songsToDelete = mopidySongPos - self.lastSongPos
            print("lastSongPos: " + str(self.lastSongPos))
            print("mopidySongPos: " + str(mopidySongPos))
            counter = 0
            while counter < songsToDelete:
                self.queue.pop(0)
                print('song removed from queue')
                counter += 1
            self.lastSongPos = mopidySongPos
        elif self.queueStarted:
            self.queue.clear()
            self.queueStarted = False
            self.mopidy.clearQueue()
        queue = []
        for songID in self.queue:
            song = self.db.getSong(songID)
            queue.append(song)
        return queue

    #adds one or more songs to the queue
    def songToQueue(self, songIDs):
        for songID in songIDs:
            songURI = self.db.getSongURI(songID)
            self.nextInsertPos = self.mopidy.songToQueue(songURI, self.nextInsertPos)
            self.queue.insert(self.nextInsertPos-1, songID)
            print(self.queue)

    #starts playing the queue from the beginning
    def playQueue(self):
        self.mopidy.play()
        self.queueStarted = True
            
    
    #################### PLAYLIST ####################

    #creates an empty playlist in the DB as well as in mopidy
    def createPlaylist(self, playlistName, deviceID):
        playlistID = self.db.createPlaylist(playlistName, deviceID)
        if playlistID > 0:
            self.mopidy.createPlaylist(playlistName)
        return playlistID

    #adds one or more songs to a playlist
    def addSongToPlaylist(self, songIDs, playlistID):
        for songID in songIDs:
            success = self.db.insertSongToPlaylist(songID, playlistID)
            if success:
                self.db.incrementNextSongPos(playlistID)
                playlistName = self.db.getPlaylistName(playlistID)
                songURI = self.db.getSongURI(songID)
                self.mopidy.songToPlaylist(playlistName, songURI)

    #deletes a song from a playlist
    def deleteSongFromPlaylist(self, songID, playlistID):
        self.db.deleteSongFromPlaylist(songID, playlistID)

    #starts playing a playlist from the beginning
    def playPlaylist(self, playlistID):
        playlistName = self.db.getPlaylistName(playlistID)
        self.mopidy.loadPlaylist(playlistName)
        self.mopidy.play()
        self.queue.clear()
        playlistSongs = self.db.getSongsFromPlaylist(playlistID)
        for song in playlistSongs:
            self.queue.append(song['songID'])
        self.queueStarted = True

    #returns all playlists
    def getPlaylists(self):
        return self.db.getPlaylists()

    #returns all the songs from a playlist
    def getSongsFromPlaylist(self, playlistID):
        return self.db.getSongsFromPlaylist(playlistID)


    #################### SONG ####################

    #saves an uploaded song in the filesystem and DB
    def addSong(self, file, deviceID):
        filename = secure_filename(file.filename)
        filepath = os.path.join('$HOME/Music/', filename)
        songID = self.db.addSong("file://" + filepath, deviceID)
        if songID > 0:
            file.save(filepath)
            audiofile=eyed3.load(filepath)
            try:
                self.db.addSongMetaData(songID, audiofile.tag.title, audiofile.tag.artist, audiofile.tag.album, audiofile.tag.genre.name, int(audiofile.info.time_secs))
            except:
                self.db.addSongMetaData(songID, "None", "None", "None", "None", 0)
        return songID

    #returns all saved songs
    def getSongs(self):
        return self.db.getSongs()