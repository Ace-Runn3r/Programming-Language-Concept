/*
 * Author: Cole Clements, cclements2016@my.fit.edu
 * Course: CSE 4250, Spring 2019
 * Project: Proj2, Midi Decoder
 * Implementation: go version go1.11.5 windows intel/64
 */
package main

import (
	"fmt"
	"os"
	"strconv"

	//"encoding/hex"
	"io/ioutil"
)

type Note struct {
	NoteName string
	Octave   int
	Duration int
	Track    int
	Channel  int
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func outputLine(tick int, note string, octa int, dur int, tra int, chn int) {
	fmt.Printf("%07d:  %-2s    %d         %05d    %02d      %02d\n", tick, note, octa, dur, tra, chn)
}

func RemoveIndex(list []Note, index int) []Note {
	return append(list[:index], list[index+1:]...)
}

func main() {
	var notOnQueue []Note
	Notes := [12]string{"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}

	data, err := ioutil.ReadFile(os.Args[1])
	check(err)

	println("ticks     note octave duration track channel")
	tick, octa, dur, chn := 0, 0, 0, 0
	note := "C"
	pos := 0
	tra := 2 //hard codded for now
	var offNote Note

	for x := 0; x < len(data); x++ {
		if (data[x] == 0) && (data[x+1] == 192) && (data[x+2] == 0) {
			pos = x + 3
			break
		}
	}

	//println(data[80])
	done := false
	noteOn, noteOff := true, false
	for !done {
		//println(len(notOnQueue))
		if (data[pos] == 255) && (data[pos+1] == 47) { // end of track
			break

		} else if data[pos] == 0 { // note on?
			pos++
			channel := strconv.FormatInt(int64(data[pos]), 2)[4:] // chnnel prototype
			chanNum, err := strconv.ParseInt(channel, 2, 16)
			check(err)
			chn = int(chanNum) + 1

			onOffbinary := strconv.FormatInt(int64(data[pos]), 2)[:4] // not on/off flag protoye
			noteCheckNumber, err := strconv.ParseInt(onOffbinary, 2, 16)
			check(err)
			if noteCheckNumber == 9 {
				noteOn = true
			}

			pos++                               // next byte
			note = Notes[(int(data[pos]) % 12)] // note octave prototype
			octa = (int(data[pos]) / 12) - 1

			if noteOn { // add note press to qeue waiting for unpress
				noteAdded := Note{note, octa, dur, tra, chn}
				notOnQueue = append(notOnQueue, noteAdded)
			} else {
				noteOff = true
				for e := 0; e < len(notOnQueue); e++ {
					if (notOnQueue[e].NoteName == note) && (notOnQueue[e].Octave == octa) && (notOnQueue[e].Channel == chn) {

						offNote = notOnQueue[e]
						offNote.Duration = dur
						notOnQueue = RemoveIndex(notOnQueue, e)
						break
					}
				}
			}

			pos = pos + 2 //skip velocity

		} else if data[pos] > 2 { // durration
			//println(pos)
			lowBi := strconv.FormatInt(int64(data[pos]), 2)[1:] // Dur prototype
			highBi := ""
			pos++ // move to next byte
			if data[pos] == 0 {
				lowBi = lowBi + "0000000"
			} else {
				highBi = strconv.FormatInt(int64(data[pos]), 2)[1:]
				lowBi = lowBi + highBi
			}

			time, err := strconv.ParseInt(lowBi, 2, 16)
			check(err)
			dur = int(time)

			pos++ // next byte

			onOffbinary := strconv.FormatInt(int64(data[pos]), 2)[:4] // not on/off flag protoye
			noteCheckNumber, err := strconv.ParseInt(onOffbinary, 2, 16)
			check(err)
			if noteCheckNumber == 9 {
				noteOn = true
				channel := strconv.FormatInt(int64(data[pos]), 2)[4:] // chnnel prototype
				chanNum, err := strconv.ParseInt(channel, 2, 16)
				check(err)
				chn = int(chanNum) + 1
			} else {
				noteOff = true
			}
			pos++                               // next byte
			note = Notes[(int(data[pos]) % 12)] // note octave prototype
			octa = (int(data[pos]) / 12) - 1
			if noteOn {
				noteAdded := Note{note, octa, dur, tra, chn} // add note press to qeue waiting for unpress
				notOnQueue = append(notOnQueue, noteAdded)

			} else {
				noteOff = true
				for e := 0; e < len(notOnQueue); e++ {
					if (notOnQueue[e].NoteName == note) && (notOnQueue[e].Octave == octa) && (notOnQueue[e].Channel == chn) {
						offNote = notOnQueue[e]
						offNote.Duration = dur
						notOnQueue = RemoveIndex(notOnQueue, e)
						break
					}
				}
			}
			pos = pos + 2 // skip celocity

		} else {
			pos++
		}
		noteOn = false
		if noteOff {
			dur = offNote.Duration
			tra = offNote.Track
			chn = offNote.Channel
			note = offNote.NoteName
			octa = offNote.Octave
			outputLine(tick, note, octa, offNote.Duration, tra, chn)
			tick = tick + dur
			noteOff = false
		}
	}
}
