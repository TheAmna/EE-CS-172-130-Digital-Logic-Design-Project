## Project Poster 

## Team Members 

- [Mahnum Ahmed](https://github.com/mahnum-ahmed)
- [Aqsa Muneer](https://github.com/aqsa-muneer)
- [Humna Khan](https://github.com/humna0809)
- [Amna Ali](https://github.com/TheAmna)

  
## Project Overview

The user toggles one of the first 5 FPGA switches to select a song, which is decoded into a 4-bit song number. This song number is sent to three separate modules: the VGA display module shows the song number on screen, the audio trigger module sends a signal to the laptop to play the corresponding MP3 file, and the ROM selector module activates the memory block containing that song's frequency data. The memory read controller begins reading 24-bit RGB values from the active ROM at a rate of one frame every 10 clock cycles. Each RGB value is sent to the LED driver, which updates the LED color. The read continues frame by frame until the song ends, at which point the system returns to awaiting the next song selection. 

## User Flow Diagram 



## State Transition Diagram



## Control Block 



## VGA Screens 



## Video Demo 




## Challenges





## Key Learnings 
