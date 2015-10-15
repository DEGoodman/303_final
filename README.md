303_final
---

### UPDATE
A newer version of this project is [EVA](https://github.com/DEGoodman/EVA). It uses the internet instead of a physical sensor array. It can be run from any laptop with an internet connection.

---
This is an environmental interpreter.

The system reads and interprets environmental data from Arduino, and passes it to Processing. Processing uses onboard microphone to pick up audio, and is displayed visually. Visual characteristics are determined by environmental data.


Arduino runs StandardFirmata program.
Processing now reads data directly from Arduino board. 
### Note:
Although Processing is OS agnostic, the port for I/O reading must be specified prior to running (main.pde, line 31. See output from line 30).
