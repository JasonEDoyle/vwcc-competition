'' =================================================================================================
''
''   File....... jm_ppm.spin
''   Purpose.... 
''   Author..... Jon "JonnyMac" McPhalen (aka Jon Williams)
''               Copyright (c) 2010-2011 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 29 DEC 2010
''   Updated.... 05 JAN 2011
''
'' =================================================================================================

{{

  Creates PPM stream suitable for driving trainer port on RC transmitter, typically through
  a simple NPN open-collector circuit like this:

        470Ω  ┌──── o/c ppm stream
  pin ────
              │
  vss ───────┻──── gnd

  The PPM input is typically pulled up.

  The output is one to eight servo pulses, followed by a final trailing pulse.  The output
  (from pin) usually looks like this:  

    
      │ ch1 │ ch2 │ ch3 │ ch4 │ ch5 │ ch6 │ ch7 │ ch8 │    sync    │ ch1

  Timing is specified in microseconds.  The start method allows the user to set the pin
  to use, the mode (active-high or active-low), the number of channels, the timing for
  the framing pulses and the overall servo frame time.

}}

con

  SVO_MIN = 1_000                                               ' servo limits in microseconds
  SVO_MAX = 2_000

  SVO_CTR = 1_500

  
var

  long  cog
  long  uscnt                                                   ' cnt ticks per microseconds

  long  ppmpin                                                  ' ppm output pin
  long  state                                                   ' lead/lag pulse state
  long  channels                                                ' servo channels, 1 - 8
  long  pulsecnt                                                ' cnt ticks for lead/lag pulse
  long  framecnt                                                ' cnt ticks for servo frame
  
  long  servo[8]                                                ' position values (in microseconds)
  

pub start(pin, level, nservos, uspulse, usframe) | ok

'' Starts PPM cog
'' -- pin     = output pin
'' -- level   = active state of lead/lag pulse
'' -- nservos = number of servos (1 to 8)
'' -- uspulse = microseconds for lead/lag pulse (typically 300, 0.3ms)
'' -- usframe = microseconds for servo frame (typically 20_000, 20ms)

  finalize                                                      ' stop if already running

  uscnt := clkfreq / 1_000_000                                  ' ticks per microsecond

  ppmpin   := pin                                               ' setup cog parameters
  state    := level
  channels := 1 #> nservos <# 8
  pulsecnt := uspulse * uscnt
  framecnt := usframe * uscnt

  setall(SVO_CTR)
    
  ok := cog := cognew(@entry, @ppmpin) + 1                      ' start the cog

  return ok


pub finalize

'' Stops cog (if running)

  if cog
    cogstop(cog~ - 1)


pub set(ch, pos)

'' Sets channel (ch) to pos (microseconds)

  if (ch => 0) and (ch =< 7)                                    ' check for valid channel
    pos := SVO_MIN #> pos <# SVO_MAX                            ' limit position value
    servo[ch] := pos * uscnt                                    ' update channel position


pub setall(pos)

'' Sets all channels to pos (microseconds)

  pos := SVO_MIN #> pos <# SVO_MAX                              ' limit position value 

  longfill(@servo[0], pos * uscnt, 8)                           ' update all channels


pub setbuf(pntr, nchan) | idx, pos

'' Sets servos to positions in buffer (array or DAT) at pntr
'' -- pntr is address of array of words with position values in microseconds
'' -- count is number of channels (1 to 8)

  if (nchan => 1) and (nchan =< 8)                              ' if legal
    repeat idx from 0 to (nchan-1)                              ' loop through desired channels
      pos := SVO_MIN #> word[pntr][idx] <# SVO_MAX              ' read/limit position
      servo[idx] := pos * uscnt                                 ' update channel position
  

dat

                        org     0

entry                   mov     tmp1, par                       ' start of parameters
                        rdlong  tmp2, tmp1                      ' read ppm pin#
                        mov     ppmmask, #1                     ' create mask
                        shl     ppmmask, tmp2

                        add     tmp1, #4
                        rdlong  tmp2, tmp1              wz      ' read active state of pulse
        if_z            or      outa, ppmmask                   ' if low, make idle high
        if_nz           andn    outa, ppmmask                   ' else make idle low
                        or      dira, ppmmask                   ' make pin an output

                        add     tmp1, #4
                        rdlong  chans, tmp1                     ' get # channels

                        add     tmp1, #4
                        rdlong  pulsetix, tmp1                  ' get ticks per lead/lag pulse

                        add     tmp1, #4
                        rdlong  frametix, tmp1                  ' get ticks per servo frame

                        add     tmp1, #4
                        mov     svopntr, tmp1                   ' save hub address of servo[0]

                        mov     ftimer, frametix                ' setup frame timer
                        add     ftimer, cnt                     ' start it
                        
ppmframe                waitcnt ftimer, frametix                ' idle for sync point

                        mov     count, chans                    ' set # channels
                        mov     hub, svopntr                    ' point to servo[0]

:loop                   xor     outa, ppmmask                   ' start pulse
                        mov     stimer, cnt                     ' setup pulse timer
                        add     stimer, pulsetix
                        rdlong  servotix, hub                   ' get channel timing from hub
                        add     hub, #4                         ' point to next channel
                        sub     servotix, pulsetix              ' correct timing for lead/lag pulse
                        waitcnt stimer, servotix                ' let pulse finish
                        xor     outa, ppmmask                   ' back to idle
                        waitcnt stimer, pulsetix                ' let servo timing finish
                        djnz    count, #:loop                   ' update channels

                        xor     outa, ppmmask                   ' lag pulse
                        waitcnt stimer, #0
                        xor     outa, ppmmask

                        jmp     #ppmframe 

' --------------------------------------------------------------------------------------------------

ppmmask                 res     1                               ' mask for ppm pin
chans                   res     1                               ' # of channels
pulsetix                res     1                               ' cnt ticks for lead/lag pulse
frametix                res     1                               ' cnt ticks in servo frame
svopntr                 res     1                               ' pointer to servo[0]

ftimer                  res     1                               ' frame (all servos) timer
stimer                  res     1                               ' servo timer

count                   res     1                               ' for servos loop
hub                     res     1                               ' address of activer servo timing
servotix                res     1                               ' cnt ticks for current servo

tmp1                    res     1                               ' work vars
tmp2                    res     1

                        fit     496                                    

                        
dat

{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

}}  