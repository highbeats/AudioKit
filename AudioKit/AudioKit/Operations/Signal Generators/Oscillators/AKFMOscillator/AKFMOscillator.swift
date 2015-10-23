//
//  AKFMOscillator.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/** Classic FM Synthesis audio generation. */
public class AKFMOscillator: AKOperation {

    // MARK: - Properties

    private var internalAU: AKFMOscillatorAudioUnit?
    private var token: AUParameterObserverToken?

    private var baseFrequencyParameter:        AUParameter?
    private var carrierMultiplierParameter:    AUParameter?
    private var modulatingMultiplierParameter: AUParameter?
    private var modulationIndexParameter:      AUParameter?
    private var amplitudeParameter:            AUParameter?

    /** In cycles per second, or Hz, this is the common denominator for the carrier and modulating frequencies. */
    public var baseFrequency: Float = 440 {
        didSet {
            baseFrequencyParameter?.setValue(baseFrequency, originator: token!)
        }
    }
    /** This multiplied by the baseFrequency gives the carrier frequency. */
    public var carrierMultiplier: Float = 1.0 {
        didSet {
            carrierMultiplierParameter?.setValue(carrierMultiplier, originator: token!)
        }
    }
    /** This multiplied by the baseFrequency gives the modulating frequency. */
    public var modulatingMultiplier: Float = 1.0 {
        didSet {
            modulatingMultiplierParameter?.setValue(modulatingMultiplier, originator: token!)
        }
    }
    /** This multiplied by the modulating frequency gives the modulation amplitude. */
    public var modulationIndex: Float = 1.0 {
        didSet {
            modulationIndexParameter?.setValue(modulationIndex, originator: token!)
        }
    }
    /** Output Amplitude. */
    public var amplitude: Float = 0.5 {
        didSet {
            amplitudeParameter?.setValue(amplitude, originator: token!)
        }
    }

    // MARK: - Initializers

    /** Initialize this oscillator operation */
    public override init() {
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x666f7363 /*'fosc'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKFMOscillatorAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKFMOscillator",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.output = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKFMOscillatorAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
            AKManager.sharedInstance.engine.connect(AKManager.sharedInstance.engine.inputNode!, to: self.output!, format: nil)
        }

        guard let tree = internalAU?.parameterTree else { return }

        baseFrequencyParameter        = tree.valueForKey("baseFrequency")        as? AUParameter
        carrierMultiplierParameter    = tree.valueForKey("carrierMultiplier")    as? AUParameter
        modulatingMultiplierParameter = tree.valueForKey("modulatingMultiplier") as? AUParameter
        modulationIndexParameter      = tree.valueForKey("modulationIndex")      as? AUParameter
        amplitudeParameter            = tree.valueForKey("amplitude")            as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.baseFrequencyParameter!.address {
                    self.baseFrequency = value
                }
                else if address == self.carrierMultiplierParameter!.address {
                    self.carrierMultiplier = value
                }
                else if address == self.modulatingMultiplierParameter!.address {
                    self.modulatingMultiplier = value
                }
                else if address == self.modulationIndexParameter!.address {
                    self.modulationIndex = value
                }
                else if address == self.amplitudeParameter!.address {
                    self.amplitude = value
                }
            }
        }

    }
}
