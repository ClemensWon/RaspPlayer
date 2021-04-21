# Created by Martin, 20.04.2021
# Code is from here: https://towardsdatascience.com/how-to-build-an-mp3-music-player-with-python-619e0c0dcee2

import pygame  # used to create video games
import tkinter as tkr  # used to develop GUI
from tkinter.filedialog import Directory, askdirectory  # it permit to select dir
import os  # it permits to interact with the operating system
import random

music_player = tkr.Tk()
music_player.title("RaspPlayer 0.1")
music_player.geometry("450x600")

directory = askdirectory()
os.chdir(directory)
song_list = os.listdir()

play_list = tkr.Listbox(music_player, font="Helvetica 12 bold", bg="yellow", selectmode=tkr.SINGLE)

pos = 0
for item in song_list:
  play_list.insert(pos, item)
  pos += 1

pygame.init()
pygame.mixer.init()


# Functions to control music player

def play():
  pygame.mixer.music.load(play_list.get(tkr.ACTIVE))
  var.set(play_list.get(tkr.ACTIVE))
  pygame.mixer.music.play()


def stop():
  pygame.mixer.music.stop()


def pause():
  pygame.mixer.music.pause()


def unpause():
  pygame.mixer.music.unpause()


def queue():
  pygame.mixer.music.queue(play_list.get(tkr.ACTIVE))
  pygame.mixer.music.play()


def skip():
  index = song_list.index(play_list.get(tkr.ACTIVE)) + 1
  pygame.mixer.music.load(song_list[index])
  var.set(play_list.get(index))
  play_list.activate(index)
  pygame.mixer.music.play()


def shuffle():
  index = random.randint(0, len(song_list) - 1)
  pygame.mixer.music.load(song_list[index])
  var.set(play_list.get(index))
  pygame.mixer.music.play()


Button1 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="PLAY", command=play, bg="blue", fg="white")
Button2 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="STOP", command=stop, bg="red", fg="white")
Button3 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="PAUSE", command=pause, bg="purple", fg="white")
Button4 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="UNPAUSE", command=unpause, bg="orange", fg="white")
Button5 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="QUEUE", command=queue, bg="green", fg="white")
Button6 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="SKIP", command=skip, bg="black", fg="white")
Button7 = tkr.Button(music_player, width=5, height=3, font="Helvetica 12 bold", text="SHUFFLE", command=shuffle, bg="pink", fg="white")

var = tkr.StringVar() # lookup function
song_title = tkr.Label(music_player, font="Helvetica 12 bold", textvariable=var)

song_title.pack()
Button1.pack(fill="x")
Button2.pack(fill="x")
Button3.pack(fill="x")
Button4.pack(fill="x")
Button5.pack(fill="x")
Button6.pack(fill="x")
Button7.pack(fill="x")
play_list.pack(fill="both", expand="yes")

music_player.mainloop()