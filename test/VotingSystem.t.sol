// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {VotingSystem, Poll} from "../src/VotingSystem.sol";

contract VotingSystemTest is Test {
    VotingSystem public voting;
    string[] public threeOptions = ["o1", "o2", "o3"];
    string public title = "Poll Title";
    uint32 duration = 1;
    uint256 amountInGwei = 1;
    uint256 amountInWei = amountInGwei * 1e9;

    function setUp() public {
        voting = new VotingSystem(address(this));
        vm.deal(address(this), 1 ether);
    }

    /// tests that all created polls are returned even if they are deleted or ended
    function test_getAllPolls() public {
        voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 firstPollId;

        (,, firstPollId,,) = voting.polls(0);
        Poll[] memory allPolls = voting.getAllPolls();

        assertEq(allPolls[0].id, firstPollId);
        assertEq(allPolls.length, voting.allPollsCount());
    }

    /// tests that only the active polls are returned
    function test_getActivePollsWhileAllAreActive() public {
        voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);

        Poll[] memory activePolls = voting.getActivePolls();
        Poll[] memory allPolls = voting.getAllPolls();

        assertEq(activePolls[0].id, allPolls[0].id);
        assertEq(activePolls.length, allPolls.length);
    }

    /// tests that the poll creation increase the count of the active polls
    function test_increasedActivePollsCount() public {
        uint32 currCount = voting.activePollsCount();

        voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);

        assertEq(voting.activePollsCount(), currCount + 1);
    }

    /// tests that the poll creation increase the count of all the polls
    function test_increasedAllPollsCount() public {
        uint32 currCount = voting.allPollsCount();

        voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);

        assertEq(voting.allPollsCount(), currCount + 1);
    }

    /// tests that the poll owner is assigned correctly
    function test_pollOwnerAssigned() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        address owner;

        (owner,,,,) = voting.polls(voting.pollsIndexMap(pollId));

        assertEq(owner, address(this));
    }

    /// tests that deleting the poll is working as expected
    function test_deletePoll() public {
        uint32 pollOneId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 pollTwoId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 countBeforeDelete = voting.activePollsCount();
        uint32 countAfterDelete;

        voting.deletePoll{value: amountInWei}(pollTwoId);

        countAfterDelete = voting.activePollsCount();

        assertEq(countAfterDelete, countBeforeDelete - 1);

        (,, uint32 deletedPollTwoId,,) = voting.polls(voting.pollsIndexMap(pollTwoId));

        assertEq(deletedPollTwoId, 0);

        voting.deletePoll{value: amountInWei}(pollOneId);

        (,, uint32 deletedPollOneId,,) = voting.polls(voting.pollsIndexMap(pollOneId));

        assertEq(deletedPollOneId, 0);
    }

    /// tests that the votes count has increased by one after voting
    function test_increasedPollVotes() public {
        voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);

        uint32 oldVotesCount = voting.getActivePolls()[0].votesCount;
        uint32 newVotesCount;

        voting.vote{value: amountInWei / 2}(1, 1);

        newVotesCount = voting.getActivePolls()[0].votesCount;

        assertEq(newVotesCount, oldVotesCount + 1);
    }

    /// tests that the voting is working as expected
    function test_addedUserVote() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 optionId = 1;
        uint32[2][] memory userVotes;
        uint32[2] memory firstVote;

        voting.vote{value: amountInWei / 2}(pollId, optionId);

        userVotes = voting.getUserVotes();

        firstVote = userVotes[0];

        assertEq(firstVote[0], pollId);
        assertEq(firstVote[1], optionId);
    }

    /// tests that the voting has increased the votes count
    function test_increasedUserVotes() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32[2][] memory userVotes;

        voting.vote{value: amountInWei / 2}(pollId, 1);

        userVotes = voting.getUserVotes();

        assertEq(userVotes.length, 1);
    }

    /// tests that the voting has increased the option votes
    function test_increasedOptionVotes() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 optionVotes;

        voting.vote{value: amountInWei / 2}(pollId, 1);

        vm.warp(block.timestamp + duration * 1 days);

        optionVotes = voting.getOptionVotes(pollId, 1);

        assertEq(optionVotes, 1);
    }

    /// tests that getting the option votes should revert if the poll has not ended yet
    function test_RevertIf_PollHasNotEnded() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);
        uint32 optionVotes;

        vm.expectRevert();

        optionVotes = voting.getOptionVotes(pollId, 0);
    }

    /// tests that voting should happen only once by one user
    function test_RevertIf_tryingToVoteSecondTime() public {
        uint32 pollId = voting.createNewPoll{value: amountInWei}(title, threeOptions, duration);

        voting.vote{value: amountInWei / 2}(pollId, 1);
        // Should revert because already voted
        vm.expectRevert();
        voting.vote{value: amountInWei / 2}(pollId, 1);
    }
}
