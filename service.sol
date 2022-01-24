pragma solidity >=0.7.0 <0.9.0;

contract PayPerService {

    struct service {
       
        address owner;
        uint amount;
        uint timestamp;
        uint expirationTime;
        uint interestAmount;
        uint viewers;
   }

    struct message {

        string message;
        uint code;
    }

    struct paidService {

        address owner;
        address payee;
        uint amount;
        uint timestamp;
        bool paid;
    }


    mapping(address => mapping (uint => service)) public services;
    //mapping(address => mapping (uint => message)) private messages;

    mapping(address => mapping (address => mapping (uint => paidService))) public paidServices;

    mapping(address => mapping (address => mapping (uint => message))) private messages;



    mapping(address => uint[]) private listmappingOwner;
    mapping(address => uint[]) private listmappingBuyer;

    uint private ID;



    function newService(
        uint amount,
        uint expirationTime,
        uint interestAmount,
        uint viewers,
        string memory _message,
        uint _code

    ) public {

        ID = listmappingOwner[msg.sender].length;

        services[msg.sender][ID].owner = msg.sender;
        services[msg.sender][ID].amount = amount;
        services[msg.sender][ID].timestamp = block.timestamp;
        services[msg.sender][ID].expirationTime = expirationTime;
        services[msg.sender][ID].interestAmount = interestAmount;
        services[msg.sender][ID].viewers = viewers;

        messages[msg.sender][msg.sender][ID].message = _message;
        messages[msg.sender][msg.sender][ID].code = _code;

        listmappingOwner[msg.sender].push(ID);
    }


    function payService(address owner, uint ID) public payable {

            uint payment;

            payment = services[owner][ID].amount;

            require(msg.value >= payment);

            paidServices[msg.sender][owner][ID].payee = msg.sender;
            paidServices[msg.sender][owner][ID].owner = owner;
            paidServices[msg.sender][owner][ID].amount = msg.value;
            paidServices[msg.sender][owner][ID].timestamp = block.timestamp;

            paidServices[msg.sender][owner][ID].paid = true;

            // write owner message to user address

            string memory _message;
            uint _code;

            _message = messages[owner][owner][ID].message;
            _code = messages[owner][owner][ID].code;

            messages[msg.sender][owner][ID].message = _message;
            messages[msg.sender][owner][ID].code = _code;

        }


    function viewMessage(address owner, uint ID) public view virtual returns (string memory) {

        require(paidServices[msg.sender][owner][ID].paid == true);

        return messages[msg.sender][owner][ID].message;

    }


}
