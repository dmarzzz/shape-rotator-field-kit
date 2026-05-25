---
name: herd-mcp
description: Connect to blockchain data via Herd MCP server — contract inspection, transaction decoding, wallet analysis, HAL action building across Ethereum and Base. Use when the user says "look up a contract", "decode this tx", "check this wallet", "build a HAL action", or needs onchain data in their workflow.
---

# herd-mcp

Herd MCP is a Model Context Protocol server that connects AI agents to
blockchain data and functions. It enables natural language queries for
contract inspection, transaction decoding, wallet analysis, and onchain
action building across Ethereum and Base.

## When to invoke

The user said something like:
- "look up this contract"
- "decode this transaction"
- "check this wallet"
- "what does this contract do"
- "build a HAL action"
- "inspect onchain data"
- "compare contract versions"
- "who deployed this contract"

## Setup

The Herd MCP server should already be registered. If not, add it:

```bash
claude mcp add --transport http herd-mcp https://mcp.herd.eco/v1
```

After adding, authenticate via the MCP interface:
1. Locate `herd-mcp` in the MCP list (`claude mcp list`)
2. Click the authenticate button when prompted
3. Complete OAuth login at herd.eco

## Available Tools (19 total)

### Contract Analysis
- **Contract Metadata** — ABI, proxy history, token data, deployment info
- **Deployed Contracts** — find contracts deployed by a wallet or factory
- **Contract Version Diffs** — compare code between upgradeable versions
- **Code Analysis** — search contract source with AI-generated regex
- **Role Topology** — inspect role/permission structure of a contract

### Transaction & Activity
- **Latest Transactions** — recent txs by function call or event
- **Query Transaction** — decode traces, logs, and balance shifts
- **Token Activity** — token balance and transfer history
- **Transaction Activity** — enriched tx history for any address
- **Wallet Overview** — type detection, balances, activity metrics

### HAL Development
- **Code Blocks** — create/execute TypeScript blocks for HAL expressions
- **Actions & Adapters** — create, search, update, delete HAL actions
- **Collections** — organize actions and adapters
- **Evaluation** — simulate/test HAL expressions in sandbox

### Reference
- **Bookmarks** — saved wallets, contracts, transactions
- **Documentation** — HAL and platform docs access

## Supported Networks
- Ethereum
- Base

## Docs
- https://docs.herd.eco/herd-mcp/introduction
- https://docs.herd.eco/llms.txt
