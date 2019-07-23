//
//  Bundle+Utility.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

internal extension Bundle {
    static func resourceBundle(for type: AnyClass) -> Bundle? {
        let frameworkBundle = Bundle(for: type)
        let frameworkName = frameworkBundle.resourceURL?.deletingPathExtension().lastPathComponent
        if let pathToResourceBundle = frameworkBundle.path(forResource: frameworkName, ofType: "bundle") {
            if let bundle = Bundle(path: pathToResourceBundle) {
                return bundle
            }
        }
        return nil
    }
}
