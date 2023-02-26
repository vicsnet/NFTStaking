// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTStaking is ERC20, ERC721Holder, Ownable {
    IERC721 public nft;
    IERC20 public stakedToken;

    mapping(uint256 => address) public TokenOwnerOf;
    mapping(uint256 => uint256) public TokenStakedAt;
    mapping(address => uint256) public AmountStakedAt;
    mapping(address => uint256) public amountOwner;
    uint256 public EMISSION_RATE = (50 *10 ** decimals() ) / 1 days;
    // uint256 public 
    constructor (address _nft, address _stakedToken) ERC20("VinceToken", "VTN"){
        nft = IERC721(_nft);
        stakedToken = IERC20(_stakedToken);
    }

    function stake(uint256 _amount) external{
        require(nft.balanceOf(msg.sender) > 0, "Insufficient Bored Ape, Purchase more");
        require(stakedToken.balanceOf(msg.sender) >= _amount, "Insufficiet balance");
        // nft.safeTransferFrom(msg.sender, address(this), tokenId);
        stakedToken.transferFrom(msg.sender, address(this), _amount);
        amountOwner[msg.sender] =_amount;
        // TokenOwnerOf[tokenId] = msg.sender;

        TokenStakedAt[_amount] = block.timestamp;
        AmountStakedAt[msg.sender] = block.timestamp;
    }
    function calculateToken() public view returns(uint256){
        require(amountOwner[msg.sender] >0 ,"No token staked");
        uint256 timeElapsed = (block.timestamp - AmountStakedAt[msg.sender])%2;
        uint256 _amount = amountOwner[msg.sender];
        // percentage
        // uint256 ratio = 1/1000;
        // 0.01% daily
        // uint256 rewardPerDay = timeElapsed * _amount ;
        uint256 reward = _amount*10**((1*timeElapsed)/1000);
        

        // A = P (1 + r/365)365t
        // A= totalAmount+compoundInterest
        // p=amount deposited
        // t=time
        // r=ratio
        // A = P e**(rt)

        //  P(1+r/n)**(nt) - P.

//     uint currentPeriod = block.timestamp / periodLength;

// for (uint period = lastPeriod; period < currentPeriod; period++)
//   principal += ratio * principal;
// lastPeriod = currentPeriod;

        // uint256 dailyPercent = rewardPerDay /100;

        // return timeElapsed* EMISSION_RATE;
        return reward;
    }
    function unStake() external{
        // require(TokenOwnerOf[tokenId] == msg.sender, "You can't unstake");
        require(amountOwner[msg.sender] >0, "This account doen not have enough balance");
        _mint(msg.sender, calculateToken());
        // nft.transferFrom(address(this), msg.sender, tokenId);
        stakedToken.transfer(msg.sender, amountOwner[msg.sender]);
        // delete TokenOwnerOf[tokenId];
        // delete TokenStakedAt[tokenId];
    } 
}