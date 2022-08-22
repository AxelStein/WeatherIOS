//
//  ErrorMessageView.swift
//  Weather
//
//  Created by Александр Шерий on 22.08.2022.
//

import UIKit

class ErrorMessageView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initSubviews()
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ErrorMessageView", bundle: nil)
        // nib.instantiateWithOwner(self, options: nil)
        nib.instantiate(withOwner: self)
        contentView.frame = bounds
        addSubview(contentView)

        // custom initialization logic
    }
}
