//
//  roundButton.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/12/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit
import Overture

class PrimaryButton: UIButton {
    override func didMoveToWindow() {
        with(self, primaryButtonStyle)
    }

}
