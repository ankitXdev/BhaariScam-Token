# BhaariScam Token — Technical Documentation

## 1. Overview

- **Contract Name**: BhaariScam  
- **Symbol**: BSCAM  
- **Standard**: ERC-20 (Simplified, Custom Implementation)  
- **Compiler Version**: ^0.8.0  
- **Purpose**:
  - A gas-efficient, educational version of ERC-20.
  - Demonstrates low-level logic of balances, allowances, and transfers.
  - Focused on understanding, not production readiness.

## 2. Core Functions

### 🔧 Functional Summary

| Function | Description |
|--------|-------------|
| `transfer(to, amount)` | Sends tokens from caller to another address. |
| `approve(spender, amount)` | Allows another address to spend tokens. |
| `transferFrom(from, to, amount)` | Moves tokens from one address to another using allowance. |
| `balanceOf(account)` | Returns the balance of an address. |
| `allowance(owner, spender)` | Shows remaining spendable amount. |

## 3. Gas Optimization Techniques

✅ **Use of `bytes32` for strings** → Cheaper than `string`.  
✅ **Avoid zero-to-non-zero writes** → Prevents high gas costs.  
✅ **Cached storage references** → Fewer `SLOAD` operations.  
✅ **Split `require` checks** → Slightly cheaper per condition.  
✅ **Conditional `delete` for gas refund** → Deletes storage entries when zero.  
✅ **No SafeMath** → Solidity 0.8+ handles overflows automatically.

## 4. Security Analysis

### ✅ Mitigated Risks

- **Reentrancy**: No external calls inside state-changing functions.  
- **Overflow/Underflow**: Safe due to Solidity 0.8+ compiler checks.  
- **Front-Running (in transfers)**: Not applicable to standard transfers.

### ⚠ Potential Risks

| Risk | Description | Fix |
|------|-------------|-----|
| No SafeERC20 | Doesn’t verify if receiving contracts can handle ERC-20 tokens. | Use OpenZeppelin’s `SafeERC20`. |
| Approval Front-Running | The standard `approve` issue remains. | Use `increaseAllowance` and `decreaseAllowance`. |
| No Access Control | Anyone can transfer or approve. | Add `Ownable` for minting/burning roles. |
| No Pause or Blacklist | Tokens cannot be frozen or restricted. | Add `Pausable` or Blacklist functionality if required. |

## 5. Comparison with OpenZeppelin ERC-20

| Feature | BhaariScam | OpenZeppelin ERC-20 |
|--------|------------|----------------------|
| Gas Efficiency | ✅ Highly optimized | Standard |
| String Storage | ❌ `bytes32` (cheaper) | ✅ `string` (more readable) |
| Safe Transfers | ❌ No SafeERC20 | ✅ Built-in |
| Approval Security | ❌ Original ERC-20 | ✅ `increaseAllowance` pattern |
| Extensibility | ❌ Minimal | ✅ Modular (`Ownable`, `Pausable`) |

## 6. Recommendations for Production Use

✅ Use OpenZeppelin’s ERC20 as a base (audited, secure).  
✅ Add SafeERC20 for all contract-to-contract transfers.  
✅ Implement `increaseAllowance` / `decreaseAllowance` to prevent front-running.  
✅ Add `Ownable` if minting/burning capabilities are needed.  
✅ Emit events for all critical actions (e.g., `Mint`, `Burn`).  
✅ Conduct a full audit before mainnet deployment.

## 🧠 Final Notes

**Educational Value**:  
Excellent for learning gas optimizations and storage efficiency.  

**Production Readiness**:  
⚠ Not recommended for live environments without added security layers.  

**Recommended Alternative**:  
Extend OpenZeppelin’s ERC20 contract for production-ready tokens.
