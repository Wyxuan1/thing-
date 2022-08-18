pragma solidity ^0.8.16;

import "solmate/tokens/ERC721.sol";
import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

interface IDirectLoanBase {
    function loanRepaidOrLiquidated(uint32) external view returns (bool);
    function getPayoffAmount(uint32 _loanId) external view returns (uint256);
}

contract partsell is ERC721, Ownable, ReentrancyGuard {
    //only supprot buying and selling in ETH, also only loans for 
    address private NFTfiAddress;
    uint public tickSizing;
    uint public internalId;
    
    struct chungus {
        address Seller;
        uint tokenId;
        uint internalId;
        
    }
    //public tickrange = mapping(uint => tickrange);
    struct tickrange {
        address buyer;
        uint upperTick;
        uint lowerTick;
    }

    constructor() {
        NFTfiAddress = 0xf896527c49b44aAb3Cf22aE356Fa3AF8E331F280;
        //tick sizing is set at 0.5 eth 
        tickSizing = 500000000000000000;
        internalId = 0;
    }
    function makeOffer(uint lowerTick, uint upperTick, uint smartNFTID, uint cost) public {

    }
}