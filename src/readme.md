#### File Description 
* astigmatism.sv : draw astigmatism detecting image 
* clkgen.v : Default clock generating module provided by Altera
* Core.sv : Main module, cooridinate VGA, vision, IR protocols with finite state machine.
* core_tb.sv/ core_tb2.sv : Testbench of core module
* Debounce.sv : Stabilize the signal
* IR_RECEIVE.sv : Coordinate IR protocols in FPGA and IR controller
* virtual_IR.sc : Coordinate core module and IR_RECEIVE to interact with VGA interface
* LCD_controller.sv/ LCD_SHOW.sv : Debugging purpose, illustrate state change and vision determinated result in LCD
* Reset_Delay.sv : Reset delay
* RS232.sv : Transmit vision determinated result to our computer with RS232 interface
* rsa_qsys.v : System integration module
* SevenHexDecoder.sv/ SevenDecDecoder.sv : Debugging purpose, illustrate state change and vision determinated result in Seven-segment display
* VGA_show.sv : Illustrate digits in VGA
* VGA_time_generator.sv : Set up displaying time per second and other VGA parameters
* Coordinate core module and other VGA module
* Wrapper_transfer.sv : Integrate 3 functionalities : eyesight, astigmatism and blind-color in one mudule.
* generate_mifs_opt.py : transder bmp file to mifs file in python
