//
//  Column.swift
//  AdaptiveItemSizeLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class Column {
    private let configuration: AdaptiveItemSizeLayout.Configuration
    private let columnNumber: Int
    private var attributesSet = [UICollectionViewLayoutAttributes]()
    private(set) var maxY: CGFloat = 0.0
    
    init(configuration: AdaptiveItemSizeLayout.Configuration, columnNumber: Int) {
        self.configuration = configuration
        self.columnNumber = columnNumber
    }
    
    private var originX: CGFloat {
        var x = configuration.sectionInsets.left
        if columnNumber != 0 {
            x += (configuration.itemWidth + configuration.minimumInterItemSpacing) * CGFloat(columnNumber)
        }
        return x
    }
    
    private var originY: CGFloat {
        return (attributesSet.count == 0) ? configuration.sectionInsets.top : maxY + configuration.minimumLineSpacing
    }
    
    func addAttributes(indexPath: NSIndexPath, itemSize: CGSize) {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = CGRect(x: originX, y: originY, width: configuration.itemWidth, height: configuration.itemHeight(rawItemSize: itemSize))
        maxY = attributes.frame.maxY
        attributesSet.append(attributes)
    }
    
    func getAttributes(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesSet.filter{
            $0.indexPath.section == indexPath.section && $0.indexPath.item == indexPath.item
        }.first
    }
    
    func getAttributes(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        return attributesSet.filter{ CGRectIntersectsRect($0.frame, rect) }
    }
}