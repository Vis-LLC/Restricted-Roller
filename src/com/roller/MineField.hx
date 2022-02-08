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
class MineField<T> implements Collection<T> implements Rule<T> {
  private var _defined : Array<T> = new Array<T>();
  private var _collection : Array<T> = new Array<T>();
  private var _undefined : Array<T>;
  private var _obstacles : Map<T, Int>;
  private var _width : Int;
  private var _height : Int;

  public function new(obstacles : Map<T, Int>, width : Int, height : Int) {
    _width = width;
    _height = height;
    _obstacles = obstacles;
    #if js
      var cnt : Int = 0;
      var o : T = null;
      js.Syntax.code("for (var o in obstacles) { var cnt = obstacles[o]; ");
    #elseif (hax_ver >= 4)
    for (o => cnt in obstacles) {
    #else
    for (o in obstacles.keys()) {
      var cnt : Int = obstacles.get(o);
    #end
      while (cnt > 0) {
        _collection.push(o);
        cnt--;
      }
    #if js
      js.Syntax.code("}");
    #else
    }
    #end

    _undefined = _collection.copy();
  }

  public static function create<T>(options : MineFieldOptions<T>) : MineField<T> {
    options.verify();
    return new MineField(options.getObstacles(), options.getWidth(), options.getHeight());
  }

  public function roll(roll : Float) : Null<T> {
    var index : Int = Math.floor(_undefined.length * roll);
    var value : T = _undefined[index];
    return value;
  }

  public function add(roll : T) : Void {
    if (roll != null) {
      _undefined.remove(roll);
      _defined.push(roll);
    }
  }

  public function getAvailable() : Array<T> {
    return _undefined;
  }

  public function compile(decorator : Null<Null<T> -> Null<T> -> Null<T> -> Null<T> -> Null<T> -> Null<T> -> Null<T> -> Null<T> -> Null<T> -> T>) : Array<Array<T>> {
    var map : Array<Array<T>> = new Array<Array<T>>();
    {
      var row : Array<T> = new Array<T>();
      for (o in _defined) {
        row.push(o);
        if (row.length >= _width) {
          map.push(row);
          if (map.length <= _height) {
            row = new Array<T>();
          }
        }
      }
    }

    if (decorator != null) {
      var index : Int = 0;
      while (index < _defined.length) {
        var column : Int = index % _width;
        var row : Int = Math.floor(index / _width);

        var nw : Null<T> = null;
        var n : Null<T> = null;
        var ne : Null<T> = null;
        var w : Null<T> = null;
        var o : Null<T> = null;
        var e : Null<T> = null;
        var sw : Null<T> = null;
        var s : Null<T> = null;
        var se : Null<T> = null;

        if (row > 0 && column > 0) {
          nw = map[row - 1][column - 1];
        }

        if (row > 0) {
          nw = map[row - 1][column];
        }

        if (row > 0 && column < _width) {
          ne = map[row - 1][column + 1];
        }

        if (column > 0) {
          w = map[row][column - 1];
        }
  
        o = map[row][column];
  
        if (column < _width) {
          e = map[row][column + 1];
        }        

        if (row < _height && column > 0) {
          sw = map[row + 1][column - 1];
        }
  
        if (row < _height) {
         nw = map[row + 1][column];
        }
  
        if (row < _height && column < _width) {
          ne = map[row + 1][column + 1];
        }

        map[row][column] = decorator(nw, n, ne, w, o, e, sw, s, se);
        index++;
      }
    }

    return map;
  }

  public function generate() : MineField<T> {
    (new Roller(this, this)).rollUntilDone();
    return this;
  }

  @:generic
  public static function generateBoardFor<T>(obstacles : Map<T, Int>, width : Int, height: Int) : MineField<T> {
    var board : MineField<T> = new MineField<T>(obstacles, width, height);
    board.generate();
    return board;
  }

  public static function generateBoardForAsString(obstacles : Map<String, Int>, width : Int, height: Int) : String {
    var rows : Array<Array<String>> = generateBoardForAsArray(obstacles, width, height);
    var s : StringBuf = new StringBuf();
    for (row in rows) {
      for (e in row) {
        s.add(e);
      }
      s.add("\n");
    }
    return s.toString();
  }

  public static function generateBoardForAsArray(obstacles : Map<String, Int>, width : Int, height: Int) : Array<Array<String>> {
    var mf : MineField<String> = generateBoardFor(obstacles, width, height);
    return mf.compile(null);
  }
}