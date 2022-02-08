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
class SudokuSection<T> implements Collection<T> implements Rule<T> {
  private var _defined : Array<T> = new Array<T>();
  private var _undefined : Array<T>;
  private var _collection : Array<T>;

  public function new(collection : Array<T>) {
    _collection = collection;
    _undefined = _collection.copy();
  }

  public function roll(roll : Float) : Null<T> {
    var index : Int = Math.floor(_collection.length * roll);
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

  public function getDefined() : Array<T> {
    return _defined;
  }

  public function iterator() : Iterator<T> {
    return _defined.iterator();
  }
}