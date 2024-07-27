// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChainConnectToken is ERC20 {
    mapping(address => bool) public admins;

    modifier _onlyAdmin() {
        require(admins[msg.sender], "caller is not the admin");
        _;
    }

    constructor() ERC20("Chain Connect", "CC") {
        admins[msg.sender] = true;
    }

    function addAdmin(address _admin) external _onlyAdmin {
        admins[_admin] = true;
    }
    function removeAdmin(address _admin) external _onlyAdmin {
        admins[_admin] = false;
    }
    function mint(address _to, uint _amount) external _onlyAdmin {
        _mint(_to, _amount);
    }
    function burn(address _account, uint _amount) external _onlyAdmin {
        _burn(_account, _amount);
    }
}