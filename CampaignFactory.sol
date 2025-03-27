// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Campaign.sol";
import "./PriceConvertor.sol";

contract CampaignFactory {
    address[] public deployedCampaigns;
    mapping(address => address[]) public ownerCampaigns;

    event CampaignCreated(address indexed owner, address campaignAddress, string title, uint256 endDate, address priceFeed);

    function createCampaign(
        uint256 raising_goal,
        uint256 minimal_amount_usd,
        uint256 maximal_amount_usd,
        uint256 campaign_date_end,
        string calldata description,
        string calldata title,
        address priceFeedAddress
    ) external {
        require(campaign_date_end > block.timestamp, "End date must be future");
        require(minimal_amount_usd <= maximal_amount_usd, "Minimal exceeds maximal");
        require(raising_goal >= maximal_amount_usd, "Goal below maximal");
        require(priceFeedAddress != address(0), "Invalid price feed address");

        PriceConvertor priceConvertor = new PriceConvertor(priceFeedAddress);

        Campaign newCampaign = new Campaign(
            msg.sender,
            raising_goal,
            minimal_amount_usd,
            maximal_amount_usd,
            campaign_date_end,
            description,
            title,
            address(priceConvertor)
        );

        deployedCampaigns.push(address(newCampaign));
        ownerCampaigns[msg.sender].push(address(newCampaign));

        emit CampaignCreated(msg.sender, address(newCampaign), title, campaign_date_end, priceFeedAddress);
    }

    function getDeployedCampaigns() external view returns (address[] memory) {
        return deployedCampaigns;
    }

    function getCampaignsByOwner(address owner) external view returns (address[] memory) {
        return ownerCampaigns[owner];
    }
}
