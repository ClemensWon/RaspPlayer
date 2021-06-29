DROP DATABASE RaspPlayer;


DROP USER 'johnlennon'@'localhost';


CREATE DATABASE RaspPlayer;

CREATE USER 'johnlennon'@'localhost' identified by 'woodstock69';

GRANT SELECT, INSERT, UPDATE, DELETE ON RaspPlayer.* TO 'johnlennon'@'localhost';

FLUSH PRIVILEGES;

USE RaspPlayer;

CREATE TABLE SoundBoxSettings (
    soundBoxID int primary key,
    masterPassword varchar(256) not null,
    sessionPin int not null
);

INSERT INTO SoundBoxSettings (soundBoxID, masterPassword, sessionPin)
VALUES (0, 'masterPasswordHash', 0000);

CREATE TABLE User (
    deviceID varchar(50) primary key,
    username varchar(20) not null,
    banned boolean not null,
    token varchar(500)
);

CREATE TABLE Song (
    songID int primary key auto_increment,
    deviceID varchar(50) NOT NULL,
    songName varchar(50) not null,
    genre varchar(30),
    duration int NOT NULL,
    likes int NOT NULL,
    skips int NOT NULL,
    album varchar(50) NOT NULL,
    replays int NOT NULL,
    filepath varchar (500) NOT NULL unique,
    foreign key (deviceID) references User(deviceID) on delete cascade
);

CREATE TABLE Interpret (
    interpretID int primary key auto_increment,
    interpretName varchar(50) not null unique
);

CREATE TABLE Playlist (
    playlistID int primary key auto_increment,
    playlistName varchar(30) not null unique,
    nextSongPos int NOT NULL,
    deviceID varchar(50) NOT NULL,
    foreign key (deviceID) references User(deviceID) on delete cascade
);

CREATE TABLE InterpretToSong (
    songID int NOT NULL,
    interpretID int NOT NULL,
    primary key (songID, interpretID),
    foreign key (songID) references Song(songID) on delete cascade,
    foreign key (interpretID) references Interpret(interpretID) on delete cascade
);

CREATE TABLE SongToPlaylist (
    playlistID int NOT NULL,
    songID int NOT NULL,
    songPos int NOT NULL,
    primary key (playlistID, songID),
    foreign key (playlistID) references Playlist(playlistID) on delete cascade,
    foreign key (songID) references Song(songID) on delete cascade
);

INSERT INTO User (deviceID, username, banned, token) VALUES ("999", "Alex", 0, "abc");

INSERT INTO Song (deviceID, songName, genre, duration, likes, skips, album, replays, filepath) VALUES ("999", "Found God in a Tomato", "rock", 30, 2, 1, "High Viscera", 1, "aslökdfjsölj");
INSERT INTO Song (deviceID, songName, genre, duration, likes, skips, album, replays, filepath) VALUES ("999", "Cornflake", "rock", 35, 0, 0, "High Viscera", 0, "asdf");

INSERT INTO Interpret (interpretID, interpretName) VALUES(1, "PPC");

INSERT INTO InterpretToSong(songID, interpretID) VALUES (1, 1);
INSERT INTO InterpretToSong(songID, interpretID) VALUES (2, 1);

commit;