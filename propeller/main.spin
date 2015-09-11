'' =================================================================================================
''
''   File....... main.spin
''   Purpose.... 
''   Author..... Jason Doyle
''               Copyright (c) 2015 Jason Doyle
''   E-mail..... jason.e.doyle@gmail.com
''   Started.... 06 SEP 2015
''   Updated.... 
''
'' =================================================================================================

OBJ

ppm     :   "jm_ppm"
serial  :   "FullDuplexSerial"
ping    :   "Ping"

CON

Ping_pin    := 1
PPM_pin     := 2

RX_pin      := 3
TX_pin      := 4

PUB Main

    ppm.start(PPM_pin, level, nservos, uspulse, usframe)

    