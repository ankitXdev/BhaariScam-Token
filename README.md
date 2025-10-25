## Key Functionalities

Function	Purpose
transfer(to, amount)	Sends tokens from caller to another address.
approve(spender, amount)	Allows another address to spend tokens on your behalf.
transferFrom(from, to, amount)	Enables a spender to move tokens from one address to another using an allowance.
balanceOf(account)	Returns balance of any address.
allowance(owner, spender)	Shows remaining tokens a spender can use.
## Security and Optimization Analysis
| Area | Status | Notes |
| --- | --- | --- |
| Overflow/Underflow | ✅ Safe (Solidity 0.8+ auto-checks) |
| Unchecked arithmetic | ✅ Used intentionally for gas efficiency |
| Events | ✅ Transfer and Approval correctly emitted |
| Zero-address protection | ✅ Implemented |
| Front-running risk | ⚠ Exists (standard **ERC**-20 approval flaw) |
| Reentrancy | ✅ Not applicable |
| Gas optimization | ✅ Manual unchecked block and direct mapping access |
## Comparison with OpenZeppelin ERC-20
| Feature | BhaariScam | OpenZeppelin **ERC**-20 |
| --- | --- | --- |
| Gas Efficiency | ✅ Highly optimized | Standard |
| String Storage | ❌ bytes32 (cheaper) | ✅ string (more readable) |
| Safe Transfers | ❌ No SafeERC20 | ✅ Built-in |
| Approval Security | ❌ Original **ERC**-20 | ✅ increaseAllowance pattern |
| Extensibility | ❌ Minimal | ✅ Modular (Ownable, Pausable) |
