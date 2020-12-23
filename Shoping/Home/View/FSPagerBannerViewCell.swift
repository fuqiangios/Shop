//
//  FSPagerBannerViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import FSPagerView

class FSPagerBannerViewCell: FSPagerViewCell {

    @objc open var gif: LLGifImageView? {
        if let _ = _gif {
            return _gif
        }
        let gif = LLGifImageView.init(frame: self.contentView.bounds)
        gif.backgroundColor = .white
        self.contentView.addSubview(gif)
        _gif = gif
        return gif
    }
    fileprivate weak var _gif: LLGifImageView?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("-zz-z-z-\(self.contentView.bounds)")
        if let gif = self.gif {
            gif.frame = self.contentView.bounds

        }
    }
}
