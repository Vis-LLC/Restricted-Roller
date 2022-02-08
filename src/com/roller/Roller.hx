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
class Roller<T> {
  private var _rule : Rule<T>;
  private var _collection : Null<Collection<T>>;

  public function new(rule : Rule<T>, collection : Null<Collection<T>>) {
    _rule = rule;
    _collection = collection;
  }

  public function roll() : Bool {
    var result : Null<T> = rollAndReturn();
    _collection.add(result);
    return result != null;
  }

  public function rollAndReturn() : Null<T> {
    return _rule.roll(Math.random());
  }

  public function rollUntilDone() : Bool {
    var ran : Bool = false;
    while (roll()) {
      ran = true;
    }
    return ran;
  }
}