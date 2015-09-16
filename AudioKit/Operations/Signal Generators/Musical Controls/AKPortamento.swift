//
//  AKPortamento.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/16/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Applies portamento smoothing to a step-valued control signal.

This applies portamento to a control signal. Useful for smoothing out low-resolution signals and applying glissando to filters. At each new step value, the output is low-pass filtered to move towards that value at a rate determined by halfTime.
*/
@objc class AKPortamento : AKParameter {

    // MARK: - Properties

    private var port = UnsafeMutablePointer<sp_port>.alloc(1)

    private var input = AKParameter()

    /** Time during which the curve will traverse half the distance towards the new value, then half as much again, etc., theoretically never reaching its asymptote. [Default Value: 0.02] */
    private var halfTime: Float = 0



    // MARK: - Initializers

    /** Instantiates the portamento with default values

    - parameter input: Input audio signal. 
    */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates portamento with constants

    - parameter input: Input audio signal. 
    - parameter halfTime: Time during which the curve will traverse half the distance towards the new value, then half as much again, etc., theoretically never reaching its asymptote. [Default Value: 0.02]
    */
    init (input sourceInput: AKParameter, halfTime htimeInput: Float) {
        super.init()
        input = sourceInput
        setup(htimeInput)
        dependencies = [input]
        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal portamento */
    internal func bindAll() {
    }

    /** Internal set up function */
    internal func setup(halfTime: Float = 0.02) {
        sp_port_create(&port)
        sp_port_init(AKManager.sharedManager.data, port, halfTime)
    }

    /** Computation of the next value */
    override func compute() {
        sp_port_compute(AKManager.sharedManager.data, port, &(input.leftOutput), &leftOutput);
        sp_port_compute(AKManager.sharedManager.data, port, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_port_destroy(&port)
    }
}
