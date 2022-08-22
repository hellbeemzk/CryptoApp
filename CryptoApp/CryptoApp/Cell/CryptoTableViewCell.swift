//
//  CryptoTableViewCell.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

final class CryptoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CryptoTableViewCell"
    
    weak var delegate: AddToFavoriteDelegate?
    
    private var addToFavoriteAction: (() -> Void)?
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        return label
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "staroff"), for: .normal)
        button.setImage(UIImage(named: "staron") , for: .selected)
        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
        self.configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setUpViews() {
        contentView.addSubview(self.cellView)
        let cellSubViews = [nameLabel, symbolLabel, priceLabel, starButton, iconImageView]
        cellSubViews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            self.cellView.addSubview(subView)
        }
    }
    
    func configureViews() {
        self.setupLayoutCellView()
        self.setupLayoutImage()
        self.setupLayoutName()
        self.setupLayoutStar()
        self.setupLayoutSymbolLabel()
        self.setupLayoutPriceLabel()
    }
    
    @objc func addToFavorite(sender: UIButton) {
        sender.isSelected.toggle()
        self.addToFavoriteAction?()
        self.delegate?.addToFavorite()
    }
    
    // MARK: - Layout rules
    private func setupLayoutCellView() {
        NSLayoutConstraint.activate([
            self.cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            self.cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            self.cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            self.cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            self.cellView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupLayoutImage() {
        NSLayoutConstraint.activate([
            self.iconImageView.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor),
            self.iconImageView.widthAnchor.constraint(equalToConstant: 45),
            self.iconImageView.leadingAnchor.constraint(equalTo: self.cellView.leadingAnchor, constant: 15)
        ])
    }
    
    private func setupLayoutName() {
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 15),
            self.nameLabel.topAnchor.constraint(equalTo: self.cellView.topAnchor, constant: 10),
        ])
    }
    
    private func setupLayoutStar() {
        NSLayoutConstraint.activate([
            self.starButton.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 15),
            self.starButton.topAnchor.constraint(equalTo: self.cellView.topAnchor, constant: 10),
        ])
    }
    
    private func setupLayoutSymbolLabel() {
        NSLayoutConstraint.activate([
            self.symbolLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 15),
            self.symbolLabel.bottomAnchor.constraint(equalTo: self.cellView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupLayoutPriceLabel() {
        NSLayoutConstraint.activate([
            self.priceLabel.trailingAnchor.constraint(equalTo: self.cellView.trailingAnchor, constant: -20),
            self.priceLabel.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor)
        ])
    }
    
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.nameLabel.text = nil
        self.priceLabel.text = nil
        self.symbolLabel.text = nil
        self.addToFavoriteAction = nil
    }
    
    // MARK: - Configure Method for cell
    
    func configure (with viewModel: ViewModelCellCryptoProtocol) {
        self.nameLabel.text = viewModel.name
        self.symbolLabel.text = viewModel.symbol
        self.priceLabel.text = viewModel.price
        self.starButton.isSelected = viewModel.isFavorite
        self.addToFavoriteAction = {
            viewModel.setFavorite()
        }
        if let data = viewModel.iconData {
            self.iconImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.iconUrl {
            DispatchQueue.main.async {
                self.iconImageView.load(url: url)
            }
        }
    }
    
}
