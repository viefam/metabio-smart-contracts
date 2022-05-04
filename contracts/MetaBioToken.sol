// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MetaBioToken is ERC20 {
    constructor() ERC20("MetaBioToken", "MBT") {
        _mint(msg.sender, 100000 * 10 ** 18);
    }
}