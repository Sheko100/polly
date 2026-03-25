// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A data structure that defines a poll object
struct Poll {
    address owner;
    uint32 votesCount;
    uint32 id;
    uint32 endTime;
    string title;
    string[] options;
}

/// @title A Voting Management System
/// @notice A contract that defines a management system for polls and votes
contract VotingSystem is Ownable {
    /// @notice an array of the Poll structure
    Poll[] public polls;

    /// @notice a mapping of the ids and the associted poll index in the polls array
    mapping(uint32 => uint32) public pollsIndexMap;

    /// @notice the created polls count
    uint32 public allPollsCount = 0;
    
    /// @notice the active polls count
    uint32 public activePollsCount = 0;

    /// @notice poll id => option id => number of votes
    mapping(uint32 => mapping(uint32 => uint32)) optionVotes;

    /// @notice user address => array of arrays that has 2 members (in this order) the poll id and the option id
    mapping(address => uint32[2][]) votedPolls;

    event PollCreated(address owner, uint32 pollId);
    event PollDeleted(uint32 pollId);
    event VoteRegistered(address voter, uint32 pollId, uint32 optionId);

    modifier existingPollOnly(uint32 pollId) {
        require(isPollExist(pollId),"There is no existing poll with passed id");
        _;
    }

    modifier votedUserOnly() {
        require(hasUserVoted(), "The user has not voted in any poll");
        _;
    }

    modifier pollOwnerOnly(uint32 pollId) {
        require(isPollOwner(pollId), "Only poll owner can do this operation");
        _;
    }

    modifier singleVoteOnly(uint32 pollId, uint32 optionId) {
        require(!hasUserVoted() || !alreadyVotedToPoll(pollId), "User already voted to this poll");
        _;
    }
    
    modifier pollEndedOnly(uint32 pollId) {
        require(isPollEnded(pollId), "The poll still not ended yet");
        _;
    }    

    constructor(address initialOwner) Ownable(initialOwner) {}

    /// @notice gets the option total votes count
    /// @param pollId the poll id
    /// @param optionId the option id
    /// @return option votes
    function getOptionVotes(uint32 pollId, uint32 optionId) external view pollEndedOnly(pollId) returns(uint32) {
        return optionVotes[pollId][optionId];
    }

    /// @notice gets all the active polls
    /// @return an array of Poll objects
    function getActivePolls() external view returns (Poll[] memory) {
        Poll[] memory activePolls = new Poll[](activePollsCount);
        uint32 activePollIndex = 0;
        for (uint32 pollIndex = 0; pollIndex < polls.length; pollIndex++) {
            Poll storage poll = polls[pollIndex];
            if (poll.id != 0) {
                activePolls[activePollIndex] = poll;
                activePollIndex++;
            }
        }
        return activePolls;
    }
    
    /// @notice gets the user votes
    /// @return userVotes array of arrays that has 2 members (in this order) the poll id and the option id
    function getUserVotes() public view returns (uint32[2][] memory) {
        uint32[2][] storage votes = votedPolls[msg.sender];
        uint32[2][] memory userVotes = new uint32[2][](votes.length);
        uint32 userVoteIndex = 0;
        for (uint32 voteIndex = 0; voteIndex < votes.length; voteIndex++) {
            uint32 pollId = votes[voteIndex][0];
            if (isPollExist(pollId)) {
                userVotes[userVoteIndex] = votes[voteIndex];
                userVoteIndex++;
            }
        }
        return userVotes;
    }
    
    /// @notice gets all the polls created even if they are deleted or ended
    /// @return an array of Poll structure
    function getAllPolls() public view returns (Poll[] memory){
      return polls;
    }

    /// @notice gets poll based on id
    function getPoll(uint32 pollId) internal view existingPollOnly(pollId) returns (Poll storage) {
        return polls[pollsIndexMap[pollId]];
    }

    /// @notice A method that handles the creation of a new poll
    /// @return the created poll id
    function createNewPoll(string memory title, string[] memory options, uint32 duration) public payable returns (uint32) {

        // amount is very low for smooth testing/development
        // but should be changed in production
        if (msg.value < 1 gwei) {
          revert("Amount sent is less than 1 gwei");
        }

        // increment all polls count
        allPollsCount++;
        
        // increment the active polls count
        activePollsCount++;

        // add a new poll
        polls.push();

        // get the poll
        Poll storage newPoll = polls[polls.length - 1];
        
        newPoll.owner = msg.sender;
        newPoll.id = allPollsCount;
        newPoll.endTime = uint32(block.timestamp + duration * 1 days);
        newPoll.title = title;
        newPoll.options = options;

        // store the new poll in the mapping
        pollsIndexMap[newPoll.id] = uint32(polls.length - 1);

        emit PollCreated(newPoll.owner, allPollsCount);

        return allPollsCount;
    }

    /// @notice deletes existing poll
    /// @param pollId the poll id
    function deletePoll(uint32 pollId) public payable pollOwnerOnly(pollId) {
    
        if (msg.value < 1 gwei) {
          revert("Amount sent is less than 1 gwei");
        }
        
        // decrement the activePollsCount
        activePollsCount = activePollsCount > 0 ? activePollsCount - 1 : 0;

        // delete the poll
        delete polls[pollsIndexMap[pollId]];

        emit PollDeleted(pollId);
    }

    /// @notice Increment the votes of a poll option
    /// @param pollId an id of a poll
    /// @param optionId an id of a poll option
    function vote(uint32 pollId, uint32 optionId) public payable singleVoteOnly(pollId, optionId) {

        if (msg.value < 0.5 gwei) {
          revert("Amount sent is less than 0.5 gwei");
        }

        // get the poll
        Poll storage poll = getPoll(pollId);

        // increment the votes count of the poll
        //pollsMap[pollId].votesCount += 1;
        
        poll.votesCount += 1;
        
        // increment the option votes count
        optionVotes[pollId][optionId] += 1;
        
        // add the poll to the voted polls of the user
        votedPolls[msg.sender].push([pollId, optionId]);

        emit VoteRegistered(msg.sender, pollId, optionId);
    }

    /// @notice checks if the poll exist and stored or not
    /// @param pollId the poll id
    function isPollExist(uint32 pollId) public view returns (bool) {
        if (polls[pollsIndexMap[pollId]].id == 0) {
            return false;
        }
        return true;
    }

    /// @notice checks if the user has voted or not
    function hasUserVoted() private view returns (bool) {
        if (votedPolls[msg.sender].length == 0) {
            return false;
        }
        return true;
    }

    /// @notice checks if the poll owner address equal to the message sender
    /// @param _pollId the poll id
    function isPollOwner(uint32 _pollId) private view returns (bool) {
        Poll memory poll = getPoll(_pollId);
        if (poll.owner == msg.sender) {
            return true;
        }
        return false;
    }

    /// @notice checks if the user has already voted in a poll or not
    /// @param _pollId the poll id
    function alreadyVotedToPoll(uint32 _pollId) private view returns (bool) {
        // uint32[2][] memory votes = this.getUserVotes();
        uint32[2][] memory votes = getUserVotes();
        for (uint32 voteIndex = 0; voteIndex < votes.length; voteIndex++) {
            uint32 pollId = votes[voteIndex][0];
            if (_pollId == pollId) {
                return true;
            }
        }
        return false;
    }
    
    /// @notice checks if the poll has ended or not
    /// @param _pollId the pollId
    function isPollEnded(uint32 _pollId) private view returns (bool) {
      Poll memory poll = getPoll(_pollId);
      
      if (block.timestamp >= poll.endTime) {
        return true;
      }
      
      return false;
    }    
}

