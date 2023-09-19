// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract ERC20 {
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    address public owner;
    uint8 public decimals;

    uint256 public totalSupply;

    uint32 public constant MAX_SUPPLY_ALLOWED = 1_000_000;

    // owner -> spender -> allowance
    // this enables an owner to give allowance to multiple addresses
    mapping(address => mapping(address => uint256)) public allowance;


    error ExceedMaxSupply();

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;

        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        
        if((totalSupply + amount) > MAX_SUPPLY_ALLOWED){
            revert ExceedMaxSupply();
        }
        require(msg.sender == owner, "only owner can create tokens");

        totalSupply += amount;
        balanceOf[to] += amount;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        return helperTransfer(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;

        return true;
    }

    // just added
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        if (msg.sender != from) {
            require( allowance[from][msg.sender] >= amount,"not enough allowance"
            );

            allowance[from][msg.sender] -= amount;
        }

        return helperTransfer(from, to, amount);
    }

    // it's very important for this function to be internal!
    function helperTransfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        require(balanceOf[from] >= amount, "not enough money");
        require(to != address(0), "cannot send to address(0)");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        return true;
    }
}
