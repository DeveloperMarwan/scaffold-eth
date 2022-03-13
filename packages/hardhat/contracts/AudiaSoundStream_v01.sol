pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

contract AudiaSoundStream_v01 is ERC1155, ERC1155Supply, Ownable {
    uint256 private constant TRACK_FIXED_PRICE = 10000000000000000; //0.01 MATIC (for testing purposes)

    enum TrackNumbers {
        NOTUSED,
        ONE,
        TWO,
        THREE,
        FOUR,
        FIVE,
        SIX,
        SEVEN,
        EIGHT,
        NINE
    }

    struct TrackData {
        uint256 trackId;
        string uriPart;
        uint256 mintPrice;
        uint16 supplyLimit;
        bool    isSet;
    }

    mapping(TrackNumbers => TrackData) private trackNumberToData;
    bool public saleActive = false;

    constructor() ERC1155("ipfs://") {
        trackNumberToData[TrackNumbers.ONE] = TrackData(uint(TrackNumbers.ONE),     'bafyreihhrcu2ujzogayxtqrzegr2ejuxp6koubddoc6j35tjz4ponmc26e/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.TWO] = TrackData(uint(TrackNumbers.TWO),     'bafyreidrq3r5wilm4o7cviwlz7jyyatmrplnp565it3436n36k7ghhceoy/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.THREE] = TrackData(uint(TrackNumbers.THREE), 'bafyreib6wiosy2qtqgmoen3g6zyu3tqvpxmmszqyxwkeiqjbt6iy3blejq/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.FOUR] = TrackData(uint(TrackNumbers.FOUR),   'bafyreifhz2xk2q53c3hbxhu2jombqlmtcbdxthw7b7g3m2wiocb6bupncm/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.FIVE] = TrackData(uint(TrackNumbers.FIVE),   'bafyreiczr6k6p4jet65fz7iixy2br4ji2q3g63dwuponmujtbqzqxgajhu/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.SIX] = TrackData(uint(TrackNumbers.SIX),     'bafyreifvky7mjikq3q2wwtth7ptqn5f5ko5cxdtg7jp7bozm535aynkrjy/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.SEVEN] = TrackData(uint(TrackNumbers.SEVEN), 'bafyreigvw65aub5lnujn7oyk3sbwj2d3o5t737uog5widuvahuijn2pici/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.EIGHT] = TrackData(uint(TrackNumbers.EIGHT), 'bafyreigfygobdmyykwlzrhaou6vishmmuzibjywl56szybxoqmwjj3h6om/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);
        trackNumberToData[TrackNumbers.NINE] = TrackData(uint(TrackNumbers.NINE),   'bafyreif2honk4snxe34ubh2iofzsnmw7avyvdkk45bkeqfteax6bczvpa4/metadata.json', 
                TRACK_FIXED_PRICE, 1000, true);                                                                                                                                
    }

    function uri(uint256 id) public view override returns (string memory) {
        console.log('uri::id = %s', id);
        TrackData storage trackData = trackNumberToData[TrackNumbers(id)];
        require(trackData.isSet, 'uri::Invalid token id');
        string memory baseURI = super.uri(id);
        console.log('uri:baseURI = %s', baseURI);
        console.log('uri:trackData.uriPart = %s', trackData.uriPart);
        return string(abi.encodePacked(baseURI, trackData.uriPart));
    }

    function buyAlbumTrack(TrackNumbers _trackNumber, uint256 _howMany) public payable {
        TrackData storage trackData = trackNumberToData[_trackNumber];
        require(trackData.isSet, 'buyAlbumTrack::Invlaid track number');
        require(_howMany > 0, 'buyAlbumTrack::Invlalid value for how many tracks');
        require(msg.value >= trackData.mintPrice * _howMany, 'buyAlbumTrack::Not enough paid');
        require(totalSupply(uint(trackData.trackId)) <= trackData.supplyLimit, 'buyAlbumTrack::Already reached supply limit for this track');
        _mint(msg.sender, uint(trackData.trackId), _howMany, "");
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
            internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

}