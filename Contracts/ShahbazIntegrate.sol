pragma solidity ^0.6.6;

import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';


//import '@OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol'
//import "@openzeppelin/contracts/token//ERC20/IERC20.sol";
import './IERC20.sol';


contract ShahbazIntegerate
{
    IUniswapV2Router02 private router;
    IUniswapV2Factory private factory;

    constructor(address _router , address _factory) public
    {
        router = IUniswapV2Router02(_router);
        factory = IUniswapV2Factory(_factory);

    }

    function SWAP(address[] memory path , uint _amountIn , uint amountOutMin) public
    {
    uint amountIn =  _amountIn;

    require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
    require(IERC20(path[0]).approve(address(router), amountIn), 'approve failed.');
    // amountOutMin must be retrieved from an oracle of some kind
    // address[] memory path = new address[](2);
    // path[0] = address(DAI);
    // path[1] = UniswapV2Router02.WETH();
    router.swapExactTokensForETH(amountIn, amountOutMin, path, msg.sender, block.timestamp);

    }


    //Add Liquidity
    function AddLiquidity(address tokenA,address tokenB,uint amountADesired,uint amountBDesired , uint _tolerence)  public
    {
        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired), 'transferFrom failed.');
        require(IERC20(tokenA).approve(address(router), amountADesired), 'approve failed.');

        require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired), 'transferFrom failed.');
        require(IERC20(tokenB).approve(address(router), amountBDesired), 'approve failed.');

        uint amountAMin = amountADesired - (amountADesired * _tolerence);
        uint amountBMin = amountBDesired - (amountBDesired * _tolerence);
        
        router.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, msg.sender, block.timestamp);



    }

//Remove Liquidity
    function RemoveLiquidity(address tokenA,address tokenB, uint liquidity) public
    {
        // require(IERC20(tokenA).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // require(IERC20(tokenA).approve(address(router),liquidity ), 'approve failed.');

        // require(IERC20(tokenB).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // require(IERC20(tokenB).approve(address(router), liquidity), 'approve failed.');

        
        address pairAddress = factory.getPair(tokenA, tokenB);
        require(IUniswapV2Factory(pairAddress).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        require(IUniswapV2Factory(pairAddress).approve(address(router),liquidity ), 'approve failed.');
        
        uint amountAMin = 0;
        uint amountBMin = 0;

        router.removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, msg.sender, block.timestamp);
    }
}