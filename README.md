# BhaariScam Token
*A gas-optimized ERC-20 token for Solidity learning*

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Sepolia Testnet](https://img.shields.io/badge/Network-Sepolia-blue)](https://sepolia.etherscan.io/token/0x959f490eab1fc1c80713c6f7b9f543b72076bed9)

---

## **⚠️ Disclaimer**
This contract is **for educational purposes only** and demonstrates extreme gas optimizations. It is **not audited** and lacks production-grade safeguards (e.g., `SafeERC20`). **Do not use in production**.

---

## **📌 Overview**
**BhaariScam** is a **highly gas-optimized** ERC-20 token designed to teach advanced Solidity techniques:
- **Storage efficiency**: Uses `bytes32` for `name`/`symbol` (cheaper than `string`).
- **Gas-saving tricks**: Avoids zero-to-non-zero storage writes, caches storage reads, and minimizes redundant operations.
- **Standard ERC-20**: Implements `transfer`, `approve`, `transferFrom`, and metadata functions.

---

## **🔗 Deployed Contract**
| **Network**  | **Contract Address**                                   | **Etherscan**                          |
|--------------|-------------------------------------------------------|----------------------------------------|
| Sepolia      | [`0x959f490eab1fc1c80713c6f7b9f543b72076bed9`](https://sepolia.etherscan.io/address/0x959f490eab1fc1c80713c6f7b9f543b72076bed9) | [View Token](https://sepolia.etherscan.io/token/0x959f490eab1fc1c80713c6f7b9f543b72076bed9) |

### **Deployment Details**
- **Initial Supply**: `10,000 SCAM` (18 decimals).
- **Deployer Address**: [`0x266Ec89eB84Ad1Fe161d2748c1dCf3979B2Db2fD`](https://sepolia.etherscan.io/address/0x266Ec89eB84Ad1Fe161d2748c1dCf3979B2Db2fD) (Remix `account{0}`).
- **Constructor Input**: `10000` (mints `10,000 * 10^18` tokens).
- **Verification**: [Verified Source Code](https://sepolia.etherscan.io/address/0x959f490eab1fc1c80713c6f7b9f543b72076bed9#code).

---

## **🛠 Key Features**
### **Gas Optimizations**
| **Technique**               | **Example**                          | **Gas Saved**               |
|-----------------------------|--------------------------------------|-----------------------------|
| `bytes32` for strings       | `_name = "0x426861617269205363616d"` | ~20k vs. `string` storage   |
| Avoid zero-to-non-zero writes | `account.balance = 1` before update  | 17,100 gas penalty avoided  |
| Cached storage references    | `Account storage sender = _accounts[msg.sender]` | ~100 gas per access |
| Split `require` statements   | `require(to != 0); require(value != 0)` | ~3 gas per check |
| Conditional `delete`        | `if (balance == value) delete sender.balance` | ~5k gas refund |

### **ERC-20 Compliance**
- **Functions**: `transfer`, `approve`, `transferFrom`, `balanceOf`, `totalSupply`.
- **Events**: `Transfer`, `Approval`.
- **Metadata**: `name()`, `symbol()`, `decimals()` (hardcoded to `18`).

---

## **🚨 Security Notes**
### **✅ Mitigated Risks**
- **Reentrancy**: No external calls in state-changing functions.
- **Overflow/Underflow**: Handled by Solidity `^0.8.20`.
- **Zero-Address Checks**: Validates `to` and `spender` in `transfer`/`approve`.

### **⚠️ Educational Gaps**
| **Risk**               | **Issue**                              | **Suggested Fix**                     |
|------------------------|----------------------------------------|---------------------------------------|
| No `SafeERC20`         | Transfers to contracts may fail.       | Use OpenZeppelin’s `SafeERC20`.       |
| Approval Front-Running | Vulnerable to race conditions.         | Use `increaseAllowance`/`decreaseAllowance`. |
| No Access Control      | Anyone can call `transfer`/`approve`.   | Add `Ownable` for admin functions.    |

---

## **📂 Project Structure**

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
