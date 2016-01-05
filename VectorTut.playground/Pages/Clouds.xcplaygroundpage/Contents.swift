/*

- This tutorial takes up two pages in the Playground. To access both, make sure the project navigator is showing. (View > Navigators > Show Project Navigator)

- In order to view the final output, ensure that the Assistant Editor is showing. (View > Assistant Editor > Show Assistant Editor)

*/


// Scenario #1: Making cloud shapes

import UIKit
import XCPlayground

func generateRandomCloud() -> UIImage {
    
    func randomInt(lower lower: Int, upper: Int) -> Int {
        assert(lower < upper)
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    func circle(at center: CGPoint, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
    }
    
    let a = Double(randomInt(lower: 70, upper: 100))
    let b = Double(randomInt(lower: 10, upper: 35))
    let ndiv = 12 as Double
    
    
    let points = (0.0).stride(to: 1.0, by: 1/ndiv).map { CGPoint(x: a * cos(2 * M_PI * $0), y: b * sin(2 * M_PI * $0)) }

    let path = UIBezierPath()
    path.moveToPoint(points[0])
    for point in points[1..<points.count] {
        path.addLineToPoint(point)
    }
    path.closePath()
    
    
    let minRadius = (Int)(M_PI * a/ndiv)
    let maxRadius = minRadius + 25
    
    for point in points[1..<points.count] {
        let randomRadius = CGFloat(randomInt(lower: minRadius, upper: maxRadius))
        let circ = circle(at: point, radius: randomRadius)
        path.appendPath(circ)
    }
    
    //return path
    let (width, height) = (path.bounds.width, path.bounds.height)
    let margin = CGFloat(20)
    UIGraphicsBeginImageContext(CGSizeMake(path.bounds.width + margin, path.bounds.height + margin))
    UIColor.whiteColor().setFill()
    path.applyTransform(CGAffineTransformMakeTranslation(width/2 + margin/2, height/2 + margin/2))
    path.fill()
    let im = UIGraphicsGetImageFromCurrentImageContext()
    return im
}


class View: UIView {
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        UIColor.blueColor().setFill()
        CGContextFillRect(ctx, rect)
        
        let cloud1 = generateRandomCloud().CGImage
        let cloud2 = generateRandomCloud().CGImage
        let cloud3 = generateRandomCloud().CGImage
        CGContextDrawImage(ctx, CGRect(x: 20, y: 20, width: CGImageGetWidth(cloud1), height: CGImageGetHeight(cloud1)), cloud1)
        
        CGContextDrawImage(ctx, CGRect(x: 300, y: 100, width: CGImageGetWidth(cloud2), height: CGImageGetHeight(cloud2)), cloud2)
        
        CGContextDrawImage(ctx, CGRect(x: 50, y: 200, width: CGImageGetWidth(cloud3), height: CGImageGetHeight(cloud3)), cloud3)
    }
}

XCPlaygroundPage.currentPage.liveView = View(frame: CGRectMake(0, 0, 600, 800))
