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

    def insertUser(self,deviceID, username, banned, token):
        self.cur.execute(
            "INSERT INTO User (deviceID, username, banned, token) VALUES (?, ?, ?, ?)", 
            (deviceID, username, banned, token))

        self.conn.commit()

    def getUsers(self):
        self.cur.execute("SELECT * FROM User")

        return self.cur