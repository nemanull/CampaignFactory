# Solidity Crowdfunding Smart Contract

This repository provides an Ethereum-based crowdfunding solution implemented in Solidity, using Chainlink Oracles for price conversions and precise timing controls.

---

## 📁 Project Structure

```
.
├── Campaign.sol
├── CampaignFactory.sol
├── GetTime.sol
└── PriceConvertor.sol
```

---

## 🛠️ Smart Contracts Overview

### **Campaign.sol**
Handles individual crowdfunding campaigns:
- Campaign creation, funding, withdrawal, refunds
- Automatic campaign state management (Active, Completed, Refunded)
- Uses `PriceConvertor` for real-time ETH/USD conversions

### **CampaignFactory.sol**
Factory contract to:
- Deploy multiple crowdfunding campaigns
- Keep track of campaigns created by users
- Emit events on new campaign creation

### **PriceConvertor.sol**
- Integrates with Chainlink price feeds for reliable ETH/USD conversions
- Provides utility functions for accurate fundraising calculations

### **GetTime.sol**
- Manages campaign timing with countdown utilities
- Provides detailed time left breakdown (days, hours, minutes, seconds)

---

## 🚀 Getting Started

### **Prerequisites:**
- [Solidity Compiler](https://docs.soliditylang.org/en/latest/installing-solidity.html)
- [Remix IDE](https://remix.ethereum.org/) or other development frameworks (e.g., Hardhat, Foundry)

### **Installation & Deployment:**

1. Clone the repository:
```bash
git clone https://github.com/nemanull/CampaignFactory.git
```

2. Compile using your preferred development environment (e.g., Remix, Hardhat, or Foundry).

3. Deploy `CampaignFactory.sol` first and then use it to deploy `Campaign.sol` contracts.

---

## 🔗 Dependencies
- Chainlink Oracles (`AggregatorV3Interface`)

Ensure correct Chainlink Price Feed address for your target blockchain.

---

## ✅ Verification & Testing

- Verify contracts on [Etherscan](https://etherscan.io/) or relevant blockchain explorers.
- Thoroughly test your contracts before deploying to mainnet (recommended: Remix or Hardhat testing).

---

## ⚠️ Disclaimer

This repository is provided as-is, with no warranty or guarantees. Use responsibly and perform your own due diligence.

---

## 📄 License

MIT License.

