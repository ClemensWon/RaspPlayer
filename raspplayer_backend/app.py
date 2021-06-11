from datetime import datetime
from flask import Flask,jsonify, request
from functools import wraps
from flask_sqlalchemy import sqlalchemy
from CLasses import User, Session, Admin
import json
import jwt
import datetime

#Parameter check incoming

app = Flask(__name__)
app.config['SECRET_KEY'] = 'SECRETKEY'

songs = [{"id":0, "name" : "Sockosophie","artist" : "Kaeptn Peng", "genre" : "Rap", "released" : "2013", "album": "test-album", "addedBy": "Alex"},{"id":1,"name" : "Panikk in der Diskko","artist" : "ODMGIDA feat Kex Kuhl", "genre" : "Rap", "released" : "2020", "album": "test-album" , "addedBy": "Bob"},{"id":2,"name" : "Awkward", "artist" : "Duzoe", "genre" : "Rap", "released" : "2020", "album": "test-album" , "addedBy": "Clemens"}]


session = Session.Session('default')
admin   = Admin.Admin()

def checkForAdmin(func):
    @wraps(func)
    def wrapped(*args, **kwargs):
        token = request.headers.get('Token')
        if not token:
            return jsonify({'message': 'Missing token'}), 403
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            if not data.get('admin'):
                return jsonify({'message': 'User is not admin'}), 401
        except:
            return jsonify({'message': 'Invalid Token'}), 401
        return func(*args, **kwargs)
    return wrapped

def checkForUser(func):
    @wraps(func)
    def wrapped(*args, **kwargs):
        token = request.headers.get('Token')
        if not token:
            return jsonify({'message': 'Missing token'}), 403
        try:
            #check if device Id is banned
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            if data.get('admin'):
                return func(*args, **kwargs)
            elif not data.get('sessionPin') == session.sessionPin:
                return jsonify({'message': 'SessionPin not registered'}), 401
        except:
            return jsonify({'message': 'Invalid Token'}), 401
        return func(*args, **kwargs)
    return wrapped

def checkJsonValid(func):
    @wraps(func)
    def wrapped(*args, **kwargs):
        if request.is_json:
            data = request.get_json()
            try:
                test=json.dumps(data)
                return func(*args, **kwargs)
            except ValueError as e:
                return jsonify({'message': 'invalid json'}), 400
        else:
            return jsonify({'message': 'data is not json'}), 400
    return wrapped

