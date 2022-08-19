pragma solidity ^0.8.16;

import "solmate/tokens/ERC721.sol";
import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

//contract should be upgradeable so add some ownable stuff idk

interface IDirectLoanBase {
    function loanRepaidOrLiquidated(uint32) external view returns (bool);
    function getPayoffAmount(uint32 _loanId) external view returns (uint256);
}
interface IERC721 {
    //could probably exclude and show in UI then tbh
    function ownerOf(uint256 tokenID) view virtual;
    function safeTransferFrom(address from,
        address to,
        uint256 tokenId) public virtual override;
}

contract partsell is ERC721, Ownable, ReentrancyGuard {
    //only supprot buying and selling in ETH, also only loans for 
    address private NFTfiAddress;
    address public liquidationAddress;

    uint public tickSizing;
    uint public internalId;
    //mapping nftID to internalId
    mapping(nftID => uint) public nftID;

    struct nftID {
        address Seller;
        uint tokenId;
        uint internalId;
        //frakt - check if NFT is fractionalized
        bool frakt;
    }
    //internalID 
    //public tickrange = mapping(uint => tickrange);
    struct tickrange {
        uint tokenID;
        address buyer;
        //if it's a sell order, buyer address is address(0)
        uint upperTick;
        uint lowerTick;
        bool sold;
        uint orderExpiry;
    }
    //keep track of orders for each specific NFT using an array (not implemented)
    NFTOrders[] public tickrange;

    constructor() {
        NFTfiAddress = 0xf896527c49b44aAb3Cf22aE356Fa3AF8E331F280;
        liquidationAddress = 0xbb8eeB1b3494e123144Ce38E1aac8f7b96b5EfA5;
        //tick sizing is set at 0.5 eth 
        tickSizing = 500000000000000000;
        internalId = 1;
    }
    function makeOffer(uint _lowerTick, uint _upperTick, uint smartNFTID, uint cost, uint orderExpiry) public {
        //check validity of orderexpiry
        require(orderExpiry >= block.timestamp, "order validity in past")
        //run fillBid(); to check if order is valid + can fill a sell order
        //check if NFT is initialized in system
        if(nftID[smartNFTID] == 0){
            //assign it an internal Id, allow for bids to be made even if its not on sale
            internalId++;

        }
        tickrange({
            internalID: tokenID,
            buyer: msg.sender,
            lowerTick:_lowerTick,
            upperTick:_upperTick,
            sold: false,
            time: orderExpiry
        });
    }

    function cancelOffer(uint _lowerTick, uint _upperTick, uint smartNFTID, uint cost) public {
        //change orderexpiry to equal block.timestamp in order to allow for
    }
    //for selling the NFT, it should actually be adding this contract as an approved seller on the NFT
    //for gas efficiency, there should be two options: setapproval for all, and for safety, set approval for specific item.

    //NFT should only be transferred when a bid is filled
    function setSellRange(uint smartNFTID, uint _lowerTick, uint _upperTick, uint cost) public{
        require(ownerOf(smartNFTID) == msg.sender, "not the owner");
        //contract should check if contract is approved to spend, whether it's setapprovalforAll, or just the speciifc item
        require(stuff, "Contract not approved to spend NFT");
        fillBid(smartNFTID, _lowerTick, _upperTick)
        //allow the seller to set range that they'd like to sell at
        //setup the order in the OB
        tickrange({
            internalID: smartNFTID,
            buyer: address(0),
            lowerTick:_lowerTick,
            upperTick:_upperTick,
            sold: false
        });
    }
    function fillBid(uint smartNFTID, uint _lowerTick, uint _upperTick) internal {
        //check if the offer/sale matches anything in the orderbook, if so - begin the sale by transferring the NFT from seller to this contract
        _checkBids(smartNFTID, uint _lowerTick, uint _upperTick);

        //fillBid
        //if NFT isn't already transferred into contract, do this.
        safeTransferFrom(seller, address(this), smartNFTID);

        //update specific struct order so that sold: true for the specific order
        //update frakt = true for this asset
    }

    function _checkBids(uint smartNFTID) internal returns(bool) {
        //if frakt = true, run this check to see if the order is valid and that the upper and lower bounds for order aren't sold yet

    }

    function settleLoan(uint smartNFTID) public{
        //check that the NFT is repaid
        if(loanisrepaid){
            _repaymentSuccess(smartNFTID);
        }
        
        //in case of defaultm transfer NFT to liquidationAddress, where dealt with manually. rn it's mine 
    }
    
    function _repaymentSuccess(uint smartNFTID) private{
        //if loan is repaid, the NFT is burnt and the funds end up in this smart contract, settleLoan is called
        //people are paid based upon their positions

        //check if the positions are in range, if position is out of range don't pay
        //payoff remaining funds received from NFTfi to the seller
    }
    function identifyNFTID(uint internalID) public pure returns(uint smartNFTID) {
        //identity NFTID based on the internalID, idk if this is needed
    }
}