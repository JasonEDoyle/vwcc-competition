'' =================================================================================================
''
''   File....... main.spin
''   Purpose.... 
''   Author..... Jason Doyle
''               Copyright (c) 2015 Jason Doyle
''   E-mail..... jason.e.doyle@gmail.com
''   Started.... 06 SEP 2015
''   Updated.... 06 NOV 2015
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
    ROLL_CH     = 1
    PITCH_CH    = 2
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
    
    ' Intialize all the channels   
    ppm.setall(SVO_MIN)         ' Set all channels to min value

    ppm.set(ROLL_CH, SVO_CTR)   ' Set controls to center
    ppm.set(PITCH_CH, SVO_CTR)
    ppm.set(YAW_CH, SVO_CTR)
    
    'cal_channels
    
'    pause(1000)                 ' Pause for 1 sec
   arm_flight

'    ppm.set(TH_CH, 1_550)
    pause(5000)

'    ppm.set(TH_CH, SVO_MIN)
    
'    pause(500)
    disarm_flight
    
pub pause(ms)

    waitcnt(ms*(clkfreq/1000) + cnt)
    
PRI arm_flight
    ppm.set(ARMING_CH, SVO_MAX)     ' Arm the flight controller
    pause(3000)                     ' Wait for flight controller to arm
    
PRI disarm_flight
    ppm.set(ARMING_CH, SVO_MIN)     ' Disarm the flight controller
    pause(1000)                     ' Wait for flight controller to disarm

PRI cal_channels
 ' Initailize controls
    repeat 5
      ppm.set(TH_CH, SVO_MIN)     ' Set throttle channel to min 1.0 ms
      pause(500)
      ppm.set(TH_CH, SVO_CTR)     ' Set throttle channel to center 1.5 ms
      pause(500)
      ppm.set(TH_CH, SVO_MAX)     ' Set throttle channel to max 2.0 ms
      pause(500)
    ppm.set(TH_CH, SVO_CTR)     ' Set throttle channel to center
    pause(1000)

    repeat 5
      ppm.set(ROLL_CH, SVO_MIN)     ' Set roll channel to min  1.0 ms
      pause(500)
      ppm.set(ROLL_CH, SVO_CTR)     ' Set roll channel to center 1.5 ms
      pause(500)
      ppm.set(ROLL_CH, SVO_MAX)     ' Set roll channel to max 2.0 ms
      pause(500)
    ppm.set(ROLL_CH, SVO_CTR)     ' Set roll channel to center
    pause(1000)

    repeat 5
      ppm.set(PITCH_CH, SVO_MIN)     ' Set pitch channel to min 1.0 ms
      pause(500)
      ppm.set(PITCH_CH, SVO_CTR)     ' Set pitch channel to center 1.5 ms
      pause(500)
      ppm.set(PITCH_CH, SVO_MAX)     ' Set pitch channel to max 2.0 ms
      pause(500)
    ppm.set(PITCH_CH, SVO_CTR)     ' Set pitch channel to center
    pause(1000)

    repeat 5
      ppm.set(YAW_CH, SVO_MIN)     ' Set yaw channel to min 1.0 ms
      pause(500)
      ppm.set(YAW_CH, SVO_CTR)     ' Set yaw channel to center 1.5 ms
      pause(500)
      ppm.set(YAW_CH, SVO_MAX)     ' Set yaw channel to max 2.0 ms
      pause(500)
    ppm.set(YAW_CH, SVO_CTR)     ' Set pitch channel to center
    pause(1000)

    repeat 10
      ppm.set(FMODE_CH, SVO_MIN)     ' Set flight mode channel to min 1.0 ms
      pause(500)
      ppm.set(FMODE_CH, SVO_CTR)     ' Set flight mode channel to center 1.5 ms
      pause(500)
      ppm.set(FMODE_CH, SVO_MAX)     ' Set flight mode channel to max 2.0 ms
      pause(500)
    ppm.set(FMODE_CH, SVO_CTR)     ' Set flight mode channel to center
    pause(1000)

    repeat 10
      ppm.set(ARMING_CH, SVO_MIN)     ' Set arming channel to min 1.0 ms
      pause(500)
      ppm.set(ARMING_CH, SVO_CTR)     ' Set arming channel to center 1.5 ms
      pause(500)
      ppm.set(ARMING_CH, SVO_MAX)     ' Set arming channel to max 2.0 ms
      pause(500)
    ppm.set(ARMING_CH, SVO_CTR)     ' Set arming channel to center
    pause(1000)
    