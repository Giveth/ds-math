/// math.sol -- mixin for inline numerical wizardry

// Copyright (C) 2015, 2016, 2017 Dapphub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
// 
// Thank you to @zandy and the Dappsys team for writing this beautiful library
// This library was modified to reorder and rename the functions and many
// comments were added for clarification.
// See their original library here: https://github.com/dapphub/ds-math
//
// Also the OpenZepplin team deserves gratitude and recognition for making
// their own beautiful library which has been very well utilized in solidity
// contracts across the Ethereum ecosystem and inspired the multiply() and
// divide() functions. See their library here:
// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/SafeMath.sol

pragma solidity ^0.4.10;

contract SafeMath {

//////////////////////////////////////////////////////////////
//// Ensuring overflow and underflow errors are not included
//////////////////////////////////////////////////////////////

    // ensure that the result of adding x and y is valid 
    function add(uint128 x, uint128 y) constant returns (uint128 z) {
        assert( (z = x + y) >= x);
    }
 
    // ensure that the result of subtracting x and y is valid 
    function subtract(uint128 x, uint128 y) constant returns (uint128 z) {
        assert( (z = x - y) <= x);
    }

    // ensure that the result of multiplying x and y is valid 
    function multiply(uint x, uint y) internal returns (uint) {
        uint z = x * y;
        assert(x == 0 || z / x == y);
        return z;
    }

    // ensure that the result of dividing x and y is valid 
    function divide(uint x, uint y) internal returns (uint) {
        assert(y > 0);
        uint z = x / y;
        assert(x == y * z + x % y);
        return z;
    }

    // return the minimum of two values
    function min(uint128 x, uint128 y) constant internal returns (uint128 z) {
        return (x <= y) ? x : y;
    }

    // return the maximum of two values
    function max(uint128 x, uint128 y) constant internal returns (uint128 z) {
        return (x >= y) ? x : y;
    }

    // helper function
    function assert(bool assertion) internal {
        if (!assertion) {
          throw;
        }
    }

////////////////////////////////////////////////
//// Ensuring rounding errors are not included
////////////////////////////////////////////////

    // ensure that the resulting integer is 128 bits
    function ensure128Bit(uint256 x) constant returns (uint128 z) {
        assert( (z = uint128(x)) == x);
    }

    uint128 constant BP18 = 10 ** 18;  // scales token balance to precision of 18 digits
    uint128 constant BP36 = 10 ** 36;  // scales token balance to precision of 36 digits

    // ensures that `x` multiplied by `y` is returned and is precise to 18
    //  digits, the actual math looks like:
    //  x*y + 500000000000000000
    //  -------------------------
    //     1000000000000000000
    //  with the resulting integer ensured to be 128 bits
    function safeBP18Mult(uint128 x, uint128 y) constant returns (uint128 z) {
        z = ensure128Bit(( (uint256(x) * y) + (BP18 / 2) ) / BP18);
    }

    // ensures that `x` divided by `y` is returned and is precise to 18 digits,
    //   the actual math looks like:
    //  x * 1000000000000000000 + y/2
    //  -----------------------------
    //               y
    //  with the resulting integer ensured to be 128 bits
    function safeBP18Div(uint128 x, uint128 y) constant returns (uint128 z) {
        z = ensure128Bit(( (uint256(x) * BP18) + (y / 2) ) / y);
    }
    
    // ensures that `x` multiplied by `y` is returned and is precise to 36
    //  digits, the actual math looks like:
    //  x*y + 500000000000000000000000000000000000
    //  ------------------------------------------
    //    1000000000000000000000000000000000000
    //  with the resulting integer ensured to be 128bit
    function safeBP36Mult(uint128 x, uint128 y) constant returns (uint128 z) {
        z = ensure128Bit(( (uint256(x) * y) + (BP36 / 2) ) / BP36);
    }
    // ensures that `x` divided by `y` is returned and is precise to 36 digits,
    //  the actual math looks like:
    //  x*1000000000000000000000000000000000000 + y/2
    //  ---------------------------------------------
    //                        y
    //  with the resulting integer ensured to be 128bit
    function safeBP36Div(uint128 x, uint128 y) constant returns (uint128 z) {
        z = ensure128Bit(( (uint256(x) * BP36) + (y / 2) ) / y);
    }

    // ensures that `x` to the `n` power is returned and is precise to 36 digits
    // using a for loop which multiplies `x` by itself `n` times 
    function safeBP36Power(uint128 x, uint64 n) constant returns (uint128 z) {
        // if n is an odd number, 
        // z = x, 
        // else, 
        // z = 10**36
        z = n % 2 != 0 ? x : BP36;
        // n = n / 2; while n isn't 0, n = n / 2
        for (n /= 2; n != 0; n /= 2) {
            x = safeBP36Mult(x, x);
            // if n / 2 doesn't yield a remainder of 0, 
            if (n % 2 != 0) {
                z = safeBP36Mult(z, x);
            }
        }
    }
}
