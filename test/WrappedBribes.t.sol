pragma solidity 0.8.13;

import './BaseTest.sol';
import "contracts/WrappedBribe.sol";
import "contracts/factories/WrappedBribeFactory.sol";
import "forge-std/console2.sol";

contract WrappedBribesTest is BaseTest {
    VotingEscrow escrow;
    GaugeFactory gaugeFactory;
    BribeFactory bribeFactory;
    WrappedBribeFactory wxbribeFactory;
    Voter voter;
    RewardsDistributor distributor;
    Minter minter;
    Gauge gauge;
    ExternalBribe xbribe;
    WrappedBribe wxbribe;
    Gauge gauge2;
    ExternalBribe xbribe2;
    WrappedBribe wxbribe2;

    function setUp() public {
        vm.warp(block.timestamp + 1 weeks); // put some initial time in

        deployOwners();
        deployCoins();
        mintStables();
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 2e25;
        amounts[1] = 1e25;
        amounts[2] = 1e25;
        mintFlow(owners, amounts);
        mintLR(owners, amounts);
        VeArtProxy artProxy = new VeArtProxy();
        escrow = new VotingEscrow(address(FLOW), address(artProxy), owners[0], csrNftId);
        deployPairFactoryAndRouter();

        // deployVoter()
        gaugeFactory = new GaugeFactory(csrNftId);
        bribeFactory = new BribeFactory(csrNftId);
        voter = new Voter(address(escrow), address(factory), address(gaugeFactory), address(bribeFactory), address(wxbribeFactory), csrNftId);
        wxbribeFactory = new WrappedBribeFactory(address(voter), csrNftId);

        escrow.setVoter(address(voter));
        factory.setVoter(address(voter));
        deployPairWithOwner(address(owner));

        // deployMinter()
        distributor = new RewardsDistributor(address(escrow), csrNftId);
        minter = new Minter(address(voter), address(escrow), address(distributor), csrNftId);
        distributor.setDepositor(address(minter));
        FLOW.setMinter(address(minter));
        address[] memory tokens = new address[](5);
        tokens[0] = address(USDC);
        tokens[1] = address(FRAX);
        tokens[2] = address(DAI);
        tokens[3] = address(FLOW);
        tokens[4] = address(LR);
        voter.initialize(tokens, address(minter));

        Minter.Claim[] memory claims = new Minter.Claim[](0);
        minter.initialMintAndLock(claims, 0);
        minter.startActivePeriod();

        // USDC - FRAX stable
        gauge = Gauge(voter.createGauge(address(pair)));
        xbribe = ExternalBribe(gauge.external_bribe());
        wxbribe = WrappedBribe(wxbribeFactory.oldBribeToNew(address(xbribe)));


        // USDC - FRAX stable
        gauge2 = Gauge(voter.createGauge(address(pair2)));
        xbribe2 = ExternalBribe(gauge2.external_bribe());
        wxbribe2 = WrappedBribe(wxbribeFactory.oldBribeToNew(address(xbribe2)));

        // ve
        FLOW.approve(address(escrow), TOKEN_1);
        escrow.create_lock(TOKEN_1, FOUR_YEARS);
        vm.startPrank(address(owner2));
        FLOW.approve(address(escrow), TOKEN_1);
        escrow.create_lock(TOKEN_1, FOUR_YEARS);
        vm.warp(block.timestamp + 1);
        vm.stopPrank();

        vm.startPrank(address(owner3));
        FLOW.approve(address(escrow), TOKEN_1);
        escrow.create_lock(TOKEN_1, FOUR_YEARS);
        vm.warp(block.timestamp + 1);
        vm.stopPrank();
    }

    function testOldBribesAreBroken() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(xbribe), TOKEN_1);
        xbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd half a week
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = xbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        vm.startPrank(address(voter));
        // once
        xbribe.getRewardForOwner(1, rewards);
        // twice
        xbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post = LR.balanceOf(address(owner));
        assertEq(post - pre, TOKEN_1);
    }

    function testWrappedBribesCanClaimOnlyOnce() public {
        // Epoch 0
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd half a week
        // Epoch flip
        // Epoch 1 starts
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        console2.log("");
        console2.log("Epoch 1: BEFORE checking 1 in bribe");
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);

        // Middle of Epoch 1
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe2), TOKEN_1);
        wxbribe2.notifyRewardAmount(address(LR), TOKEN_1);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // vote
        address[] memory pools2 = new address[](1);
        pools2[0] = address(pair2);
        uint256[] memory weights2 = new uint256[](1);
        weights2[0] = 10000;
        voter.vote(1, pools2, weights2);


        vm.startPrank(address(owner2));
        voter.vote(2, pools2, weights2);
        vm.stopPrank();


        vm.startPrank(address(owner3));
        voter.vote(3, pools, weights);
        vm.stopPrank();

        // fwd half a week
        // Epoch flip
        // Epoch 2 starts
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre2 = LR.balanceOf(address(owner));
        console2.log("");
        console2.log("Epoch 2: BEFORE checking 1 in bribe2");
        uint256 earned2 = wxbribe2.earned(address(LR), 1);
        assertEq(earned2, TOKEN_1 / 2);

        console2.log("");
        console2.log("Epoch 2: BEFORE checking 1 in bribe1");
        earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, 0);

        // rewards
        address[] memory rewards2 = new address[](1);
        rewards2[0] = address(LR);

        vm.startPrank(address(voter));
        // once
        wxbribe2.getRewardForOwner(1, rewards2);
        uint256 post2 = LR.balanceOf(address(owner));
        // twice
        wxbribe2.getRewardForOwner(1, rewards2);
        vm.stopPrank();

        uint256 post_post2 = LR.balanceOf(address(owner));
        assertEq(post_post2, post2);
        assertEq(post_post2 - pre2, TOKEN_1 / 2);

        continueEpoch2();
    }

    function continueEpoch2() public {
        // Middle of epoch 2
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;

        vm.startPrank(address(owner3));
        voter.vote(3, pools, weights);
        vm.stopPrank();

        epoch3();
    }

    function epoch3() public {
        // fwd half a week
        // Epoch flip
        // Epoch 3 starts
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);
    
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;

        vm.startPrank(address(owner3));
        voter.vote(3, pools, weights);
        vm.stopPrank();

        // not claiming epoch 3 bribes for NFT 3
        epoch4();
    }

    function epoch4() public {
        // fwd a week
        // Epoch flip
        // Epoch 4
        vm.warp(block.timestamp + 1 weeks);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;

        voter.vote(1, pools, weights);

        vm.startPrank(address(owner3));
        voter.reset(3);
        vm.stopPrank();

        // Middle of epoch 4
        vm.warp(block.timestamp + 1 weeks / 2);

        console2.log("");
        console2.log("Epoch 4: BEFORE checking 1");
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, 0); // Existing bug: this is >0 
        console2.log("");
        console2.log("Epoch 4: BEFORE checking 2");
        earned = wxbribe.earned(address(LR), 2);
        assertEq(earned, TOKEN_1 / 2);
        console2.log("");
        console2.log("Epoch 4: BEFORE checking 3");
        earned = wxbribe.earned(address(LR), 3);
        assertEq(earned, TOKEN_1 * 3);

        epoch5();
    }

    function epoch5() public {
        // fwd half a week
        // Epoch flip
        // Epoch 5
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        console2.log("");
        console2.log("Epoch 5: BEFORE checking 1");
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1);
        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1);
    }

    function testWrappedBribesCanClaimOnlyOnceArray() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd half a week
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        // rewards
        address[] memory rewards = new address[](2);
        rewards[0] = address(LR);
        rewards[1] = address(LR);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);
    }

   function testBribesCanClaimLeftOverRewardAfterBeingHandled() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // fwd half a week
        uint epochTimestamp = block.timestamp;
        vm.warp(block.timestamp + 1 weeks / 2);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        wxbribe.handleLeftOverRewards(epochTimestamp, rewards);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd a week
        vm.warp(block.timestamp + 1 weeks);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);
    }

    function testBribesCanClaimLeftOverRewardAfterBeingHandledPlusAddingMoreBribes() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // fwd half a week
        uint epochTimestamp = block.timestamp;
        vm.warp(block.timestamp + 1 weeks / 2);

        // add more bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        wxbribe.handleLeftOverRewards(epochTimestamp, rewards);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd a week
        vm.warp(block.timestamp + 1 weeks);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1);
    }

    function testBribesCanClaimLeftOverRewardAfterBeingHandledAfterSeveralEpochs() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // fwd half a week
        uint epochTimestamp = block.timestamp;
        vm.warp(block.timestamp + 1 weeks / 2);

        // add more bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd a week
        vm.warp(block.timestamp + 3 weeks);

        wxbribe.handleLeftOverRewards(epochTimestamp, rewards);

        vm.warp(block.timestamp + 1 weeks);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1);
    }

    function testCanUpdateRewardAmountWithBalanceDiscrepancy() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // transfer LR tokens to wxbribe
        LR.transfer(address(wxbribe), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // try to get reward for owner
        address[] memory tokens = new address[](1);
        tokens[0] = address(LR);

        uint256 balance1 = LR.balanceOf(address(owner));
        uint256 pre_pre_earned = wxbribe.earned(address(LR), 1);
        assertEq(pre_pre_earned, 0);
        vm.startPrank(address(voter));
        wxbribe.getRewardForOwner(1, tokens);
        vm.stopPrank();

        uint256 balance2 = LR.balanceOf(address(owner));
        assertEq(balance2 - balance1, 0);
        uint256 pre_earned = wxbribe.earned(address(LR), 1);
        assertEq(pre_earned, 0);

        // update reward amount before epoch flip
        wxbribe.updateRewardAmount(tokens);

        // fwd half a week
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, tokens);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, tokens);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);
    }

    function testCannotUpdateRewardAmountWithoutBalanceDiscrepancy() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        uint256 actualBalance1 = LR.balanceOf(address(wxbribe));
        assertEq(actualBalance1, TOKEN_1);

        uint256 accountBalance1 = wxbribe.tokenRewardBalance(address(LR));
        assertEq(accountBalance1, TOKEN_1);

        // try to update reward amount
        address[] memory tokens = new address[](1);
        tokens[0] = address(LR);
        wxbribe.updateRewardAmount(tokens);

        uint256 actualBalance2 = LR.balanceOf(address(wxbribe));
        assertEq(actualBalance2, TOKEN_1);

        uint256 accountBalance2 = wxbribe.tokenRewardBalance(address(LR));
        assertEq(accountBalance2, TOKEN_1);
    }

    function testCanUpdateRewardAmountCorrectlyAfterClaiming() public {
        vm.warp(block.timestamp + 1 weeks / 2);

        // create a bribe
        LR.approve(address(wxbribe), TOKEN_1);
        wxbribe.notifyRewardAmount(address(LR), TOKEN_1);

        // transfer LR token to wxbribe
        LR.transfer(address(wxbribe), TOKEN_1);

        // vote
        address[] memory pools = new address[](1);
        pools[0] = address(pair);
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10000;
        voter.vote(1, pools, weights);

        vm.startPrank(address(owner2));
        voter.vote(2, pools, weights);
        vm.stopPrank();

        // fwd half a week
        vm.warp(block.timestamp + 1 weeks / 2);

        uint256 pre = LR.balanceOf(address(owner));
        uint256 earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        // rewards
        address[] memory rewards = new address[](1);
        rewards[0] = address(LR);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        uint256 post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        uint256 post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);

        uint256 accountBalance1 = wxbribe.tokenRewardBalance(address(LR));

        // update reward amount before epoch flip
        wxbribe.updateRewardAmount(rewards);

        uint256 accountBalance2 = wxbribe.tokenRewardBalance(address(LR));
        assertEq(accountBalance2 - accountBalance1, TOKEN_1);

        // epoch flip
        vm.warp(block.timestamp + 1 weeks);

        pre = LR.balanceOf(address(owner));
        earned = wxbribe.earned(address(LR), 1);
        assertEq(earned, TOKEN_1 / 2);

        vm.startPrank(address(voter));
        // once
        wxbribe.getRewardForOwner(1, rewards);
        post = LR.balanceOf(address(owner));
        // twice
        wxbribe.getRewardForOwner(1, rewards);
        vm.stopPrank();

        post_post = LR.balanceOf(address(owner));
        assertEq(post_post, post);
        assertEq(post_post - pre, TOKEN_1 / 2);
    }
}