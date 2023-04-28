pragma solidity 0.8.13;

import "./BaseTest.sol";
import "contracts/AutoBribe.sol";
import "contracts/WrappedBribe.sol";
import "contracts/factories/WrappedBribeFactory.sol";
import "contracts/factories/WrappedExternalBribeFactory.sol";
import "forge-std/console2.sol";

contract AutoBribeTest is BaseTest {
    VotingEscrow escrow;
    GaugeFactory gaugeFactory;
    BribeFactory bribeFactory;
    WrappedBribeFactory wbribeFactory;
    WrappedExternalBribeFactory wxbribeFactory;
    Voter voter;
    RewardsDistributor distributor;
    Minter minter;
    Gauge gauge;
    ExternalBribe xbribe;
    WrappedBribe wbribe;
    AutoBribe autoBribe;
    Gauge gauge2;
    ExternalBribe xbribe2;
    WrappedBribe wbribe2;
    AutoBribe autoBribe2;

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
        escrow = new VotingEscrow(
            address(FLOW),
            address(artProxy),
            owners[0],
            csrNftId
        );
        deployPairFactoryAndRouter();

        // deployVoter()
        gaugeFactory = new GaugeFactory(csrNftId);
        bribeFactory = new BribeFactory(csrNftId);
        wxbribeFactory = new WrappedExternalBribeFactory(csrNftId);
        voter = new Voter(
            address(escrow),
            address(factory),
            address(gaugeFactory),
            address(bribeFactory),
            address(wxbribeFactory),
            csrNftId
        );
        wbribeFactory = new WrappedBribeFactory(
            address(voter),
            csrNftId
        );

        escrow.setVoter(address(voter));
        factory.setVoter(address(voter));
        wxbribeFactory.setVoter(address(voter));
        deployPairWithOwner(address(owner));

        // deployMinter()
        distributor = new RewardsDistributor(address(escrow), csrNftId);
        minter = new Minter(
            address(voter),
            address(escrow),
            address(distributor),
            csrNftId
        );
        distributor.setDepositor(address(minter));
        FLOW.setMinter(address(minter));
        address[] memory tokens = new address[](5);
        tokens[0] = address(USDC);
        tokens[1] = address(FRAX);
        tokens[2] = address(DAI);
        tokens[3] = address(FLOW);
        tokens[4] = address(LR);
        voter.initialize(tokens, address(minter));

        // USDC - FRAX stable
        gauge = Gauge(voter.createGauge(address(pair)));
        xbribe = ExternalBribe(gauge.external_bribe());
        wbribe = WrappedBribe(wbribeFactory.createBribe(address(xbribe)));
        autoBribe = new AutoBribe(address(wbribe), address(owner));

        vm.startPrank(address(owner));
        autoBribe.setProject(address(owner2));
        vm.stopPrank();
    }

    function testSetUpCorrectly() public {
        assertEq(autoBribe.owner(), address(owner));
        assertEq(autoBribe.project(), address(owner2));
        assertEq(autoBribe.wBribe(), address(wbribe));
    }

    function testCanDepositAndBribeEveryWeek(
        uint256 depositAmountLR,
        uint256 depositAmountFLOW,
        uint256 depositWeeks
    ) public {
        vm.assume(
            depositAmountLR > depositWeeks &&
                depositAmountLR <= 1e25 &&
                depositAmountFLOW > depositWeeks &&
                depositAmountFLOW <= 1e25 &&
                depositWeeks > 0 &&
                depositWeeks < 52
        );

        vm.warp(block.timestamp + 1 weeks / 2);

        // Project deposit tokens
        vm.startPrank(address(owner2));
        LR.approve(address(autoBribe), depositAmountLR);
        autoBribe.deposit(address(LR), depositAmountLR, depositWeeks);

        FLOW.approve(address(autoBribe), depositAmountFLOW);
        autoBribe.deposit(address(FLOW), depositAmountFLOW, depositWeeks);
        vm.stopPrank();

        uint256 balanceBeforeLR = LR.balanceOf(address(this));
        uint256 balanceBeforeFLOW = FLOW.balanceOf(address(this));

        for (uint256 i = 0; i < depositWeeks - 1; ) {
            autoBribe.bribe();
            vm.warp(block.timestamp + 1 weeks);

            unchecked {
                ++i;
            }
        }

        assertGt(LR.balanceOf(address(autoBribe)), 0);
        assertGt(FLOW.balanceOf(address(autoBribe)), 0);

        autoBribe.bribe();
        vm.warp(block.timestamp + 1 weeks);

        assertEq(LR.balanceOf(address(autoBribe)), 0);
        assertEq(FLOW.balanceOf(address(autoBribe)), 0);
        assertEq(
            LR.balanceOf(address(wbribe)) +
                LR.balanceOf(address(this)) -
                balanceBeforeLR,
            depositAmountLR
        );
        assertEq(
            FLOW.balanceOf(address(wbribe)) +
                FLOW.balanceOf(address(this)) -
                balanceBeforeFLOW,
            depositAmountFLOW
        );
    }

    function testCanDepositAllAndBribeEveryWeek(uint256 depositWeeks) public {
        vm.assume(depositWeeks <= 52 && depositWeeks > 0);
        vm.warp(block.timestamp + 1 weeks / 2);

        // deposit tokens
        address[] memory bribeTokens = new address[](2);
        bribeTokens[0] = address(LR);
        bribeTokens[1] = address(FLOW);

        // Project depoit tokens
        vm.startPrank(address(owner2));
        LR.approve(address(autoBribe), type(uint256).max);
        FLOW.approve(address(autoBribe), type(uint256).max);
        autoBribe.depositAll(bribeTokens, depositWeeks);
        vm.stopPrank();

        uint256 balanceBeforeLR = LR.balanceOf(address(this));
        uint256 balanceBeforeFLOW = FLOW.balanceOf(address(this));

        for (uint256 i = 0; i < depositWeeks - 1; ) {
            autoBribe.bribe();
            vm.warp(block.timestamp + 1 weeks);

            unchecked {
                ++i;
            }
        }

        assertGt(LR.balanceOf(address(autoBribe)), 0);
        assertGt(FLOW.balanceOf(address(autoBribe)), 0);

        autoBribe.bribe();
        vm.warp(block.timestamp + 1 weeks);

        assertEq(LR.balanceOf(address(autoBribe)), 0);
        assertEq(FLOW.balanceOf(address(autoBribe)), 0);

        assertEq(
            LR.balanceOf(address(wbribe)) +
                LR.balanceOf(address(this)) -
                balanceBeforeLR,
            1e25
        );
        assertEq(
            FLOW.balanceOf(address(wbribe)) +
                FLOW.balanceOf(address(this)) -
                balanceBeforeFLOW,
            1e25
        );
    }

    function testRedeposit(
        uint256 depositAmountLR,
        uint256 depositWeeks
    ) public {
        vm.assume(
            depositAmountLR > depositWeeks &&
                depositAmountLR <= 1e24 &&
                depositWeeks > 0 &&
                depositWeeks < 52
        );

        vm.warp(block.timestamp + 1 weeks / 2);

        // Project deposit tokens
        vm.startPrank(address(owner2));
        LR.approve(address(autoBribe), type(uint256).max);
        autoBribe.deposit(address(LR), depositAmountLR, depositWeeks);
        vm.stopPrank();

        uint256 balanceBeforeLR = LR.balanceOf(address(this));

        autoBribe.bribe();
        vm.warp(block.timestamp + 1 weeks);

        vm.startPrank(address(owner2));
        LR.approve(address(autoBribe), depositAmountLR);
        autoBribe.deposit(address(LR), depositAmountLR, depositWeeks);
        vm.stopPrank();

        for (uint256 i = 0; i < depositWeeks * 2 - 2; ) {
            autoBribe.bribe();
            vm.warp(block.timestamp + 1 weeks);

            unchecked {
                ++i;
            }
        }

        assertGt(LR.balanceOf(address(autoBribe)), 0);

        autoBribe.bribe();
        vm.warp(block.timestamp + 1 weeks);

        assertEq(LR.balanceOf(address(autoBribe)), 0);
        assertEq(
            LR.balanceOf(address(wbribe)) +
                LR.balanceOf(address(this)) -
                balanceBeforeLR,
            depositAmountLR * 2
        );
    }

    function testEmptyOut(
        uint256 depositAmountLR,
        uint256 depositAmountFLOW,
        uint256 depositWeeks
    ) public {
        vm.assume(
            depositAmountLR > depositWeeks &&
                depositAmountLR <= 1e25 &&
                depositAmountFLOW > depositWeeks &&
                depositAmountFLOW <= 1e25 &&
                depositWeeks > 0 &&
                depositWeeks < 52
        );

        vm.warp(block.timestamp + 1 weeks / 2);

        // Project deposit tokens
        vm.startPrank(address(owner2));
        LR.approve(address(autoBribe), depositAmountLR);
        autoBribe.deposit(address(LR), depositAmountLR, depositWeeks);

        FLOW.approve(address(autoBribe), depositAmountFLOW);
        autoBribe.deposit(address(FLOW), depositAmountFLOW, depositWeeks);

        autoBribe.seal();
        vm.stopPrank();

        vm.expectRevert("only project can empty out");
        autoBribe.emptyOut();

        vm.startPrank(address(owner2));
        vm.expectRevert("deposit is sealed");
        autoBribe.emptyOut();
        vm.stopPrank();

        vm.startPrank(address(owner));
        autoBribe.unSeal();
        vm.stopPrank();

        uint256 balanceBeforeLR = LR.balanceOf(address(owner2));
        uint256 balanceBeforeFLOW = FLOW.balanceOf(address(owner2));

        vm.startPrank(address(owner2));
        autoBribe.emptyOut();
        vm.stopPrank();

        assertEq(autoBribe.bribeTokenToWeeksLeft(address(LR)), 0);
        assertEq(autoBribe.bribeTokenToWeeksLeft(address(FLOW)), 0);

        assertEq(LR.balanceOf(address(autoBribe)), 0);
        assertEq(FLOW.balanceOf(address(autoBribe)), 0);

        assertEq(
            LR.balanceOf(address(owner2)) - balanceBeforeLR,
            depositAmountLR
        );
        assertEq(
            FLOW.balanceOf(address(owner2)) - balanceBeforeFLOW,
            depositAmountFLOW
        );
    }

    function testTeamCannotSetProjectTwice() public {
        vm.startPrank(address(owner));
        vm.expectRevert("only project / team can only set once");
        autoBribe.setProject(address(owner2));
        vm.stopPrank();
    }

    function testProjectSetProjectTwice() public {
        vm.startPrank(address(owner2));
        autoBribe.setProject(address(owner3));
        vm.stopPrank();

        vm.startPrank(address(owner3));
        autoBribe.setProject(address(0x10));
        vm.stopPrank();
    }
}
