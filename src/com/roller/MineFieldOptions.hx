/*
    Copyright (C) 2020-2021 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    Restricted Roller
    Restricted Roller - MineFieldOptions.hx
*/

package com.roller;

@:expose
@:nativeGen
class MineFieldOptions<T> {
    private var _obstacles : Map<T, Int> = cast new Map<Any, Int>();
    private var _width : Null<Int> = null;
    private var _height : Null<Int> = null;
    private var _remaining : Null<Int> = null;

    public function width(w : Int) : MineFieldOptions<T> {
        _width = w;
        calcRemaining();
        return this;
    }

    public function height(h : Int) : MineFieldOptions<T> {
        _height = h;
        calcRemaining();
        return this;
    }

    private function calcRemaining() : Void {
        if (_remaining == null && _width != null && _height != null) {
            _remaining = _width * _height;
        }
    }

    public function addObstacle(v : T, ?cnt : Int = 1) : MineFieldOptions<T> {
        var current : Null<Int> = _obstacles.get(v);
        if (current == null) {
            current = 0;
        }
        _obstacles.set(v, current + cnt);
        _remaining -= cnt;
        return this;
    }

    public function addObstacleWithOdds(v : T, ?odds : Float = -1) : MineFieldOptions<T> {
        if (odds == -1) {
            return addObstacle(v, _remaining);
        } else {
            return addObstacle(v, Math.round(odds / 100 * _width * _height));
        }
    }

    public function isReady() : Bool {
        return _remaining == 0 && _width > 0 && _height > 0;
    }

    public function verify() : Void {
        if (!isReady()) {
            throw "Invalid Minefield configuration";
        }
    }

    public function getObstacles() : Map<T, Int> {
        return _obstacles;
    }

    public function getWidth() : Int {
        return _width;
    }

    public function getHeight() : Int {
        return _height;
    }    
}