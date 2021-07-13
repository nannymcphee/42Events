//
//  EventContentView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit

class EventContentView: BaseView {
    // MARK: - IBOutlets
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var cvTags: DynamicHeightCollectionView!
    @IBOutlet weak var lbMedalEngraving: PaddingLabel!
    @IBOutlet weak var vContent: UIView!
    
    // MARK: - Variables
    private var tags: [EventTag] = []
    
    // MARK: - Overrides
    override func initialize() {
        super.initialize()
        self.nibSetup()
        self.initUI()
        self.initCollectionView()
    }
    
    override func updateLocalize() {
        super.updateLocalize()
        self.lbMedalEngraving.text = Text.freeMedalEngraving.localized
    }
    
    // MARK: - Private functions
    private func initUI() {
        self.lbTitle.font = fontScheme.extraBold16
        self.lbSubtitle.font = fontScheme.medium12
        self.lbMedalEngraving.font = fontScheme.medium14
        
        self.lbTitle.textColor = AppColors.black
        self.lbSubtitle.textColor = AppColors.black
        self.lbMedalEngraving.textColor = .white
        
        self.lbMedalEngraving.text = Text.freeMedalEngraving.localized
        self.lbMedalEngraving.backgroundColor = AppColors.red
        self.lbMedalEngraving.textInsets = UIEdgeInsets.init(all: 8)
        self.lbMedalEngraving.customBorder(cornerRadius: (self.lbMedalEngraving.frame.size.height / 2 + self.lbMedalEngraving.textInsets.vertical),
                                           borderWidth: 1,
                                           color: .clear)
        
        self.ivThumbnail.customBorder(cornerRadius: 12, borderWidth: 1, color: .clear)
    }
    
    private func initCollectionView() {
        self.cvTags.registerNib(TagCollectionViewCell.self)
        self.cvTags.delegate = self
        self.cvTags.dataSource = self
        self.cvTags.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
    }
    
    // MARK: - Public functions
    public func populateData(_ data: EventModel) {
        self.lbTitle.text = data.raceName
        self.lbSubtitle.text = data.racePeriod
        self.lbMedalEngraving.isHidden = !data.isFreeEngraving
        self.ivThumbnail.setImage(url: data.bannerCard)
        self.tags = data.getAllTags()
        self.cvTags.reloadData()
        self.cvTags.layoutIfNeeded()
    }
    
    public func resetData() {
        self.lbTitle.text = nil
        self.lbSubtitle.text = nil
        self.lbMedalEngraving.isHidden = true
        self.ivThumbnail.image = nil
        self.tags.removeAll()
        self.cvTags.reloadData()
    }
}

// MARK: - Extensions
extension EventContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(data: tags[indexPath.item])
        return cell
    }
}

extension EventContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = self.tags[indexPath.row]
        let iconWidth: CGFloat = tag.iconName == nil ? 0 : 24
        let labelHorizontalPadding: CGFloat = 16
        let labelSize = tag.title.localized.labelSize(font: fontScheme.medium12, considering: collectionView.frame.size.width)
        return CGSize(width: labelSize.width + iconWidth + labelHorizontalPadding, height: 30.0)
    }
}
