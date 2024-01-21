// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BorrowLend {
    struct Loan {
        uint amount;
        uint interestRate;
        uint dueDate;
        bool isRepaid;
    }
    
    struct User {
        uint creditScore;
        Loan loan;
    }
    
    mapping(address => User) private users;
    address public admin;
    
    event LoanTaken(address indexed borrower, uint amount, uint interestRate, uint dueDate);
    event LoanRepaid(address indexed borrower, uint repaidAmount);
    event CreditScoreUpdated(address indexed user, uint newCreditScore);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }
    
    constructor() payable  {
        admin = msg.sender;
    }

    function setCreditScore(address user, uint score) external onlyAdmin {
        require(score <= 850, "Credit score can't exceed 850");
        users[user].creditScore = score;
        emit CreditScoreUpdated(user, score);
    }
    
    function getLoanDetails(address borrower) external view returns (Loan memory) {
        return users[borrower].loan;
    }
    
    function borrow(uint requestedAmount) external {
        User storage borrower = users[msg.sender];
        require(borrower.loan.amount == 0, "Existing loan must be repaid first.");
        uint interestRate = calculateInterest(borrower.creditScore);
        uint dueDate = block.timestamp + 30 days; // Loan due date set to 30 days from now
        
        borrower.loan = Loan(requestedAmount, interestRate, dueDate, false);
        
        require(address(this).balance >= requestedAmount, "Insufficient funds in the contract");
        payable(msg.sender).transfer(requestedAmount);
        
        emit LoanTaken(msg.sender, requestedAmount, interestRate, dueDate);
    }
    
    function repay() external payable {
        User storage borrower = users[msg.sender];
        Loan storage loan = borrower.loan;
        uint repaymentAmount = loan.amount + (loan.amount * loan.interestRate) / 100;
        require(loan.amount != 0, "No active loan to repay");
        require(block.timestamp <= loan.dueDate, "Loan is overdue.");
        require(msg.value >= repaymentAmount, "Insufficient amount to cover the debt.");
        
        loan.isRepaid = true;
        recalculateCreditScore(msg.sender, true);
        
        // Emit the event before potentially reverting due to overpayment
        emit LoanRepaid(msg.sender, repaymentAmount);
        
        if (msg.value > repaymentAmount) {
            uint overpayment = msg.value - repaymentAmount;
            payable(msg.sender).transfer(overpayment);
        }
        
        // Clear the loan after repayment
        delete users[msg.sender].loan;
    }
    
    function recalculateCreditScore(address borrower, bool onTimePayment) private {
        User storage user = users[borrower];
        
        // Placeholder for a more complex credit score recalculating algorithm.
        if (onTimePayment) {
            user.creditScore += 10; // Simple increase for on-time payment
        } else {
            if (user.creditScore > 10) {
                user.creditScore -= 10; // Simple decrease for late or missing payments
            }
        }
        
        emit CreditScoreUpdated(borrower, user.creditScore);
    }
    
    function calculateInterest(uint creditScore) private pure returns (uint) {
        if (creditScore > 750) return 5;  // 5% interest for high credit scores.
        if (creditScore > 500) return 10; // 10% interest for medium credit scores.
        return 20;                        // 20% interest for low credit scores.
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // Function to allow direct Ether transactions to fund the contract.
    receive() external payable {}
}