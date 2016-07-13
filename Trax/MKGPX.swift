//
//  MKGPX.swift
//  Trax
//
//  Created by Alfred on 16/7/13.
//  Copyright © 2016年 WanXunAlfred. All rights reserved.
//

import Foundation
import MapKit

extension GPX.Waypoint:MKAnnotation{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return name }
    
    var subtitle: String? { return info }
}