#Testvariables
@app.route('/login', methods = ["POST"])
@checkJsonValid
def login():
    requestData = request.get_json()
    if(requestData['sessionPin'] == session.sessionPin):
        #create User in database
        #log deviceId to Database
        newUser = User.User(requestData['username'])
        session.users.append(newUser)
        token = jwt.encode({
            'username': requestData['username'],
            'sessionPin': session.sessionPin,
            'exp': datetime.datetime.utcnow()+datetime.timedelta(minutes=30)
        },
        app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify(
            {'token': token}
        )
    else:
        return jsonify(
            {'message': 'SessionPin was not correct'}
        ), 401

@app.route('/login/master', methods = ["POST"])
@checkJsonValid
def loginMaster():
    requestData = request.get_json()
    if requestData['password'] == admin.password and requestData['username'] == admin.username:
        token = jwt.encode({
            'username': requestData['username'],
            'admin': 'yes',
            'sessionPin': session.sessionPin,
            'exp': datetime.datetime.utcnow()+datetime.timedelta(minutes=30)
        },
        app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify(
            {'token': token}
        )
    else:
        return jsonify(
            {'message': 'Login as Master was not sucessfull'}
        ), 401

@app.route('/songs', methods = ["GET"])
@checkForUser
def returnAllSongs():
    return jsonify(
        {'songs': songs}
    )

@app.route('/')
def index():
    return 'Hello World'

@app.route('/songs/<string:name>', methods = ["GET"])
@checkForUser
def returnOneSong(name):
    oneSong = [songs for songs in songs if songs['name'] == name]
    return jsonify(
        {'song': oneSong}
    )

@app.route('/settings/sessionPin', methods = ["POST"])
@checkForAdmin
@checkJsonValid
def changeSessionPin():
    requestData = request.get_json()
    session.sessionPin = requestData['newPin']
    return jsonify(
        {'sessionPin': session.sessionPin}
    )

@app.route('/session/currentSong/like', methods = ["PUT"])
@checkForUser
@checkJsonValid
def likeSong():
    return jsonify(
        {'message': 'song Liked'}
    )

@app.route('/users/ban/<userId>', methods = ["PUT"])
@checkForUser
@checkJsonValid
#ban User
def banUser():
    return jsonify(
        {'message': 'song Liked'}
    )

@app.route('/session/currentSong/get', methods = ["PUT"])
@checkForUser
@checkJsonValid
#Get song from DB
def getCurrentSong():
    return jsonify(
        {'message': 'get Song'}
    )

@app.route('/session/currentSong/pause')
def currentSongPause():
    session.pause()
    return 'pause/resume'

@app.route('/settings')
def settings():
    #get Settings
    return 'settings'

@app.route('/users/muteAll')
def mutAll():
    #mute All users
    return 'mute'

@app.route('/users/kickAll')
def kickAll():
    #kick All users
    return 'kick'

@app.route('/session/setPlaylist')
def setPlaylist():
    #setPlaylistId
    return 'setPlaylist'

@app.route('/session/setCurrentSong/<songId>', methods = ["PUT"])
@checkForAdmin
@checkJsonValid
def setCurrentSong(songId):
    session.currentSong = songId
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/skip', methods = ['GET'])
@checkForUser
def skipCurrentSong():
    session.skip()
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/play', methods = ['GET'])
@checkForUser
def playCurrentSong():
    session.play()
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/stop', methods = ['GET'])
@checkForUser
def replayCurrentSong():
    session.replay()
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/start', methods = ['GET'])
@checkForUser
def startSession():
    session = Session.Session("default")
    return jsonify(
        {'session': "Created New"}
    )

@app.route('/statistics', methods = ["GET"])
@checkForUser
def getStatistics():
    return jsonify(
        {
            'statistics': 'yes',
            'bestDj': {
                'username': 'DJ Ötzi',
                'likes': 2,
            },
            'bestSong': {
                'songname': 'Song1',
                'likes': 69,
            },
            'favArtist': {
                'artistname': 'Mozart',
                'likes': 123,
            },
            'playlistJunkie': {
                'username': 'MoneyBoy',
                'songsAdded': 123,
            },
            'mostReplays': {
                'songname': 'Song24',
                'replays': 5,
            },
            'mostSkipped': {
                'songname': 'Song99',
                'skipped': 19,
            },
        }
    )

@app.route('/session/queue/add/<songId>', methods = ['PUT'])
@checkForUser
def addSongToQueue(songId):
    session.songToQueue(songId)
    return jsonify(
        {'queue': songId}
    )

@app.route('/Library/upload', methods = ['POST'])
@checkForUser
def uploadSong():
    return jsonify(
        {'upload': 'yes'}
    )

@app.route('/Session/Volume/<amount>', methods = ['GET'])
@checkForUser
def setVolume(amount):
    session.setvolume(int(amount))
    return jsonify(
        {'volume': amount}
    )

@app.route('/Session/Volume/mute', methods = ['GET'])
@checkForUser
def muteVolume():
    session.mute()
    return jsonify(
        {'volume': 'muted'}
    )

@app.route('/Session/Mute/<username>', methods = ['PUT'])
@checkForUser
@checkJsonValid
def muteUser(username):
    return jsonify(
        {'muted': username}
    )

@app.route('/Session/Users/return', methods = ['GET'])
@checkForUser
def returnUsers():
    users = session.returnUsers()
    return jsonify(
        users
    )

@app.route('/Session/Queue/return', methods = ['GET'])
@checkForUser
def returnQueue():
    songs = session.returnQueue()
    return jsonify(
        songs
    )

@app.route('/Session/Queue/delete/<songId>', methods = ['GET'])
@checkForUser
def deleteSongFromQueue():
    return jsonify(
        songs
    )

@app.route('/Session/playlist/get/', methods = ['GET'])
@checkForUser
def getPlaylist():
    #getPlaylistData
    return jsonify(
        {'message': 'getPlaylist'}
    )

@app.route('/Session/playlist/delete/<songId>', methods = ['GET'])
@checkForUser
def deleteSongFromPlaylist():
    #deleteSongFromPlaylist
    return jsonify(
        {'message': 'delete Playlist'}
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    
#@app.route("/login/master", methods = ["POST"])
#def returnMasterJWT():
#    password = request.body.password
#    if password == master:
