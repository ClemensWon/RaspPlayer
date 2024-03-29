from datetime import datetime
from flask import Flask,jsonify, request
from functools import wraps
from classes import User, Session, Admin, User
import json
import jwt
import datetime

#Parameter check incoming

app = Flask(__name__)
app.config['SECRET_KEY'] = 'SECRETKEY'

songs = [{"id":0, "name" : "Sockosophie","artist" : "Kaeptn Peng", "genre" : "Rap", "released" : "2013", "album": "test-album", "addedBy": "Alex"},{"id":1,"name" : "Panikk in der Diskko","artist" : "ODMGIDA feat Kex Kuhl", "genre" : "Rap", "released" : "2020", "album": "test-album" , "addedBy": "Bob"},{"id":2,"name" : "Awkward", "artist" : "Duzoe", "genre" : "Rap", "released" : "2020", "album": "test-album" , "addedBy": "Clemens"}]


session = Session.Session('default')
session.clearQueue()
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

        check = 0

        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        except:
            print('INVALID TOKEN')
            return jsonify({'message': 'Invalid Token'}), 401

        if data.get('admin'):
            return func(*args, **kwargs)
        elif session.getBanned(data.get('deviceId')):
            print('device banned')
            return jsonify({'message': 'DeviceId banned'}), 401
        elif not data.get('sessionPin') == session.sessionPin:
            print ('sessionPin not registered')
            return jsonify({'message': 'SessionPin not registered'}), 401

        for user in session.users:
            if user.deviceId == data.get('deviceId'):
                return func(*args, **kwargs)
            else:
                continue
            
        return jsonify({'message': 'This Device is not a user in the current Session'}), 401

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

#MULTI

@app.route('/login', methods = ["POST"])
@checkJsonValid
def login():
    requestData = request.get_json()
    if(requestData['sessionPin'] == session.sessionPin):
        token = jwt.encode({
            'username': requestData['username'],
            'sessionPin': session.sessionPin,
            'deviceId' : requestData['deviceId']
        },
        app.config['SECRET_KEY'], algorithm="HS256")
        newUser = User.User(requestData['deviceId'], requestData['username'], 0, token)
        session.insertUser(newUser)
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
        },
        app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify(
            {'token': token}
        )
    else:
        return jsonify(
            {'message': 'Login as Master was not sucessfull'}
        ), 401

@app.route('/sessionPin', methods = ["GET"])
@checkForAdmin
def getSessionPin():
    return jsonify(
        {'sessionPin': session.sessionPin}
    )

@app.route('/volume', methods = ["GET"])
@checkForUser
def getVolume():
    return jsonify(
        {'Volume': session.volume}
    )


#SONGS

@app.route('/songs', methods = ["GET"])
@checkForUser
def returnAllSongs():
    songs = session.getSongs()
    return jsonify(
        songs
    )

@app.route('/songs/<id>', methods = ["GET"])
@checkForUser
def returnOneSong(id):
    song = session.getSpecSong(id)
    return jsonify(
        song
    )

#SESSION

@app.route('/session/currentSong/like', methods = ["PUT"])
@checkForUser
def likeSong():
    session.likeCurr()
    return jsonify(
        {'message': 'song Liked'}
    )

@app.route('/session/start', methods = ['PUT'])
@checkForUser
def startSession():
    session = Session.Session("default")
    return jsonify(
        {'session': "Created New"}
    )

@app.route('/session/users/return', methods = ['GET'])
@checkForUser
def returnUsers():
    users = session.returnUsers()
    return jsonify(
        users
    )


#################### PLAYER CONTROLS ####################

#calls a function in Session.py to set the player volume to the specified amount
@app.route('/session/volume/<amount>', methods = ['PUT'])
@checkForUser
def setVolume(amount):
    session.setvolume(int(amount))
    return jsonify(
        {'volume': amount}
    )

#calls a function in Session.py to mute the player volume
@app.route('/session/volume/mute', methods = ['PUT'])
@checkForUser
def muteVolume():
    session.mute()
    return jsonify(
        {'volume': 'muted'}
    )

#calls a function in Session.py to skip the current song, if the specified skipvote percentage is met
@app.route('/session/currentSong/skip', methods = ['PUT'])
@checkForUser
def skipCurrentSong():

    check = 0
    for user in session.muted:
        if user == data.get('deviceId'):
            return jsonify({'message': 'This Device is muted'}), 401
        else:
            continue

    for user in session.skipList:
        if user == request.headers.get('deviceId'):
            check = 1
        else:
            continue

    if check == 0:
        session.skipList.append(request.headers.get('deviceId'))

    for user in session.skipList:
        print(user)

    session.skip()
    return jsonify(
        {'currentSong': session.queue[0]}
    )

#calls a function in Session.py to pause/resume the player
@app.route('/session/currentSong/pause', methods = ["PUT"])
def currentSongPause():
    session.pause()
    return 'pause/resume'

#calls a function in Session.py to replay the currently playing song
@app.route('/session/currentSong/replay', methods = ['GET'])
@checkForUser
def replayCurrentSong():
    session.replay()
    return jsonify(
        {'currentSong': session.currentSong}
    )


#################### QUEUE ####################

#calls a function in Session.py to return all songs in the queue
@app.route('/session/queue', methods = ['GET'])
#@checkForUser
def returnQueue():
    queue = session.returnQueue()
    return jsonify(
        queue
    )

#calls a function in Session.py to add one or more songs to the queue
@app.route('/session/queue/addSongs', methods = ['POST'])
#@checkForUser
def addSongToQueue():
    requestData = request.get_json()
    songPos = session.songToQueue(requestData['songIDs'])
    return jsonify(
        {'message': 'done'}
    )

#calls a function in Session.py to delete the specified song from the queue
@app.route('/session/queue/deleteSong', methods = ['DELETE'])
#@checkForUser
def deleteSongFromQueue():
    requestData = request.get_json()
    session.deleteFromQueue(requestData['songID'])
    return jsonify(
        {'message': 'song deleted from queue'}
    )

#calls a function in Session.py to start playing the queue
@app.route('/session/queue/play', methods = ['POST'])
#@checkForUser
def playQueue():
    session.playQueue()
    return jsonify(
        {'message': 'playing queue'}
    )


#################### SONG ####################

#calls a function in Session.py to store the uploaded song in the filesystem and database
@app.route('/library/upload', methods = ['POST'])
#@checkForUser
def uploadSong():
    file = request.files['file']
    songID = session.addSong(file, request.headers.get('deviceID'))
    if songID > 0:
        return jsonify(
            {'message': 'song added to library'}
        )
    else:
        return jsonify(
            {'error': 'song already in library'}
        ), 400

#calls a function in Session.py to return all stored songs
@app.route('/library/songs', methods = ['GET'])
#@checkForUser
def getSongs():
    songs = session.getSongs()
    print(songs)
    return jsonify(
        songs
    )


#################### PLAYLIST ####################

#calls a function in Session.py to create a new playlist
@app.route('/session/playlist/create', methods = ['PUT'])
#@checkForUser
@checkJsonValid
def createPlaylist():
    requestData = request.get_json()
    playlistID = session.createPlaylist(requestData['playlistName'], requestData['deviceID'])
    if playlistID > 0:
        return jsonify(
            {'playlistID': playlistID}
        )
    else:
        return jsonify(
            {'error': 'playlistName already exists'}
        ), 400

#calls a function in Session.py to add songs to a playlist
@app.route('/session/playlist/addSongs', methods = ['PUT'])
#@checkForUser
@checkJsonValid
def addSongToPlaylist():
    requestData = request.get_json()
    success = session.addSongToPlaylist(requestData['songIDs'], requestData['playlistID'])
    return jsonify(
        {'message': 'done'}
    )

#calls a function in Session.py to delete a song from a playlist
@app.route('/session/playlist/deleteSong', methods = ['DELETE'])
#@checkForUser
@checkJsonValid
def deleteSongFromPlaylist():
    requestData = request.get_json()
    session.deleteSongFromPlaylist(requestData['songID'], requestData['playlistID'])
    return jsonify(
        {'message': 'song deleted from playlist'}
    )

#calls a function in Session.py to start playing a playlist from the beginning
@app.route('/session/playlist/play', methods = ['POST'])
#@checkForUser
@checkJsonValid
def playPlaylist():
    requestData = request.get_json()
    session.playPlaylist(requestData['playlistID'])
    return jsonify(
        {'message': 'playing playlist'}
    )

#calls a function in Session.py to return all playlists
@app.route('/session/playlists', methods = ['GET'])
#@checkForUser
def getPlaylists():
    playlists = session.getPlaylists()
    return jsonify(
        playlists
    )

#calls a function in Session.py to return all songs from a playlist
@app.route('/session/playlist/songs/<playlistID>', methods = ['GET'])
#@checkForUser
def getSongsFromPlaylist(playlistID):
    songs = session.getSongsFromPlaylist(playlistID)
    return jsonify(
        songs
    )

#################### USER ####################

@app.route('/users/ban/<deviceId>', methods = ["PUT"])
@checkForAdmin
def banUser(deviceId):
    session.banUser(deviceId)
    return jsonify(
        {'message': 'User banned'}
    )

@app.route('/users/unban/<deviceId>', methods = ["PUT"])
@checkForAdmin
def unbanUser(deviceId):
    session.unbanUser(deviceId)
    return jsonify(
        {'message': 'User unbanned'}
    )

@app.route('/users/muteAll')
@checkForAdmin
def mutAll():
    #mute All users
    return 'mute'

@app.route('/users/kickAll', methods = ["PUT"])
@checkForAdmin
def kickAll():
    session.kickAll()
    return jsonify(
        {'message': 'All kicked'}
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    
#@app.route("/login/master", methods = ["POST"])
#def returnMasterJWT():
#    password = request.body.password
#    if password == master:
