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
    function add(uint x, uint y) constant returns (uint z) {
        assert( (z = x + y) >= x);
    }
 
    // ensure that the result of subtracting x and y is valid 
    function subtract(uint x, uint y) constant returns (uint z) {
        assert( (z = x - y) <= x);
    }

    // ensure that the result of multiplying x and y is valid 
    function multiply(uint x, uint y) constant returns (uint z) {
        uint z = x * y;
        assert(x == 0 || z / x == y);
        return z;
    }

    // ensure that the result of dividing x and y is valid
    // note: Solidity now throws on division by zero, so a check is not needed
    function divide(uint x, uint y) constant returns (uint z) {
        
        uint z = x / y;
        assert(x == ( (y * z) + (x % y) ));
        return z;
    }
    // return the lowest of two 64 bit ints
    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
      return a < b ? a : b;
    }
    // return the largest of two 64 bit ints
    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
      return a >= b ? a : b;
    }

    // return the minimum of two values
    function min(uint x, uint y) internal constant returns (uint) {
        return (x <= y) ? x : y;
    }

    // return the maximum of two values
    function max(uint x, uint y) internal constant returns (uint) {
        return (x >= y) ? x : y;
    }

}
