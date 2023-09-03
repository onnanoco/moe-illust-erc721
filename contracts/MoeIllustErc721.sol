// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
********************          ********************          ********************
********************          ********************          ******************((
********************          ********************          ***************(((((
********************          ********************          *************(((((((
********************          ********************          **********((((((((((
********************          ********************          ********((((((((((((
********************          ********************          *****(((((((((((((((
********************          ********************          ***(((((((((((((((((
                                                                                
                                                                                
                                                                                
                                                                                
********************          ********************          ((((((((((((((((((((
********************          ******************((          ((((((((((((((((((((
********************          ***************(((((          ((((((((((((((((((((
********************          *************(((((((          ((((((((((((((((((((
********************          **********((((((((((          ((((((((((((((((((((
********************          ********((((((((((((          ((((((((((((((((((((
********************          *****(((((((((((((((          ((((((((((((((((((((
********************          ***(((((((((((((((((          ((((((((((((((((((((
********************                                                            
********************                                                            
********************                                                            
********************                                                            
********************((((((((((((((((((((((((((((((          ((((((((((((((((((((
******************((((((((((((((((((((((((((((((((          ((((((((((((((((((((
***************(((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
*************(((((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
**********((((((((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
********((((((((((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
*****(((((((((((((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
***(((((((((((((((((((((((((((((((((((((((((((((((          ((((((((((((((((((((
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

struct NftInfo {
  string uri;
  address creatorAddress;
  string proof;
}

contract MoeIllust is ERC721 {

  using Counters for Counters.Counter;

  Counters.Counter private _tokenIdTracker;
  uint256 public constant fee = 10**18;
  address public immutable moeErc20Address;

  mapping (uint256 => NftInfo) public nftInfo;

  constructor(string memory _name, string memory _symbol, address _moeErc20Address) ERC721(_name, _symbol) {
    moeErc20Address = _moeErc20Address;
  }

  function mint(address to, string memory uri, address creatorAddress, string memory proof) public {
    ERC20 moeErc20 = ERC20(moeErc20Address);
    require(moeErc20.balanceOf(_msgSender()) >= fee, "MOE: insufficient MOE balance");
    moeErc20.transferFrom(_msgSender(), address(this), fee);
    _mint(to, _tokenIdTracker.current());
    nftInfo[_tokenIdTracker.current()] = NftInfo(uri, creatorAddress, proof);
    _tokenIdTracker.increment();
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    _requireMinted(tokenId);

    return nftInfo[tokenId].uri;
  }

  function tokenCreatorAddress(uint256 tokenId) public view returns (address) {
    _requireMinted(tokenId);

    return nftInfo[tokenId].creatorAddress;
  }

  function tokenProof(uint256 tokenId) public view returns (string memory) {
    _requireMinted(tokenId);

    return nftInfo[tokenId].proof;
  }
}