/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

let defaultItemScale: CGFloat = 0.7

class LensFlowLayout: UICollectionViewFlowLayout {
  
  override func prepare() {
    super.prepare()
    
    scrollDirection = .horizontal
    minimumLineSpacing = 0
  }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy: [UICollectionViewLayoutAttributes] = []

        for itemAttributes in attributes! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes

            // TODO: Perform layout attributes change here
            changeLayoutAttributes(itemAttributesCopy)
            attributesCopy.append(itemAttributesCopy)
        }

        return attributesCopy
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    private func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        let collectionViewCenter = collectionView!.frame.size.width / 2
        let offset = collectionView!.contentOffset.x
        // Vì centerX của cell là giá trị ko đổi nên để tính khoảng cách giữa centerX của cell và centerX của collectionView thì centerX thực của cell khi scroll đc tính = centerX - offset
        let normalizedCenter = attributes.center.x - offset
        
        let maxDistance = itemSize.width + minimumLineSpacing
        // actualDistance: distance between centerX of cell and centerX of collectionView
        let actualDistance = abs(collectionViewCenter - normalizedCenter)
        
        // scaleDistance: 0 -> maxDistance: 50
        let scaleDistance = min(actualDistance, maxDistance)

        // ratio: 0 -> 1
        let ratio = (maxDistance - scaleDistance) / maxDistance
        // scale: defaultItemScale: 0.7 -> 1
        let scale = defaultItemScale + ratio * (1 - defaultItemScale)
        
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
}

