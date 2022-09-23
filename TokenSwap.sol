//SPDX-License-Identifier

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC20/IERC20.sol";

/*
interface IERC20 (
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
)
*/

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    IERC20 public token2;
    address public owner2;

    constructor (
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
    ) public {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }

    function swap(uint _amount1, uint _amount2) public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        //This confirms the token allowed by this address to spend is greater or equal to that of the amount inputted
        require(token1.allowance(owner1, address(this)) >= _amount1, "Token1 allowance to low");

        require(token2.allowance(owner2, address(this)) >= _amount2, "Token1 allowance to low");

        //transfer tokens
        //Transfer token1 from owner1 to owner2
        _safeTransferFrom(token1, owner1, owner2, _amount1);
        //Transfer token2 from owner2 to owner1
        _safeTransferFrom(token2, owner2, owner1, _amount2);

    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint _amount
    ) private{
        bool sent = token.transferFrom(sender, recipient, _amount);
        require(sent, "Token transfer failed");
    }
}

/*
Nirvscoin
Address token1: 0xd9145CCE52D386f254917e481eB44e9943F39138
owner token1: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
20000000000000000000

Davecoin
Address token2: 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95
owner token2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
30000000000000000000

TokenSwap
Address: 0x652c9ACcC53e765e1d96e2455E618dAaB79bA595
20000000000000000000 nirvscoin
30000000000000000000 davecoin
*/