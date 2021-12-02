pragma solidity ^0.5.0;

import './Interfaces/IERC20.sol';
import './Interfaces/IERC1155.sol';
import './Interfaces/IERC1155Receiver.sol';
import './Interfaces/IConditionalTokens.sol';

contract MyDefiProject {
    IERC20 dai;
    IConditionalTokens conditionalTokens;
    address public oracle;
    address admin;

    mapping(bytes32 => mapping(uint => uint)) public tokenBalance;

    constructor (
        address _dai,
        address _conditionalTokens,
        address _oracle
    ) public {
        dai = IERC20(_dai);
        conditionalTokens = IConditionalTokens(_conditionalTokens);
        oracle = _oracle;
        admin = msg.sender;
    }

    function createBet(bytes32 questionId, uint amount) external {
        conditionalTokens.prepareCondition(
            oracle,
            questionId,
            3
        );

        bytes32 conditionId = conditionalTokens.getConditionId(
            oracle,
            questionId,
            3
        );

        uint[] memory partition = new uint[](2);
        partition[0] =1;
        partition[1] =3;
        dai.approve(address(conditionalTokens),amount);
        conditionalTokens.splitPosition(
            dai,
            bytes32(0),
            conditionId,
            partition,
            amount
        );

        tokenBalance[questionId][0] = amount;
        tokenBalance[questionId][1] = amount;
    }

    function transferTokens (
        bytes32 questionId,
        uint indexSet,
        address to,
        uint amount
    ) external {
        require (msg.sender == admin, 'only Admin');
        require (tokenBalance[questionId][indexSet] >= amount, 'not enough token');

        bytes32 conditionId = conditionalTokens.getConditionId(
            oracle,
            questionId,
            3
        );

        bytes32 collectionId = conditionalTokens.getCollectionId(
            bytes32(0),
            conditionId,
            indexSet
        );

        uint positionId = conditionalTokens.getPositionId(
            dai,
            collectionId
        );
        conditionalTokens.safeTransferFrom(
            address (this),
            to,
            positionId,
            amount,
            ""
        );
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }
}
