//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PakoToken is ERC20 {
    
    constructor(uint _totalSupply) ERC20("PakoToken","PAKO"){
        _mint(msg.sender, _totalSupply * 10**18);
    }
}
