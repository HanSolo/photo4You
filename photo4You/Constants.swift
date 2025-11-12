//
//  Constants.swift
//  photo4You
//
//  Created by Gerrit Grunwald on 12.11.25.
//

import Foundation


public struct Constants {
    public static let APP_GROUP_ID    : String = "group.eu.hansolo.photo4you"
    
    public static let SECONDS_PER_DAY : Double = 86400
    
    
    // ********** ENUMS **********
    public enum Duration: String, Equatable, CaseIterable, Sendable, Identifiable {
        case SEC_10
        case SEC_30
        case MIN_1
        case MIN_5
        case MIN_10
        case MIN_20
        case MIN_30
        case HOUR_1
        case HOUR_2
        case HOUR_3
        case HOUR_6
        case HOUR_12
        case HOUR_24
        
        var name: String {
            switch self {
                case .SEC_10  : return "10 sec"
                case .SEC_30  : return "30 sec"
                case .MIN_1   : return "1 min"
                case .MIN_5   : return "5 min"
                case .MIN_10  : return "10 min"
                case .MIN_20  : return "20 min"
                case .MIN_30  : return "30 min"
                case .HOUR_1  : return "1 hour"
                case .HOUR_2  : return "2 hour"
                case .HOUR_3  : return "3 hour"
                case .HOUR_6  : return "6 hour"
                case .HOUR_12 : return "12 hour"
                case .HOUR_24 : return "24 hour"
            }
        }
        
        var index: Int {
            switch self {
                case .SEC_10  : return 0
                case .SEC_30  : return 1
                case .MIN_1   : return 2
                case .MIN_5   : return 3
                case .MIN_10  : return 4
                case .MIN_20  : return 5
                case .MIN_30  : return 6
                case .HOUR_1  : return 7
                case .HOUR_2  : return 8
                case .HOUR_3  : return 9
                case .HOUR_6  : return 10
                case .HOUR_12 : return 11
                case .HOUR_24 : return 12
            }
        }
        
        var seconds: TimeInterval {
            switch self {
                case .SEC_10  : return     10
                case .SEC_30  : return     30
                case .MIN_1   : return     60
                case .MIN_5   : return    300
                case .MIN_10  : return    600
                case .MIN_20  : return  1_200
                case .MIN_30  : return  1_800
                case .HOUR_1  : return  3_600
                case .HOUR_2  : return  7_200
                case .HOUR_3  : return 10_800
                case .HOUR_6  : return 21_600
                case .HOUR_12 : return 43_200
                case .HOUR_24 : return 86_400
            }
        }
        
        public var id: UUID {
            switch self {
                case .SEC_10  : return UUID()
                case .SEC_30  : return UUID()
                case .MIN_1   : return UUID()
                case .MIN_5   : return UUID()
                case .MIN_10  : return UUID()
                case .MIN_20  : return UUID()
                case .MIN_30  : return UUID()
                case .HOUR_1  : return UUID()
                case .HOUR_2  : return UUID()
                case .HOUR_3  : return UUID()
                case .HOUR_6  : return UUID()
                case .HOUR_12 : return UUID()
                case .HOUR_24 : return UUID()
            }
        }
        
        public static func fromSeconds(seconds: Double) -> Duration {
            switch seconds {
                case 10     : return .SEC_10
                case 30     : return .SEC_30
                case 60     : return .MIN_1
                case 300    : return .MIN_5
                case 600    : return .MIN_10
                case 1_200  : return .MIN_20
                case 1_800  : return .MIN_30
                case 3_600  : return .HOUR_1
                case 7_200  : return .HOUR_2
                case 10_800 : return .HOUR_3
                case 21_600 : return .HOUR_6
                case 43_200 : return .HOUR_12
                case 86_400 : return .HOUR_24
                default     : return .SEC_10
            }
        }
    }
}
