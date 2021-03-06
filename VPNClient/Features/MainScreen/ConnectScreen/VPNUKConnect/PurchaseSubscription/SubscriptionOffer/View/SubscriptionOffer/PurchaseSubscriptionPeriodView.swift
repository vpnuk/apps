//
//  PurchaseSubscriptionPeriodView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionPeriodView: UIView {
    private lazy var appearance = Appearance()
    private var optionSelectedAction: ((_ index: Int) -> Void)?
    private var infoTapAction: (() -> Void)?
    
    // MARK: - Content
    
    private lazy var tooltipView = PurchaseSubscriptionTooltipView()
    
    private lazy var periodQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        button.addTarget(self, action: #selector(quastionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var choosePeriodLabel: UILabel = {
        let label = UILabel()
        label.textColor = appearance.choosePeriodLabelColor
        label.font = appearance.choosePeriodLabelFont
        return label
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            choosePeriodLabel,
            periodQuastionButton,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.periodLabelStackViewSpacing
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            scrollView,
            tooltipView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.headerAndScrollViewSpacing
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(optionsStackView)
        return scroll
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildOptionViews(fromOption options: [Option], selectedIndex: Int?) -> [PurchaseSubscriptionOptionView] {
        let optionsViews = options.enumerated().map { index,option -> PurchaseSubscriptionOptionView in
        let optionView = PurchaseSubscriptionOptionView()
            
            optionView.update(model: .init(
                title: option.title,
                tappedAction: { [weak self] in self?.optionSelectedAction?(index) },
                isSelected: selectedIndex == index
                ))
            return optionView
        }
        return optionsViews
    }
    
    func update(model: Model) {
        optionSelectedAction = model.optionSelectedAction
        choosePeriodLabel.text = model.title
        let newOptionsView = buildOptionViews(
            fromOption: model.options,
            selectedIndex: model.selectedOptionIndex
        )
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for optionView in newOptionsView {
            optionsStackView.addArrangedSubview(optionView)
        }
        periodQuastionButton.isHidden = model.infoTapAction == nil
        infoTapAction = model.infoTapAction
        
        if let tooltip = model.tooltipModel {
            tooltipView.isHidden = false
            tooltipView.update(model: tooltip)
        } else {
            tooltipView.isHidden = true
        }
        
    }
    
    @objc private func quastionButtonTapped(){
        infoTapAction?()
    }
    
    private func setupSubviews() {
        tooltipView.isHidden = true
        addSubview(contentStackView)
        scrollView.contentInset = appearance.scrollViewContentInsets
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(optionsStackView.snp.height)
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        optionsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionPeriodView {
    struct Model {
        let title: String
        let options: [Option]
        let selectedOptionIndex: Int?
        let optionSelectedAction: (_ index: Int) -> Void
        let infoTapAction: (() -> Void)?
        let tooltipModel: PurchaseSubscriptionTooltipView.Model?
    }
    
    struct Option {
        let title: String
    }
    
    struct Appearance {
        //MARK: - ChoosePeriod Appearance
        let choosePeriodLabelFont = Style.Fonts.standartBoldFont
        let choosePeriodLabelColor = Style.Color.darkGrayColor
        
        //MARK: - StackViews Appearance
        let contentStackViewSpacing = Style.Spacing.standartSpacing
        let headerAndScrollViewSpacing = Style.Constraint.smallConstreint
        let periodLabelStackViewSpacing = Style.Spacing.standartSpacing
        let scrollViewContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

