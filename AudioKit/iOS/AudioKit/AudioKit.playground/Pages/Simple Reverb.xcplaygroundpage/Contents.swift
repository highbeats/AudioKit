//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Simple Reverb
//: ### This is an implementation of Apple's simplest reverb which only allows you to set presets

import XCPlayground
import AudioKit

let bundle = NSBundle.mainBundle()
let file = bundle.pathForResource("drumloop", ofType: "wav")
var player = AKAudioPlayer(file!)
player.looping = true
var reverb = AKReverb(player)

//: Load factory preset and give the dry/wet mix amount here
reverb.loadFactoryPreset(.Cathedral)
reverb.dryWetMix = 0.5

AudioKit.output = reverb
AudioKit.start()

player.play()

//: Toggle processing on every loop
AKPlaygroundLoop(every: 3.428) { () -> () in
    if reverb.isBypassed {
        reverb.start()
    } else {
        reverb.bypass()
    }
    reverb.isBypassed ? "Bypassed" : "Processing" // Open Quicklook for this
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
