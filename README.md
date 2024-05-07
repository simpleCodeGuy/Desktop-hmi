# Desktop-hmi  
It is a desktop application to draw UI elements on screen. These elements can communicate with Modbus-TCP devices in realtime.
<center><a href="https://youtu.be/IvLdoEzT2GM">Video link of working application</a></center>

## Status of project
Implemented
- Drawing UI elements on screen
- 'modbus-master-isolate', a dart library to act as a modbus master in Modbus/TCP protocol.

Pending
- Interface of UI elements on screen with Modbus-TCP elements

## Features implemented
All the screen features are implemented using flutter canvas.
1. Create: line, circle, rectangle, text, button 
2. Select item 
3. Copy single, Copy multiple 
4. Delete 
5. Snap on screen 
    - grid
    - end points
    - center
    - boundary 
6. Move screen
    - left
    - right
    - up
    - down
    - top left
    - zoom in 
    - zoom out
    - zoom original
