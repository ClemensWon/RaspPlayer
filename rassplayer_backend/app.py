from datetime import datetime
from flask import Flask,jsonify, request
from functools import wraps
from flask_sqlalchemy import SQLAlchemy
from Classes.db import *
import jwt
import pprint
import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = 'SECRETKEY'

def checkForToken(func):
    @wraps(func)
    def wrapped(*args, **kwargs):
        token = request.args.get('token')
        if not token:
            return jsonify({'message': 'Missing token'}), 403
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        except:
            return jsonify({'message': 'Invalid Token'}), 403
        return func(*args, **kwargs)
    return wrapped

#Testvariables

songs = [{'name' : 'Sockosophie','artist' : 'Kaeptn Peng', 'genre' : 'Rap', 'released' : '2013'},{'name' : 'Panikk in der Diskko','artist' : 'ODMGIDA feat Kex Kuhl', 'genre' : 'Rap', 'released' : '2020'},{'name' : 'Awkward', 'artist' : 'Duzoe', 'genre' : 'Rap', 'released' : '2020'}]
user = 'master'
password = "1234"

@app.route('/')
def index():
    return 'Hello World'

@app.route('/login/master', methods = ["POST"])
def loginMaster():
    if request.form['password'] == password:
        token = jwt.encode({
            'user': 'master',
            'exp': datetime.datetime.utcnow()+datetime.timedelta(minutes=30)
        },
        app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify(
            {'token': token}
        )
    else:
        return jsonify(
            {'message': 'Login as Master was not sucessfull'}, 403
        )

@app.route('/songs', methods = ["GET"])
@checkForToken
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


if __name__ == '__main__':
    app.run(debug=True)
    
#@app.route("/login/master", methods = ["POST"])
#def returnMasterJWT():
#    password = request.body.password
#    if password == master:
