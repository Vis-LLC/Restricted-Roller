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
class Crossword extends WordPuzzle {
    private static var _validDirections : Array<Int> = WordPuzzle.validDirectionsNonDiagonal();
    private static var _oddsOfNoOverlap : Float = 0.25;

    private function new(collection : Null<Array<String>>) {
        super(collection);
    }

    private function createPuzzle(maxX : Int, maxY : Int, ?requiredOverlaps : Int = 0) : WordPuzzle.WordPuzzleResult {
        if (requiredOverlaps == - 1) {
            var result : WordPuzzle.WordPuzzleResult = null;
            var i : Int = 1;
            while (true) {
                try {
                    result = createPuzzle(maxX, maxY, i++);
                } catch (ex : Any) {
                    return result;
                }
            }
        } else {
            while (true) {
                var overlaps : Int = 0;
                var spots : Array<Int> = new Array<Int>();
                {
                    var length : Int = maxX * maxY;
                    while (spots.length < length) {
                        spots.push(spots.length);
                    }
                }                
                var result : WordPuzzle.WordPuzzleResult = new WordPuzzle.WordPuzzleResult();
                var map : Array<Array<String>> = new Array<Array<String>>();
                var words : Map<String, WordPuzzle.WordPuzzlePosition> = new Map<String, WordPuzzle.WordPuzzlePosition>();
                result._map = map;
                result._words = words;
                
                while (map.length < maxY) {
                    var row : Array<String> = new Array<String>();
                    map.push(row);
                    while (row.length < maxX) {
                        row.push(null);
                    }
                }
    
                for (word in _words.iterator()) {
                    var position : WordPuzzle.WordPuzzlePosition = null;
    
                    if (word._validOverlap != null) {
                        var overlap : Int = Math.floor(word._validOverlap.length * Math.random());
                        if (overlap < word._validOverlap.length) {
                            var overlapInfo : WordPuzzle.WordPuzzleOverlap = word._validOverlap[overlap];
                            var otherWord : String;
                            var wordI : Int;
                            var otherWordI : Int;
                            if (overlapInfo._wordA == word._word) {
                                otherWord = overlapInfo._wordB;
                                wordI = overlapInfo._positionA;
                                otherWordI = overlapInfo._positionB;
                            } else {
                                otherWord = overlapInfo._wordA;
                                wordI = overlapInfo._positionB;
                                otherWordI = overlapInfo._positionA;
                            }
                            var otherPosition : WordPuzzle.WordPuzzlePosition = words.get(otherWord);
                            if (otherPosition != null) {
                                var x : Int = otherPosition._x + otherWordI * otherPosition._directionX;
                                var y : Int = otherPosition._y + otherWordI * otherPosition._directionY;
                                var directions : Array<Int> = validDirections(_validDirections, result, map, spots, word._word, x, y, wordI, maxX, maxY);
                                if (directions != null) {
                                    var direction : Int = Math.floor(Math.floor(directions.length * Math.random()) / 2) * 2;
                                    position = new WordPuzzle.WordPuzzlePosition();
                                    position._x = x - directions[direction + 0] * wordI;
                                    position._y = y - directions[direction + 1] * wordI;
                                    position._directionX = directions[direction];
                                    position._directionY = directions[direction + 1];
                                    overlaps++;
                                }
                            }
    
                            if (position == null) {
                                var spot : Int = spots[Math.floor(spots.length * Math.random())];
                                var x : Int = spot % maxX;
                                var y : Int = Math.floor(spot / maxX);
                                var directions : Array<Int> = validDirections(_validDirections, result, map, spots, word._word, x, y, 0, maxX, maxY);
                                if (directions != null) {
                                    spots.remove(spot);
                                    var direction : Int = Math.floor(Math.floor(directions.length * Math.random()) / 2) * 2;
                                    position = new WordPuzzle.WordPuzzlePosition();
                                    position._x = x;
                                    position._y = y;
                                    position._directionX = directions[direction];
                                    position._directionY = directions[direction + 1];
                                }
                            }
    
                            if (position != null) {
                                words[word._word] = position;
                                var i : Int = 0;
                                var cx : Int = position._x;
                                var cy : Int = position._y;
    
                                while (i < word._word.length) {
                                    spots.remove(cx + cy * maxX);
                                    map[cy][cx] = word._word.substr(i, 1);
                                    i++;
                                    cx += position._directionX;
                                    cy += position._directionY;
                                }                            
                            } else {
                                // TODO - Restart
                            }
                        }
                    }
                }
    
                if (overlaps >= requiredOverlaps) {
                    return result;
                }
            }
        }
    }

    public static function generateBoardForAsString(words : Array<String>, maxX : Int, maxY : Int, ?requiredOverlaps : Int = 0) : String {
        var board : StringBuf = new StringBuf();

        for (row in generateBoardForAsArray(words, maxX, maxY, requiredOverlaps)) {
            board.add(row.join(""));
            board.add("\n");
        }

        return board.toString();
    }

    public static function generateBoardForAsArray(words : Array<String>, maxX : Int, maxY : Int, ?requiredOverlaps : Int = 0) : Array<Array<String>> {
        return generateBoardFor(words, maxX, maxY, requiredOverlaps)._map;
    }

    public static function generateBoardFor(words : Array<String>, maxX : Int, maxY : Int, ?requiredOverlaps : Int = 0) : WordPuzzle.WordPuzzleResult {
        var search : Crossword = new Crossword(words);
        return search.createPuzzle(maxX, maxY, requiredOverlaps);
    }
}