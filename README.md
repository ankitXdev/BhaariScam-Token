📘 BhaariScam TokenA gas-optimized ERC-20 token for educational purposes.OverviewBhaariScam is a highly gas-optimized ERC-20 token contract designed to demonstrate advanced Solidity techniques. It avoids expensive operations (e.g., string storage, redundant SSTOREs) while maintaining core ERC-20 functionality.⚠️ Educational FocusThis contract is for learning and demonstration purposes only.Not audited for production use.Lacks SafeERC20 checks for contract interactions.Intentionally named “Scam” to emphasize its educational (and non-malicious) intent.✅ Key FeaturesGas OptimizationsUses bytes32 for name and symbol (cheaper than string).Avoids the 22,100-gas penalty for zero-to-non-zero storage writes.Minimizes storage reads/writes via cached references and conditional updates.Standard ERC-20 ComplianceImplements: transfer, transferFrom, approve, balanceOf, totalSupply.Emits: Transfer, Approval events.SecurityNo reentrancy risks (no external calls in state-changing functions).Input validation (e.g., zero-address checks).🔐 Contract DetailsStorage Layout (Optimized)VariableTypeDescription_namebytes32private constant Token name in hex ("Bhaari Scam")_symbolbytes32private constant Token symbol in hex ("SCAM")_decimalsuint256private constant Fixed to 18 (standard ERC-20 decimals)totalSupplyuint256public Total token supply_accountsmapping(address => Account)Tracks balances and allowances per address🧱 Account StructSoliditystruct Account {
    uint256 balance;
    mapping(address => uint256) allowances;
}
Functions🔧 Core Functionsconstructor(uint256 initialSupply)Mints initialSupply * 10^18 to the deployer.Gas tricks: avoids zero-to-non-zero penalty, uses a storage pointer.Emits Transfer(address(0), msg.sender, initialAmount).transfer(address to, uint256 value)Splits require statements for cheaper checks.Caches sender and recipient storage references.Deletes the balance from storage if it's fully transferred (gas refund).transferFrom(address from, address to, uint256 value)Caches only necessary storage references.Accesses allowance mapping directly.Deletes zeroed allowances (gas refund).approve(address spender, uint256 value)Not protected against the common approval front-running vector.Avoids unnecessary storage reads if the value is unchanged.👁 View FunctionsFunctionReturnsOptimization Detailsname()stringConverts bytes32 to string on-the-fly.symbol()stringSame as name().decimals()uint256Returns the constant 18.balanceOf()uint256Direct mapping read.🧰 Internal Helper_bytes32ToString(bytes32 data)Converts bytes32 to an in-memory string.Dynamically calculates the string length to avoid trailing null bytes.Copies only non-zero bytes.Gas Optimizations BreakdownTechniqueExampleGas Savedbytes32 for strings_name = "0x426861617269205363616d"~20k (on deployment)Avoid zero-to-non-zero writeaccount.balance = 1; account.balance = amount;~17,100Cached storage referencesAccount storage sender = _accounts[msg.sender];~100 per accessSplit require statementsrequire(to != 0); require(value != 0);~3 per conditionConditional deleteif (balance == value) delete sender.balance;~5k (gas refund)Minimal storage updatesUpdate only if value != allowanceValue~5kSecurity Analysis✅ Mitigated RisksReentrancy: No external calls exist in state-changing functions.Overflow/Underflow: Handled natively by Solidity ^0.8.20.Front-Running: Not applicable (no time-sensitive logic like in a DEX).⚠ Potential Risks (Educational Gaps)RiskIssueSuggested FixNo SafeERC20No check if a recipient contract can handle ERC-20 tokens.Use OpenZeppelin’s SafeERC20 library or transfer hooks.Approval Front-RunningVulnerable approve logic.Use increaseAllowance and decreaseAllowance patterns.No Access ControlAnyone can call transfer/approve (as intended).Add Ownable if mint/burn functions were to be added.No Paused/BlacklistTokens can't be frozen/recovered if stolen.Add Pausable or Blacklist (adds centralization).6. Deployment & Interaction🛠 Remix DeploymentCompile: Use Solidity ^0.8.20 with optimization enabled (e.g., 200 runs).Deploy: Input an initialSupply (e.g., 1000 will mint 1000 * 10^18 tokens).Interact: Use transfer(to, amount) or approve(spender, amount). Note that amounts should be in wei (e.g., 1000000000000000000 for 1 token).💻 Example (ethers.js)JavaScriptconst token = await ethers.getContractAt("BhaariScam", "0xContractAddress");

// Transfer 100 tokens
await token.transfer("0xRecipientAddress", ethers.utils.parseEther("100"));
7. Comparison with OpenZeppelin ERC-20FeatureBhaariScamOpenZeppelin ERC-20Gas Efficiency✅ Highly optimizedStandardString Storage❌ bytes32 (cheaper)✅ string (more readable)Safe Transfers❌ No SafeERC20✅ Built-inApproval Security❌ Original ERC-20✅ increaseAllowance patternExtensibility❌ Minimal✅ Modular (Ownable, Pausable)8. Recommendations for Production UseUse OpenZeppelin’s ERC20 as a base (audited, secure).Add SafeERC20 for all contract-to-contract transfers.Implement increaseAllowance / decreaseAllowance to prevent front-running.Add Ownable if minting/burning capabilities are needed.Emit events for all critical actions (e.g., Mint, Burn).🧠 Final NotesEducational Value: Great for learning gas optimizations and storage patterns.Production Readiness: Not recommended without addressing security gaps.Alternative: Extend OpenZeppelin’s ERC20 for production-ready tokens.

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
