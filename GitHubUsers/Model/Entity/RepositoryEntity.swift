//
//  RepositoryEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/19.
//

import Foundation

struct RepositoryEntity: Identifiable, Hashable {
    var id = UUID()
    var name: String = localString.hyphen()
    var owner: String = localString.empty()
    var isPrivate: Bool =  false
    var htmlUrl: String = localString.empty()
    var description: String = localString.empty()
    var fork: Bool =  false
    var url: String =  localString.hyphen()
    var stargazers: String = localString.zero()
    var watchers: String = localString.zero()
    var forks: String = localString.zero()
    var lanuage: String = localString.empty()
    var allow_forking: Bool =  false
}

extension RepositoryEntity {
    init(_ src: GitReposItem ) {
        name = src.name ?? localString.hyphen()
        owner = src.owner?.login ?? localString.empty()
        isPrivate = src._private ?? false
        htmlUrl = src.htmlUrl ?? localString.empty()
        description = src._description ?? localString.empty()
        fork = src.fork ?? false
        url = src.url ?? localString.hyphen()
        stargazers = (src.stargazersCount ?? 0) .formatPoints()
        watchers = (src.watchersCount ?? 0) .formatPoints()
        lanuage = src.language ?? localString.empty()
        forks = (src.forksCount ?? 0) .formatPoints()
        allow_forking = src.allowForking ?? false
    }
    
    func isEqual(owner: String, repo: String) -> Bool {
        return self.owner == owner && self.name == repo
    }
}
