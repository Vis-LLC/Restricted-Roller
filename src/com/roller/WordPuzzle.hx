/*
    Copyright (C) 2020 Vis LLC - All Rights Reserved

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/*
    Restricted Roller
*/

package com.roller;

import haxe.display.Display.Package;

@:expose
@:nativeGen
class WordPuzzle {
    private var _words : Map<String, WordPuzzleRecord>;
    private static var _validDirectionsDiagonal : Array<Int> = [1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1, 0, -1, 1, -1];
    private static var _validDirectionsNonDiagonal : Array<Int> = [1, 0, 0, 1, -1, 0, 0, -1];

    public static function validDirectionsDiagonal() : Array<Int> {
        return _validDirectionsDiagonal;
    }

    public static function validDirectionsNonDiagonal() : Array<Int> {
        return _validDirectionsNonDiagonal;
    }    

    private function new(collection : Null<Array<String>>) {
        _words = new Map<String, WordPuzzleRecord>();
        for (word in collection) {
            var record : WordPuzzleRecord  = new WordPuzzleRecord();
            record._word = word;
            var validOverlap : Array<WordPuzzleOverlap> = checkOverlaps(word);
            record._validOverlap = validOverlap;
            if (validOverlap != null) {
                for (overlap in validOverlap) {
                    var oldOverlap : Array<WordPuzzleOverlap> = _words[overlap._wordB]._validOverlap;
                    if (oldOverlap == null) {
                        oldOverlap = new Array<WordPuzzleOverlap>();
                        _words[overlap._wordB]._validOverlap = oldOverlap;
                    }
                    oldOverlap.push(overlap);
                }
            }
            _words.set(word, record);
        }
    }

    private function checkOverlaps(word : String) : Array<WordPuzzleOverlap> {
        var overlaps : Array<WordPuzzleOverlap> = null;
        for (wordB in _words.keys()) {
            var overlap : Array<WordPuzzleOverlap> = checkOverlap(word, wordB);
            if (overlap != null) {
                if (overlaps == null) {
                    overlaps = new Array<WordPuzzleOverlap>();
                }
                overlaps = overlaps.concat(overlap);
                var overlapsB : Array<WordPuzzleOverlap> = _words.get(wordB)._validOverlap;
                if (overlapsB == null) {
                    overlapsB = new Array<WordPuzzleOverlap>();
                    _words.get(wordB)._validOverlap = overlapsB;
                }
                overlaps = overlaps.concat(overlap);
            }
        }
        return overlaps;
    }

    private function checkOverlap(wordA : String, wordB : String) : Array<WordPuzzleOverlap> {
        var overlaps : Array<WordPuzzleOverlap> = null;
        var a : Int = 0;
        while (a < wordA.length) {
            var c : String = wordA.substr(a, 1);
            var b : Int = wordB.indexOf(c);
            while (b >= 0) {
                var overlap = new WordPuzzleOverlap();
                overlap._wordA = wordA;
                overlap._wordB = wordB;
                overlap._positionA = a;
                overlap._positionB = b;
                if (overlaps == null) {
                    overlaps = new Array<WordPuzzleOverlap>();
                }
                overlaps.push(overlap);
                b = wordB.indexOf(c, b + 1);
            }
            a++;
        }
        return overlaps;
    }

    private function validDirections(validDirectionsTemplate : Array<Int>, result : WordPuzzleResult, map : Array<Array<String>>, spots : Array<Int>, word : String, x : Int, y : Int, startI : Int, maxX : Int, maxY : Int) : Array<Int> {
        var validDirections : Array<Int> = validDirectionsTemplate.copy();
        var i : Int = 0;
        while (i < word.length) {
            var direction : Int = 0;
            while (direction < validDirections.length) {
                var cx : Int = x + validDirections[direction + 0] * (i - startI);
                var cy : Int = y + validDirections[direction + 1] * (i - startI);
                var spot = cx + cy * maxX;
                if (cx < 0 || cx >= maxX || cy < 0 || cy >= maxY || spots.indexOf(spot) <= 0 && map[cy][cx] != null && map[cy][cx] != word.substr(i, 1)) {
                    validDirections.splice(direction, 2);
                } else {
                    direction += 2;
                }
            }
      
            i++;
        }
        
        if (validDirections.length <= 0) {
            validDirections = null;
        }
        return validDirections;
    }
}

@:expose
@:nativeGen
class WordPuzzleRecord {
    public var _word : String;
    public var _validOverlap : Array<WordPuzzleOverlap>;
    public var _position : Array<Int>;

    public function new() { }
}

@:expose
@:nativeGen
class WordPuzzleOverlap {
    public var _wordA : String;
    public var _wordB : String;
    public var _positionA : Int;
    public var _positionB : Int;

    public function new() { }
}

@:expose
@:nativeGen
class WordPuzzleResult {
    public var _map : Array<Array<String>>;
    public var _words : Map<String, WordPuzzlePosition>;
    
    public function new() { }
}

@:expose
@:native
class WordPuzzlePosition {
    public var _word : String;
    public var _x : Int;
    public var _y : Int;
    public var _directionX : Int;
    public var _directionY : Int;

    public function new() { }
}