// Scenario #2: Generating jigsaw puzzle pieces

import UIKit
import XCPlayground

enum Edge {
    case Outie
    case Innie
    case Flat
}

func jigsawPieceMaker(size size: CGFloat, edges: [Edge]) -> UIBezierPath {
    
    func incrementalPathBuilder(firstPoint: CGPoint) -> ([CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(firstPoint)
        return {
            points in
            assert(points.count % 3 == 0)
            for i in 0.stride(through: points.count - 3, by: 3) {
                path.addCurveToPoint(points[i+2], controlPoint1: points[i], controlPoint2: points[i+1])
            }
            
            return path
        }
    }

    
    let outie_coords: [(x: CGFloat, y: CGFloat)] = [/*(0, 0), */ (1.0/9, 0), (2.0/9, 0), (1.0/3, 0), (37.0/60, 0), (1.0/6, 1.0/3), (1.0/2, 1.0/3), (5.0/6, 1.0/3), (23.0/60, 0), (2.0/3, 0), (7.0/9, 0), (8.0/9, 0), (1.0, 0)]
    
    let outie_points = outie_coords.map { CGPointApplyAffineTransform(CGPointMake($0.x, $0.y), CGAffineTransformMakeScale(size, size)) }
    let innie_points = outie_points.map { CGPointMake($0.x, -$0.y) }
    let flat_points = outie_points.map { CGPointMake($0.x, 0) }
    
    var shapeDict: [Edge: [CGPoint]] = [.Outie: outie_points, .Innie: innie_points, .Flat: flat_points]
    
   
    let transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(-M_PI/2)), 0, size)
       let path_builder = incrementalPathBuilder(CGPointZero)
    var path: UIBezierPath!
    for edge in edges {
        path = path_builder(shapeDict[edge]!)
        
        for (e, pts) in shapeDict {
            let tr_pts = pts.map { CGPointApplyAffineTransform($0, transform) }
            shapeDict[e] = tr_pts
        }
    }

    path.closePath()
    return path
}


let piece1 = jigsawPieceMaker(size: 100, edges: [.Innie, .Outie, .Flat, .Innie])

let piece2 = jigsawPieceMaker(size: 100, edges: [.Innie, .Innie, .Innie, .Innie])
piece2.applyTransform(CGAffineTransformMakeRotation(CGFloat(M_PI/3)))




