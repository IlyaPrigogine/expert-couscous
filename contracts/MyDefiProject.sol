pragma solidity ^0.5.0;

import './Interfaces/IERC20.sol';
import './Interfaces/IERC1155.sol';
import './Interfaces/IERC1155Receiver.sol';
import './Interfaces/IConditionalTokens.sol';

contract MyDefiProject {
    IERC20 dai;
    IConditionalTokens conditionalTokens;
    address public oracle;

    constructor (
        address _dai,
        address _conditionalTokens,
        address _oracle
    ) public {
        dai = IERC20(_dai);
        conditionalTokens = IConditionalTokens(_conditionalTokens);
        oracle = _oracle;
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
    }
}
