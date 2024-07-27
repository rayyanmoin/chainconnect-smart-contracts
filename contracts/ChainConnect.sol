// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.26;
import "AccountCreation.sol";

error NoPriceForNFS(string memory status, uint256 price);
error NoBidForBuy(string memory status, uint256 bidDuration);

contract ChainConnect{
    /**
    1 -> Buyable
    2 -> NFS
    3 -> Biddable
     */

    constructor(string memory _name,
        string memory _symbol)AccountCreation(_name, _symbol) {}

    function mint(uint256 biduration,uint8 status, uint256 price, string calldata metadata, string memory tokenURI)external{
        if(status == 2 && price > 0){
            revert NoPriceForNFS("Not For Sale", price);
        }
        if(status == 1 && biduration > 0){
            revert NoBidForBuy("No Duration", biduration);
        }
        if(status == 1 && biduration > 0){
            revert NoBidForBuy("No Duration", biduration);
        }
    }    

}
