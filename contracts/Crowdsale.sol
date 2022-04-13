//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./PakoToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Crowdsale is Ownable {
    // The token being sold
    PakoToken public token;

    // Address where funds are collected
    // address public wallet;

    // How many token units a buyer gets per wei
    uint256 public rate;

    // Amount of wei raised
    uint256 public weiRaised;

    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );
    modifier _preValidatePurchase(address _beneficiary, uint256 _weiAmount) {
        require(_beneficiary != address(0), "Beneficiary can't be zero");
        require(_weiAmount != 0, "Must purchase tokens");
        _;
    }

    /**
     * @param _rate Number of token units a buyer gets per wei
     * @param _token Address of the token being sold
     */
    constructor(uint256 _rate, address _token) {
        require(_rate > 0, "Rate must be positive");
        require(_token != address(0), "Token address can't be zero");
        rate = _rate;
        token = PakoToken(_token);
    }

    // -----------------------------------------
    // Crowdsale external interface
    // -----------------------------------------

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * @param _beneficiary Address performing the token purchase
     */
    function buyTokens(address _beneficiary)
        public
        payable
        _preValidatePurchase(_beneficiary, msg.value)
    {
        uint256 weiAmount = msg.value;
        // _preValidatePurchase(_beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);
        // update state
        weiRaised = weiRaised + weiAmount;
        _processPurchase(_beneficiary, tokens * 1e18);
        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens * 1e18);
    }

    // -----------------------------------------
    // Internal interface (extensible)
    // -----------------------------------------

    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
     * @param _beneficiary Address performing the token purchase
     * @param _tokenAmount Number of tokens to be emitted
     */
    function _deliverTokens(address _beneficiary, uint256 _tokenAmount)
        internal
    {
        token.transfer(_beneficiary, _tokenAmount);
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
     * @param _beneficiary Address receiving the tokens
     * @param _tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address _beneficiary, uint256 _tokenAmount)
        internal
    {
        _deliverTokens(_beneficiary, _tokenAmount);
    }

    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param _weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 _weiAmount)
        internal
        view
        returns (uint256)
    {
        return _weiAmount / rate;
    }

    /**
     * @dev Determines how ETH is stored/withdraw on buy owner.
     */
    function withdrawFunds() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
