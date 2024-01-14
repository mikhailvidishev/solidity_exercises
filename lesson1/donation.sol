// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Donation {
    
    error Contract__IncorrectDonation();
    error Contract__InsufficientBalance();
    error Contract__OnlyOwner();

    // DonationElement keeps specific donation
    struct DonationElement {
        uint256 amount;
    }

    address owner;

    address[] donationKeys;

    uint256 donationsTotal;

    // donations keeps all donations from specific users, identified by address
    mapping(address => DonationElement[]) public donations;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Contract__OnlyOwner();
        }
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function donate() external payable {
        uint256 donationAmount = msg.value;

        if (donationAmount <= 0) {
            revert Contract__IncorrectDonation();
        }

        address donator = msg.sender;
        
        DonationElement memory d = DonationElement({ amount: donationAmount });
        
        if (donations[donator].length == 0) {
            donationKeys.push(donator);
        }

        donations[donator].push(d);

        donationsTotal = donationsTotal + donationAmount;
    }

    function sendHelp(address to, uint256 amount) external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance < amount) {
            revert Contract__InsufficientBalance();
        }
        payable(to).transfer(amount);
    }

    function getDonators() external view returns (address[] memory) {
        return donationKeys;
    }

    function getSumOfDonations() external view returns (uint256) {
        return donationsTotal;
    }
}