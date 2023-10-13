//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract referralProgram {

    address owner;

    constructor () {
        owner = msg.sender;
    }

    modifier onlyOwner () {
        require(msg.sender == owner, "not owner");
        _;
    }

    mapping(address => string) public addressCode;
    mapping(string => address) public codeAddress;
    mapping(address => uint32) public AddressPuntuation;
    uint32 public points;
    string[] codeList;
    bool hasReg;

    function setPoinsAmount(uint32 _points) public onlyOwner{
        points = _points;
    }

    function createCode(string memory code) public {
        require(codeListReview(code) == false, "This code exist, please choose another code");
        addressCode[msg.sender] = code;
        codeAddress[code] = msg.sender;
        AddressPuntuation[msg.sender] += points;
        codeList.push(code);
    }

    function codeListReview(string memory code) public view returns(bool isInList) {
        uint32 i;
        for(i = 0; i < codeList.length; i++){
            if (keccak256(abi.encodePacked(code)) == keccak256(abi.encodePacked(codeList[i]))) {
                return(true);
            } 
        }
        return(false);
    } 

    function regWithCode(string memory code) public {
        require(hasReg == false);
        require(codeListReview(code) == true);
        address referrer = codeAddress[code];
        AddressPuntuation[referrer] += points;
        AddressPuntuation[msg.sender] += points; 
        hasReg = true;
    }
} 
