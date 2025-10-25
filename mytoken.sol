// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BhaariScam {
    bytes32 private constant _name = "Bhaari Scam";
    bytes32 private constant _symbol = "SCAM";
    uint256 private constant _decimals = 18;
    uint256 public totalSupply;

    struct Account {
        uint256 balance;
        mapping(address spender => uint256 amount) allowances;
    }
    mapping(address owner => Account) private _accounts;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) payable {
        uint256 initialAmount = initialSupply * 10 ** _decimals;
        totalSupply = initialAmount;
        Account storage account = _accounts[msg.sender];
        account.balance = 1;
        account.balance = initialAmount;
        emit Transfer(address(0), msg.sender, initialAmount);
    }

    function name() public pure returns (string memory) {
        return _bytes32ToString(_name);
    }

    function symbol() public pure returns (string memory) {
        return _bytes32ToString(_symbol);
    }

    function decimals() public pure returns (uint256) {
        return _decimals;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _accounts[owner].balance;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid to");
        require(value != 0, "Zero value");

        Account storage sender = _accounts[msg.sender];
        Account storage recipient = _accounts[to];

        uint256 senderBalance = sender.balance;
        require(senderBalance != 0, "No balance");
        require(senderBalance >= value, "Low balance");

        if (senderBalance == value) {
            delete sender.balance;
            recipient.balance += value;
        } else {
            sender.balance = senderBalance - value;
            recipient.balance += value;
        }

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid spender");
        _accounts[msg.sender].allowances[spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid to");
        require(value != 0, "Zero value");

        Account storage fromAccount = _accounts[from];
        Account storage toAccount = _accounts[to];

        uint256 fromBalance = fromAccount.balance;
        require(fromBalance != 0, "No from balance");
        require(fromBalance >= value, "Low from balance");

        uint256 allowanceValue = fromAccount.allowances[msg.sender];
        require(allowanceValue != 0, "No allowance");
        require(allowanceValue >= value, "Low allowance");

        if (allowanceValue == value) {
            delete fromAccount.allowances[msg.sender];
        } else {
            fromAccount.allowances[msg.sender] = allowanceValue - value;
        }

        fromAccount.balance = fromBalance - value;
        toAccount.balance += value;

        emit Transfer(from, to, value);
        return true;
    }

    function _bytes32ToString(bytes32 data) private pure returns (string memory) {
        uint256 length = 0;
        for (uint256 i = 0; i < 32; i++) {
            if (data[i] != 0) {
                length++;
            }
        }
        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = data[i];
        }
        return string(result);
    }
}
