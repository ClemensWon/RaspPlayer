import mariadb
import sys

try:
    conn = mariadb.connect(
        user="johnlennon",
        password="woodstock69",
        host="localhost",
        port=3306,
        database="RaspPlayer"

    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)

cur = conn.cursor()

def insertUser(deviceID, username, banned, token):
    cur.execute(
        "INSERT INTO User (deviceID, username, banned, token) VALUES (?, ?, ?, ?)", 
        (deviceID, username, banned, token))

    conn.commit()
    conn.close()

def getUsers():
    cur.execute("SELECT * FROM User")

    return cur