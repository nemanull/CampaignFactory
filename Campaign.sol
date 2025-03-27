// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./PriceConvertor.sol";
import "./GetTime.sol";

contract Campaign {

    PriceConvertor public immutable priceConvertor;
    GetTime public getTime;

    address public immutable CAMPAIGN_OWNER;
    uint256 public immutable CAMPAIGN_RAISING_GOAL;
    uint256 public immutable CAMPAIGN_MINIMAL_AMOUNT_USD;
    uint256 public immutable CAMPAIGN_MAXIMAL_AMOUNT_USD;
    uint256 public immutable CAMPAIGN_DATE_START;
    uint256 public immutable CAMPAIGN_DATE_END;

    string public campaign_title;
    string public campaign_description;

    address[] public funders;
    mapping(address => uint256) public funder_fundedAmount;
    mapping(address => bool) private existingFunder;

    bool public paused;

    enum CampaignState { Active, Completed, Refunded }
    CampaignState public state;

    event Funded(address indexed funder, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);
    event Refunded(address indexed funder, uint256 amount);

    modifier OnlyOwner {
        require(msg.sender == CAMPAIGN_OWNER, "Not authorized");
        _;
    }

    modifier campaignActive {
        require(state == CampaignState.Active, "Campaign not active");
        _;
    }

    modifier whenNotPaused {
        require(!paused, "Campaign paused");
        _;
    }

    constructor(
        address owner,
        uint256 raising_goal,
        uint256 minimal_amount, 
        uint256 maximal_amount,
        uint256 campaign_date_end,
        string memory desc,
        string memory title,
        address _priceConvertor
    ) {
        CAMPAIGN_OWNER = owner;
        priceConvertor = PriceConvertor(_priceConvertor);
        CAMPAIGN_RAISING_GOAL = raising_goal;
        CAMPAIGN_MINIMAL_AMOUNT_USD = minimal_amount * priceConvertor.WeiPerUSD();
        CAMPAIGN_MAXIMAL_AMOUNT_USD = maximal_amount * priceConvertor.WeiPerUSD();
        getTime = new GetTime(campaign_date_end);
        CAMPAIGN_DATE_START = getTime.getCurrentTimestamp();
        CAMPAIGN_DATE_END = campaign_date_end;
        campaign_title = title;
        campaign_description = desc;
        state = CampaignState.Active;
    }


    function Fund() public payable campaignActive whenNotPaused {
        require(getTime.getCurrentTimestamp() < CAMPAIGN_DATE_END, "Campaign ended");
        require(msg.value >= CAMPAIGN_MINIMAL_AMOUNT_USD, "Below minimum");
        require(funder_fundedAmount[msg.sender] + msg.value <= CAMPAIGN_MAXIMAL_AMOUNT_USD, "Above maximum");

        if (!existingFunder[msg.sender]) {
            funders.push(msg.sender);
            existingFunder[msg.sender] = true;
        }

        funder_fundedAmount[msg.sender] += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function Withdraw() public OnlyOwner {
        require(getTime.getCurrentTimestamp() >= CAMPAIGN_DATE_END, "Campaign active");
        require(state == CampaignState.Active, "Already finalized");

        if (address(this).balance >= CAMPAIGN_RAISING_GOAL) {
            state = CampaignState.Completed;
            emit Withdrawn(CAMPAIGN_OWNER, address(this).balance);
            payable(CAMPAIGN_OWNER).transfer(address(this).balance);
        } else {
            state = CampaignState.Refunded;
        }
    }

    function refund() external {
        require(state == CampaignState.Refunded, "Not refundable");
        uint256 amount = funder_fundedAmount[msg.sender];
        require(amount > 0, "No funds available");

        funder_fundedAmount[msg.sender] = 0;
        emit Refunded(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }

    function togglePause() external OnlyOwner {
        paused = !paused;
    }

    function getTimeLeft() public view returns (uint256) {
        return getTime.timeLeft();
    }

    function isGoalReached() public view returns (bool) {
        return address(this).balance >= CAMPAIGN_RAISING_GOAL;
    }

    receive() external payable {
        Fund();
    }

    fallback() external payable {
        revert("Invalid function call or Ether sent incorrectly");
    }
}
