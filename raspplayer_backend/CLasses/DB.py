import mariadb
import sys

class DB:
    def __init__(self):
        try:
            self.conn = mariadb.connect(
                user="johnlennon",
                password="woodstock69",
                host="localhost",
                port=3306,
                database="RaspPlayer"
            )
        except mariadb.Error as e:
            print(f"Error connecting to MariaDB Platform: {e}")
            sys.exit(1)
        
        self.cur = self.conn.cursor()

    def insertUser(self,deviceId, username, banned, token):
        try:
            self.cur.execute(
                "INSERT INTO User (deviceID, username, banned, token) VALUES (?,?,?,?)", 
                (deviceId, username, banned, token)) 
            self.conn.commit()

        except:
            print("Already there")
            try:
                self.cur.execute(
                "UPDATE User SET username = ?, banned = ?, token = ? WHERE deviceID = ?",
                (username, banned, token, deviceId))     
                self.conn.commit()
            except:
                print("Did not work")

    def getUsers(self):
        self.cur.execute("SELECT * FROM User")

        return self.cur
    
    def getUser(self,deviceId):
        self.cur.execute("SELECT * FROM User WHERE deviceID = ?", (deviceId,))
        return self.cur.fetchall()

    def getSongs(self):
        self.cur.execute("SELECT * FROM Song")

        return self.cur.fetchall()

    def getSpecSong(self,id):
        self.cur.execute("SELECT * FROM Song WHERE songID = ?",
        (id,))

        return self.cur

    def likeSong(self,id):
        self.cur.execute("UPDATE Song SET likes = likes+1 WHERE songID = ?",
        (id,))
        return

    def banUser(self,deviceId):
        self.cur.execute("UPDATE User SET banned = 1 WHERE deviceId = ?",
        (deviceId,))
        return

    def unbanUser(self,deviceId):
        self.cur.execute("UPDATE User SET banned = 0 WHERE deviceId = ?",
        (deviceId,))
        return

    def getBanned(self, deviceId):
        self.cur.execute("SELECT banned FROM User WHERE deviceID = ?",
        (deviceId,))

        return self.cur

    def getToken(self, deviceId):
        self.cur.execute("SELECT token FROM User WHERE deviceID = ?",
        (deviceId,))

        return self.cur

    def getInterpretToSong(self, songID):
        self.cur.execute("SELECT * FROM InterpretToSong WHERE songID = ?", (songID,))
        return self.cur.fetchall()

    def getInterpret(self, interpretID):
        self.cur.execute("SELECT * FROM Interpret WHERE interpretID = ?",(interpretID,))
        return self.cur.fetchall()
        

    #################### PLAYLISTS ####################

    def createPlaylist(self, playlistName, deviceID):
        try:
            self.cur.execute("INSERT INTO Playlist (playlistName, nextSongPos, deviceID) VALUES (?, ?, ?)", (playlistName, 0, deviceID))
            self.conn.commit()
            return self.cur.lastrowid
        except:
            return -1

    def insertSongToPlaylist(self, songID, playlistID):
        self.cur.execute("SELECT nextSongPos FROM Playlist WHERE playlistID = ?", (playlistID,))
        nextSongPos = self.cur.fetchall()[0][0]
        try:
            self.cur.execute("INSERT INTO SongToPlaylist (playlistID, songID, songPos) VALUES (?, ?, ?)", (playlistID, songID, nextSongPos))
            self.conn.commit()
            return True
        except:
            return False

    def deleteSongFromPlaylist(self, songID, playlistID):
        self.cur.execute("SELECT songPos FROM SongToPlaylist WHERE songID = ? and playlistID = ?", (songID, playlistID))
        songPos = self.cur.fetchall()[0][0]

        self.cur.execute("UPDATE SongToPlaylist SET songPos = songPos-1 WHERE playlistID = ? and songPos > ?", (playlistID, songPos))

        self.cur.execute("UPDATE Playlist SET nextSongPos = nextSongPos-1 WHERE playlistID = ?", (playlistID,))

        self.cur.execute("DELETE FROM SongToPlaylist WHERE songID = ? and playlistID = ?", (songID, playlistID))

        self.conn.commit()

    def getPlaylists(self):
        self.cur.execute("SELECT * FROM Playlist INNER JOIN User ON Playlist.deviceID = User.deviceID")
        playlists = []
        for (playlistID, playlistName, nextSongPos, deviceIDPlaylist, deviceID, username, banned, token) in self.cur:
            playlists.append({
                'playlistID': playlistID,
                'playlistName': playlistName,
                'creator': username,
                'numberOfSongs': nextSongPos
            })
        return playlists

    def incrementNextSongPos(self, playlistID):
        self.cur.execute("UPDATE Playlist SET nextSongPos = nextSongPos+1 WHERE playlistID = ?", (playlistID,))
        self.conn.commit()

    def getPlaylistName(self, playlistID):
        self.cur.execute("SELECT playlistName FROM Playlist WHERE playlistID = ?", (playlistID,))
        return self.cur.fetchall()[0][0]

    def getSongsFromPlaylist(self, playlistID):
        self.cur.execute("SELECT * FROM SongToPlaylist INNER JOIN Song ON SongToPlaylist.songID=Song.songID INNER JOIN InterpretToSong ON Song.songID = InterpretToSong.songID INNER JOIN Interpret ON InterpretToSong.interpretID = Interpret.interpretID INNER JOIN User ON Song.deviceID = User.deviceID WHERE playlistID = ?", (playlistID,))
        songs = []
        for (playlistID, songIDSongToPlaylist, songPos, songID, deviceIDSong, songName, genre, duration, likes, skips, album, replays, filepath, songIDInterpretToSong, interpretIDInterpretToSong, interpretID, interpretName, deviceID, username, banned, token) in self.cur:
            songs.append({
                'songID': songID,
                'addedBy': username,
                'songName': songName,
                'genre': genre,
                'duration': duration,
                'likes': likes,
                'skips': skips,
                'album': album,
                'replays': songID,
                'filepath': filepath,
                'songPos': songPos,
                'interpretName': interpretName
            })
        return songs


    #################### SONG ####################

    def getSongURI(self, songID):
        self.cur.execute("SELECT filepath FROM Song WHERE songID = ?", (songID,))
        return self.cur.fetchall()[0][0]

    def addSong(self, filepath, deviceID):
        try:
            self.cur.execute("INSERT INTO Song (deviceID, songName, genre, duration, likes, skips, album, replays, filepath) VALUES (?, ?, ?, ?, ?, ?, ? ,? ,?)", (deviceID, "", "", 0, 0, 0, "", 0, filepath))
            self.conn.commit()
            return self.cur.lastrowid
        except:
            return -1

    def addSongMetaData(self, songID, songName, interpretName, album, genre, duration):
        self.cur.execute("UPDATE Song SET songName = ?, album = ?, genre = ?, duration = ? WHERE songID = ?", (songName, album, genre, duration, songID))
        self.conn.commit()

        try:
            self.cur.execute("INSERT INTO Interpret (interpretName) VALUES (?)", (interpretName,))
            self.conn.commit()
            interpretID = self.cur.lastrowid
        except:
            elf.cur.execute("SELECT interpretID FROM Interpret WHERE interpretName = ?", (interpretName,))
            self.conn.commit()
            interpretID = self.cur.fetchall()[0][0]

        self.cur.execute("INSERT INTO InterpretToSong (songID, interpretID) VALUES (? ,?)", (songID, interpretID))
        self.conn.commit()

    def getSongs(self):
        self.cur.execute("SELECT * FROM User INNER JOIN Song ON User.deviceID = Song.deviceID INNER JOIN InterpretToSong ON Song.songID = InterpretToSong.songID INNER JOIN Interpret ON InterpretToSong.interpretID = Interpret.interpretID")
        songs = []
        for (deviceID, username, banned, token, songID, deviceIDSong, songName, genre, duration, likes, skips, album, replays, filepath, songIDInterpretToSong, interpretIDInterpretToSong, interpretID, interpretName) in self.cur:
            songs.append({
                'songID': songID,
                'addedBy': username,
                'songName': songName,
                'genre': genre,
                'duration': duration,
                'likes': likes,
                'skips': skips,
                'album': album,
                'replays': replays,
                'filepath': filepath,
                'interpretName': interpretName
            })
        return songs