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

@:expose
@:nativeGen
class Sudoku implements Collection<String> implements Rule<String> {
  private var _squares : Array<SudokuSection<String>> = new Array<SudokuSection<String>>();
  private var _rows : Array<SudokuSection<String>> = new Array<SudokuSection<String>>();
  private var _columns : Array<SudokuSection<String>> = new Array<SudokuSection<String>>();
  private var _rollNumber : Int = 0;
  private var _squareIndex : Int = 0;
  private var _squareDivider : Int = 0;
  private var _size : Int = 0;
  private var _elementCount : Int = 0;
  private var _rowIndex : Int = 0;
  private var _columnIndex : Int = 0;
  private var _collection : Array<String>;

  private function new(collection : Null<Array<String>>) {
    if (collection == null) {
      collection = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    }
    _collection = collection;
    _squareDivider = Math.floor(Math.sqrt(collection.length));
    _size = _squareDivider * _squareDivider;
    _elementCount = _size * _size;

    while (_squares.length < _size) {
      _squares.push(new SudokuSection(collection));
    }

    while (_rows.length < _size) {
      _rows.push(new SudokuSection(collection));
    }

    while (_columns.length < _size) {
      _columns.push(new SudokuSection(collection));
    }
  }

  public function roll(roll : Float) : Null<String> {
    var collection : Array<String> = getAvailable();
    var index : Int = Math.floor(collection.length * roll);
    var value : String = collection[index];
    return value;
  }

  public function add(roll : String) : Void {
    if (roll != null) {
      _squares[_squareIndex].add(roll);
      _rows[_rowIndex].add(roll);
      _columns[_columnIndex].add(roll);
      _rollNumber++;
      _columnIndex = _rollNumber % _columns.length;
      _rowIndex = Math.floor(_rollNumber / _columns.length);
      _squareIndex = Math.floor(_columnIndex / _squareDivider) + Math.floor(_rowIndex / _squareDivider) * 3;
    }
  }

  public function getAvailable() : Array<String> {
    var available : Map<String, Int> = new Map<String, Int>();
    var finalAvailable : Array<String> = new Array<String>();

    if (_squareIndex >= _squares.length) {
      return finalAvailable;
    }

    for (o in _squares[_squareIndex].getAvailable()) {
      available[o] = 1;
    }

    for (o in _rows[_rowIndex].getAvailable()) {
      available[o]++;
    } 

    for (o in _columns[_columnIndex].getAvailable()) {
      available[o]++;
    } 

    for (o in available.keys()) {
      if (available[o] >= 3) {
        finalAvailable.push(o);
      }
    }

    return finalAvailable;
  }

  private function compile(sections : Array<SudokuSection<String>>) : Array<Array<String>> {
    var collection : Array<Array<String>> = new Array<Array<String>>();

    for (section in sections) {
      collection.push(section.getDefined());
    }

    return collection;
  }

  public function compileByColumn() : Array<Array<String>> {
    return compile(_columns);
  }

  public function compileBySquare() : Array<Array<String>> {
    return compile(_squares);
  }
  
  public function compileByRow() : Array<Array<String>> {
    return compile(_rows);
  }
 
  public function generate() : Sudoku {
    (new Roller(this, this)).rollUntilDone();
    return this;
  }

  public static function generateBoardFor(collection : Null<Array<String>>) : Sudoku {
    var board : Sudoku;
    while (true) {
      board = new Sudoku(collection);
      board.generate();
      if (board._rollNumber >= board._elementCount) {
        return board;
      }
    }
  }

  public static function generateBoardForAsString(collection : Null<Array<String>>) : String {
    return generateBoardFor(collection).toString();
  }

  public static function generateBoardForAsArray(collection : Null<Array<String>>) : Array<Array<String>> {
    return generateBoardFor(collection).toArray();
  }

  public function toString() : String {
    var s : StringBuf = new StringBuf();
    for (row in _rows) {
      for (e in row) {
        s.add(e);
      }
      s.add("\n");
    }
    return s.toString();
  }

  public function toArray() : Array<Array<String>> {
    var rows = new Array<Array<String>>();

    for (row in _rows) {
      var newRow = new Array<String>();
      for (e in row) {
        newRow.push(e);
      }
      rows.push(newRow);
    }

    return rows;
  }
}