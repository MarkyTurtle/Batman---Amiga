# Ripped Files
The two disk images here are DOS disks containing the files ripped from the original Batman Disks 1 & 2 respectively.
 - [disk1files.adf](./disk1files.adf) - contains files ripped from Batman Disk 1
 - [disk2files.adf](./disk2files.adf) - contains files ripped from Batman Disk 2 

The following folders contain the original packed raw files ripped from disks 1 & 2
 - [/disk1files](./disk1files/) - contains the packed files as ripped from Batman Disk 1
 - [/disk2files](./disk2files/) - contains the packed files as ripped from Batman Disk 2

The following folders contain the unpacked raw files ripped from disks 1 & 2 (unpacked using xfdmaster)
 - [/disk1files-unpacked](./disk1files-unpacked/) - contains the unpacked files as ripped from Batman Disk 1
 - [/disk2files-unpacked](./disk2files-unpacked/) - contains the unpacked files as ripped from Batman Disk 2 

The following descriptions are assumptions until proven otherwise. Checkout the GameLoader Folder for details of where these files are loaded into memory etc.


### Notes:
\* The Loading.iff file is the only genuine ILBM IFF file, the loader processes these files and depacks to the allocated bitplane memory starting at $00007700 (10K per bitplane, 5 planes)

## Disk 1 - Files
<table>
<tr>
    <th>Filename</th><th>File Type</th><th>Description</th><th>Code Useage</th><th>Load Address</th>
</tr>
<tr>
    <td>loading.iff</td><td>IFF ILBM</td><td>Game Loading Picture</td><td>load_loading_screen</td><td>$00007700 *</td>
</tr>
<tr>
    <td>panel.iff</td><td>IFF HUFF</td><td>I'm guessing its the code and gfx for the bottom panel/energy/score area of the screen.</td><td>load_loading_screen</td><td>$0007C7FC </td>
</tr>
<tr>
    <td>titlepic.iff</td><td>IFF HUFF</td><td>I'm guessing it's the graphics for the title screen, an maybe the failure/completion screen also and fonts.</td><td>load_title_screen1 <br/> load_title_screen2</td><td>$00000000</td>
</tr>
<tr>
    <td>titleprg.iff</td><td>IFF HUFF</td><td>I'm guessing this is the title screen code.</td><td>load_title_screen1 <br/> load_title_screen2</td><td>$00000000</td>
</tr>
<tr>
    <td>code1.iff</td><td>IFF HUFF</td><td>Level 1 - Axis Chemicals Platformer</td><td>load_level_1</td><td>$00000000</td>
</tr>
<tr>
    <td>mapgr.iff</td><td>IFF HUFF</td><td>Level 1 - Graphics</td><td>load_level_1</td><td>$00000000</td>
</tr>
<tr>
    <td>batspr1.iff</td><td>IFF HUFF</td><td> Level 1/5 - Batman/Enemy Sprites</td><td>load_level_1 <br/> load_level_5</td><td>$00000000</td>
</tr>
<tr>
    <td>chem.iff</td><td>IFF HUFF</td><td>Level 1 - More Assets</td><td>load_level_1</td><td>$00000000</td>
</tr>
<tr>
    <td>code5.iff</td><td>IFF HUFF</td><td>Level 5 - Church Platformer</td><td>load_level_5</td><td>$00000000</td>
</tr>
<tr>
    <td>mapgr2.iff</td><td>IFF HUFF</td><td>Level 5 - Graphics</td><td>load_level_5</td><td>$00000000</td>
</tr>
<tr>
    <td>church.iff</td><td>IFF HUFF</td><td>Level 5 - More Assets</td><td>load_level_5</td><td>$00000000</td>
</tr>
</table>



## Disk 2 - Files
<table>
<tr>
    <th>Filename</th><th>File Type</th><th>Description</th><th>Code Useage</th><th>Load Address</th>
</tr>
<tr>
    <td>code.iff</td><td>IFF HUFF</td><td>Level 2/4 - Batmobile</td><td>load_level_2 <br/> load_level_4</td><td>$00000000</td>
</tr>
<tr>
    <td>data.iff</td><td>IFF HUFF</td><td>Level 2/4 - Level Assets</td><td>load_level_2 <br/> load_level_4</td><td>$00000000</td>
</tr>
<tr>
    <td>data2.iff</td><td>IFF HUFF</td><td>Level 2 - Batmobile Level/Road Layout</td><td>load_level_2</td><td>$00000000</td>
</tr>
<tr>
    <td>music.iff</td><td>Unknown</td><td>Level 2/4 Looks like it contains music and soundFx (does not have IFF headers)</td><td>load_level_2 <br/> load_level_4</td><td>$00000000</td>
</tr>
<tr>
    <td>batcave.iff</td><td>IFF HUFF</td><td>Level 3 - Batcave Lab</td><td>load_level_3</td><td>$00000000</td>
</tr>
<tr>
    <td>data4.iff</td><td>IFF HUFF</td><td>Level 4 - Batwing Level/Road Layout</td><td>load_level_4</td><td>$00000000</td>
</tr>
</table>

 
