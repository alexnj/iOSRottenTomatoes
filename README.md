iOSRottenTomatoes
=================

Time spent on this exercise is about 10 hours.

## User stories
* [x] User can view a list of movies from Rotten Tomatoes.  Poster images must be loading asynchronously.
* [x] User can view movie details by tapping on a cell
* [x] User sees loading state while waiting for movies API.  You can use one of the 3rd party libraries here.
* [x] User sees error message when there's a networking error.  You may not use UIAlertView to display the error.  See this screenshot for what the error message should look like: network error screenshot.
* [x] User can pull to refresh the movie list.

### Optional user stories
* [x] All images fade in (optional)
* [x] For the large poster, load the low-res image first, switch to high-res when complete (optional)
* [x] All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional).
* [x] Customize the highlight and selection effect of the cell. (optional)
* [x] Customize the navigation bar. (optional)
* [x] Add a tab bar for Box Office and DVD. (optional)
* [x] Add a search bar. (optional)

### Additional requirements
* [x] Must use Cocoapods.
* [x] Asynchronous image downloading must be implemented using the UIImageView category in the AFNetworking library.

## Demo

![demo](screencast.gif)

## Pods imported
* AFNetworking
* NoticeView
* TMCache
