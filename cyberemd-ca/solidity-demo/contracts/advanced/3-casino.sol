// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title casino_demo
/// @author Mulander
/// @notice guess big or small
/// @dev features(guess, open, fee)
contract casino_demo {
    struct Player {
        address payable addr;
        uint256 amount;
    }

    uint8 constant feePercent = 90;

    bool public isFinished;
    uint256 public endTime;
    uint256 public lgTol;
    uint256 public ltTol;
    address public owner;

    Player[] lgList;
    Player[] ltList;

    event Bet(address from, uint256 amout, bool choice);
    event Open(uint256 tol, bool choice);

    constructor(uint256 _endTime) {
        owner = msg.sender;
        isFinished = false;
        endTime = _endTime;
    }

    function bet(bool _choice) public payable {
        require(!isFinished, "bet is finished");
        require(block.timestamp <= endTime, "time is end");
        require(msg.value > 0, "val should be positive");

        Player memory player = Player(payable(msg.sender), msg.value);

        if (_choice) {
            lgList.push(player);
            lgTol += msg.value;
        } else {
            ltList.push(player);
            ltTol += msg.value;
        }

        require(
            address(this).balance == (lgTol + ltTol),
            "tol balance not match"
        );

        emit Bet(msg.sender, msg.value, _choice);
    }

    function open() public payable {
        require(block.timestamp > endTime, "time is not end");

        isFinished = true;

        bool choice = getChoice();

        Player[] memory lucyList = choice ? lgList : ltList;
        uint256[2] memory tolVec = choice ? [ltTol, lgTol] : [lgTol, ltTol];

        for (uint i = 0; i < lucyList.length; i++) {
            Player memory player = lucyList[i];
            uint256 bouns = (tolVec[0] * player.amount) / tolVec[1];
            player.addr.transfer(player.amount + (bouns * feePercent) / 100);
        }

        emit Open(lgTol + ltTol, choice);
    }

    function getBalance () public view returns(uint256 balance, uint256 tol) {
        return (address(this).balance,  lgTol + ltTol);
    }

    function getChoice() internal view returns (bool) {
        uint256 random = uint(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    lgTol,
                    ltTol,
                    endTime,
                    msg.sender
                )
            )
        ) % 10;

        return random > 5;
    }
}
