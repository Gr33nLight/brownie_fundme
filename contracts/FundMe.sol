// SPDX-License-Identifier: minutes
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmount;
    address[] public founders;

    address public owner;
    AggregatorV3Interface public priceFeed;

    //  0x9326BFA02ADD2366b30bacB125260Af641031331

    constructor(address _priceFeed) public {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        uint256 receivedVal = msg.value;
        // Check if received wei amount is >= to 5$ converted
        require(
            getConversionRate(receivedVal) / (10**18) >= 5,
            "You need to spend at least 5 USD!!"
        );
        addressToAmount[msg.sender] += msg.value;
        founders.push(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        for (uint256 index = 0; index < 0; index++) {
            address founder = founders[index];
            addressToAmount[founder] = 0;
        }
        founders = new address[](0);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    // Return ETH price with 18 decimals (8 base + 10 added)
    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * (10**10));
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }

    // Gets the USD value of wei received in input
    function getConversionRate(uint256 weiAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPriceWei = getPrice();
        uint256 ethAmountUsd = (weiAmount * ethPriceWei) / 10**18;
        return ethAmountUsd;
    }
}
