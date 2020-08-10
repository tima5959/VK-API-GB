//
//  CollectionViewFLowLayout.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 31.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout  {
    
    // Хранит атрибуты для заданных индексов
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnCount = 2 // Количество столбцов
    var cellHeight: CGFloat = 128 // Высота ячейки
    private var totalCellsHeight: CGFloat = 0 // Хранит суммарную высоту всех ячеек
    
    override func prepare() {
        self.cacheAttributes = [:] // Инициализирует атрибуты
        
        // Проверим наличие Collection View
        guard let collectionView = self.collectionView else { return }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        // Проверим что в секции есть хоть одна ячейка
        guard itemCount > 0 else { return }
        
        
        // Определяем ширину большой ячейки
        let bigCellWidth = collectionView.frame.width
        // Определяем ширину маленькой ячейки
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnCount)
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (index + 1) % (columnCount + 1) == 0
            
            if isBigCell {
                attributes.frame = CGRect(x: 0,
                                          y: lastY,
                                          width: bigCellWidth,
                                          height: self.cellHeight)
                
                lastY += self.cellHeight
            } else {
                attributes.frame =  CGRect(x: lastX,
                                           y: lastY,
                                           width: smallCellWidth,
                                           height: self.cellHeight)
                
                let isLastColumn = (index + 2) % (self.columnCount + 2) == 0 || index == itemCount - 1
                if isLastColumn {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX = smallCellWidth
                }
                cacheAttributes[indexPath] = attributes
                self.totalCellsHeight = lastY
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in return
            rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0,
                      height: self.totalCellsHeight)
    }
}
