# Batman The Movie - Amiga A500
[Batman The Movie, Amiga, 2 Disk Europe, Ocean](https://www.lemonamiga.com/games/details.php?id=131)

This repo contains my progress of the disassembling of the 2 Disk version of Batman The Movie for the Amiga. 
- Check out the latest updated Test ADFs
     - [DosCrackShrinkler_rebuild.adf](./crack/packedcrack/DosCrackShrinkler_rebuild.adf) containing the **Title Screen** rebuilt from Source Code (**SOME GFX CORRUPTION**)
     - [DosCrackShrinkler.adf](./crack/packedcrack/DosCrackShrinkler.adf) containing the original game files repacked on a single disk. 
  
The inspiration for this exercise was discovering the following cracking series run by **h0ffman**. Links to those resources shown below.

 - [Youtube](https://www.youtube.com/@HoffmanYouTube)
 - [Twitch](https://www.twitch.tv/djh0ffman)
 - [GitHub](https://github.com/djh0ffman)

Resources and code used in this project is listed below. If there's anything used which hasn't been credited, please let me know. Also thanks to the TTE Crew member **JAYCEE_1980** who supplied a download link for the RNC disk code in the h0ffman twitch stream: Episode #16 Lemmings.

- [Batman 2 Disk Europe](https://www.lemonamiga.com/games/details.php?id=131) 
- [WinUAE](https://www.winuae.net/) - Windows Amiga Emulator
- [FS-UAE](https://fs-uae.net/) - Linux Amiga Emulator
- Action Reply MKIII - Emulator ROMS
- [VS Code](https://code.visualstudio.com/) 
   - Amiga Assembly Extension
- RNC DosIO - Low level disk code
- [Shrinkler](https://github.com/askeksa/Shrinkler) - file cruncher/decruncher
- [Salvador](https://github.com/emmanuel-marty/salvador) - zxo file cruncher/decruncher
- [XFDMaster](http://aminet.net/package/util/pack/xfdmaster) - utilities for depacking almost any packed file format.

## Overview
This exercise is not one of speed, but of learning. It looks like this game could be cracked just by patching out the serial number check around $139C in the loader code. The intention is to spend more time disassembling parts of the code that wouldn't normally be disassembled to crack the game. I'll be following the steps below, like all plans likely to change.

 - Disassemble the boot loader. [Code Folder](./loader/bootblock/)
 - Disassemble the game loader. [Code Folder](./loader/gameloader/modified/)
 - Disassemble the Rob Northen Disk Protection. [Code Folder](./loader/gameloader/modified/)
 - Ripping the files from the disk. [Files Folder](./rawrippedfiles/) 
 - Unpack the ripped files. [Files Folder](./rawrippedfiles/)
   - [Disk 1 Unpacked](./rawrippedfiles/disk1files-unpacked/)
   - [Disk 2 Unpacked](./rawrippedfiles/disk2files-unpacked/)
   - [File Memory Map](./FileRelocation.md) - File Relocation/Load Table
 - Re-pack the files for reuse. [Files Folder](./crack/packedcrack/)
   - [Shrinkler Disk 1](./crack/packedcrack/shrinkfiles/disk1/)
   - [Shrinkler Disk 2](./crack/packedcrack/shrinkfiles/disk2/)
   - [ZX0 Disk 1](./crack/packedcrack/zx0files/disk1/)
   - [ZX0 Disk 2](./crack/packedcrack/zx0files/disk2/)
 - Create a Cracked Version of the Disk. - Amiga DOS disk with custom loader (rnc dosio)
   - **Dos Crack V2**
   - [DosCrackZX0.adf](./crack/packedcrack/DosCrackZX0.adf) - In Progress (semi functional some loading corruption, game/timer speed up, level 2 onwards)
   - **Dos Crack V1** - 
   - [DosCrackShrinkler.adf](./crack/packedcrack/DosCrackShrinkler.adf) - In Progress (game/timer speed up, level 2 onwards)
   - Load time is far too slow, need to change packer
 - Disassemble the Game Panel
    - [Code Project](./gamesource/panel/)
    - [Test .adf disk image](./crack/packedcrack/DosCrackShrinkler_rebuild.adf)
 - Disassemble the Title Screen.
    - [Code Project](./gamesource/titleprg)
    - The Title Screen code can be rebuilt from source and executed in VSCode
    - Updated Test ADF with Title Screen rebuilt from Source Code - [DosCrackShrinkler_rebuild.adf](./crack/packedcrack/DosCrackShrinkler_rebuild.adf) 
 - Disassemble the Platform Levels.
    - [Code Project](./gamesource/chem/) - Music & SFX for Level1 - Done with test program to play Music/FSX
    - [Code Project](./gamesource/code1/) - Axis Chemicals - Level1 - In Progress
    - [Code Project](./gamesource/batspr1/) - Game Sprites - Level1/5 - Just Data - TODO: Write Test Project to Display Sprites
    - [Code Project](./gamesource/mapgr/) - Level GFX & Data - Level1 - Just Data - TODO: Write Test Project to Display GFX/Level Data
 - Disassemble the Batmobile/Batwing Levels.
 - Disassemble the BatCave Level.



## Progress to Date

2024-08-13 - Added test program to the 'chem' project which plays the level 1 music. [Project Link](./gamesource/chem/) - Left mouse button to cycle through music/sfx.

2024-08-03 - Rebuild the test ADF image using the rebuilt batspr.shrunk and mapgr.shrunk files which were rebuilt from the source data. So this disk image now contains a rebuilt titleprg.shrunk, batspr1.shrunk and mapgr.shrunk files. [DosCrackShrinkler_rebuild.adf](./crack/packedcrack/DosCrackShrinkler_rebuild.adf) - give it a go ( works on my machine **:)** )

2024-08-03 - Added raw data project for batspr1.iff, this file is data only. Need to get around to adding a test GFX viewer to the project in the furure.

2024-08-03 - Added raw data project for mapgr.iff, this file is data only. Need to get around to adding a test GFX viewer to the project in the future.

2024-08-01 - Have been disassmbling the 'code1' program for the level 1 of the game, have formatted the code enough to enable the code to assemble without error. There are a couple of code warnings remaining, I've also noticed some self modifying code contained with the program :-( [VSCode Project Link](./gamesource/code1/)

2024-07-25 - Successfully rebuilt the TitleScreen program from source code and added to test .adf disk image [DosCrackShrinkler_rebuild.adf](./crack/packedcrack/DosCrackShrinkler_rebuild.adf) - give it a go ( works on my machine **:)** )

2024-07-20 - Started disassembling 'code1', the code for level 1 (Axis Chemicals). Began formatting the code, first steps to try to get the code to assemble without errors. Made a start but still much to do.

2024-07-19 - Progress to Date
  - Disassembled Game Source
      - Panel (Energy Panel, Lives, Scores etc) - Disassembled - [VSCode Project Link](./gamesource/panel/)
      - Title Screen - Disassembled - [VSCode Project Link](./gamesource/titleprg/)
      - Game Loader - Disassembled - [VSCode Project Link](./loader/gameloader/modified/) (tvd patched & decoded)
      - Boot Loader - Disassembled - [VSCode Project Link](./loader/bootblock/)

  - New Source
      - Custom Loader - MFM DOS Loader for ripped files - [VSCode Project Link](./crack/newloader/src)

  - ADF Test Disks
      - Single Disk Version (Shrinkler) - [Single Disk ADF](./crack/packedcrack/DosCrackShrinkler.adf)
      - Single Disk Version (Shrinkler) - Parts Rebuild from Source [Single Disk ADF](./crack/packedcrack/DosCrackShrinkler_rebuild.adf)

2024-07-19 - The title screen in now disassembled and can be reassembled and executed in vscode from the project code [titleprg](./gamesource/titleprg/)

2024-07-14 - Can reassemble and run the title screen in test, without gfx loaded. Music player has a fault. The title music drum track is not right, also vocals not playing correctly. It runs without crashing.

2024-07-10 - Been away for the weekend, now back and can re-assemble the title screen and execute it (without GFX or music playing). The GFX is missing as these are loaded into memory separately (to get the GFX will require a custom build of the title screen).  The music is not currently playing and is causing an exception to be thrown during the do_play_song routine which is called to play the current song during each VBL interrupt (level 3).  Will have to do a bit of tracing to find out whats going wrong (it's either some bad code disassembly or bad song data I guess).

2024-07-03 - Have disassembled the code to the game 'titleprg' (title screen code & music). The code assembles without error and is 90% documented, there are areas of the music format that are still to be uncovered. Also I haven't yet tested the re-assembled version of the title screen code.

2024-06-05 - Have disassembled the code to the game 'panel' file. I can now re-assemble the file and have tested it on the test .adf disk image here [DosCrackShrinkler_Rebuild.adf](./crack/packedcrack/DosCrackShrinkler_rebuild.adf)

2024-06-03 - First draft of the 'panel' program has been disassembled and can be reassembled in vscode. Some tidying up and splitting out into gfx includes required. Move on to the Title Screen next. Might gain a bit more insight into the VBL interrupts and timings there. 

2024-05-30 - Been disassembling the 'Panel' executable that is loaded to $7Cf7C in memory. It contains the gfx and code that manages the game status panel including keeping track of the player lives, energy, level count down timer. Looking for hints for why the 'cracked' version of the game speeds up on level 2 and beyond.  Can see that a level 3 vertical blank interrupt calls the 'update' routine every frame. At the moment it appear that this routine is being called more frequently in my version of the re-complied ADF images for level 2 and beyond. Will keep searching... probably wont find out why until I disassemble the level code and see exectly where the level 3 interrupt is raised in the game code (apart from by the vbl).

2024-05-24 - Created a zx0 version of the disk, it's not working perfoectly yet, I think the compressed files are larger, causing corruption/memory overwriting on loading. Also the game timer is speeding up when loading level 2 and above, 1 minute is taking about 50 seconds. It looks like the level 3 interrupt is being called 60 times a second(ish) instead of 50 times a second. The music and game is also running noticably faster. When returning to the title screen, the music is playing faster. Once this is sorted the game should be working on A500 and I can move on to disassembling other parts of the game.

2024-05-24 - Obtained source and built 'salvador' zx0 packer/unpacker tool and link to the depacker source code from git hub (see links above). Have packed ripped files with tool and added files to source control.

2024-05-23 - Created an Amiga DOS disk that can be played and completed, very slow loading times due to decompression (which needs to be fixed). Its a learning exercise and I'm learning loads. I think the clock timer is running too fast (also the music on the title screen), so I think the game timers aren't set quite right at the moment. Also affects game play of levels 2 & 4 which are very tight on the time limits. This needs to be looked at and fixed.

2024-05-22 - Been testing the game and have completed the cracked version. It showed the game-over screen instead of the completion screen. Also had an
intermittent crash on level 5. I've updated the new loader, so that it sets the original copy protection serial into the exception vectors.
May also need to insert other copy protection data into memory, will test when I have the time.

2024-05-21 - Noticed that Level 5 is crashing/corrupt when navigating through the level. Will have to double check the ripped data for this level, also see if there are any copy protection checksums happening during the level to cause the issue. (Also, you can get infinite energy by patching 3 NOPs into location $7fA76 when playing the game, using action replay, WIN UAE debugger, etc)

2024-05-21 - Created first verison of a single disk crack. The ADF can be found here [packedfiles.adf](./crack/packedcrack/packedfiles.adf). The load time is far too slow due to the packer used (shrinkler). Need to find a packer with a faster decruncher which still has a decent pack ratio.

2024-05-20 - Successfully created a test crack disk that boots the title screen and first level of the game from an Amiga DOS disk. [TestCrack.adf](./crack/testcrack.adf)

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
