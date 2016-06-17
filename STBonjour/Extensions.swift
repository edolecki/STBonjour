//
//  Extensions.swift
//  STBonjour
//
//  Created by Eric Dolecki on 6/16/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

// For creating Mac Addresses. Unsuded at the moment - SoundTouch APIs do not require AA:BB:CC... formatting.

extension String {
    var pairs: [String] {
        var result: [String] = []
        let chars = Array(characters)
        for index in 0.stride(to: chars.count, by: 2) {
            result.append(String(chars[index..<min(index+2, chars.count)]))
        }
        return result
    }
}
