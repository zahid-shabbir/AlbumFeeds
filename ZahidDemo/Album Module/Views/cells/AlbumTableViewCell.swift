//
//  AlbumTableViewCell.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
import UIKit
// MARK: - Connections
class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    // MARK: - Custom Funcs
    func populate(with: AlbumModel) {
        self.thumbnailImageView.download(from: with.url)
        self.titleLabel.text = self.getSpellAbleAlbum(albumId: with.id)
        self.detailLabel.text = with.title
        self.thumbnailImageView.roundCorners()
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .label
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.lightGray
        self.thumbnailImageView.layer.shadowColor = UIColor.black.cgColor
        self.thumbnailImageView.layer.shadowOpacity = 1
        self.thumbnailImageView.layer.shadowOffset = .zero
        self.thumbnailImageView.layer.shadowRadius = 10
        self.thumbnailImageView.clipsToBounds = false
        self.thumbnailImageView.layer.masksToBounds = true
    }

    /// Generating spellable ids
    /// - Parameter albumId: album id
    /// - Returns: a string with original id and spellable text
    func getSpellAbleAlbum(albumId: Int?) -> String {
        guard let albumId = albumId  else {  return "zero" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let spelableNumber = formatter.string(from: NSNumber(value: albumId)) ?? ""
        return  "\(albumId) - \(spelableNumber.capitalizingFirstLetter())"
    }
}
