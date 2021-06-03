import json

class Session:
    def __init__(this,sessionPin):
        this.sessionPin = sessionPin
        this.users = []
        this.queue = []
        this.currentSong = ''

    def returnUsers(this):
        users = {}
        i = -1
        for user in this.users:
            i=i+1
            users['user'+ str(i)] = user.username
        return users