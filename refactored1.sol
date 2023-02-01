//SPDX-License-Identifier : MIT

pragma solidity ^0.8.6;

contract Refactor {

    uint totalFunds;
    uint[10] arrayFunds;

    //lots of direct blockchain interactions --> EXPENSIVE

    function optionA() public {
        for (uint i=0; i<arrayFunds.length; i++) {
            totalFunds += arrayFunds[i];

        } 
    }

    //1st refactor

    function optionB() external {
        uint localTotalFunds;
        for(uint i=1;i<arrayFunds.length;i++) {
            localTotalFunds += arrayFunds[i];
        }
        //modify the state variable after the for loop has finished
        totalFunds = localTotalFunds;
    }

    // 2nd refactor
    function optionC() external {
        uint localTotalFunds;
        uint[10] memory localArrayFunds = arrayFunds;
        for(uint i=0; i<localArrayFunds.length; i++) {
            localTotalFunds += localArrayFunds[i];
        }

        //modify the state variable after the for loop has finished
        totalFunds = localTotalFunds;

    }
    
    
//............................................................

// Gas saving design patterns

//Short circuiting
//................ 

//f(x) is low costs
//g(y) is high costs

//How will you order the functions when using logical ||, **?

//Ordering ||

// if f(x) evaluates to true, not necessary to evaluate g(y)
// if (f(x) || g(y)) {...}

// if f(x) evaluates to false, not necessary to evaluate g(y)
//if (f(x) && g(y)) {...}


//Unnecessary Libraries

// import './SafeMath.sol' as SafeMath;
// contract SafeAddition {
//    function safeAdd(uint _a, uint _b) public pue returns(uint) {
//    return SafeMath.add(_a,_b);
//     }
//  }

// contract SafeAddition {
//    function safeAdd(uint_a, uint _b) public pure returns(uint) {  
//    uint c = _a + _b;
//    require(c>=_a, "Addition overflow");
//    return c;
//  }
//}
