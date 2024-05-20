# Batman
[Batman The Movie, Amiga, 2 Disk Europe, Ocean](https://www.lemonamiga.com/games/details.php?id=131)

This repo will contain the result of my attempt to reverse engineer the 2 Disk version of Batman The Movie for the Amiga. 

The inspiration for this exercise was discovering the following cracking series run by **djh0ffman**. Also to the TTE Crew members who (**JAYCEE_1980** who supplied a download link for the RNC disk code in Episode #16 Lemmings.) Links to those resources shown below.

 - [Youtube](https://www.youtube.com/@HoffmanYouTube)
 - [Twitch](https://www.twitch.tv/djh0ffman)
 - [GitHub](https://github.com/djh0ffman)

I've been looking for an excuse to do something on the Amiga for ages and this seemed like a nice little hobby exercise to dip in and out of, a reason to re-learn 68000 and a chance to learn something about game programming in the process.

Resources and code used in this project is lkisted below. If there's anything used which hasn't been credited, please let me know.

- WinUAE (Windows Amiga Emulator)
- FS-UAE (Linux Amiga Emulator)
- Action Reply MKIII - (Emulator ROMS)
- VS Code (Windows and MAC)
   - Amiga Assembly Extension
- RNC DosIO (Low level disk code)


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

 - Disassemble the boot loader. [Code Folder](./loader/bootblock/)
 - Disassemble the game loader. [Code Folder](./loader/gameloader/modified/)
 - Disassemble the Rob Northen Disk Protection. [Code Folder](./loader/gameloader/modified/)
 - Ripping the files from the disk. [Files Folder](./rawrippedfiles/) 
 - Decompress the ripped files. [Files Folder](./rawrippedfiles/)
   - [Disk 1 Unpacked](./rawrippedfiles/disk1files-unpacked/)
   - [Disk 2 Unpacked](./rawrippedfiles/disk2files-unpacked/)
 - Create a Cracked Version of the Disk.
   - In Progress [New Loader](./crack/newloader/)
   - **Test Disk ADF [testcrack.adf](./crack/testcrack.adf)**
   - **TODO: Repack ripped files, finish new loader, compile disk**
 - Disassemble the Title Screen.
 - Disassemble the Platform Levels.
 - Disassemble the Batmobile/Batwing Levels.
 - Disassemble the BatCave Level.



## Progress to Date

2024-05-20 - SUccessfully created a test crack disk that boots the title screen and first level of the game from an Amiga DOS disk. [TestCrack.adf](./crack/testcrack.adf)

2024-05-17 - Created a test disk image [testcrack.adf](./crack/testcrack.adf) which can load the and start the *Title Screen* from the Amiga DOS formatted disk. The game will crash if you try to start it as theres no code to load the levels etc. *Ive borked the test loader, try running on emulator with plenty of memory, think its got stack corruption at the moment*

2024-05-17 - Created simple loader using RNC DosIO to load title screen from the ripped files.

2024-05-17 - Added RNC disk code tools which I intend to use to re-create a loader for the game.

2024-05-15 - Unpacked the ripped files and added them to source control and also as unpacked Amiga DOS format ADF files.

2024-05-14 - Completed quite a few tasks on the main game loader:-
 - Completed first draft of documenting the gameloader.s code [BATMAN Loader](./loader/gameloader/modified/src/gameloader.s)
 - Added a set of ripped raw files to the rawrippedfiles source directory [Ripped Files](./rawrippedfiles/)
     - Disk 1 raw ripped files [Disk1 Files](./rawrippedfiles/disk1files/)
     - Disk 2 raw ripped files [Disk2 Files](./rawrippedfiles/disk2files/)

2024-04-26 - Commented lots of the main game loader, still some of the copy protection left to comment [BATMAN Loader](./loader/gameloader/modified/src/gameloader.s).

2024-04-09 - Began adding the disassembly of the main game loader, the "BATMAN" file from disk 1.

2024-04-07 - Completed first draft of documenting the [bootblock.s](./loader/bootblock/bootblock.s) code. 

2024-04-05 - Almost finished documenting the Bootblock code (which builds in VSCode using the Amiga Assembly plug-in)

2024-03-28 - Uploaded ripped files on ADFs, Ripped files are 'IFF' files that are further processed/decrunched by the loader before relocated into memory. All files appear to have IFF headers apart from the the music file(s), not sure what format these are yet.

2024-03-27 - I have ripped the raw files from both disks, need to upload to the repo.

2024-03-26 - Up to this point I have successfully ripped the game loader, documented it and modified it sufficently to get the game to boot without the copy protection kicking in. I've decoded and disassembled the Rob Northen protection and spent some time understanding how it works. I need to upload these files to this repo.

2024-03-25 - Spent quite a while stepping through and documenting the GameLoader (docs yet to be uploaded), also decoding the copy protection routines (early Rob Northen) trace vector decoder (again, docs to be uploaded)
