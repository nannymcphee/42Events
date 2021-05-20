//
//  EventCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var cvTags: DynamicHeightCollectionView!
    @IBOutlet weak var lbMedalEngraving: PaddingLabel!
    
    // MARK: - Variables
    private var tags: [EventTag] = []
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
        self.configureCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbTitle.text = nil
        self.lbSubtitle.text = nil
        self.lbMedalEngraving.isHidden = true
        self.ivThumbnail.image = nil
        self.tags.removeAll()
        self.cvTags.reloadData()
    }
    
    // MARK: - Private functions
    private func configureUI() {
        self.lbTitle.font = fontScheme.extraBold16
        self.lbSubtitle.font = fontScheme.medium12
        self.lbMedalEngraving.font = fontScheme.medium14
        
        self.lbTitle.textColor = AppColors.black
        self.lbSubtitle.textColor = AppColors.black
        self.lbMedalEngraving.textColor = .white

        self.lbMedalEngraving.text = "FREE MEDAL ENGRAVING"
        self.lbMedalEngraving.backgroundColor = AppColors.red
        self.lbMedalEngraving.textInsets = UIEdgeInsets.init(all: 8)
        self.lbMedalEngraving.customBorder(cornerRadius: (self.lbMedalEngraving.frame.size.height / 2 + self.lbMedalEngraving.textInsets.top),
                                           borderWidth: 1,
                                           color: .clear)
        
        self.ivThumbnail.customBorder(cornerRadius: 12, borderWidth: 1, color: .clear)
    }
    
    private func configureCollectionView() {
        self.cvTags.registerNib(TagCollectionViewCell.self)
        self.cvTags.delegate = self
        self.cvTags.dataSource = self
        self.cvTags.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
    }

    // MARK: - Public functions
    public func configureCell(data: Event) {
        self.lbTitle.text = data.raceName
        self.lbSubtitle.text = data.racePeriod
        self.lbMedalEngraving.isHidden = !data.isFreeEngraving
        self.ivThumbnail.setImage(url: data.bannerCard)
        self.tags = data.getAllTags()
        self.cvTags.reloadData()
        self.cvTags.layoutIfNeeded()
    }
}

// MARK: - Extensions
extension EventCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(data: tags[indexPath.item])
        return cell
    }
}

extension EventCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = self.tags[indexPath.row]
        let iconWidth: CGFloat = tag.iconName == nil ? 0 : 24
        let labelSize = tag.title.labelSize(font: fontScheme.medium12, considering: collectionView.frame.size.width)
        return CGSize(width: labelSize.width + iconWidth + 16, height: 30.0)
    }
}
