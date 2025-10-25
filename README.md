## Functions

### 🔧 Core Functions

**`constructor(uint256 initialSupply)`**
* Mints `initialSupply * 10^18` to the deployer.
* Gas tricks: avoids zero-to-non-zero penalty, uses a storage pointer.
* Emits `Transfer(address(0), msg.sender, initialAmount)`.

**`transfer(address to, uint256 value)`**
* Splits `require` statements for cheaper checks.
* Caches sender and recipient storage references.
* Deletes the balance from storage if it's fully transferred (gas refund).

**`transferFrom(address from, address to, uint256 value)`**
* Caches only necessary storage references.
* Accesses allowance mapping directly.
* Deletes zeroed allowances (gas refund).

**`approve(address spender, uint256 value)`**
* Not protected against the common approval front-running vector.
* Avoids unnecessary storage reads if the value is unchanged.

### 👁 View Functions
| Function | Returns | Optimization Details |
| :--- | :--- | :--- |
| `name()` | `string` | Converts `bytes32` to `string` on-the-fly. |
| `symbol()` | `string` | Same as `name()`. |
| `decimals()` | `uint256` | Returns the `constant` 18. |
| `balanceOf()` | `uint256` | Direct mapping read. |

### 🧰 Internal Helper
**`_bytes32ToString(bytes32 data)`**
* Converts `bytes32` to an in-memory `string`.
* Dynamically calculates the string length to avoid trailing null bytes.
* Copies only non-zero bytes.

---

## Gas Optimizations Breakdown
| Technique | Example | Gas Saved |
| :--- | :--- | :--- |
| `bytes32` for strings | `_name = "0x426861617269205363616d"` | ~20k (on deployment) |
| Avoid zero-to-non-zero write | `account.balance = 1; account.balance = amount;` | ~17,100 |
| Cached storage references | `Account storage sender = _accounts[msg.sender];` | ~100 per access |
| Split `require` statements | `require(to != 0); require(value != 0);` | ~3 per condition |
| Conditional delete | `if (balance == value) delete sender.balance;` | ~5k (gas refund) |
| Minimal storage updates | Update only if `value != allowanceValue` | ~5k |

---

## Security Analysis

### ✅ Mitigated Risks
* **Reentrancy:** No external calls exist in state-changing functions.
* **Overflow/Underflow:** Handled natively by Solidity `^0.8.20`.
* **Front-Running:** Not applicable (no time-sensitive logic like in a DEX).

### ⚠ Potential Risks (Educational Gaps)
| Risk | Issue | Suggested Fix |
| :--- | :--- | :--- |
| **No SafeERC20** | No check if a recipient contract can handle ERC-20 tokens. | Use OpenZeppelin’s `SafeERC20` library or transfer hooks. |
| **Approval Front-Running** | Vulnerable `approve` logic. | Use `increaseAllowance` and `decreaseAllowance` patterns. |
| **No Access Control** | Anyone can call `transfer`/`approve` (as intended). | Add `Ownable` if `mint`/`burn` functions were to be added. |
| **No Paused/Blacklist** | Tokens can't be frozen/recovered if stolen. | Add `Pausable` or `Blacklist` (adds centralization). |

---

## 6. Deployment & Interaction

### 🛠 Remix Deployment
* **Compile:** Use Solidity `^0.8.20` with optimization enabled (e.g., 200 runs).
* **Deploy:** Input an `initialSupply` (e.g., `1000` will mint `1000 * 10^18` tokens).
* **Interact:** Use `transfer(to, amount)` or `approve(spender, amount)`. Note that amounts should be in wei (e.g., `1000000000000000000` for 1 token).

### 💻 Example (ethers.js)
```javascript
const token = await ethers.getContractAt("BhaariScam", "0xContractAddress");

// Transfer 100 tokens
await token.transfer("0xRecipientAddress", ethers.utils.parseEther("100"));
