package main

import (
        "os"
        "encoding/hex"
        "io/ioutil"
        )

func check(e error) {
    if e != nil {
        panic(e)
    }
}
        
func main(){

data, err := ioutil.ReadFile(os.Args[1])
check(err)


midiHex := hex.EncodeToString(data)


println(string(data))
println(midiHex)
println(len(midiHex))

println()
println(string(midiHex[0]))
println(string(midiHex[1]))
println()

println(midiHex)

println(data)
println(data[0])
println(data[1])
println(data[2])

stdoutDumper := hex.Dumper(os.Stdout)

defer stdoutDumper.Close()
stdoutDumper.Write(data)

}