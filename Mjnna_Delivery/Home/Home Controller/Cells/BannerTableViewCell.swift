//
//  BannerTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 04/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

@objc protocol bannerViewControllerHandlerDelegate: class {
    func bannerProductClick(type:String,image:String,id:String,title:String)
}

import UIKit
import FSPagerView



class BannerTableCell: UITableViewCell {
    
    lazy var title: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.anchor(height:20)
        return lb
    }()
    lazy var subTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.anchor(height:20)
        return lb
    }()
    lazy var stackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [title,subTitle])
        sv.alignment = .fill
        sv.spacing = 5
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()
    lazy var bannerView: FSPagerView = {
       let v = FSPagerView()
        v.layer.cornerRadius = 10
        v.register(BannerCell.self, forCellWithReuseIdentifier: "cell")
       return v
    }()
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.bannerCollectionModel.count
        pc.contentHorizontalAlignment = .center
        pc.currentPageIndicatorTintColor = .gray
        pc.pageIndicatorTintColor = .lightGray
        pc.anchor(height:15)
        return pc
    }()

    var bannerCollectionModel = [BannerData]()
    var delegate:bannerViewControllerHandlerDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.isUserInteractionEnabled = true
        self.bannerView.register(BannerCell.self, forCellWithReuseIdentifier: "cell")
        bannerView.layer.cornerRadius = 10
        self.bannerView.itemSize = self.bannerView.frame.size
            .applying(CGAffineTransform())
        self.pageControl.numberOfPages = self.bannerCollectionModel.count
        self.pageControl.contentHorizontalAlignment = .center
        self.bannerView.automaticSlidingInterval = 3.0
    }
    
   private func setup(){
    self.selectionStyle = .none
    self.bannerView.dataSource = self
    self.bannerView.delegate = self
    self.bannerView.reloadData()
    self.title.text = "BannerTitle".localized
    self.subTitle.text = "BannerSubTitle".localized
    addSubview(stackView)
    stackView.anchor(top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20,height: 45)
    
    addSubview(bannerView)
    bannerView.anchor(top: stackView.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20,height: 160 )
    
    addSubview(pageControl)
    pageControl.anchor(top: bannerView.bottomAnchor,bottom: self.bottomAnchor,paddingTop: 10, width: self.frame.width, height: 15 )
    NSLayoutConstraint.activate([
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
   }

    

}
extension BannerTableCell:FSPagerViewDataSource,FSPagerViewDelegate {

    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerCollectionModel.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! BannerCell
        cell.bannerImageView.loadImageFrom(url:bannerCollectionModel[index].imageUrl , dominantColor: bannerCollectionModel[index].dominant_color)
        cell.categoryName.text = bannerCollectionModel[index].bannerName
        

        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        delegate.bannerProductClick(type: bannerCollectionModel[index].bannerType, image: bannerCollectionModel[index].imageUrl, id: bannerCollectionModel[index].bannerLink,title:bannerCollectionModel[index].bannerName)
        
        self.pageControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}


class BannerCell: FSPagerViewCell {
    
    lazy var bannerImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.opacity = 0.8
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.addSubview(categoryName)
        categoryName.anchor( bottom: iv.bottomAnchor, left: iv.leadingAnchor,right: iv.trailingAnchor, paddingBottom: 30, paddingLeft: 20,paddingRight: 20, height: 15)
        return iv
    }()
    lazy var categoryName: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.anchor(height:15)
        return lb
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
       self.setup()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        self.layer.cornerRadius = 10
        addSubview(bannerImageView)
        bannerImageView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor)
        
        categoryName.anchor(bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingBottom: 30, paddingLeft: 20, paddingRight: 20,height: 20)
        
    }
    
}

