//
//  CurrentFilm.swift
//  FilmSearch
//
//  Created by Denys on 18.10.16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import Foundation


class CurrentFilm {
  let title: String?
  let year: String?
  let poster: String?
  let director: String?
  let writer: String?
  let actors: String?
  let country: String?
  let imdbRating: String?
  let imdbVotes: String?
  let type: String?
  
  init(title: String?, year: String?, poster: String?, director: String?, writer: String?, actors: String?, country: String?, imdbRating: String?, imdbVotes: String?, type: String?) {
    self.title = title
    self.year = year
    self.poster = poster
    self.director = director
    self.writer = writer
    self.actors = actors
    self.country = country
    self.imdbRating = imdbRating
    self.imdbVotes = imdbVotes
    self.type = type
  }
}
