import json

class Session:
    def __init__(this,sessionPin):
        this.sessionPin = sessionPin
        this.users = []
        this.queue = [1,3,4,2,5]
        this.playlist = 0           #playlistId
        this.usersMuted = []

    def returnUsers(this):
        users = {}
        i = -1
        for user in this.users:
            i=i+1
            users['user'+ str(i)] = user.username
        return users
    
    def returnQueue (this):
        queue = {}
        i = -1
        for song in this.queue:
            i=i+1
            queue['song@'+ str(i)] = song #ID
        return queue