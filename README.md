
## Team Members 

- [Mahnum Ahmed](https://github.com/mahnum-ahmed)
- [Aqsa Muneer](https://github.com/aqsa-muneer)
- [Humna Khan](https://github.com/humna0809)
- [Amna Ali](https://github.com/TheAmna)

  
## Project Overview

The user toggles one of the first 5 FPGA switches to select a song, which is decoded into a 4-bit song number. This song number is sent to three separate modules: the VGA display module shows the song number on screen, the audio trigger module sends a signal to the laptop to play the corresponding MP3 file, and the ROM selector module activates the memory block containing that song's frequency data. The memory read controller begins reading 24-bit RGB values from the active ROM at a rate of one frame every 10 clock cycles. Each RGB value is sent to the LED driver, which updates the LED color. The read continues frame by frame until the song ends, at which point the system returns to awaiting the next song selection. 

<img width="600" height="700" alt="image" src="https://github.com/user-attachments/assets/cb4e7441-01fe-4b2d-8d81-870512a46aab" />

## User Flow Diagram 

<img width="500" height="600" alt="image" src="https://github.com/user-attachments/assets/4d607366-a336-4d82-a702-344d0125d8c8" />


## State Transition Diagram

<img width="400" height="500" alt="image" src="https://github.com/user-attachments/assets/7e0d5b06-2d22-4c07-bbc5-4ed2de394ceb" />


## Control Block 

<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/7a928f5f-f8b0-48eb-b768-1fbf57c86f5d" />



## VGA Screens 

<img width="600" height="400" alt="image" src="https://github.com/user-attachments/assets/c4dbce4a-37a7-42e3-a00d-f669f4d0b880" />

*Song selection screen*

<img width="600" height="400" alt="image" src="https://github.com/user-attachments/assets/9185f88a-e2aa-477b-bee2-f877f2c82654" />

*Error screen displayed if two songs selected*

## Video Demo 



https://github.com/user-attachments/assets/d3cadfa7-0b2a-42be-9f22-7b9d66e914e4


*Sky full of stars*

https://github.com/user-attachments/assets/3bf830f6-a55d-4fbd-bad5-69f5f1ec9651

*Faded*

## Challenges


## Key Learnings 
<!--The main challenge was integrating the Basys 3 Digilent FPGA with the WS2812 LED strip. This is because the FPGA outputs 3.3V while the LED strip takes 5 V input. We discussed with our labs Research Assisstant Sir Khuzaima. He recommended that we use a MOSFET to as a level converter. However, that did not workout because 






