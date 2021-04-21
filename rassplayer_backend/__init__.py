from flask import Flask,jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__, instance_relative_config=False)

#Testvariables

songs = [{'name' : 'Sockosophie','artist' : 'Kaeptn Peng', 'genre' : 'Rap', 'released' : '2013'},{'name' : 'Panikk in der Diskko','artist' : 'ODMGIDA feat Kex Kuhl', 'genre' : 'Rap', 'released' : '2020'},{'name' : 'Awkward', 'artist' : 'Duzoe', 'genre' : 'Rap', 'released' : '2020'}]

@app.route('/')
def index():
    return 'Hello World'

@app.route('/songs', methods = ["GET"]) 
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

app.run(host='0.0.0.0', port=8008)