from datetime import datetime
from flask import Flask,jsonify, request
from functools import wraps
from flask_sqlalchemy import sqlalchemy
from CLasses import User, Session, Admin
import jwt
import datetime


#FIX ADMIN TOKEN? OTHER WAY TO AUTH ADMIN THEN IN TOKEN THAT CAN BE SEEN

app = Flask(__name__)
app.config['SECRET_KEY'] = 'SECRETKEY'

songs = [{'name' : 'Sockosophie','artist' : 'Kaeptn Peng', 'genre' : 'Rap', 'released' : '2013'},{'name' : 'Panikk in der Diskko','artist' : 'ODMGIDA feat Kex Kuhl', 'genre' : 'Rap', 'released' : '2020'},{'name' : 'Awkward', 'artist' : 'Duzoe', 'genre' : 'Rap', 'released' : '2020'}]


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
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            if data.get('admin'):
                return func(*args, **kwargs)
            elif not data.get('sessionPin') == session.sessionPin:
                return jsonify({'message': 'SessionPin not registered'}), 401
        except:
            return jsonify({'message': 'Invalid Token'}), 401
        return func(*args, **kwargs)
    return wrapped

#Testvariables

@app.route('/')
def index():
    return 'Hello World'

@app.route('/login', methods = ["POST"])
def login():
    requestData = request.get_json()
    if(requestData['sessionPin'] == session.sessionPin):
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

@app.route('/songs/<string:name>', methods = ["GET"]) 
def returnOneSong(name):
    oneSong = [songs for songs in songs if songs['name'] == name]
    return jsonify(
        {'song': oneSong}
    )

@app.route('/settings/sessionPin', methods = ["POST"])
@checkForAdmin
def changeSessionPin():
    requestData = request.get_json()
    session.sessionPin = requestData['newPin']
    return jsonify(
        {'sessionPin': session.sessionPin}
    )

@app.route('/session/currentSong/like', methods = ["PUT"])
@checkForUser
def likeSong():
    #like in DB
    return jsonify(
        {'message': 'song Liked'}
    )

@app.route('/session/setCurrentSong/<songId>', methods = ["PUT"])
@checkForAdmin
def setCurrentSong(songId):
    session.currentSong = songId
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/skip', methods = ['GET'])
@checkForUser
def skipCurrentSong():
    session.currentSong = 'nextSong'
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/play', methods = ['GET'])
@checkForUser
def playCurrentSong():
    session.currentSong = 'play'
    #currentSong = nextSong
    return jsonify(
        {'currentSong': session.currentSong}
    )

@app.route('/session/currentSong/replay', methods = ['GET'])
@checkForUser
def replayCurrentSong():
    session.currentSong = 'replay'
    #currentSong = nextSong
    return jsonify(
        {'currentSong': session.currentSong}
    )

'''
BRAUCHEN  WIR DAS NOCH?
@app.route('/session/end', methods = ['GET'])
@checkForAdmin
def endSession():
    #currentSong = nextSong
    return jsonify(
        {'session': thisSession}
    )
'''

@app.route('/session/start', methods = ['GET'])
@checkForAdmin
def startSession():
    session = Session.Session("default")
    #currentSong = nextSong
    return jsonify(
        {'session': "Created New"}
    )

@app.route('/statistics', methods = ["GET"])
@checkForUser
def getStatistics():
    #get statistics
    return jsonify(
        {'statistics': 'yes'}
    )

@app.route('/session/queue/add/<songId>', methods = ['PUT'])
@checkForUser
def addSongToQueue(songName):
    #addSongHere
    return jsonify(
        {'queue': songName}
    )

@app.route('/Library/upload', methods = ['POST'])
@checkForUser
def uploadSong():
    #uploadSong
    return jsonify(
        {'upload': 'yes'}
    )

@app.route('/Session/Volume/<amount>', methods = ['GET'])
@checkForUser
def setVolume(amount):
    #setSessionVolume
    return jsonify(
        {'volume': amount}
    )

@app.route('/Session/Volume/mute', methods = ['GET'])
@checkForUser
def muteVolume():
    #muteVolume
    return jsonify(
        {'volume': 'muted'}
    )

@app.route('/Session/Mute/<username>', methods = ['PUT'])
@checkForUser
def muteUser(username):
    #muteUser
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


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    
#@app.route("/login/master", methods = ["POST"])
#def returnMasterJWT():
#    password = request.body.password
#    if password == master:
