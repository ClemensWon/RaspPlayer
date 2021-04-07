DROP DATABASE RaspPlayer;

DROP USER 'StandartUser';

CREATE DATABASE RaspPlayer;

CREATE USER 'StandartUser' identified by '4XvwPp3RDPsr5E8s';

GRANT SELECT, INSERT, UPDATE, DELETE ON RaspPlayer.* TO 'StandartUser';

FLUSH PRIVILEGES;

USE RaspPlayer;

CREATE TABLE SoundBoxSettings (
    soundBoxID int primary key,
    masterPassword varchar(256) not null,
    partyPin int not null
);

INSERT INTO SoundBoxSettings (soundBoxID, masterPassword, partyPin)
VALUES (0, 'masterPasswordHash', 0000);

CREATE TABLE User (
    deviceID int primary key,
    username varchar(20) not null,
    banned boolean not null
);

CREATE TABLE Song (
    songID int primary key auto_increment,
    songName varchar(50) not null,
    genre varchar(30)
);

CREATE TABLE Interpret (
    interpretID int primary key auto_increment,
    interpretName varchar(50) not null
);

CREATE TABLE Playlist (
    playlistID int primary key auto_increment,
    playlistName varchar(30) not null
);

CREATE TABLE InterpretToSong (
    songID int,
    interpretID int,
    primary key (songID, interpretID),
    foreign key (songID) references Song(songID) on delete cascade,
    foreign key (interpretID) references Interpret(interpretID) on delete cascade
);

CREATE TABLE SongToPlaylist (
    playlistID int,
    songID int,
    deviceID int not null,
    primary key (playlistID, songID),
    foreign key (playlistID) references Playlist(playlistID) on delete cascade,
    foreign key (songID) references Song(songID) on delete cascade,
    foreign key (deviceID) references User(deviceID) on delete cascade
);

CREATE TABLE History (
    songID int,
    date datetime,
    deviceID int not null,
    primary key (songID, date),
    foreign key (songID) references Song(songID) on delete cascade,
    foreign key (deviceID) references User(deviceID) on delete cascade
);

commit;