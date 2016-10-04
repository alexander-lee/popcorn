# Tipster

Popcorn is an iOS app that checks the [Movies Database API](https://developers.themoviedb.org/3) to shows the currently playing movies

Submitted by: Alexander Lee

Time spent: 6 hours spent in total

## Features

* User can view a list of movies currently playing in theaters from The Movie Database.
* Poster images are loaded using the UIImageView category in the AFNetworking library.
* User sees a loading state while waiting for the movies API.
* User can pull to refresh the movie list (Pull Horizontally).
* User sees an error message when there's a networking error.
* User can search for a movie.
* All images fade in as they are loading.
* User can view the large movie poster by tapping on a cell.
* For the large poster, load the low resolution image first and then switch to the high resolution image when complete.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/alexander-lee/popcorn/blob/master/demo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).


## License

    Copyright 2016 Alexander Lee

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
