//
//  Ocean+FloatVerticalMenuList.swift
//  FSCalendar
//
//  Created by Leticia Fernandes on 17/03/22.
//

import Foundation
import OceanTokens
import UIKit
import SkeletonView

extension Ocean {
    public class FloatVerticalMenuList: UIView {

        public var navigationItem: UINavigationItem? {
            didSet {
                addRightBarButtonItem()
            }
        }

        public var iconNavBarButton: UIImage? = Ocean.icon.dotsVerticalOutline {
            didSet {
                addRightBarButtonItem()
            }
        }

        public var iconNavBarButtonTintColor: UIColor = Ocean.color.colorBrandPrimaryPure {
            didSet {
                addRightBarButtonItem()
            }
        }

        public var options: [OceanNavigationBarOption] = [] {
            didSet {
                updateUI()
            }
        }

        public var onTouch: ((OceanNavigationBarOption) -> Void)?

        private lazy var menuOptionsShadowContainerView: UIView = {
            let shadowView = UIView()
            shadowView.backgroundColor = .clear
            shadowView.layer.shouldRasterize = true
            shadowView.layer.rasterizationScale = UIScreen.main.scale
            shadowView.layer.shadowColor = #colorLiteral(red: 0.05149866641, green: 0.05984989554, blue: 0.1014773026, alpha: 0.6).cgColor
            shadowView.layer.shadowOpacity = 0.2
            shadowView.layer.shadowRadius = 15.0
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)

            return shadowView
        }()

        private lazy var menuOptionsContainerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = Ocean.color.colorInterfaceLightPure
            containerView.layer.cornerRadius = 8.0
            containerView.clipsToBounds = true

            return containerView
        }()

        private lazy var verticalStackView: Ocean.StackView = {
            Ocean.StackView { stack in
                stack.axis = .vertical
                stack.alignment = .fill
                stack.distribution = .fill
                stack.spacing = .zero
            }
        }()

        private lazy var contentStack: Ocean.StackView = {
            Ocean.StackView { stack in
                stack.axis = .horizontal
                stack.distribution = .fill
                stack.alignment = .fill
                stack.translatesAutoresizingMaskIntoConstraints = false

                menuOptionsShadowContainerView.addSubview(menuOptionsContainerView)
                menuOptionsContainerView.addSubview(verticalStackView)

                stack.add([
                    menuOptionsShadowContainerView
                ])

            }
        }()

        private lazy var mainStack: Ocean.StackView = {
            Ocean.StackView { stack in
                stack.axis = .vertical
                stack.distribution = .fill
                stack.translatesAutoresizingMaskIntoConstraints = false

                stack.add([
                    contentStack
                ])

                stack.isLayoutMarginsRelativeArrangement = true
                stack.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }()

        public convenience init(builder: FloatVerticalMenuListBuilder = nil) {
            self.init()
            builder?(self)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            self.addSubview(mainStack)
            self.setupConstraints()
        }

        private func setupConstraints() {
            self.mainStack.setConstraints(([.topToTop(Ocean.size.spacingInsetXxs),
                                            .trailingToTrailing(Ocean.size.spacingInsetXs)], toView: self))
            self.menuOptionsContainerView.setConstraints((.fillSuperView, toView: menuOptionsShadowContainerView))
            self.verticalStackView.setConstraints(([.marginEqual(0)], toView: menuOptionsContainerView))
            self.layoutIfNeeded()
        }

        private func addRightBarButtonItem() {
            guard self.navigationItem != nil else { return }

            let icon = self.iconNavBarButton?.tinted(with: self.iconNavBarButtonTintColor)
            let barButtonItem = OceanBarButtonItem(image: icon,
                                                   style: .plain,
                                                   target: self, action: nil)
            barButtonItem.action = #selector(self.handleMenuVisibility)
            self.navigationItem?.rightBarButtonItem = barButtonItem
        }

        @objc private func handleMenuVisibility() {
            self.isHidden = !self.isHidden
        }

        private func updateUI() {
            verticalStackView.removeSubviews()

            for index in 0..<options.count {
                let itemMenu = options[index]

                let iconImageView = UIImageView { imageView in
                    imageView.image = itemMenu.image?.withRenderingMode(.alwaysTemplate)
                    imageView.tintColor = itemMenu.tintColor
                    imageView.contentMode = .center
                }

                let titleLabel = Ocean.Typography.description { label in
                    label.text = itemMenu.title
                    label.textColor = itemMenu.tintColor
                    label.numberOfLines = 1
                    label.setContentHuggingPriority(.required, for: .horizontal)
                }

                let button = UIButton(frame: .zero)
                button.tag = index
                button.setTitle("", for: .normal)
                button.addTarget(self, action: #selector(self.itemTapped(_:)), for: .touchUpInside)

                let containerItemView = UIView()
                containerItemView.backgroundColor = .clear
                containerItemView.addSubviews(iconImageView, titleLabel, button)

                verticalStackView.addArrangedSubview(containerItemView)


                iconImageView.setConstraints(([.height(Ocean.size.spacingStackXs),
                                               .leadingToLeading(20),
                                               .topToTop(itemMarginTop(index)),
                                               .bottomToBottom(itemMarginBottom(index))], toView: containerItemView))

                titleLabel.setConstraints(([.trailingToTrailing(20)], toView: containerItemView),
                                          ([.leadingToTrailing(Ocean.size.spacingStackXs),
                                            .centerVertically], toView: iconImageView))

                button.setConstraints((.fillSuperView, toView: containerItemView))
            }
        }

        func itemMarginTop(_ index: Int) -> CGFloat {
            let isFirst = index == 0
            let marginTop: CGFloat = isFirst ? 20 : 10
            return marginTop
        }

        func itemMarginBottom(_ index: Int) -> CGFloat {
            let isLast = index == options.count - 1
            let marginBottom: CGFloat = isLast ? 20 : 10
            return marginBottom
        }

        @objc func itemTapped(_ sender: Any?) {
            if let button = sender as? UIButton, button.tag < self.options.count {
                let itemMenu = self.options[button.tag]
                self.onTouch?(itemMenu)
            }
        }
    }
}
