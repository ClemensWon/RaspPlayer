import mariadb
import sys

class DB:
    def __init__(self):
        try:
            self.pool = mariadb.connect(
                user="johnlennon",
                password="woodstock69",
                host="localhost",
                port=3306,
                pool_name="raspplayer",
                pool_size=20,
                database="RaspPlayer"
            )
        except mariadb.Error as e:
            print(f"Error connecting to MariaDB Platform: {e}")
            sys.exit(1)
        
        # cur = pconn.cursor()


    def get_pool_connection(self):
        try:
            pconn = self.pool.get_connection()

        except mariadb.PoolError as e:

            # Report Error
            print(f"Error opening connection from pool: {e}")

            # Create New Connection as Alternate
            pconn = mariadb.connection(
                user="johnlennon",
                password="woodstock69",
                host="localhost",
                port=3306,
                database="RaspPlayer")
        
        return pconn


    def insertUser(self,deviceId, username, banned, token):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute(
                "INSERT INTO User (deviceID, username, banned, token) VALUES (?,?,?,?)", 
                (deviceId, username, banned, token)) 
            pconn.commit()

        except:
            print("Already there")
            try:
                cur.execute(
                "UPDATE User SET username = ?, banned = ?, token = ? WHERE deviceID = ?",
                (username, banned, token, deviceId))     
                pconn.commit()

            except:
                print("Did not work")
        
        pconn.close()


    def getUsers(self):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM User")
        except:
            print("Error from getUsers")

        return cur

    
    def getUser(self,deviceId):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM User WHERE deviceID = ?", (deviceId,))
            result = cur.fetchall()
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from getUser")


    def getSpecSong(self,id):
        cur.execute("SELECT * FROM Song WHERE songID = ?",
        (id,))

        return cur

    def likeSong(self,id):
        cur.execute("UPDATE Song SET likes = likes+1 WHERE songID = ?",
        (id,))
        return

    def banUser(self,deviceId):
        cur.execute("UPDATE User SET banned = 1 WHERE deviceId = ?",
        (deviceId,))
        return

    def unbanUser(self,deviceId):
        cur.execute("UPDATE User SET banned = 0 WHERE deviceId = ?",
        (deviceId,))
        return

    def getBanned(self, deviceId):
        cur.execute("SELECT banned FROM User WHERE deviceID = ?",
        (deviceId,))

        return cur

    def getToken(self, deviceId):
        cur.execute("SELECT token FROM User WHERE deviceID = ?",
        (deviceId,))

        return cur

    def getInterpretToSong(self, songID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM InterpretToSong WHERE songID = ?", (songID,))
            result = cur.fetchall()
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from getInterpretToSong")

    def getInterpret(self, interpretID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM Interpret WHERE interpretID = ?",(interpretID,))
            result = cur.fetchall()
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from getInterpret")
        

    #################### PLAYLISTS ####################

    def createPlaylist(self, playlistName, deviceID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("INSERT INTO Playlist (playlistName, nextSongPos, deviceID) VALUES (?, ?, ?)", (playlistName, 0, deviceID))
            pconn.commit()
            result = cur.lastrowid
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from createPlaylist")
            return -1


    def insertSongToPlaylist(self, songID, playlistID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT nextSongPos FROM Playlist WHERE playlistID = ?", (playlistID,))
            nextSongPos = cur.fetchall()[0][0]
            try:
                cur.execute("INSERT INTO SongToPlaylist (playlistID, songID, songPos) VALUES (?, ?, ?)", (playlistID, songID, nextSongPos))
                pconn.commit()
                pconn.close()
                return True
            except:
                return False
        except:
            pconn.close()
            print("Error from insertSongToPlaylist")


    def deleteSongFromPlaylist(self, songID, playlistID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT songPos FROM SongToPlaylist WHERE songID = ? and playlistID = ?", (songID, playlistID))
            songPos = cur.fetchall()[0][0]

            cur.execute("UPDATE SongToPlaylist SET songPos = songPos-1 WHERE playlistID = ? and songPos > ?", (playlistID, songPos))

            cur.execute("UPDATE Playlist SET nextSongPos = nextSongPos-1 WHERE playlistID = ?", (playlistID,))

            cur.execute("DELETE FROM SongToPlaylist WHERE songID = ? and playlistID = ?", (songID, playlistID))

            pconn.commit()
            pconn.close()
        except:
            pconn.close()
            print("Error from deleteSongFromPlaylist")


    def getPlaylists(self):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM Playlist INNER JOIN User ON Playlist.deviceID = User.deviceID")
            playlists = []
            for (playlistID, playlistName, nextSongPos, deviceIDPlaylist, deviceID, username, banned, token) in cur:
                playlists.append({
                    'playlistID': playlistID,
                    'playlistName': playlistName,
                    'creator': username,
                    'numberOfSongs': nextSongPos
                })
            
            pconn.close()
            return playlists
        except:
            pconn.close()
            print("Error from getPlaylists")


    def incrementNextSongPos(self, playlistID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("UPDATE Playlist SET nextSongPos = nextSongPos+1 WHERE playlistID = ?", (playlistID,))
            pconn.commit()
            pconn.close()
        except:
            pconn.close()
            print("Error from incrementNextSongPos")


    def getPlaylistName(self, playlistID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT playlistName FROM Playlist WHERE playlistID = ?", (playlistID,))
            result = cur.fetchall()[0][0]
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from getPlaylistName")


    def getSongsFromPlaylist(self, playlistID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM SongToPlaylist INNER JOIN Song ON SongToPlaylist.songID=Song.songID INNER JOIN InterpretToSong ON Song.songID = InterpretToSong.songID INNER JOIN Interpret ON InterpretToSong.interpretID = Interpret.interpretID INNER JOIN User ON Song.deviceID = User.deviceID WHERE playlistID = ?", (playlistID,))
            songs = []
            for (playlistID, songIDSongToPlaylist, songPos, songID, deviceIDSong, songName, genre, duration, likes, skips, album, replays, filepath, songIDInterpretToSong, interpretIDInterpretToSong, interpretID, interpretName, deviceID, username, banned, token) in cur:
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
            
            pconn.close()
            return songs
        except:
            pconn.close()
            print("Error from getSongsFromPlaylist")


    #################### SONG ####################

    def getSongURI(self, songID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT filepath FROM Song WHERE songID = ?", (songID,))
            result = cur.fetchall()[0][0]
            pconn.close()
            return result
        except:
            pconn.close()
            print("Errof from getSongURI")


    def addSong(self, filepath, deviceID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("INSERT INTO Song (deviceID, songName, genre, duration, likes, skips, album, replays, filepath) VALUES (?, ?, ?, ?, ?, ?, ? ,? ,?)", (deviceID, "", "", 0, 0, 0, "", 0, filepath))
            pconn.commit()
            result = cur.lastrowid
            pconn.close()
            return result
        except:
            pconn.close()
            print("Error from addSong")
            return -1

    def addSongMetaData(self, songID, songName, interpretName, album, genre, duration):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("UPDATE Song SET songName = ?, album = ?, genre = ?, duration = ? WHERE songID = ?", (songName, album, genre, duration, songID))
            pconn.commit()
        except:
            print("Error from addSongMetaData")

        try:
            cur.execute("INSERT INTO Interpret (interpretName) VALUES (?)", (interpretName,))
            pconn.commit()
            interpretID = cur.lastrowid
        except:
            cur.execute("SELECT interpretID FROM Interpret WHERE interpretName = ?", (interpretName,))
            interpretID = cur.fetchall()[0][0]

        cur.execute("INSERT INTO InterpretToSong (songID, interpretID) VALUES (? ,?)", (songID, interpretID))
        pconn.commit()
        pconn.close()

    def getSongs(self):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM User INNER JOIN Song ON User.deviceID = Song.deviceID INNER JOIN InterpretToSong ON Song.songID = InterpretToSong.songID INNER JOIN Interpret ON InterpretToSong.interpretID = Interpret.interpretID")
            songs = []
            for (deviceID, username, banned, token, songID, deviceIDSong, songName, genre, duration, likes, skips, album, replays, filepath, songIDInterpretToSong, interpretIDInterpretToSong, interpretID, interpretName) in cur:
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

            pconn.close()
            return songs
        except:
            pconn.close()
            print("Error from getSongs")


    def getSong(self, songID):
        pconn = self.get_pool_connection(self)
        try:
            cur = pconn.cursor()
            cur.execute("SELECT * FROM User INNER JOIN Song ON User.deviceID = Song.deviceID INNER JOIN InterpretToSong ON Song.songID = InterpretToSong.songID INNER JOIN Interpret ON InterpretToSong.interpretID = Interpret.interpretID WHERE Song.songID = ?", (songID,))
            song = {}
            for (deviceID, username, banned, token, songID, deviceIDSong, songName, genre, duration, likes, skips, album, replays, filepath, songIDInterpretToSong, interpretIDInterpretToSong, interpretID, interpretName) in cur:
                song = {
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
                }

            pconn.close()
            return song
        except:
            print("Error from getSong")

            