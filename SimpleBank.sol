// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error SimpleBank__FundKurang();
error SimpleBank__GagalWithdraw();
error SimpleBank__NotOwner();

contract SimpleBank {
    mapping(address => uint256) public balances;
    bool public paused;

    address immutable owner;

    constructor() {
        owner = msg.sender;
    }


    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert SimpleBank__NotOwner();
        }
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external payable {
        if (balances[msg.sender] < amount) {
            revert SimpleBank__FundKurang();
        }

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert SimpleBank__GagalWithdraw();
        }

        balances[msg.sender] -= amount;
    }

    function setPaused(bool _p) external onlyOwner {
        paused = _p;
    }
}
