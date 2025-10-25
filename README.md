📘 BhaariScam Token Documentation
A gas-optimized ERC-20 token for educational purposes

1. Overview
BhaariScam is a highly gas-optimized ERC-20 token contract designed to demonstrate advanced Solidity techniques. It avoids expensive operations (e.g., string storage, redundant SSTOREs) while maintaining core ERC-20 functionality.

✅ Key Features
Gas Optimizations

Uses bytes32 for name/symbol (cheaper than string)

Avoids 22,100-gas penalty for zero-to-non-zero storage writes

Minimizes storage reads/writes via cached references and conditional updates

Standard ERC-20 Compliance

Implements: transfer, transferFrom, approve, balanceOf, totalSupply

Emits: Transfer, Approval events

Security

No reentrancy risks (no external calls in state-changing functions)

Input validation (e.g., zero-address checks)

⚠️ Educational Focus

Not audited for production use

Lacks SafeERC20 checks

Intentionally named “Scam” to emphasize educational (not malicious) intent

2. Contract Details
🔐 Storage Layout (Optimized)
Variable	Type	Description
_name	bytes32 private constant	Token name in hex ("Bhaari Scam")
_symbol	bytes32 private constant	Token symbol in hex ("SCAM")
_decimals	uint256 private constant	Fixed to 18 (standard ERC-20 decimals)
totalSupply	uint256 public	Total token supply
_accounts	mapping(address => Account)	Tracks balances and allowances per address
🧱 Account Struct
solidity
struct Account {
    uint256 balance;
    mapping(address => uint256) allowances;
}
3. Functions
🔧 Core Functions
constructor(uint256 initialSupply)

Mints initialSupply * 10^18 to deployer

Gas tricks: avoids zero-to-non-zero penalty, uses storage pointer

Emits Transfer(address(0), msg.sender, initialAmount)

transfer(address to, uint256 value)

Splits require statements for cheaper checks

Caches sender/recipient references

Deletes balance if fully transferred

transferFrom(address from, address to, uint256 value)

Caches only necessary storage

Direct allowance access

Deletes zeroed allowances

approve(address spender, uint256 value)

Not protected against front-running

Avoids unnecessary storage reads

👁 View Functions
Function	Returns	Optimization Details
name()	string	Converts bytes32 to string on-the-fly
symbol()	string	Same as name()
decimals()	uint256	Returns constant 18
balanceOf()	uint256	Direct mapping read
🧰 Internal Helper
_bytes32ToString(bytes32 data)

Converts bytes32 to string

Dynamically calculates string length

Copies only non-zero bytes

4. Gas Optimizations Breakdown
Technique	Example	Gas Saved
bytes32 for strings	_name = "0x426861617269205363616d"	~20k
Avoid zero-to-non-zero write	account.balance = 1; account.balance = amount;	~17,100
Cached storage references	Account storage sender = _accounts[msg.sender];	~100 per access
Split require statements	require(to != 0); require(value != 0);	~3 per condition
Conditional delete	if (balance == value) delete sender.balance;	~5k
Minimal storage updates	Update only if value != allowanceValue	~5k
5. Security Analysis
✅ Mitigated Risks
Reentrancy: No external calls in state-changing functions

Overflow/Underflow: Handled by Solidity ^0.8.20

Front-Running: Not applicable (no time-sensitive logic)

⚠ Potential Risks (Educational Only)
Risk	Issue	Suggested Fix
No SafeERC20	No check if recipient can handle tokens	Use OpenZeppelin’s SafeERC20 or transfer hook
Approval Front-Running	Vulnerable approve logic	Use increaseAllowance/decreaseAllowance
No Access Control	Anyone can call transfer/approve	Add Ownable for mint/burn
No Paused/Blacklist	Tokens can't be frozen/recovered if stolen	Add Pausable or Blacklist (centralization trade-off)
6. Deployment & Interaction
🛠 Remix Deployment
Compile: Solidity ^0.8.20 with optimization (200 runs)

Deploy: Input initialSupply (e.g., 1000 → mints 1000 * 10^18)

Interact: Use transfer(to, amount) or approve(spender, amount)

💻 Example (ethers.js)
javascript
const token = await ethers.getContractAt("BhaariScam", "0xContractAddress");
await token.transfer("0xRecipient", ethers.utils.parseEther("100"));
7. Comparison with OpenZeppelin ERC-20
Feature	BhaariScam	OpenZeppelin ERC-20
Gas Efficiency	✅ Highly optimized	Standard
String Storage	❌ bytes32 (cheaper)	✅ string (more readable)
Safe Transfers	❌ No SafeERC20	✅ Built-in
Approval Security	❌ Original ERC-20	✅ increaseAllowance pattern
Extensibility	❌ Minimal	✅ Modular (Ownable, Pausable)
8. Recommendations for Production
Use OpenZeppelin’s ERC20 as a base (audited, secure)

Add SafeERC20 for contract-to-contract transfers

Implement increaseAllowance/decreaseAllowance

Add Ownable if minting/burning is needed

Emit events for critical actions (e.g., Mint, Burn)

🧠 Final Notes
Educational Value: Great for learning gas optimizations and storage patterns

Production Readiness: Not recommended without addressing security gaps

Alternative: Extend OpenZeppelin’s ERC20 for production-ready tokens

## 🌐 Deployment

### Sepolia Testnet
| Item               | Details                                                                                     |
|--------------------|---------------------------------------------------------------------------------------------|
| **Contract**       | [`0x959f490eab1fc1c80713c6f7b9f543b72076bed9`](https://sepolia.etherscan.io/address/0x959f490eab1fc1c80713c6f7b9f543b72076bed9) |
| **Token Tracker**   | [Etherscan Token Page](https://sepolia.etherscan.io/token/0x959f490eab1fc1c80713c6f7b9f543b72076bed9) |
| **Verification**   | ✅ [Verified Source](https://sepolia.etherscan.io/address/0x959f490eab1fc1c80713c6f7b9f543b72076bed9#code) |
| **Initial Supply**  | 10,000 `SCAM` (18 decimals)                                                                   |

### How to Interact
1. **Add Token to Wallet**:
   - **Token Contract Address**: `0x959f490eab1fc1c80713c6f7b9f543b72076bed9`
   - **Symbol**: `SCAM`
   - **Decimals**: `18`

2. **Test Transactions**:
   ```javascript
   // Using ethers.js
   const token = await ethers.getContractAt(
     "BhaariScam",
     "0x959f490eab1fc1c80713c6f7b9f543b72076bed9"
   );
   await token.transfer("0xRecipientAddress", ethers.utils.parseEther("100"));
