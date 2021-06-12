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

    def getSongs(self):
        self.cur.execute("SELECT * FROM Song")

        return self.cur

    def getSpecSong(self,id):
        self.cur.execute("SELECT * FROM Song WHERE songID = ?",
        (id,))

        return self.cur

    def getBanned(self, deviceId):
        self.cur.execute("SELECT banned FROM User WHERE deviceID = ?",
        (deviceId,))

        return self.cur

    def getToken(self, deviceId):
        self.cur.execute("SELECT token FROM User WHERE deviceID = ?",
        (deviceId,))

        return self.cur