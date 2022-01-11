# toy_5

## About:

This piece, written for new media group Ensemble Decipher and titled toy_5, seeks to explore aspects of
improvisational and generative algorithmic computer music. The work is designed to be immediately accessible to
non-musicians through a participatory setting, if so desired, according to principles developed by Tina Blaine and
Sidney Fels, while also providing the opportunity for more rehearsed performances like the video here: https://www.youtube.com/watch?v=yiQjoRHxn-c.

The work’s visuals and sound are controlled by
mouse cursor position, mouse clicks, and keystrokes through OSC. In the performance linked above, they are then shared,
in this case through the consumer-grade teleconferencing software Zoom. The code
for audio generation was written in SuperCollider, while the visuals were coded in the JavaScript based live-coding and visualization package, <a href=https://github.com/ojack/hydra>hydra</a>.  

## Installation

Download and install SuperCollider:

https://supercollider.github.io/download

or if you have brew installed:

`brew install --cask supercollider`

NB: For the boot.command file that easily boots the work's software to run properly, SuperCollider must be in your Applications directory. The path will look like so:

`~/Applications/SuperCollider.app`

Download the github repository by opening terminal and pasting:

`git clone https://github.com/eclemmon/toy_5.git`

or by clicking <a href=https://github.com/eclemmon/toy_5/archive/refs/heads/master.zip>here</a>.

Once the files have been downloaded, navigate to `/toy_5/super_collider_files/` directory and double click on the `boot.command` shell script to run the software. Then, simply follow the instructions in the score and in the SuperCollider files.

It is recommended that the bass part is performed by maximum two players, and the chimes parts maximum four. The granulation part should be played by one or two players.

This software has been tested on SuperCollider 3.12, and macOS 12.0.1 (Monterey), but it should work on older versions of macOS as well as long as a recent, stable version of SuperCollider has been installed.

## Software/Packages Required:
* <a href=https://supercollider.github.io/download>SuperCollider 3.10.4-3.11.2</a>
* <a href=https://github.com/ojack/hydra>Hydra 1.2.4</a> (best installed in Atom)
* If playing this in a networked setting, something like: <a href=https://zoom.us/>Zoom</a> or <a href=https://www.jacktrip.org/>JackTrip</a>.

<a href=https://ericlemmon.net/>Get in touch if you have any questions!</a>
