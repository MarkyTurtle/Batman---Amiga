# Batman
Batman The Movie, Amiga, 2 Disk Europe, Ocean

This repo will contain the result of my attempt to reverse engineer the 2 Disk version of Batman The Movie for the Amiga. 

This major inspiration for this exercise was discovering the following cracking series run by **djh0ffman**. Links to those resources shown below.

 - [Youtube](https://www.youtube.com/@HoffmanYouTube)
 - [Twitch](https://www.twitch.tv/djh0ffman)
 - [GitHub](https://github.com/djh0ffman)

I've been looking for an excuse to do something on the Amiga for ages and this seemed like a nice little hobby exercise to dip in and out of, a reason to re-learn 68000 and a chance to learn something about game programming in the process.

I'll be standing on the shoulders of giants and any resources and code used in this project will be linked to below and if it gets too long here.

 - WinUAE (Windows Amiga Emulator)
 - FS-UAE (Linux Amiga Emulator)
 - Action Reply MKIII - (Emulator ROMS)
 - VS Code (Windows and MAC)



## Contents
 - [Original Floppy Disk Images](./originalfloppies/README.md)
 - [Raw Ripped Files](./rawrippedfiles/rippedfiles.md)
 - Loader
   - [Boot Loader](./loader/bootloader.md)
   - [Game Loader](./loader/gameloader.md)



## Overview
This exercise is not one of speed, but of learning. The intension is to spend more time disassembling parts of the code.

I was always impressed by the game and think it would be interesting to try to reverse engineer the Platform and Racing Levels to get an understanding of how they work. (We'll see if my interest level holds up).

I'll be following the steps below, like all plans likely to change.

 - Disassemble the boot loader.
 - Disassemble the game loader.
 - Disassemble the Rob Northen Disk Protection.
 - Ripping the files from the disk. 
 - Create a Cracked Version of the Disk.
 - Disassemble the Title Screen.
 - Disassemble the Platform Levels.
 - Disassemble the Racing Levels.
 - Disassemble the BatCave Level.



## Progress to Date
2023-04-07 - Completed first draft of documenting the [bootblock.s](./loader/bootblock/bootblock.s) code. 

2024-04-05 - Almost finished documenting the Bootblock code (which builds in VSCode using the Amiga Assembly plug-in)

2024-03-28 - Uploaded ripped files on ADFs, Ripped files are 'IFF' files that are further processed/decrunched by the loader before relocated into memory. All files appear to have IFF headers apart from the the music file(s), not sure what format these are yet.

2024-03-27 - I have ripped the raw files from both disks, need to upload to the repo.

2024-03-26 - Up to this point I have successfully ripped the game loader, documented it and modified it sufficently to get the game to boot without the copy protection kicking in. I've decoded and disassembled the Rob Northen protection and spent some time understanding how it works. I need to upload these files to this repo.

2024-03-25 - Spent quite a while stepping through and documenting the GameLoader (docs yet to be uploaded), also decoding the copy protection routines (early Rob Northen) trace vector decoder (again, docs to be uploaded)
