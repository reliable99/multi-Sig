// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MultiSig {
    address[] public signers;
    uint256 quorum;
    uint256 txCount;

    address owner;
    address nextOwner;
      
    struct Transaction {
        uint256 id;
        uint256 amount;
        address receiver;
        uint256 signersCount;
        bool isExecuted;
        address txCreator;
    }

    Transaction[] allTransactions;

    mapping(uint256 => mapping(address => bool)) hasSigned;
    mapping(uint256 => Transaction) transactions;
    mapping(address => bool) isValidSigner;

    constructor(address[] memory _validSigners, uint256 _quorum) {
        owner = msg.sender;
        signers = _validSigners;
        quorum = _quorum;

        for (uint8 i = 0; i <  _validSigners.length; i++)  {
            require(_validSigners[i] != address(0), "get out");

            isValidSigner[_validSigners[i]] = true;
        }
      
    }

    function initiateTransaction(uint256 _amount, address _receiver) external  {
        require(msg.sender != address(0), "Zero address not allowed");
        require(_amount > 0, "No zero value allowed");

        onlyValidSigner();

        uint256 _txId = txCount + 1;

        Transaction storage tns = transactions[_txId];

        tns.id = _txId;
        tns.amount = _amount;
        tns.receiver = _receiver;
        tns.signersCount = tns.signersCount + 1;
        tns.txCreator = msg.sender;

        allTransactions.push(tns);

        hasSigned[_txId][msg.sender] = true;

        txCount = txCount + 1;
    }

    function approveTransaction(uint256 _txId) external  {

    }

    function getAllTransactions() external view returns (Transaction[] memory) {
        return  allTransactions;
    }

    function onlyOwner() private view {
        require(msg.sender == owner, "Not owner");
    }

    function onlyValidSigner() private view {
        require(isValidSigner[msg.sender], "Not valid signer");
    }

    receive() external payable { }

    fallback() external payable {}
}