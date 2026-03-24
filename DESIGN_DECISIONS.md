## Design Decisions

1. **Inherited OpenZepplin Ownable contract**

Files:

- **src/contracts/VotingSystem.sol** (lines: 18 and 66)

2. **Access Control Restrictions**

Files:

- **src/contracts/VotingSystem.sol** (lines: 51, 154, and 214)

3. **Optimizing Gas**

Files:

- **src/contracts/VotingSystem.sol** (lines: 23, 32, and 35)


## Security Practices

1. **Used 0.8.20 as a specific compiler pragma**

Files:

- **src/contracts/VotingSystem.sol** (line: 2 )
- **src/test/VotingSystem.t.sol** (line; 2)


2. **Proper use of Require**

Files:

- **src/contracts/VotingSystem.sol** (line: 42, 47, 52, and 62)

3. **Used modifires for validation**

- **src/contracts/VotingSystem.sol** (lines: 40, 46, 51 and 61)
