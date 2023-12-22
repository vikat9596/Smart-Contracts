//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract EventContract{

    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events; //details of the event 
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string calldata name, uint date, uint price, uint ticketCount) public{
        require(block.timestamp<date, "You cannot create an event for past date");
        require(ticketCount>0,"Ticket count must be greater than 0");
        events[nextId]= Event(msg.sender,name, date, price, ticketCount, ticketCount);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) public payable{
        require(events[id].date!=0,"Event Does not Exist");
        require(events[id].date>block.timestamp,"Event has Ended");
        Event storage _event= events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemaining>=quantity,"Not enoungh tickets left");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+= quantity;

    }

    function transferTicket(uint id, uint quantity, address to) public {
        require(events[id].date!=0,"Event Does not Exist");
        require(events[id].date>block.timestamp,"Event has Ended");
        require(tickets[msg.sender][id]>=quantity,"You do not have tickets to transfer");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+= quantity;
    }

}
