//
//  UIUpdates.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/21/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

func updateInMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
