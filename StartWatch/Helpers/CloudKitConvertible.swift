//
//  CloudKitConvertible.swift
//  StartWatch
//
//  Taken from Spencer's After Hours lecture on CloudKit
//  https://www.youtube.com/watch?v=rS5ygb5uds4&feature=youtu.be
//  ~21 min
//

import CloudKit

protocol CloudKitConvertible {
    init?(cloudKitRecord: CKRecord)

    var cloudKitRecord: CKRecord { get }
    var cloudKitRecordID: CKRecord.ID? { get set }

    static var recordTypeKey: String { get }
}
