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

CON

    _clkmode = xtal1 + pll16x       ' System clock 80 MHz
    _xinfreq = 5_000_000

  CLK_FREQ = ((_clkmode - xtal1) >> 6) * _xinfreq
  MS_001   = CLK_FREQ / 1_000
  US_001   = CLK_FREQ / 1_000_000
      
'    PING_PIN    = 1
    PPM_PIN     = 25

'    RPI_RX_PIN  = 3
'    RPI_TX_PIN  = 4

' RC Channels
    TH_CH       = 0
    PITCH_CH    = 1
    ROLL_CH     = 2
    YAW_CH      = 3

' Servo poitions
    SVO_MIN     = 1_000                                               ' servo limits in microseconds
    SVO_MAX     = 2_000

    SVO_CTR     = 1_500

OBJ

    ppm     :   "jm_ppm"
    serial  :   "FullDuplexSerial"
    ping    :   "Ping"

PUB Main
    
    ppm.start(PPM_PIN, 0, 4, 300, 20_000) ' 4 servos/channels, 300us suggested from jm_ppm.spin, 20_000 suggested from jm_ppm.spin
    pause(1)
    
    ' Initailize controls
    ppm.set(TH_CH, SVO_CTR)     ' Set throttle to 0
    ppm.set(PITCH_CH, SVO_CTR)  ' Center pith control
    ppm.set(ROLL_CH, SVO_CTR)   ' Center Roll
    ppm.set(YAW_CH, SVO_CTR)    ' Center Yaw

pub pause(ms) | t

'' Delay program ms milliseconds

  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += MS_001)
    