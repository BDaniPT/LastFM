//
//  String+Extension.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

extension String {

    func stringWithoutSpaces() -> String {
        return replacingOccurrences(of: " ", with: "+")
    }
}
