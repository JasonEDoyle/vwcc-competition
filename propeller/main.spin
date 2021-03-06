'' =================================================================================================
''
''   File....... main.spin
''   Purpose.... 
''   Author..... Jason Doyle
''               Copyright (c) 2015 Jason Doyle
''   E-mail..... jason.e.doyle@gmail.com
''   Started.... SEP. 06, 2015
''   Updated.... NOV. 17, 2015
''
'' =================================================================================================

CON

    _clkmode = xtal1 + pll16x       ' System clock 80 MHz
    _xinfreq = 6_000_000

' Pin Connections
    PING_PIN    = 14
    PPM_PIN     = 7
    ARMED_LED   = 27
    AUTO_LED    = 26
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
    SVO_MIN     = 1_000                 ' servo limits in microseconds
    SVO_MAX     = 2_000

    SVO_CTR     = 1_500
    
' Flight Parameters
    HOVER_HEIGHT = 12                   ' Hover height in centimeters

VAR
    long  pulsewidth[6]
    long  distace
      
DAT
  pins          LONG 1, 2, 3, 4, 5, 6
  
OBJ

    ppm     :   "jm_ppm"
    serial  :   "FullDuplexSerial"
    ping    :   "Ping"
    rx      :   "RX"
        
PUB Main | i
    
    serial.Start (31,  30, 0, 115_200)      ' Communicate with debug cable
'    serial.Start (16, 15, 0, 115_200)      ' Communicate with RPi
    ppm.start(PPM_PIN, 0, 6, 300, 20_000) ' 6 servos/channels, 300us suggested from jm_ppm.spin, 20_000 suggested from jm_ppm.spin
    pause(1)
    
    ' Intialize all the channels   
    ppm.setall(SVO_MIN)                     ' Set all channels to min value

'    ppm.set(ROLL_CH, SVO_CTR)              ' Set controls to center
'    ppm.set(PITCH_CH, SVO_CTR)
'    ppm.set(YAW_CH, SVO_CTR)
    
    dira[ARMED_LED] := 1                    ' Set arming LED pin to output
    dira[AUTO_LED]  := 1                    ' Set Autonomous LED pin to output
                                            ' 
    'cal_channels

    rx.Start(@pins,@pulseWidth)
    
    repeat
         
        autonomous_flight
        if pulsewidth[5] > 1_500            ' Arm flight. RC knob
            arm_flight
            
            if pulsewidth[4] > 1_500            ' Switch to autonomous mode. RC switch
                autonomous_flight
            
            else
                outa[AUTO_LED] := 0
                ppm.set(0, pulsewidth[2])
                ppm.set(1, pulsewidth[0])
                ppm.set(2, pulsewidth[1])
                ppm.set(3, pulsewidth[3])

        else                              ' Disarm flight. RC knob
            'ppm.setall(SVO_MIN)
            disarm_flight
            
        
            
    
PUB pause(ms)

    waitcnt(ms*(clkfreq/1000) + cnt)
    
'PUB rx_input  | i, pulse[6]
'
'    rx.start(@pins,@pulseWidth)
'    waitcnt(clkfreq/2 + cnt)

PUB autonomous_flight | distance, throttle
    'TODO
    'add Ping sensor
    outa[AUTO_LED] := 1
    distance := ping.Centimeters(PING_PIN)  ' Get distance in centimeters
    pause(10)                               ' Required to allow secondary echos to die out.
    
'    if distance < 17
        ' throttle up
'        throttle++
'    if distance > 21
        ' throttle down
'        throttle--
        
    ppm.set(TH_CH, throttle)

'    pause(1000)
    serial.Dec(distance)                    ' Output ping distance to terminal
    serial.Tx(13)                           ' New line

PRI arm_flight

    outa[ARMED_LED] := 1                    ' Turn on arming LED
    ppm.set(ARMING_CH, SVO_MAX)             ' Arm the flight controller
    'pause(3000)                            ' Wait for flight controller to arm
    
PRI disarm_flight

    outa[ARMED_LED] := 0                    ' Turn off arming LED
    ppm.set(ARMING_CH, SVO_MIN)             ' Disarm the flight controller
    'pause(1000)                            ' Wait for flight controller to disarm

PRI cal_channels

 ' Initailize controls
    repeat 5
      ppm.set(TH_CH, SVO_MIN)           ' Set throttle channel to min 1.0 ms
      pause(500)
      ppm.set(TH_CH, SVO_CTR)           ' Set throttle channel to center 1.5 ms
      pause(500)
      ppm.set(TH_CH, SVO_MAX)           ' Set throttle channel to max 2.0 ms
      pause(500)
    ppm.set(TH_CH, SVO_CTR)             ' Set throttle channel to center
    pause(1000)

    repeat 5
      ppm.set(ROLL_CH, SVO_MIN)         ' Set roll channel to min  1.0 ms
      pause(500)
      ppm.set(ROLL_CH, SVO_CTR)         ' Set roll channel to center 1.5 ms
      pause(500)
      ppm.set(ROLL_CH, SVO_MAX)         ' Set roll channel to max 2.0 ms
      pause(500)
    ppm.set(ROLL_CH, SVO_CTR)           ' Set roll channel to center
    pause(1000)

    repeat 5
      ppm.set(PITCH_CH, SVO_MIN)        ' Set pitch channel to min 1.0 ms
      pause(500)
      ppm.set(PITCH_CH, SVO_CTR)        ' Set pitch channel to center 1.5 ms
      pause(500)
      ppm.set(PITCH_CH, SVO_MAX)        ' Set pitch channel to max 2.0 ms
      pause(500)
    ppm.set(PITCH_CH, SVO_CTR)          ' Set pitch channel to center
    pause(1000)

    repeat 5
      ppm.set(YAW_CH, SVO_MIN)          ' Set yaw channel to min 1.0 ms
      pause(500)
      ppm.set(YAW_CH, SVO_CTR)          ' Set yaw channel to center 1.5 ms
      pause(500)
      ppm.set(YAW_CH, SVO_MAX)          ' Set yaw channel to max 2.0 ms
      pause(500)
    ppm.set(YAW_CH, SVO_CTR)            ' Set pitch channel to center
    pause(1000)

    repeat 10
      ppm.set(FMODE_CH, SVO_MIN)        ' Set flight mode channel to min 1.0 ms
      pause(500)
      ppm.set(FMODE_CH, SVO_CTR)        ' Set flight mode channel to center 1.5 ms
      pause(500)
      ppm.set(FMODE_CH, SVO_MAX)        ' Set flight mode channel to max 2.0 ms
      pause(500)
    ppm.set(FMODE_CH, SVO_CTR)          ' Set flight mode channel to center
    pause(1000)

    repeat 10
      ppm.set(ARMING_CH, SVO_MIN)       ' Set arming channel to min 1.0 ms
      pause(500)
      ppm.set(ARMING_CH, SVO_CTR)       ' Set arming channel to center 1.5 ms
      pause(500)
      ppm.set(ARMING_CH, SVO_MAX)       ' Set arming channel to max 2.0 ms
      pause(500)
    ppm.set(ARMING_CH, SVO_CTR)         ' Set arming channel to center
    pause(1000)
    
