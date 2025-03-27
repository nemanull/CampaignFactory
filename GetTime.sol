// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GetTime{
    uint256 public campaignEnd;

    constructor(uint256 _campaignEnd) {
        require(_campaignEnd > block.timestamp, "End time must be in the future");
        campaignEnd = _campaignEnd;
    }

    function getCurrentTimestamp() public view returns (uint256) {
        return block.timestamp;
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= campaignEnd) {
            return 0;
        }
        return campaignEnd - block.timestamp;
    }

    function timeLeftDetailed()
        public
        view
        returns (
            uint256 daysLeft,
            uint256 hoursLeft,
            uint256 minutesLeft,
            uint256 secondsLeft
        )
    {
        uint256 remaining = timeLeft();
        daysLeft = remaining / 1 days;
        remaining %= 1 days;
        hoursLeft = remaining / 1 hours;
        remaining %= 1 hours;
        minutesLeft = remaining / 1 minutes;
        secondsLeft = remaining % 1 minutes;
    }
}
