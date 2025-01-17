//
//  CardGroupViewController.swift
//  OceanDesignSystem
//
//  Created by Vini on 08/09/21.
//  Copyright © 2021 Blu Pagamentos. All rights reserved.
//

import Foundation
import UIKit
import OceanTokens
import OceanComponents

final public class CardGroupViewController : UIViewController {
    public override func viewDidLoad() {
        self.view.backgroundColor = Ocean.color.colorInterfaceLightPure
        
        let containerView = UIView()

        containerView.oceanConstraints
            .width(constant: 250)
            .height(constant: 60)
            .make()

        let label = UILabel()
        label.text = "Test card content"
        label.textColor = Ocean.color.colorInterfaceDarkDeep
        containerView.addSubview(label)

        label.oceanConstraints
            .center(to: containerView)
            .make()

        let cardGroup1 = Ocean.CardGroup { view in
            view.image = Ocean.icon.cloudOutline
            view.title = "Title"
            view.badgeStatus = .alert
            view.badgeNumber = 5
            view.cardContentView = containerView
            view.actionTitle = "Call to action"
            view.onTouch = { print("1") }
        }

        let cardGroup2 = Ocean.CardGroup { view in
            view.title = "Title"
            view.subtitle = "Subtitle"
            view.badgeStatus = .highlight
            view.badgeNumber = 8
            view.actionTitle = "Call to action"
            view.onTouch = { print("2") }
        }

        let cardGroup3 = Ocean.CardGroup { view in
            view.title = "Title"
            view.badgeStatus = .neutral
            view.badgeNumber = 0
        }

        let cardGroup4 = Ocean.CardGroup { view in
            view.title = "Title"
        }

        let cardGroup5 = Ocean.CardGroup { view in
            view.title = "Title"
            view.subtitle = "Subtitle"
            view.badgeStatus = .alert
            view.badgeNumber = 9
        }

        let stack = Ocean.StackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Ocean.size.spacingStackXs
        stack.add([cardGroup1, cardGroup2, cardGroup3, cardGroup4, cardGroup5])

        self.view.addSubview(stack)

        stack.oceanConstraints
            .width(constant: 250)
            .centerX(to: self.view)
            .topToTop(to: self.view, constant: 24)
            .make()
    }
}
