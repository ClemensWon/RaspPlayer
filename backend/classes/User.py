class User:
    
    def __init__(this, deviceId, username, banned, token):
        this.username=username
        this.deviceId=deviceId
        this.token=token
        this.banned=banned
        this.muted= ''
        this.counterPosMuted= ''
        this.counterNegMuted= ''