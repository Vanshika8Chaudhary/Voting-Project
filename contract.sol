// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract ProposalContract { 
    // Our contract code
    address owner;

     uint256 private  counter;
    struct Proposal{
       string description;
       uint256 approve;
       uint256 reject;
       uint256 pass;
       uint256 total_vote_to_end;
       bool current_state;
       bool is_active;
       string title;
    }

     mapping (uint256 => Proposal) proposal_history; // Recordings of previous proposals

     address [] private voted_address; // array

    constructor(){
        owner = msg.sender;
        voted_address.push(msg.sender);
    }

    modifier OnlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier active(){
        require(proposal_history[counter].is_active == true , "The proposal is not active");
        _;
    }

    modifier  newVoter(address _address){
        require(!isVoted(address) , "Address has already voted!");
        _;
    }

     function setOwner(address new_owner) external OnlyOwner{
        owner = new_owner;
    }
   
    function create(string calldata _description, uint256 total_vote_to_end, string calldata _title) external OnlyOwner{
        counter += 1;
        proposal_history[counter] = Proposal(_description,0,0,0,total_vote_to_end,false,true,_title);
    }

    

    
    function vote(uint8 choice)external {
        
        Proposal storage proposal = proposal_history[counter];
        uint256 total_vote = proposal.approve + proposal.reject+proposal.pass;

        voted_address.push(msg.sender);

        if(choice == 1){
            proposal.approve += 1;
            proposal.current_State = calculateCurrentState();
        }
        else if(choice == 2){
            proposal.reject += 1;
            proposal.current_State = calculateCurrentState();
        }
        
        else if(choice == 0){
            proposal.pass += 1;
            proposal.current_State = calculateCurrentState();
        }

        if((proposal.total_vote_to_end - total_vote == 1 )&& (choice == 1 || choice == 2 || choice ==0) ){
            proposal.is_active = false;
            voted_address = [owner];
        }

        }

        // function calculateCurrentState() private view returns(bool){
        //     Proposal storage proposal = proposal_history[counter];
        //     uint256 approve = proposal.approve;
        //     uint256 reject = proposal.reject;
        //     uint256 pass = proposal.pass;

        //     if(proposal.pass%2 == 1){
        //         pass += 1;
        //     }

        //     pass = pass/2;
        //     if(approve > reject+pass){
        //         return  true;
        //     }
        //     else{
        //         return false;
        //     }
        // }


        function calculateCurrentState() private view returns(bool){
            Proposal storage proposal = proposal_history[counter];
            uint256 pass =  proposal.pass;
            pass = (pass +(pass%2))/2;
            return proposal.approve>pass+proposal.reject;

        }



    }

