// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVesting {
    struct VestingSchedule {
        uint256 totalTokens;
        uint256 tokensWithdrawn;
        uint256 startTime;
        uint256 cliff;
        uint256 vestingDuration;
    }

    mapping(address => VestingSchedule) public investorVesting;
    mapping(address => VestingSchedule) public advisorVesting;
    mapping(address => VestingSchedule) public developerVesting;

    address public founderWallet;
    IERC20 public token;

    constructor(
        uint256 vestingStartTime,
        address founderWalletAddress,
        address advisorAddress,
        address teamAddress,
        address tokenAddress
    ) {
        founderWallet = founderWalletAddress;
        token = IERC20(tokenAddress);

        // Vesting schedule for investors
        uint256 investorTotalTokens = 120_000_000 * 10**18;
        investorVesting[teamAddress] = VestingSchedule(
            investorTotalTokens,
            0,
            vestingStartTime,
            0,
            10 minutes
        );

        // Vesting schedule for advisors
        uint256 advisorTotalTokens = 16_000_000 * 10**18;
        advisorVesting[advisorAddress] = VestingSchedule(
            advisorTotalTokens,
            0,
            vestingStartTime,
            0,
            10 minutes
        );

        // Vesting schedule for developers
        uint256 developerTotalTokens = 24_000_000 * 10**18;
        developerVesting[teamAddress] = VestingSchedule(
            developerTotalTokens,
            0,
            vestingStartTime,
            0,
            10 minutes
        );
    }

    function withdrawInvestorTokens() public {
        VestingSchedule storage vesting = investorVesting[msg.sender];
        uint256 vestedTokens = calculateVestedTokens(vesting);
        uint256 withdrawableTokens = vestedTokens - vesting.tokensWithdrawn;
        require(withdrawableTokens > 0, "No tokens available for withdrawal");
        vesting.tokensWithdrawn += withdrawableTokens;
        token.transfer(msg.sender, withdrawableTokens);
    }

    function withdrawAdvisorTokens() public {
        VestingSchedule storage vesting = advisorVesting[msg.sender];
        uint256 vestedTokens = calculateVestedTokens(vesting);
        uint256 withdrawableTokens = vestedTokens - vesting.tokensWithdrawn;
        require(withdrawableTokens > 0, "No tokens available for withdrawal");
        vesting.tokensWithdrawn += withdrawableTokens;
        token.transfer(msg.sender, withdrawableTokens);
    }

    function withdrawDeveloperTokens() public {
        VestingSchedule storage vesting = developerVesting[msg.sender];
        uint256 vestedTokens = calculateVestedTokens(vesting);
        uint256 withdrawableTokens = vestedTokens - vesting.tokensWithdrawn;
        require(withdrawableTokens > 0, "No tokens available for withdrawal");
        vesting.tokensWithdrawn += withdrawableTokens;
        token.transfer(msg.sender, withdrawableTokens);
    }

    function calculateVestedTokens(VestingSchedule storage vesting)
    internal
    view
    returns (uint256)
    {
        if (block.timestamp < vesting.startTime + vesting.cliff) {
        return 0;
    }

    uint256 elapsedTime = block.timestamp - vesting.startTime;
    if (elapsedTime >= vesting.vestingDuration) {
        return vesting.totalTokens;
    }

    uint256 vestedTokens = (elapsedTime * vesting.totalTokens) / vesting.vestingDuration;
    return vestedTokens;
    }
}