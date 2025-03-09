//
//  allEventsTVCellTableViewCell.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/10/7.
//

import UIKit

class AllEventsTVCell: UITableViewCell {
    var dateStr: String!
    var nameStr: String!
    var noteStr: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setCell()
        setCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear        
        // 添加约束使contentView左右有间距
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ST_DP(20)),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ST_DP(20)),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ST_DP(16))
        ])
        
        // 设置圆角
        self.contentView.layer.cornerRadius = ST_DP(16)
        self.contentView.layer.masksToBounds = true
        
    }
    
    func setCellContent() {
        let idLb = UILabel(
            frame: CGRect(
                x: ST_DP(12),
                y: ST_DP(16),
                width: 0,
                height: ST_DP(18)
            )
        )
        idLb.text = "\(dateStr ?? "7.24")由\(nameStr ?? "天黑黑")添加"
        idLb.textColor = ColorHex(hexStr: "C9CDD4")
        idLb.font = .systemFont(ofSize: ST_DP(13))
        idLb.sizeToFit()
        self.contentView.addSubview(idLb)
        
        let noteLb = UILabel(
            frame: CGRect(
                x: ST_DP(12),
                y: ST_DP(46),
                width: ST_DP(319),
                height: ST_DP(52)
            )
        )
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = ST_DP(13)
        noteLb.attributedText = NSAttributedString(
            string: "\(noteStr ?? "参与的《青春环游记》第一季第2期参与的《青春环游记》第一季第2期")",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: ST_DP(16)),
                .paragraphStyle: paraStyle
            ]
        )
        noteLb.textColor = ColorHex(hexStr: "1D2129")
        noteLb.numberOfLines = 0
        
        self.contentView.addSubview(noteLb)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
