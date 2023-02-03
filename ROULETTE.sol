//SPDX-Licenser-Identifier : MIT
pragma solidity ^0.4.18;

contract Roulette {

    enum  BetType {Color, Number}

    //BetType.Color: 0-black, 1-Red
    //BetType.Number: -1 00, 0,.....,36 for numbers
    //choice: based on the BetType


    struct Bet {

        address user;
        uint amount;
        BetType betType;
        uint block;
        int choice;

    }
    
    uint public constant NUM_POCKETS = 38;

    uint8[18] public RED_NUMBERS = [1,3,5,7,9,12,14,16,18,19,21,25,25,27,30,32,34,36];
    uint8[18] public BLACK_NUMBERS = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35];

    //mapping of wheel numbers to colors
    mapping(int=>int) public COLORS;

    address public owner;
    uint public counter = 0;

    mapping(uint=>Bet) public bets;

    event BetPlaced(address user,uint amount,BetType betType,uint block, int choice);
    event Spin(uint id, int landed);


    constructor() public {
        owner = msg.sender;
        for (uint i=0;i<18;i++) {
            COLORS[RED_NUMBERS[i]]=1;
        }
    }

    //FUNCTIONS

    function wager(BetType _betType,int _choice) payable public {
        require(msg.value>0, "must wager a value > 0");
        if (_betType == BetType.Color) {
            require(_choice == 0 || _choice == 1, "Must choose red or black");
        } else  {
            require(_choice >= -1 && _choice <= 36, "Must choose 00,0,1....36");
        }

        counter++;
        bets[counter] = Bet(msg.sender, msg.value, _betType, block.number + 3, _choice);
        emit BetPlaced(msg.sender, msg.value, _betType, block.number + 3, _choice);
    }

    function spin(uint _id) public {
        Bet storage bet = bets[_id];
        require(msg.sender==bet.user);
        require(block.number >= bet.block);
        require(block.number <= bet.block + 255);

        bytes32 random = keccak256(block.blockhash(bet.block), _id);
        int landed = int(uint(random) % NUM_POCKETS) -1 ;

        if(bet.betType == BetType.Color) {
            if (landed > 0 && COLORS[landed] == bet.choice) {
                //correct bet on color pays out x 2
                msg.sender.transfer(bet.amount * 2);

            }else if (bet.betType == BetType.Number) {
                if (landed  == bet.choice) {
                //correct bet on a number pays out x 35
                msg.sender.transfer(bet.amount * 35);


                }

            }

            }

            delete bets[_id];
            emit Spin(_id, landed);
        }


        function fund() public payable {}

        function kill() public {
            require(msg.sender==owner, "you are not the contract owner.");
            selfdestruct(owner);

        }


    }





  

