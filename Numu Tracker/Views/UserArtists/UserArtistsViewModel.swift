//
//  UserArtistsViewModel.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/3/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

protocol UserArtistsViewModelDelegate: class {
    func refreshData()
}

class UserArtistsViewModel {
    weak var delegate: UserArtistsViewModelDelegate?
    fileprivate var artists: [Artist] = []

    public var artistsSectionTitles: [String] = []
    public var artistsSectionDictionaries: [String: [Artist]] = [:]

    var sortMethod: String = defaults.artistSortMethod {
        didSet {
            defaults.artistSortMethod = self.sortMethod
            sortArray()
            createSections()
            delegate?.refreshData()
        }
    }

    fileprivate var lastResult: StorageResult?

    public init(delegate: UserArtistsViewModelDelegate) {
        self.delegate = delegate
    }

    fileprivate func sortArray() {
        self.artists = self.artists.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
    }

    fileprivate func checkForSpecialCharacter(_ artistKey: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: artistKey))
            || !CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: artistKey))
    }

    fileprivate func setupNameSort() {
        artistsSectionTitles = artistsSectionTitles.sorted(by: { $0 < $1 })
        if !artistsSectionTitles.isEmpty {
            if artistsSectionTitles[0] == "#" {
                artistsSectionTitles.remove(at: 0)
                artistsSectionTitles.append("#")
            }
        }
    }

    fileprivate func createSections() {
        artistsSectionDictionaries = [:]
        artistsSectionTitles = []
        for artist in self.artists {
            var artistKey = ""
            switch sortMethod {
            case "name_first":
                artistKey = String(artist.name.prefix(1).uppercased())
                if checkForSpecialCharacter(artistKey) { artistKey = "#" }
            case "name":
                artistKey = String(artist.nameSort.prefix(1).uppercased())
                if checkForSpecialCharacter(artistKey) { artistKey = "#" }
            default:
                artistKey = String(artist.name.prefix(1).uppercased())
                if checkForSpecialCharacter(artistKey) { artistKey = "#" }
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MMMM d, yyyy"
//                if let date = dateFormatter.date(from: artist.recentRelease) {
//                    dateFormatter.dateFormat = "yyyy"
//                    if artist.recentRelease == "December 31, 1969" {
//                        artistKey = "None"
//                    } else {
//                        artistKey = String(dateFormatter.string(from: date).prefix(4))
//                    }
//                } else {
//                    artistKey = "None"
//                }
            }
            if var artistValues = artistsSectionDictionaries[artistKey] {
                artistValues.append(artist)
                artistsSectionDictionaries[artistKey] = artistValues
            } else {
                artistsSectionDictionaries[artistKey] = [artist]
            }
        }
        artistsSectionTitles = [String](artistsSectionDictionaries.keys)
        switch sortMethod {
        case "name_first":
            setupNameSort()
        case "name":
            setupNameSort()
        default:
            setupNameSort()
//            artistsSectionTitles = artistsSectionTitles.sorted(by: { $0 > $1 })
//            if !artistsSectionTitles.isEmpty {
//                if artistsSectionTitles[0] == "None" {
//                    artistsSectionTitles.remove(at: 0)
//                    artistsSectionTitles.append("None")
//                }
//            }
        }
    }

    public func loadArtists() {
        numuDataCoordinator.fetchUserArtists(sinceDateUpdated: nil, offset: self.artists.count) { (result, _) in
            if let storageResult = result, let artists = storageResult.items as? [Artist] {
                self.lastResult = storageResult
                self.artists.append(contentsOf: artists)
                if self.lastResult?.resultsRemaining ?? 0 > 0 {
                    self.loadArtists()
                } else {
                    self.sortArray()
                    self.createSections()
                    DispatchQueue.main.async {
                        self.delegate?.refreshData()
                    }
                }
            }
        }
    }

}

extension UserArtistsViewModel: SortViewDelegate {
    func sortOptionTapped(name: String) {
        self.sortMethod = name
    }
}
