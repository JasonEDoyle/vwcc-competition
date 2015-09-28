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
      
'    PING_PIN    = 1
    PPM_PIN     = 25

'    RPI_RX_PIN  = 3
'    RPI_TX_PIN  = 4

' RC Channels
    TH_CH       = 0
    PITCH_CH    = 1
    ROLL_CH     = 2
    YAW_CH      = 3
    FMODE_CH    = 4
    ARMING_CH   = 5

' Servo poitions
    SVO_MIN     = 1_000                                               ' servo limits in microseconds
    SVO_MAX     = 2_000

    SVO_CTR     = 1_500

OBJ

    ppm     :   "jm_ppm"
    serial  :   "FullDuplexSerial"
    ping    :   "Ping"

PUB Main
    
    ppm.start(PPM_PIN, 0, 6, 300, 20_000) ' 6 servos/channels, 300us suggested from jm_ppm.spin, 20_000 suggested from jm_ppm.spin
    pause(1)
    
    

pub pause(ms)

    waitcnt(ms*(clkfreq/1000) + cnt)
    
PRI Cal_channels

 ' Initailize controls
    repeat 5
      ppm.set(TH_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(TH_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(TH_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(TH_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)

    repeat 5
      ppm.set(ROLL_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(ROLL_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(ROLL_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(ROLL_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)

    repeat 5
      ppm.set(PITCH_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(PITCH_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(PITCH_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(PITCH_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)

    repeat 5
      ppm.set(YAW_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(YAW_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(YAW_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(YAW_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)

    repeat 10
      ppm.set(FMODE_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(FMODE_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(FMODE_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(FMODE_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)

    repeat 10
      ppm.set(ARMING_CH, SVO_MIN)     ' Set throttle to 0
      pause(500)
      ppm.set(ARMING_CH, SVO_CTR)     ' Set throttle to 0
      pause(500)
      ppm.set(ARMING_CH, SVO_MAX)     ' Set throttle to 0
      pause(500)
    ppm.set(ARMING_CH, SVO_CTR)     ' Set throttle to 0
    pause(1000)