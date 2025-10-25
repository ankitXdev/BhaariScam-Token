// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Bhaari Scam Token
 * @author YourName
 * @dev Optimized ERC20 token for learning blockchain fundamentals
 * @notice This is an educational token with complete gas optimizations
 */
contract BhaariScam {
    // Using bytes32 for gas efficiency instead of string
    bytes32 private constant _name = "Bhaari Scam"; // "Bhaari Scam" in hex
    bytes32 private constant _symbol = "SCAM"; // "SCAM" in hex
    
    // Fixed decimal value with proper gas optimization
    uint256 private constant _decimals = 18;
    
    // Track total supply
    uint256 public totalSupply;

    // Optimized storage structure
    struct Account {
        uint256 balance;
        // Named mapping parameter for clarity
        mapping(address spender => uint256 amount) allowances;
    }
    mapping(address owner => Account) private _accounts;

    // Events for transaction logging
    /**
     * @notice Emitted when tokens are transferred
     * @param from Address sending tokens
     * @param to Address receiving tokens
     * @param value Amount transferred
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @notice Emitted when approval is granted
     * @param owner Token owner
     * @param spender Approved spender
     * @param value Amount approved
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @notice Initializes the token with initial supply
     * @dev Mints initial supply to deployer with gas optimizations
     * @param initialSupply Initial supply to mint (without decimals)
     */
    constructor(uint256 initialSupply) payable {
        // Avoid zero-to-one storage write by setting to 1 first
        uint256 initialAmount = initialSupply * 10 ** _decimals;
        totalSupply = initialAmount;
        
        Account storage account = _accounts[msg.sender];
        // Initialize to non-zero value to avoid 22,100 gas penalty
        account.balance = 1;
        // Update to actual value (costs only 5,000 gas)
        account.balance = initialAmount;
        
        emit Transfer(address(0), msg.sender, initialAmount);
    }

    /**
     * @notice Returns token name
     * @dev Converts bytes32 to string for display
     * @return Token name as string
     */
    function name() public pure returns (string memory) {
        return _bytes32ToString(_name);
    }

    /**
     * @notice Returns token symbol
     * @dev Converts bytes32 to string for display
     * @return Token symbol as string
     */
    function symbol() public pure returns (string memory) {
        return _bytes32ToString(_symbol);
    }

    /**
     * @notice Returns token decimals
     * @dev This is 18 for standard ERC20
     * @return Token decimals
     */
    function decimals() public pure returns (uint256) {
        return _decimals;
    }

    /**
     * @notice Returns balance of an address
     * @dev Caches storage reading for gas optimization
     * @param owner Address to query
     * @return Balance of owner
     */
    function balanceOf(address owner) public view returns (uint256) {
        return _accounts[owner].balance;
    }

    /**
     * @notice Transfer tokens to another address
     * @dev Uses gas optimized conditions and checks
     * @param to Recipient address
     * @param value Amount to transfer
     * @return Success status
     */
    function transfer(address to, uint256 value) public returns (bool) {
        // Split require statements for gas efficiency
        require(to != address(0), "Invalid to");
        // Use cheaper != 0 comparison
        require(value != 0, "Zero value");
        
        // Cache storage references
        Account storage sender = _accounts[msg.sender];
        Account storage recipient = _accounts[to];
        
        uint256 senderBalance = sender.balance;
        // Use cheaper != 0 and < instead of >=
        require(senderBalance != 0, "No balance");
        require(senderBalance >= value, "Low balance");
        
        // Avoid re-storing same value
        if (senderBalance == value) {
            // Transfer all
            delete sender.balance;
            recipient.balance += value;
        } else {
            // Transfer partial
            sender.balance = senderBalance - value;
            recipient.balance += value;
        }
        
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @notice Approve spending of tokens
     * @dev Sets allowance with gas optimized checks
     * @param spender Address to approve
     * @param value Amount to approve
     * @return Success status
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid spender");
        
        _accounts[msg.sender].allowances[spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @notice Transfer tokens from approved address
     * @dev Checks allowance before transfer with gas optimizations
     * @param from Owner of tokens
     * @param to Recipient address
     * @param value Amount to transfer
     * @return Success status
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid to");
        require(value != 0, "Zero value");
        
        // Cache only needed storage references
        Account storage fromAccount = _accounts[from];
        Account storage toAccount = _accounts[to];
        
        uint256 fromBalance = fromAccount.balance;
        require(fromBalance != 0, "No from balance");
        require(fromBalance >= value, "Low from balance");
        
        // Access allowance directly without storing msg.sender account
        uint256 allowanceValue = fromAccount.allowances[msg.sender];
        require(allowanceValue != 0, "No allowance");
        require(allowanceValue >= value, "Low allowance");
        
        // Update allowance
        if (allowanceValue == value) {
            delete fromAccount.allowances[msg.sender];
        } else {
            fromAccount.allowances[msg.sender] = allowanceValue - value;
        }
        
        // Transfer tokens
        fromAccount.balance = fromBalance - value;
        toAccount.balance += value;
        
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Internal function to convert bytes32 to string
     * @param data Bytes32 input
     * @return String representation
     */
    function _bytes32ToString(bytes32 data) private pure returns (string memory) {
        // Count actual characters (non-zero bytes)
        uint256 length = 0;
        for (uint256 i = 0; i < 32; i++) {
            if (data[i] != 0) {
                length++;
            }
        }
        
        // Create string with exact length
        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = data[i];
        }
        
        return string(result);
    }
}
