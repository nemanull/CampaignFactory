// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceConvertor {
    AggregatorV3Interface public immutable priceFeed;

    constructor(address _priceFeedAddress) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return answer;
    }

    function WeiPerUSD() public view returns (uint256) {
        int256 price = getLatestPrice();
        require(price > 0, "Invalid price");
        return (1e26) / uint256(price);
    }
}
